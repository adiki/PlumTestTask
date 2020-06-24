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
}

enum Status {
    case loading
    case idle
}

enum AppAction {
    case root(RootAction)
    case details(DetailsAction)
    case flow(FlowAction)
}

struct AppEnvironment {
}

extension AppState {
    var rootState: RootState {
        get {
            RootState(
                status: status,
                allHeros: allHeros,
                squadHeros: squadHeros,
                selectedHero: selectedHero
            )
        }
        set {
            status = newValue.status
            allHeros = newValue.allHeros
            squadHeros = newValue.squadHeros
            selectedHero = newValue.selectedHero
        }
    }
}

extension AppState {
    var detailsState: DetailsState {
        get {
            DetailsState(
                squadHeros: squadHeros,
                selectedHero: selectedHero
            )
        }
        set {
            squadHeros = newValue.squadHeros
            selectedHero = newValue.selectedHero
        }
    }
}

extension AppState {
    var flowState: FlowState {
        get {
            FlowState(selectedHero: selectedHero)
        }
        set {
            selectedHero = newValue.selectedHero
        }
    }
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    rootReducer.pullback(
        state: \AppState.rootState,
        action: /AppAction.root,
        environment: { $0 }
    ),
    detailsReducer.pullback(
        state: \AppState.detailsState,
        action: /AppAction.details,
        environment: { $0 }
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

let testState = AppState(
    status: .idle,
    allHeros: [
        Hero(name: "Name 1", biography: "Biography"),
        Hero(name: "Name 2", biography: "Biography"),
        Hero(name: "Name 3", biography: "Biography"),
        Hero(name: "Name 4", biography: "Biography"),
        Hero(name: "Name 5", biography: "Biography"),
        Hero(name: "Name 6", biography: "Biography"),
        Hero(name: "Name 7", biography: "Biography"),
        Hero(name: "Name 8", biography: "Biography")
    ],
    squadHeros: [
        Hero(name: "Name 1", biography: "Biography"),
        Hero(name: "Name 2", biography: "Biography"),
        Hero(name: "Name 3", biography: "Biography"),
        Hero(name: "Name 4", biography: "Biography"),
        Hero(name: "Name 5", biography: "Biography"),
        Hero(name: "Name 6", biography: "Biography")
    ]
)
