//
//  HeroResponse.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 24/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

struct HeroResponse: Decodable {
    struct Data: Decodable {
        let results: [Hero]
    }
    let data: Data
}
