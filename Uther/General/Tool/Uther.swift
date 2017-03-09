//
//  Uther.swift
//  Uther
//
//  Created by why on 8/8/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Uther {
    struct JsonKey {
        static let currentVersion = "curent_version"
        static let userDictionary = "user_dictionary"
    }
    
    fileprivate static var dictionary: [String:String]?
    
    static func handleMessage(_ text:String, completion:@escaping (EventType)->()) {
        // 查看版本
        if text.uppercased() == "VERSION" {
            completion(.text(UIApplication.versionDescription()))
            return
        }
        // 开启测试模式
        if text.uppercased() == "DEBUG" {
            debug = !debug
            completion(.text("DEBUG MODE ON"))
            return
        }
        // 如果处于测试模式，则随机显示一个表情
        if debug {
            let r = Double(arc4random() % 10) * 0.1
            completion(.emoji(r))
            return
        }
        
        // 本地词库检测
        if let d = dictionary, let localResult = d[text.uppercased()] {
            completion(.text(localResult))
            return
        }
        // 联网检测
        if text.isChinese {
            SentimentProvider.requestCPositive(Sentiment.chinese(text)) { p in
                if let p = p {
                    completion(.emoji(p))
                } else {
                    completion(.error)
                }
            }
        } else {
            SentimentProvider.requestEPositive(Sentiment.english(text)) { p in
                if let p = p {
                    completion(.emoji(p))
                } else {
                    completion(.error)
                }
            }
        }
    }
}
