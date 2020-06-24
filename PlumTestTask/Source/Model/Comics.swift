//
//  Comics.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 24/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

struct Comics: Decodable {
    let available: Int
    let items: [Comic]
}
