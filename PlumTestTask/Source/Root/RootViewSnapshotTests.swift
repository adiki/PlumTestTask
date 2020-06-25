//
//  RootViewSnapshotTests.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 25/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import XCTest
import SnapshotTesting
import ComposableArchitecture
@testable import PlumTestTask

class RootViewSnapshotTests: XCTestCase {
    
    private let hero1 = Hero.fixture(id: 1)
    private let hero2 = Hero.fixture(id: 2)
    private let hero3 = Hero.fixture(id: 3)
    
    func test_loading() {
        let state = AppState(
            status: .loading
        )
        verify(state: state)
    }
    
    func test_loading_withMySquadHeros() {
        let state = AppState(
            status: .loading,
            squadHeros: [hero1, hero2],
            herosToImageData: [
                hero1: Data.imageData(fromColor: .red),
                hero2: Data.imageData(fromColor: .green)
            ]
        )
        verify(state: state)
    }
    
    func test_idle() {
        let state = AppState(
            status: .idle,
            allHeros: [hero1, hero2, hero3],
            squadHeros: [hero1, hero2],
            herosToImageData: [
                hero1: Data.imageData(fromColor: .red),
                hero2: Data.imageData(fromColor: .green),
                hero3: Data.imageData(fromColor: .blue)
            ]
        )
        verify(state: state)
    }
    
    func test_didFailToLoadHeros() {
        let state = AppState(
            status: .didFailToLoadHeros
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
        let rootView = RootViewBuilder.makeRootView(store: store)
        assertSnapshot(
            matching: rootView,
            as: .image,
            file: file,
            testName: testName,
            line: line
        )
    }
}
