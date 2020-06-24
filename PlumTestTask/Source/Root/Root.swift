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

enum RootAction {
    case initialize
    case didFailToFetchHeros
    case select(hero: Hero)
    case didFetchHeros([Hero])
    case didFetchImageData(Data, hero: Hero)
    case didFailToFetchHeroImageData
}

struct RootEnvironment {
    let herosProvider: HerosProvider
}

let rootReducer = Reducer<RootState, RootAction, RootEnvironment> { state, action, environment in
    switch action {
    case .initialize:
        state.status = .loading
        return environment.herosProvider.fetchHeros()
            .map { RootAction.didFetchHeros($0) }
            .replaceError(with: RootAction.didFailToFetchHeros)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    case .didFailToFetchHeros:
        state.status = .didFailToLoadHeros
        return .none
    case let .didFetchHeros(heros):
        state.allHeros = heros
        state.status = .idle
        return Publishers.MergeMany(heros.map { environment.herosProvider.imageData(forHero: $0) })
            .map { RootAction.didFetchImageData($0.data, hero: $0.hero) }
            .replaceError(with: .didFailToFetchHeroImageData)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    case let .select(hero: hero):
        state.selectedHero = hero
        return .none
    case let .didFetchImageData(imageData, hero):
        state.herosToImageData[hero] = imageData
        return .none
    case .didFailToFetchHeroImageData:
        return .none
    }
}
