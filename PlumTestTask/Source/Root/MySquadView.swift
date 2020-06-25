//
//  MySquadView.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 25/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct MySquadView: View {
    
    @ObservedObject private var viewStore: ViewStore<RootState, RootAction>
    
    init(viewStore: ViewStore<RootState, RootAction>) {
        self.viewStore = viewStore
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Strings.mySquad)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding([.leading, .trailing], Insets.standard)
                .padding(.top, 8)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewStore.squadHeros, id: \.self) { hero in
                        Button(action: { self.viewStore.send(.select(hero: hero)) }) {
                            HeroCell(
                                hero: hero,
                                imageData: self.viewStore.herosToImageData[hero]
                            )
                        }
                        .padding(.trailing, Insets.xSmall)
                    }
                }
                .padding([.leading, .trailing], Insets.standard)
                .padding(.bottom, Insets.small)
            }
        }
    }
}
