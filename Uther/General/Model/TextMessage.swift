//
//  TextMessage.swift
//  Uther
//
//  Created by why on 8/1/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias PositiveValue  = Double

class TextMessage: Message {
    // positive value, 0~1
    var positive: PositiveValue = 0.5 {
        didSet {
            detail = JSON(["positive": positive])
        }
    }

    init(text: String) {
        super.init(type: .Text, content: text)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
