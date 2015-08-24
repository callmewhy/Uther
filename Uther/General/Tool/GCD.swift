//
//  GCD.swift
//  Uther
//
//  Created by why on 7/30/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import GCD

struct GCD {
    static func async_in_worker(closure: GCDClosure) {
        gcd.async(.Default, closure: closure)
    }
    static func async_in_main(closure: GCDClosure) {
        gcd.async(.Main, closure: closure)
    }
}