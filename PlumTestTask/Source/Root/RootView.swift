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
    private var viewStore: ViewStore<RootState, RootAction>
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
            resultView = ActivityIndicator(
                isAnimating: .constant(true),
                style: .large
            )
                .eraseToAnyView()
        case .didFailToLoadHeros:
            resultView = Text(Strings.didFailToLoadHeros)
                .eraseToAnyView()
        case .idle:
            resultView = List {
                if viewStore.squadHeros.isNotEmpty {
                    VStack(alignment: .leading) {
                        Text(Strings.mySquad)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding([.leading, .trailing], 16)
                            .padding(.top, 8)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewStore.squadHeros, id: \.self) { hero in
                                    HeroCell(
                                        hero: hero,
                                        imageData: self.viewStore.state.herosToImageData[hero]
                                    )
                                    .padding([.trailing], 4)
                                    .onTapGesture {
                                        self.viewStore.send(.select(hero: hero))
                                    }
                                }
                            }
                            .padding([.leading, .trailing], 16)
                            .padding(.bottom, 8)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.background)
                    .padding([.bottom], 8)
                }
                ForEach(viewStore.allHeros, id: \.self) { hero in
                    HeroRow(
                        hero: hero,
                        imageData: self.viewStore.state.herosToImageData[hero]
                    )
                    .onTapGesture {
                        self.viewStore.send(.select(hero: hero))
                    }
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
                environment: AppEnvironment(herosProvider: HerosNetworkProvider())
            )
        )
    }
}
