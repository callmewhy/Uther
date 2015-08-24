//
//  Double+Uther.swift
//  Uther
//
//  Created by why on 8/1/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import Foundation

extension Double {
    var emoji: String {
        get {
            return Emojis.getEmoji(positive: self)
        }
    }
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}


private let allEmojiDic = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Emoji", ofType: "plist")!)!

struct Emojis {
    static private var emojiDic = [String:[String]]()
    
    static func getEmoji(positive v:Double) -> String {
        var v = min(1, v)
        v = max(0, v)
        let key = v.format(".1")
        if let _ = allEmojiDic[key] {
            // check need update
            var needUpdate = false
            if let array = emojiDic[key] {
                needUpdate = array.isEmpty
            } else {
                needUpdate = true
            }
            if needUpdate {
                emojiDic[key] = allEmojiDic["\(key)"] as? [String]
            }
            
            // get emoji
            if var array = emojiDic[key] {
                if let _ = array.last {
                    let last = array.removeLast()
                    emojiDic[key] = array
                    return last
                }
            }
        }
        return "..."
    }
}
