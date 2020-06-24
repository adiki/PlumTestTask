//
//  Comic.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 24/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

struct Comic: Hashable, Decodable {
    let name: String
    let resourceURI: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: Comic, rhs: Comic) -> Bool {
        lhs.name == rhs.name
    }
}
