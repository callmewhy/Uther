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

private let devSetupAPI = "https://gitcafe.com/callmewhy/api/raw/dev/uther/setup.json"
private let inhouseSetupAPI = "https://gitcafe.com/callmewhy/api/raw/master/uther/setup.json"

struct Uther {
    struct JsonKey {
        static let currentVersion = "curent_version"
        static let userDictionary = "user_dictionary"
    }
    
    private static var dictionary: [String:String]?
    private static var needUpdate = false
    private static var setupAPI: String {
        get {
            #if DEBUG
                return devSetupAPI
            #else
                return inhouseSetupAPI
            #endif
        }
    }
    
    static func setup() {
        Alamofire.request(.GET, setupAPI).response() { _, _, data, error in
            if data?.length > 0 {
                self.setupWithJSON(JSON(data: data!))
            }
        }
    }
    
    static func handleMessage(text:String, completion:(EventType)->()) {
        // 查看版本
        if text.uppercaseString == "VERSION" {
            completion(.Text(UIApplication.versionDescription()))
            return
        }
        // 头像切换
        if text.uppercaseString == "CG" {
            completion(.Avatar("CGAvatar"))
            return
        }
        // 开启测试模式
        if text.uppercaseString == "DEBUG" {
            debug = !debug
            completion(.Text("开启 DEBUG 模式"))
            return
        }
        // 如果处于测试模式，则随机显示一个表情
        if debug {
            let r = Double(random() % 10) * 0.1
            completion(.Emoji(r))
            return
        }
        
        // 本地词库检测
        if let d = dictionary, let localResult = d[text.uppercaseString] {
            completion(.Text(localResult))
            return
        }
        // 需要更新
        if needUpdate {
            completion(.Text("(_・・_) " + "APP_NEED_UPDATE".localized))
            return
        }
        // 联网检测
        if text.isChinese {
            SentimentProvider.requestCPositive(Sentiment.Chinese(text)) { p in
                if let p = p {
                    completion(.Emoji(p))
                } else {
                    completion(.Error)
                }
            }
        } else {
            SentimentProvider.requestEPositive(Sentiment.English(text)) { p in
                if let p = p {
                    completion(.Emoji(p))
                } else {
                    completion(.Error)
                }
            }
        }
    }
    
    
    private static func setupWithJSON(json:JSON) {
        log.info("同步服务器配置！配置结果：\n\(json)")
        // check version
        let currentVersion  = json[JsonKey.currentVersion].string
        let selfVersion     = UIApplication.appVersion()
        if let c = currentVersion {
            switch selfVersion.compare(c, options: NSStringCompareOptions.NumericSearch) {
            case .OrderedSame:
                log.info("当前版本号 等于 服务器版本号")
            case .OrderedDescending:
                log.info("当前版本号 大于 服务器版本号")
            case .OrderedAscending:
                log.info("当前版本号 小于 服务器版本号")
                needUpdate = true
            }
        } else {
            Flurry.Error.Setup.logError("找不到最新版本号")
        }
        
        // update local dictionary
        if let d = json[JsonKey.userDictionary].dictionaryObject as? [String:String] {
            dictionary = d
        } else {
            Flurry.Error.Setup.logError("找不到热更新字典")
        }
    }
}
