//
//  IntExtension.swift
//  PinCodeTextField
//
//  Created by Alexander Tkachenko on 3/20/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation

internal extension Int {
    func times(f: () -> Void) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }

    func times( f: @autoclosure () -> Void) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
}
