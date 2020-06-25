//
//  Strings.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 23/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

enum Strings {
    static let mySquad = "My Squad"
    static let recruitToSquad = "💪 Recruit to Squad"
    static let fireFromSquad = "🔥 Fire from Squad"
    static let lastAppearedIn = "Last appeared in"
    static let didFailToLoadHeros = "Did fail to load heros"
    static let delete = "Delete"
    static let cancel = "Cancel"
    static func doYouWantToFire(name: String) -> String {
        "Do you want to fire \(name)?"
    }
    static func andOtherComic(number: Int) -> String {
        "and \(number) other comic\(number > 1 ? "s" : "")"
    }
}
