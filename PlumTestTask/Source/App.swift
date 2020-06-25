//
//  App.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 22/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture

struct AppState: Equatable {
    var status = Status.idle
    var allHeros: [Hero] = []
    var squadHeros: [Hero] = []
    var selectedHero: Hero?
    var isFiringHeroConfirmationPresented = false
    var herosToImageData: [Hero:Data] = [:]
    var comicsToImageData: [Comic:Data] = [:]
}

enum Status {
    case loading
    case idle
    case didFailToLoadHeros
}

enum AppAction {
    case root(RootAction)
    case details(DetailsAction)
    case flow(FlowAction)
}

struct AppEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let herosProvider: HerosProvider
    let persistency: Persistency
}

extension AppState {
    var rootState: RootState {
        get {
            RootState(
                status: status,
                allHeros: allHeros,
                squadHeros: squadHeros,
                selectedHero: selectedHero,
                herosToImageData: herosToImageData
            )
        }
        set {
            status = newValue.status
            allHeros = newValue.allHeros
            squadHeros = newValue.squadHeros
            selectedHero = newValue.selectedHero
            herosToImageData = newValue.herosToImageData
        }
    }
}

extension AppState {
    var detailsState: DetailsState {
        get {
            DetailsState(
                squadHeros: squadHeros,
                selectedHero: selectedHero,
                isFiringHeroConfirmationPresented: isFiringHeroConfirmationPresented,
                herosToImageData: herosToImageData,
                comicsToImageData: comicsToImageData
            )
        }
        set {
            squadHeros = newValue.squadHeros
            selectedHero = newValue.selectedHero
            isFiringHeroConfirmationPresented = newValue.isFiringHeroConfirmationPresented
            herosToImageData = newValue.herosToImageData
            comicsToImageData = newValue.comicsToImageData
        }
    }
}

extension AppState {
    var flowState: FlowState {
        get { FlowState(selectedHero: selectedHero) }
        set { selectedHero = newValue.selectedHero }
    }
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    rootReducer.pullback(
        state: \AppState.rootState,
        action: /AppAction.root,
        environment: {
            RootEnvironment(
                herosProvider: $0.herosProvider,
                persistency: $0.persistency
            )
        }
    ),
    detailsReducer.pullback(
        state: \AppState.detailsState,
        action: /AppAction.details,
        environment: {
            DetailsEnvironment(
                mainQueue: $0.mainQueue,
                herosProvider: $0.herosProvider,
                persistency: $0.persistency
            )
        }
    ),
    flowReducer.pullback(
        state: \AppState.flowState,
        action: /AppAction.flow,
        environment: { _ in () }
    )
)

extension Store where State == AppState, Action == AppAction {
    var rootStore: Store<RootState, RootAction> {
        scope(state: { $0.rootState }, action: { .root($0) })
    }
    var detailStore: Store<DetailsState, DetailsAction> {
        scope(state: { $0.detailsState }, action: { .details($0) })
    }
    var flowStore: Store<FlowState, FlowAction> {
        scope(state: { $0.flowState }, action: { .flow($0) })
    }
}
