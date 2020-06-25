//
//  HighlightButtonStyle.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 25/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import SwiftUI

struct HighlightButtonStyle: ButtonStyle {
    
    private let color: Color
    
    init(color: Color) {
        self.color = color
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(Insets.standard)
            .background(configuration.isPressed ? color.opacity(0.5) : color)
            .cornerRadius(8)
    }
}

