//
//  QCloud.swift
//  Uther
//
//  Created by why on 8/10/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import Foundation
import CryptoSwift

struct QCloud {
    fileprivate struct Secret {
        static let id  = "YOUR_ID"
        static let key = "YOUR_KEY"
    }
    
    fileprivate struct ParameterName {
        static let action       = "Action"
        static let nonce        = "Nonce"
        static let region       = "Region"
        static let secretId     = "SecretId"
        static let timestamp    = "Timestamp"
        static let signature    = "Signature"
        static let content      = "content"
    }

    static func getRequestParameters(_ content: String) -> [String: String] {
        // Parameters
        var paras = [
            ParameterName.action      : "TextSentiment",
            ParameterName.nonce       : "\(arc4random_uniform(2333))",
            ParameterName.region      : "sz",
            ParameterName.secretId    : Secret.id,
            ParameterName.timestamp   : "\(Int(Date().timeIntervalSince1970))",
            ParameterName.content     : content
        ]
        
        let parasString = paras.sorted{ $0.0 < $1.0 }.map { "\($0.0)=\($0.1)" }.joined(separator: "&")
        
        // HMAC
        let msg = "GETwenzhi.api.qcloud.com/v2/index.php?\(parasString)"
        let key = Secret.key
        var keyBuff = [UInt8]()
        keyBuff += key.utf8
        var msgBuff = [UInt8]()
        msgBuff += msg.utf8
        let hmac = try! HMAC(key: keyBuff, variant: .sha1).authenticate(msgBuff)
        let signature = Data(bytes: hmac).base64EncodedString()
        paras += [ParameterName.signature: signature]
        return paras
    }
}
