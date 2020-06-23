//
//  Strings.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 23/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Foundation

enum Strings {
    static let recruitToSquad = "💪 Recruit to Squad"
    static let fireFromSquad = "🔥 Fire from Squad"
    static let lastAppearedIn = "Last appeared in"    
    
    static func andOtherComic(number: Int) -> String {
        "and \(number) other comic\(number > 1 ? "s" : "")"
    }
}
