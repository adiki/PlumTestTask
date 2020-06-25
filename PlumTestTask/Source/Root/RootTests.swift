//
//  RootTests.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 22/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Combine
import ComposableArchitecture
import XCTest
@testable import PlumTestTask

class RootTests: XCTestCase {
    private let scheduler = DispatchQueue.testScheduler
    private let hero1 = Hero.fixture(id: 1)
    private let hero2 = Hero.fixture(id: 2)
    private let hero3 = Hero.fixture(id: 3)
    
    func test_root_happyPath() {
        let heros = [hero1, hero2, hero3]
        let imageData = Data.imageData(fromColor: .blue)
        let herosProviderMock = HerosProviderMock(
            fetchHerosMock: Just(heros)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher(),
            imageDataForHeroMock: { hero in
                Just((data: imageData, hero: hero))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )
        let persistencyMock = PersistencyMock()
                    
        let store = TestStore(
            initialState: RootState(
                status: .idle,
                allHeros: [],
                squadHeros: []
            ),
            reducer: rootReducer,
            environment: RootEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                herosProvider: herosProviderMock,
                persistency: persistencyMock
            )
        )
        
        store.assert(
            .send(.initialize) {
                $0.status = .loading
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.didFetchHeros(heros)) {
                $0.status = .idle
                $0.allHeros = heros
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.didFetchImageData(imageData, hero: hero1)) {
                $0.herosToImageData[self.hero1] = imageData
            },
            .receive(.didFetchImageData(imageData, hero: hero2)) {
                $0.herosToImageData[self.hero2] = imageData
            },
            .receive(.didFetchImageData(imageData, hero: hero3)) {
                $0.herosToImageData[self.hero3] = imageData
            },
            .send(.select(hero: hero1)) {
                $0.selectedHero = self.hero1
            }
        )
    }
    
    func test_root_unhappyPath() {
        let herosProviderMock = HerosProviderMock(
            fetchHerosMock: Fail(error: NSError(domain: "network", code: 1))
                .eraseToAnyPublisher()
        )
        let persistencyMock = PersistencyMock(
            loadMock: { _ in
                Fail<Data, Error>(error: NSError(domain: "filesystem", code: 2))
                    .eraseToEffect()
            }
        )
                    
        let store = TestStore(
            initialState: RootState(
                status: .idle,
                allHeros: [],
                squadHeros: []
            ),
            reducer: rootReducer,
            environment: RootEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                herosProvider: herosProviderMock,
                persistency: persistencyMock
            )
        )
        
        store.assert(
            .send(.initialize) {
                $0.status = .loading
            },
            .do {
                self.scheduler.advance()
            },
            .receive(.didFailToLoadSquadHeros),
            .receive(.didFailToFetchHeros) {
                $0.status = .didFailToLoadHeros
            }
        )
    }
}

