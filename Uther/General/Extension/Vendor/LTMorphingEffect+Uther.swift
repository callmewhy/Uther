//
//  LTMorphingEffect+Uther.swift
//  Uther
//
//  Created by why on 8/12/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import Foundation
import LTMorphingLabel


private var index = 0
extension LTMorphingEffect {
    static func next() -> LTMorphingEffect {
        let max = 7
        let i = index < max ? index : ((index - max) / 3) % 7
        index++
        log.debug("\(i)")
        return LTMorphingEffect(rawValue: i)!
    }
}
