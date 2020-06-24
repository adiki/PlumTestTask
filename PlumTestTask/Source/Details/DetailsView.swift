//
//  DetailsView.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 23/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct DetailsView: View {
    @ObservedObject
    private var viewStore: ViewStore<DetailsState, DetailsAction>
    
    init(viewStore: ViewStore<DetailsState, DetailsAction>) {
        self.viewStore = viewStore
    }
    
    var body: some View {
        guard let hero = viewStore.selectedHero else {
            return EmptyView().eraseToAnyView()
        }
        return ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        Image(Images.marvelLogo)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width,
                                   height: geometry.size.width
                        )
                        Text(hero.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding([.leading], 16)
                        Button(action: {
                            self.viewStore.send(.recruitOrFireButtonTapped(hero))
                        }) {
                            Text(self.viewStore.state.buttonTitle(for: hero))
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(16)
                        }
                        .frame(maxWidth: .infinity)
                        .style(for: hero, state: self.viewStore.state)
                        Text(hero.biography)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding([.leading], 16)
                        Text(Strings.lastAppearedIn)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(16)
                        HStack {
                            ComicCell()
                                .frame(minWidth: 0, maxWidth: .infinity)
                            ComicCell()
                                .frame(minWidth: 0, maxWidth: .infinity)
                        }
                        .padding([.leading, .trailing], 16)
                        Text(Strings.andOtherComic(number: 2))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(32)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea([.top])
        .eraseToAnyView()
    }
}

extension DetailsState {
    func buttonTitle(for hero: Hero) -> String {
        if doesSquadContain(hero: hero) {
            return Strings.fireFromSquad
        } else {
            return Strings.recruitToSquad
        }
    }
}

extension View {
    fileprivate func style(for hero: Hero, state: DetailsState) -> some View {
        if state.doesSquadContain(hero: hero) {
            return bordered().eraseToAnyView()
        } else {
            return filled().eraseToAnyView()
        }
    }
}


struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                DetailsView(
                    viewStore: Store(
                        initialState: testState,
                        reducer: appReducer,
                        environment: AppEnvironment()
                    ).detailStore.view
                )
            }
        }
    }
}

