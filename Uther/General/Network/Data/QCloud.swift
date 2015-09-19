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
    private struct Secret {
        static let id  = "YOUR_ID"
        static let key = "YOUR_KEY"
    }
    
    private struct ParameterName {
        static let action       = "Action"
        static let nonce        = "Nonce"
        static let region       = "Region"
        static let secretId     = "SecretId"
        static let timestamp    = "Timestamp"
        static let signature    = "Signature"
        static let content      = "content"
    }

    static func getRequestParameters(content: String) -> [String: String] {
        // Parameters
        var paras = [
            ParameterName.action      : "TextSentiment",
            ParameterName.nonce       : "\(arc4random_uniform(2333))",
            ParameterName.region      : "sz",
            ParameterName.secretId    : Secret.id,
            ParameterName.timestamp   : "\(Int(NSDate().timeIntervalSince1970))",
            ParameterName.content     : content
        ]
        
        let parasString = paras.sort{ $0.0 < $1.0 }.map { "\($0.0)=\($0.1)" }.joinWithSeparator("&")
        
        // HMAC
        let msg = "GETwenzhi.api.qcloud.com/v2/index.php?\(parasString)"
        let key = Secret.key
        var keyBuff = [UInt8]()
        keyBuff += key.utf8
        var msgBuff = [UInt8]()
        msgBuff += msg.utf8
        let hmac = Authenticator.HMAC(key: keyBuff, variant: .sha1).authenticate(msgBuff)!
        let signature = NSData.withBytes(hmac).base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        paras += [ParameterName.signature: signature]
        return paras
    }
}