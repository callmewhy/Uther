//
//  String+Uther.swift
//  Uther
//
//  Created by why on 8/1/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import Foundation

extension String {
    var toDouble: Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    var localized: String {
        let s = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        return s
    }
    
    var isChinese: Bool {
        return self.range(of: "\\p{Han}", options: .regularExpression) != nil
    }
}
