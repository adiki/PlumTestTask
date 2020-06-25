//
//  Persistency+Mock.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 25/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
@testable import PlumTestTask

struct PersistencyMock: Persistency {
    var loadMock: (String) -> Effect<Data, Error> = { _ in Empty().eraseToEffect() }
    var saveMock: (Data, String) -> Effect<Never, Error> = { _, _ in Empty().eraseToEffect() }
    
    func load(forName name: String) -> Effect<Data, Error> {
        return loadMock(name)
    }
    
    func save(data: Data, forName name: String) -> Effect<Never, Error> {
        return saveMock(data, name)
    }
}
