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
    @ObservedObject private var viewStore: ViewStore<RootState, RootAction>
    private let flowDecorator: (AnyView) -> AnyView
    
    init(
        viewStore: ViewStore<RootState, RootAction>,
        flowDecorator: @escaping (AnyView) -> AnyView
    ) {
        self.viewStore = viewStore
        self.flowDecorator = flowDecorator
        viewStore.send(.initialize)
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        let resultView: AnyView
        switch viewStore.status {
        case .loading:
            resultView = VStack {
                if viewStore.squadHeros.isNotEmpty {
                    MySquadView(viewStore: viewStore)
                }
                ActivityIndicator(
                    isAnimating: .constant(true),
                    style: .large
                )
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .padding(.top, 1)
            .eraseToAnyView()
        case .didFailToLoadHeros:
            resultView = Text(Strings.didFailToLoadHeros)
                .font(.title)
                .foregroundColor(.white)
                .eraseToAnyView()
        case .idle:
            resultView = List {
                if viewStore.squadHeros.isNotEmpty {
                    MySquadView(viewStore: viewStore)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.background)
                        .padding(.bottom, 8)
                }
                ForEach(viewStore.allHeros, id: \.self) { hero in
                    HeroRow(
                        hero: hero,
                        viewStore: self.viewStore
                    )
                }
                .listRowBackground(Color.background)
            }
            .padding(.top, 1)
            .eraseToAnyView()
        }
        return resultView
            .inject(flowDecorator: flowDecorator)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootViewBuilder.makeRootView(
            store: Store(
                initialState: AppState(),
                reducer: appReducer,
                environment: AppEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                    herosProvider: HerosNetworkProvider(),
                    persistency: FilePersistency()
                )
            )
        )
    }
}
