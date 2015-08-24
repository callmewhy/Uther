//
//  Dictionary+Operator.swift
//  Uther
//
//  Created by why on 8/6/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import Foundation

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}