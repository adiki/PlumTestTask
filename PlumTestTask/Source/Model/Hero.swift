//
//  Hero.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 22/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

struct Hero: Hashable, Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
    let comics: Comics
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Hero, rhs: Hero) -> Bool {
        lhs.id == rhs.id
    }
    
    var latestComic: Comic? {
        return comics.items.last
    }
    
    var comicJustBeforeLatest: Comic? {
        return comics.items.dropLast().last
    }
}
