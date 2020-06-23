//
//  App.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 22/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture

struct AppState: Equatable {
    enum Status {
        case loading
        case idle
    }
    var status = Status.idle
    var allHeros: [Hero] = []
    var squadHeros: [Hero] = []
    
    func doesSquadContain(hero: Hero) -> Bool {
        squadHeros.contains(hero)
    }
}

enum AppAction {
    case initialize
}

struct AppEnvironment {
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .initialize:
        return .none
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
