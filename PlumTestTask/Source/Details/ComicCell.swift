//
//  ComicCell.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 23/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import SwiftUI

struct ComicCell: View {

    var body: some View {
        VStack {
            Image(Images.marvelLogo)
                .scaledToFill()
            Text("Hulk (2008) #54")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(4)
        }
    }
}
