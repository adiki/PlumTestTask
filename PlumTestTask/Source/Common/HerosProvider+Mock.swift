//
//  HerosProvider+Mock.swift
//  PlumTestTaskTests
//
//  Created by Adrian Śliwa on 25/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Combine
import Foundation
@testable import PlumTestTask

struct HerosProviderMock: HerosProvider {
    var fetchHerosMock: AnyPublisher<[Hero], Error> = Empty().eraseToAnyPublisher()
    var imageDataForHeroMock: (Hero) -> AnyPublisher<(data: Data, hero: Hero), Error>
        = { _ in Empty().eraseToAnyPublisher() }
    var imageDataForComicMock: (Comic) -> AnyPublisher<(data: Data, comic: Comic), Error>
        = { _ in Empty().eraseToAnyPublisher() }
    
    func fetchHeros() -> AnyPublisher<[Hero], Error> {
        return fetchHerosMock
    }
    
    func imageData(forHero hero: Hero) -> AnyPublisher<(data: Data, hero: Hero), Error> {
        return imageDataForHeroMock(hero)
    }
    
    func imageData(forComic comic: Comic) -> AnyPublisher<(data: Data, comic: Comic), Error> {
        return imageDataForComicMock(comic)
    }
}
