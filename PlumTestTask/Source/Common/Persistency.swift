//
//  Persistency.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 25/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Combine
import ComposableArchitecture

protocol Persistency {
    func load(forName name: String) -> Effect<Data, Error>
    func save(data: Data, forName name: String) -> Effect<Never, Error>
}

struct FilePersistency: Persistency {
    func load(forName name: String) -> Effect<Data, Error> {
        .catching {
            let fileURL = self.fileURL(forName: name)
            return try Data(contentsOf: fileURL)
        }
    }
    
    func save(data: Data, forName name: String) -> Effect<Never, Error> {
        Effect<Void, Error>.catching {
            let fileURL = self.fileURL(forName: name)
            try data.write(to: fileURL)
        }
        .ignoreOutput()
        .eraseToEffect()
    }
    
    private func fileURL(forName name: String) -> URL {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsUrl = URL(fileURLWithPath: documentsPath)
        return documentsUrl.appendingPathComponent(name)
    }
}

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
