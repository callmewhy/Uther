//
//  String+JSON.swift
//  Uther
//
//  Created by why on 8/1/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import Foundation
import SwiftyJSON

extension String {
    var json: JSON {
        get {
            if let dataFromString = self.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                return JSON(data: dataFromString)
            } else {
                return JSON(self)
            }
        }
    }
}

extension JSON {
    var jsonString: String {
        get {
            return self.rawString() ?? ""
        }
    }
}
