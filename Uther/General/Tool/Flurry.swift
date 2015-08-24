//
//  Flurry.swift
//  Uther
//
//  Created by why on 8/8/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import Foundation

extension Flurry {

    static func start() {
        Flurry.setUserID(Keychain.userId);
        Flurry.startSession("YOUR_API_KEY");
    }
    
    enum Error: String {
        case Setup   = "SetupError"
        case Wenzhi  = "WenzhiError"
        func logError(message: String) {
            let error = NSError(domain: "com.callmewhy.uther", code: 1001, userInfo: ["Message": message])
            Flurry.logError(self.rawValue, message: message, error: error)
            log.error(message)
        }
    }

    struct Message {
        private static let send     = "Send Message"
        private static let receive  = "Receive Positive"
        
        /// 用户发送一条消息
        static func sendMessage(l: Int) {
            Flurry.logEvent(send, withParameters: ["MessageLength": l])
        }
        
        /// 从服务器接收到消息的解析结果
        static func receivePositive(p: Double?) {
            if let p = p {
                Flurry.logEvent(receive, withParameters: ["MessagePositive": p])
            }
        }
    }

}
