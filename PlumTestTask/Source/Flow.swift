//
//  Flow.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 24/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture

struct FlowState: Equatable {
    var selectedHero: Hero?
}

enum FlowAction {
    case detailsDismissed
}

let flowReducer = Reducer<FlowState, FlowAction, ()> { state, action, _ in
    switch action {
    case .detailsDismissed:
        state.selectedHero = nil
        return .none
    }
}
