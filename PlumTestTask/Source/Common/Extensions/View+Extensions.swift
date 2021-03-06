//
//  View+Extensions.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 22/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import SwiftUI

extension View {
    func inject<A>(flowDecorator: (Self) -> A) -> A {
        return flowDecorator(self)
    }
    
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    func filled() -> some View {
        background(Color.appRed)
            .cornerRadius(8)
            .padding(Insets.standard)
    }
    
    func bordered() -> some View {
        overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.appRed, lineWidth: 4)
        )
        .padding(Insets.standard)
    }
    
    func image(forData data: Data?) -> Image {
        data
            .flatMap(UIImage.init(data:))
            .map(
                Image.init(uiImage:)
            )?.renderingMode(.original)
            ?? Image(systemName: "square.fill")
    }
}

