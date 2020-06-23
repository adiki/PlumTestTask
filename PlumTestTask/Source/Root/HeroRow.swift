//
//  HeroListView.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 22/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import SwiftUI

struct HeroRow: View {
    private let hero: Hero
    
    init(hero: Hero) {
        self.hero = hero
    }
    
    var body: some View {
        HStack {
            Image(Images.marvelLogo)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 44, height: 44)
            Text(hero.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(8)
            Image(systemName: "chevron.right")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(Color.white.opacity(0.2))                
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 76, alignment: .leading)
        .background(Color.rowColor)        
        .cornerRadius(8)
    }
}
