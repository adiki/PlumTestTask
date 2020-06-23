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
    private var viewStore: ViewStore<AppState, AppAction>
    private let hero: Hero
    
    init(
        viewStore: ViewStore<AppState, AppAction>,
        hero: Hero
    ) {
        self.viewStore = viewStore
        self.hero = hero
    }
    
    var body: some View {
        GeometryReader { [hero] geometry in
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
                    Button(action: {}) {
                        Text(Strings.recruitToSquad)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(16)
                    }
                    .frame(maxWidth: .infinity)
                    .filled()
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
        .edgesIgnoringSafeArea([.top])
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
                    ).view,
                    hero: Hero(
                        name: "Name 1",
                        biography: "This is long biography about some hero that is here to help us with our task to solve problem that are important to solve to help everyone have better tools for problem their face."
                    )
                )
            }
        }
    }
}

