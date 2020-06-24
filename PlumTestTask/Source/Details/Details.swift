//
//  Details.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 23/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Combine
import ComposableArchitecture

struct DetailsState: Equatable {
    var squadHeros: [Hero]
    let selectedHero: Hero?
    let herosToImageData: [Hero:Data]
    var comicsToImageData: [Comic:Data] = [:]
    
    func doesSquadContain(hero: Hero) -> Bool {
        squadHeros.contains(hero)
    }
}

enum DetailsAction {
    case fetchComicsImagesIfNeeded
    case didFetchImageData(Data, comic: Comic)
    case didFailToFetchComicImageData
    case recruitOrFireButtonTapped(Hero)
}

struct DetailsEnvironment {
    let herosProvider: HerosProvider
}

let detailsReducer = Reducer<DetailsState, DetailsAction, DetailsEnvironment> { state, action, environment in
    switch action {
    case .fetchComicsImagesIfNeeded:
        guard let selectedHero = state.selectedHero else {
            return .none
        }
        let lastTwoComics = selectedHero.comics.items.suffix(2)
        let comicsWithoutImageData = lastTwoComics.filter { state.comicsToImageData[$0] == nil }
        guard comicsWithoutImageData.isNotEmpty else {
            return .none
        }
        return Publishers.MergeMany(comicsWithoutImageData.map { environment.herosProvider.imageData(forComic: $0) })
            .map { DetailsAction.didFetchImageData($0.data, comic: $0.comic) }
            .replaceError(with: .didFailToFetchComicImageData)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    case let .didFetchImageData(imageData, comic):
        state.comicsToImageData[comic] = imageData
        return .none
    case .didFailToFetchComicImageData:
        return .none
    case .recruitOrFireButtonTapped(let hero):
        if state.doesSquadContain(hero: hero) {
            state.squadHeros.removeAll(where: { $0 == hero })
        } else {
            state.squadHeros.insert(hero, at: 0)
        }
        return .none
    }
}
