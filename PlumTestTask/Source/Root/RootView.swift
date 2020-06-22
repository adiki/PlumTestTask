//
//  RootView.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 22/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    private let flowDecorator: (AnyView) -> AnyView
    
    init(flowDecorator: @escaping (AnyView) -> AnyView) {
        self.flowDecorator = flowDecorator
    }
    
    var body: some View {
        Text("Hello world!")
            .eraseToAnyView()
            .inject(flowDecorator: flowDecorator)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootViewBuilder.makeRootView(
            viewStore: Store(
                initialState: AppState(),
                reducer: appReducer,
                environment: AppEnvironment()
            ).view
        )
    }
}
