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
    static func makeRootView(store: Store<AppState, AppAction>) -> some View {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
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
                        NavigationLink(
                            "",
                            destination: DetailsView(
                                viewStore: store.detailStore.view
                            ),
                            isActive: store.flowStore.view.binding(
                                get: { $0.selectedHero != nil },
                                send: .detailsDismissed
                            )
                        )
                        .hidden()
                    }
                }
                .accentColor( .white)
            }
            .eraseToAnyView()
        }
        return RootView(
            viewStore: store.rootStore.view,
            flowDecorator: flowDecorator
        )
    }
}
