//
//  RootViewBuilder.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 22/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

enum RootViewBuilder {
    static func makeRootView(viewStore: ViewStore<AppState, AppAction>) -> some View {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        let flowDecorator: (AnyView) -> AnyView = { view in
            GeometryReader { geometry in
                NavigationView {
                    ZStack {
                        Color.background.edgesIgnoringSafeArea(.all)
                        view
                            .navigationBarTitle("", displayMode: .inline)
                            .navigationBarItems(trailing:
                                Image(Images.marvelLogo)
                                    .frame(width: geometry.size.width)
                        )
                    }
                }
            }
            .eraseToAnyView()
        }
        return RootView(
            viewStore: viewStore,
            flowDecorator: flowDecorator
        )
    }
}
