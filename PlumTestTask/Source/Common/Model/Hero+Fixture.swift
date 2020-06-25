//
//  Hero+Fixture.swift
//  PlumTestTaskTests
//
//  Created by Adrian Śliwa on 25/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

@testable import PlumTestTask

extension Hero {
    static func fixture(
        id: Int,
        comics: Comics = Comics(available: 0, items: [])
    ) -> Hero {
        Hero(
            id: id,
            name: "Hero \(id)",
            description: "Hero \(id) description",
            thumbnail: Thumbnail(path: "", extension: "jpg"),
            comics: comics
        )
    }
}
