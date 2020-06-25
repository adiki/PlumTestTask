//
//  DetailsViewSnapshotTests.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 25/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import XCTest
import SnapshotTesting
import ComposableArchitecture
@testable import PlumTestTask

class DetailViewSnapshotTests: XCTestCase {
    
    private let comic1 = Comic.fixture(number: 1)
    private let comic2 = Comic.fixture(number: 2)
    private let comic3 = Comic.fixture(number: 3)
    private let comic4 = Comic.fixture(number: 4)
    private var herosToImageData: [Hero:Data] = [
        Hero.fixture(id: 1): Data.imageData(fromColor: .blue)
    ]
    private lazy var comicsToImageData: [Comic:Data] = [
        comic1: Data.imageData(fromColor: .yellow),
        comic2: Data.imageData(fromColor: .purple),
        comic3: Data.imageData(fromColor: .green),
        comic4: Data.imageData(fromColor: .brown)
    ]
    
    func test_heroDetails_availableToRecruit() {
        let hero = Hero.fixture(
            id: 1,
            comics: Comics(available: 0, items: [])
        )
        let state = AppState(
            selectedHero: hero,
            herosToImageData: herosToImageData
        )
        verify(state: state)
    }
    
    func test_heroDetails_alreadyRecruited() {
        let hero = Hero.fixture(
            id: 1,
            comics: Comics(available: 0, items: [])
        )
        let state = AppState(
            squadHeros: [hero],
            selectedHero: hero,
            herosToImageData: herosToImageData,
            comicsToImageData: comicsToImageData
        )
        verify(state: state)
    }
    
    func test_heroDetails_oneComic() {
        let hero = Hero.fixture(
            id: 1,
            comics: Comics(available: 1, items: [
                comic1
            ])
        )
        let state = AppState(
            squadHeros: [hero],
            selectedHero: hero,
            herosToImageData: herosToImageData,
            comicsToImageData: comicsToImageData
        )
        verify(state: state)
    }
    
    func test_heroDetails_twoComics() {
        let hero = Hero.fixture(
            id: 1,
            comics: Comics(available: 2, items: [
                comic1,
                comic2
            ])
        )
        let state = AppState(
            squadHeros: [hero],
            selectedHero: hero,
            herosToImageData: herosToImageData,
            comicsToImageData: comicsToImageData
        )
        verify(state: state)
    }
    
    func test_heroDetails_fourComics() {
        let hero = Hero.fixture(
            id: 1,
            comics: Comics(available: 4, items: [
                comic1,
                comic2,
                comic3,
                comic4
            ])
        )
        let state = AppState(
            squadHeros: [hero],
            selectedHero: hero,
            herosToImageData: herosToImageData,
            comicsToImageData: comicsToImageData
        )
        verify(state: state)
    }
    
    private func verify(
        state: AppState,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let store = Store(
            initialState: state,
            reducer: Reducer<AppState, AppAction, AppEnvironment>.empty,
            environment: AppEnvironment(
                herosProvider: HerosProviderMock(),
                persistency: PersistencyMock()
            )
        )
        let rootView = DetailsView(viewStore: store.detailStore.view)
        assertSnapshot(
            matching: rootView,
            as: .image(layout: .fixed(width: 375, height: 900)),
            file: file,
            testName: testName,
            line: line
        )
    }
}

extension Comic {
    static func fixture(number: Int) -> Comic {
        return Comic(name: "Comic #\(number)", resourceURI: "")
    }
}
