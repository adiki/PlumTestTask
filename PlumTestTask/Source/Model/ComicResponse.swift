//
//  ComicResponse.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 24/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

struct ComicDetailsResponse: Decodable {
    struct Data: Decodable {
        let results: [ComicDetails]
    }
    let data: Data
}
