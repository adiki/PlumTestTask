//
//  DetailsTests.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 25/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Combine
import ComposableArchitecture
import XCTest
@testable import PlumTestTask

class DetailsTests: XCTestCase {
    private let scheduler = DispatchQueue.testScheduler
    private let comic = Comic.fixture(number: 1)
    private lazy var hero = Hero.fixture(
        id: 1,
        comics: Comics(available: 5, items: [comic])
    )
    
    func test_details_happyPath() {
        let imageData = Data.imageData(fromColor: .blue)
        let herosProviderMock = HerosProviderMock(
            imageDataForComicMock: { comic in
                Just((data: imageData, comic: comic))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            }
        )
        let persistencyMock = PersistencyMock()
                    
        let store = TestStore(
            initialState: DetailsState(
                squadHeros: [],
                selectedHero: hero,
                isFiringHeroConfirmationPresented: false,
                herosToImageData: [:]
            ),
            reducer: detailsReducer,
            environment: DetailsEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                herosProvider: herosProviderMock,
                persistency: persistencyMock
            )
        )
        
        store.assert(
            .send(.fetchComicsImagesIfNeeded),
            .do {
                self.scheduler.advance()
            },
            .receive(.didFetchImageData(imageData, comic: comic)) {
                $0.comicsToImageData[self.comic] = imageData
            },
            .send(.recruitOrFireButtonTapped(hero)) {
                $0.squadHeros = [self.hero]
            },
            .send(.recruitOrFireButtonTapped(hero)) {
                $0.isFiringHeroConfirmationPresented = true
            },
            .send(.fireConfirmationAlertDismissed) {
                $0.isFiringHeroConfirmationPresented = false
            },
            .send(.fire(hero)) {
                $0.squadHeros = []
            }
        )
    }
    
    func test_details_unhappyPath() {
        let herosProviderMock = HerosProviderMock(
            imageDataForComicMock: { _ in
                Fail(error: NSError(domain: "network", code: 1))
                    .eraseToAnyPublisher()
            }
        )
        let persistencyMock = PersistencyMock(
            saveMock: { _, _ in
                Fail(error: NSError(domain: "filesystem", code: 2))
                    .eraseToEffect()
            }
        )
        let store = TestStore(
            initialState: DetailsState(
                squadHeros: [],
                selectedHero: hero,
                isFiringHeroConfirmationPresented: false,
                herosToImageData: [:]
            ),
            reducer: detailsReducer,
            environment: DetailsEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                herosProvider: herosProviderMock,
                persistency: persistencyMock
            )
        )
        
        store.assert(
            .send(.fetchComicsImagesIfNeeded),
            .do {
                self.scheduler.advance()
            },
            .receive(.didFailToFetchComicImageData),
            .send(.recruitOrFireButtonTapped(hero)) {
                $0.squadHeros = [self.hero]
            },
            .receive(.didFailToSaveHeros)
        )
    }
}
