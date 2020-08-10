//
//  Effect+Extensions.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 25/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture

extension Effect where Output == Never {
  public func promoteValue<T>() -> Effect<T, Failure> {
    func absurd<A>(_ never: Never) -> A {}
    return self.map(absurd)
  }
}
