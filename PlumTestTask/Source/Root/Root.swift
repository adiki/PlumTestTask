//
//  Root.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 23/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture

struct RootState: Equatable {    
    var status: Status
    var allHeros: [Hero]
    var squadHeros: [Hero]
    var selectedHero: Hero?
}

enum RootAction {
    case initialize
    case select(Hero)
}

let rootReducer = Reducer<RootState, RootAction, AppEnvironment> { state, action, environment in
    switch action {
    case .initialize:
        return .none
    case .select(let hero):
        state.selectedHero = hero
        return .none
    }
}
