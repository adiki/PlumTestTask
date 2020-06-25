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
    private let imageData: Data?
    
    init(hero: Hero, imageData: Data?) {
        self.hero = hero
        self.imageData = imageData
    }
    
    var body: some View {
        VStack {
            image(forData: imageData)
                .renderingMode(.original)
                .resizable()                
                .scaledToFill()
                .foregroundColor(.white)
                .clipShape(Circle())        
                .frame(width: 64, height: 64)
            Text(hero.name)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: 80)
        }
    }
}
