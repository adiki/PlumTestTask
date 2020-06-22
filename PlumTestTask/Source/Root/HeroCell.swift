//
//  HeroCell.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 22/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import SwiftUI

struct HeroCell: View {
    private let hero: Hero
    
    init(hero: Hero) {
        self.hero = hero
    }
    
    var body: some View {
        VStack {
            Image(Images.marvelLogo)
                .resizable()
                .clipShape(Circle())        
                .frame(width: 64, height: 64)
            Text(hero.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding([.trailing], 4)
    }
}
