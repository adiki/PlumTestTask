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
    private let imageData: Data?
    
    init(hero: Hero, imageData: Data?) {
        self.hero = hero
        self.imageData = imageData
    }
    
    var body: some View {
        HStack {
            image(forData: imageData)
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
                .padding(8)
                .padding(.trailing, 16)
            Image(systemName: "chevron.right")
                .foregroundColor(Color.white.opacity(0.2))                
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 76, alignment: .leading)
        .background(Color.rowColor)        
        .cornerRadius(8)
    }
}
