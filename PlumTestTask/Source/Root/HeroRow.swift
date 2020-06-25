//
//  HeroListView.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 22/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct HeroRow: View {
    private let hero: Hero
    @ObservedObject
    private var viewStore: ViewStore<RootState, RootAction>
    
    init(hero: Hero, viewStore: ViewStore<RootState, RootAction>) {
        self.hero = hero
        self.viewStore = viewStore
    }
    
    var body: some View {
        Button(action: { [viewStore, hero] in viewStore.send(.select(hero: hero)) }) {
            HStack {
                image(forData: self.viewStore.herosToImageData[hero])
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .frame(width: 44, height: 44)
                Text(hero.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Insets.small)
                    .padding(.trailing, Insets.standard)
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.white.opacity(0.2))
            }
        }
        .buttonStyle(HighlightButtonStyle(color: Color.rowColor))
        .frame(maxWidth: .infinity, minHeight: 76, alignment: .leading)
    }
}
