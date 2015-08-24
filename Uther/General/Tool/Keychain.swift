//
//  Keychain.swift
//  Uther
//
//  Created by why on 8/8/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import Foundation
import KeychainAccess


struct Keychain {
    static private let keychain = KeychainAccess.Keychain(service: "com.callmewhy.uther")
    struct Keys {
        static let userId = "userid"
    }
    static var userId:String {
        get {
            if let uuid = keychain[Keys.userId] {
                log.info("\(uuid)")
                return uuid
            } else {
                let uuid = NSUUID().UUIDString
                keychain[Keys.userId] = uuid
                log.info("\(uuid)")
                return uuid
            }
        }
    }
}