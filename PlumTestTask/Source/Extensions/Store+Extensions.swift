//
//  Store+Extensions.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 22/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture

extension Store where State: Equatable {
    var view: ViewStore<State, Action> {
        return ViewStore(self)
    }
}
