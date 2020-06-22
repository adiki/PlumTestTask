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
