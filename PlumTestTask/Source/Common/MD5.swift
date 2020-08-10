//
//  MD5.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 24/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import CryptoKit
import Foundation

func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
    return digest.map { String(format: "%02hhx", $0) }
        .joined()
}
