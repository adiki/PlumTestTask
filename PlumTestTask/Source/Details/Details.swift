//
//  Details.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 23/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture

struct DetailsState: Equatable {
    var squadHeros: [Hero] = []
    var selectedHero: Hero?
    
    func doesSquadContain(hero: Hero) -> Bool {
        squadHeros.contains(hero)
    }
}

enum DetailsAction {
    case recruitOrFireButtonTapped(Hero)
}

let detailsReducer = Reducer<DetailsState, DetailsAction, AppEnvironment> { state, action, environment in
    switch action {
    case .recruitOrFireButtonTapped(let hero):
        if state.doesSquadContain(hero: hero) {
            state.squadHeros.removeAll(where: { $0 == hero })
        } else {
            state.squadHeros.insert(hero, at: 0)
        }
        return .none
    }
}
