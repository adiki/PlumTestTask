//
//  ComicCell.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 23/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import SwiftUI

struct ComicCell: View {
    
    private let comic: Comic
    private let imageData: Data?
    
    init(comic: Comic, imageData: Data?) {
        self.comic = comic
        self.imageData = imageData
    }

    var body: some View {
        VStack {
            image(forData: imageData)
                .resizable()
                .scaledToFit()                
            Text(comic.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(4)
        }
    }
}
