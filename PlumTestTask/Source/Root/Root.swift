//
//  Root.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 23/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Combine
import ComposableArchitecture

struct RootState: Equatable {    
    var status: Status
    var allHeros: [Hero]
    var squadHeros: [Hero]
    var selectedHero: Hero?
    var herosToImageData: [Hero:Data] = [:]
}

enum RootAction: Equatable {
    case initialize
    case didFailToLoadSquadHeros
    case didLoadSqauadHeros([Hero])
    case didFailToFetchHeros
    case didFetchHeros([Hero])
    case didFetchImageData(Data, hero: Hero)
    case didFailToFetchHeroImageData
    case select(hero: Hero)
}

struct RootEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let herosProvider: HerosProvider
    let persistency: Persistency
}

let rootReducer = Reducer<RootState, RootAction, RootEnvironment> { state, action, environment in
    switch action {
    case .initialize:
        state.status = .loading
        let loadMySquad = environment.persistency.load(forName: Strings.squadHerosFilename)
            .tryMap { try JSONDecoder().decode([Hero].self, from: $0) }
            .map { RootAction.didLoadSqauadHeros($0) }
            .replaceError(with: RootAction.didFailToLoadSquadHeros)
        let fetchHeros = environment.herosProvider.fetchHeros()
            .map { RootAction.didFetchHeros($0) }
            .replaceError(with: RootAction.didFailToFetchHeros)
            .eraseToEffect()
        return Publishers.Merge(loadMySquad, fetchHeros)
            .receive(on: environment.mainQueue)
            .eraseToEffect()
    case .didFailToLoadSquadHeros:
        return .none
    case .didLoadSqauadHeros(let heros):
        state.squadHeros = heros
        return .none
    case .didFailToFetchHeros:
        state.status = .didFailToLoadHeros
        return .none
    case .didFetchHeros(let heros):
        state.allHeros = heros
        state.status = .idle
        return Publishers.MergeMany(heros.map { environment.herosProvider.imageData(forHero: $0) })
            .map { RootAction.didFetchImageData($0.data, hero: $0.hero) }
            .replaceError(with: .didFailToFetchHeroImageData)
            .receive(on: environment.mainQueue)
            .eraseToEffect()
    case let .didFetchImageData(imageData, hero):
        state.herosToImageData[hero] = imageData
        return .none
    case .didFailToFetchHeroImageData:
        return .none
    case .select(let hero):
        state.selectedHero = hero
        return .none
    }
}
