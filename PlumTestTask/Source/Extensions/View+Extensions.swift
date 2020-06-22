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
}

