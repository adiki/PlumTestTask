//
//  HerosProvider.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 24/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Combine
import Foundation

protocol HerosProvider {
    func fetchHeros() -> AnyPublisher<[Hero], Error>
    func imageData(forHero hero: Hero) -> AnyPublisher<(data: Data, hero: Hero), Error>
    func imageData(forComic comic: Comic) -> AnyPublisher<(data: Data, comic: Comic), Error>
}

enum ProviderError: Error {
    case invalidURL
    case invalidComicDetailsResponse
    case networkError(URLError)
}

enum ImageSize: String {
    case square = "standard_xlarge"
    case portrait = "portrait_fantastic"
}

struct HerosNetworkProvider: HerosProvider {
    func fetchHeros() -> AnyPublisher<[Hero], Error> {
        guard let authenticatedURL = authenticatedURL(
            forPath: "https://gateway.marvel.com/v1/public/characters",
            additionalQueryItems: [URLQueryItem(name: "limit", value: "100")]
        ) else {
            return Fail<[Hero], Error>(error: ProviderError.invalidURL)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: authenticatedURL)
            .map { $0.data }
            .decode(type: HeroResponse.self, decoder: JSONDecoder())
            .map { $0.data.results }            
            .eraseToAnyPublisher()
    }
    
    func imageData(forHero hero: Hero) -> AnyPublisher<(data: Data, hero: Hero), Error> {
        imageData(forPath: hero.thumbnail.path, extension: hero.thumbnail.extension, imageSize: .square)
            .map { (data: $0, hero: hero) }
            .eraseToAnyPublisher()
    }
    
    func imageData(forComic comic: Comic) -> AnyPublisher<(data: Data, comic: Comic), Error> {
        return fetchComicDetails(urlString: comic.resourceURI)
            .map { $0.thumbnail }
            .flatMap {
                self.imageData(forPath: $0.path, extension: $0.extension, imageSize: .portrait)
            }
            .map { (data: $0, comic: comic) }
            .eraseToAnyPublisher()
    }
    
    func fetchComicDetails(urlString: String) -> AnyPublisher<ComicDetails, Error> {
        guard let authenticatedURL = authenticatedURL(forPath: urlString) else {
            return Fail<ComicDetails, Error>(error: ProviderError.invalidURL)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: authenticatedURL)
            .map { $0.data }
            .decode(type: ComicDetailsResponse.self, decoder: JSONDecoder())
            .tryMap {
                guard let comicDetails = $0.data.results.first else {
                    throw ProviderError.invalidComicDetailsResponse
                }
                return comicDetails
            }
            .eraseToAnyPublisher()
    }
    
    private func imageData(forPath path: String, extension: String, imageSize: ImageSize) -> AnyPublisher<Data, Error> {
        let urlString = "\(path)/\(imageSize.rawValue).\(`extension`)"
            .replacingOccurrences(of: "http:", with: "https:")
        guard let url = URL(string: urlString) else {
            return Fail<Data, Error>(error: ProviderError.invalidURL)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError(ProviderError.networkError)
            .eraseToAnyPublisher()
    }
    
    private func authenticatedURL(forPath path: String, additionalQueryItems: [URLQueryItem] = []) -> URL? {
        let ts = Date().timeIntervalSince1970.description
        let privateKey = "3c8e16e3cece0b64b074150b8e36f4314b889762"
        let publicKey = "4e945060d999458c342c2cbedbef082c"
        var urlComponents = URLComponents(string: path)!
        urlComponents.scheme = "https"
        urlComponents.queryItems = [
            URLQueryItem(name: "ts", value: ts),
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "hash", value: MD5(string: ts + privateKey + publicKey))
        ] + additionalQueryItems
        return urlComponents.url
    }
}
