//
//  Comic+Fixture.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 25/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

@testable import PlumTestTask

extension Comic {
    static func fixture(number: Int) -> Comic {
        return Comic(name: "Comic #\(number)", resourceURI: "")
    }
}
