//
//  Array+Uther.swift
//  Uther
//
//  Created by why on 8/2/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import Foundation

extension Array {
    func last(i: Int) -> ArraySlice<Element> {
        return self[max(count-i, 0) ..< count]
    }
}