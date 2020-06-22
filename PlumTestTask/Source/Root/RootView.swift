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
    @ObservedObject
    private var viewStore: ViewStore<AppState, AppAction>
    private let flowDecorator: (AnyView) -> AnyView
    
    init(
        viewStore: ViewStore<AppState, AppAction>,
        flowDecorator: @escaping (AnyView) -> AnyView
    ) {
        self.viewStore = viewStore
        self.flowDecorator = flowDecorator        
        viewStore.send(.initialize)
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        let resultView: AnyView
        switch viewStore.status {
        case .loading:
            resultView = ActivityIndicator(
                isAnimating: .constant(true),
                style: .large
            )
                .eraseToAnyView()
        case .idle:
            resultView = List {
                if viewStore.squadHeros.isNotEmpty {
                    VStack(alignment: .leading) {
                        Text("My Squad")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewStore.squadHeros, id: \.self) { hero in
                                    HeroCell(hero: hero)
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.background)
                    .padding([.bottom], 8)
                }
                ForEach(viewStore.allHeros, id: \.self) { hero in
                    HeroRow(hero: hero)
                }
                .listRowBackground(Color.background)
            }
            .padding([.top, .bottom], 8)
            .eraseToAnyView()
        }
        return resultView
            .inject(flowDecorator: flowDecorator)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootViewBuilder.makeRootView(
            viewStore: Store(
                initialState: AppState(
                    status: .idle,
                    allHeros: [
                        Hero(name: "Name 1"),
                        Hero(name: "Name 2"),
                        Hero(name: "Name 3"),
                        Hero(name: "Name 4"),
                        Hero(name: "Name 5"),
                        Hero(name: "Name 6"),
                        Hero(name: "Name 7"),
                        Hero(name: "Name 8")
                    ],
                    squadHeros: [
                        Hero(name: "Name 1"),
                        Hero(name: "Name 2"),
                        Hero(name: "Name 3"),
                        Hero(name: "Name 4"),
                        Hero(name: "Name 5"),
                        Hero(name: "Name 6")
                    ]
                ),
                reducer: appReducer,
                environment: AppEnvironment()
            ).view
        )
    }
}
