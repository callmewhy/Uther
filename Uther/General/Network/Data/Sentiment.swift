//
//  Sentiment.swift
//  Uther
//
//  Created by why on 7/30/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya

public enum Sentiment {
    case Chinese(String)
    case English(String)
}

// MARK: - MoyaProvider
let endpointResolver = { (endpoint: Endpoint<Sentiment>) -> (NSURLRequest) in
    let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as! NSMutableURLRequest
    request.timeoutInterval = 2.0
    return request
}
let SentimentProvider = MoyaProvider(endpointResolver: endpointResolver)

// TODO: extension MoyaTarget to handle respose
extension MoyaProvider {
    typealias positiveHandler = PositiveValue? -> Void
    func requestCPositive(endpoint: T, completion: positiveHandler) -> Cancellable {
        return self.requestJSON(endpoint, completion: { json in
            if let json = json {
                let code = json["code"].intValue
                if code == 0 {
                    let p = json["positive"].double
                    log.info("服务器返回解析结果：开心概率 = \(p)")
                    Flurry.Message.receivePositive(p)
                    completion(p)
                    return
                } else {
                    let message = json["message"].stringValue
                    Flurry.Error.Wenzhi.logError("文字情绪解析失败：\(message)")
                }
            }
            completion(nil)
        })
    }
    
    func requestEPositive(endpoint: T, completion: positiveHandler) -> Cancellable {
        return self.requestJSON(endpoint, completion: { json in
            if let json = json {
                let probability = json["probability"]
                let p = probability["pos"].double
                log.info("服务器返回解析结果：开心概率 = \(p)")
                Flurry.Message.receivePositive(p)
                completion(p)
                return
            }
            completion(nil)
        })
    }
}

// MARK: - MoyaTarget
extension Sentiment: MoyaTarget {
    public var baseURL: NSURL {
        switch self {
        case .Chinese:
            return NSURL(string: "https://wenzhi.api.qcloud.com")!
        case .English:
            return NSURL(string: "http://text-processing.com")!
        }
    }
    
    public var path: String {
        switch self {
        case .Chinese:
            return "v2/index.php"
        case .English:
            return "api/sentiment/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .Chinese:
            return .GET
        case .English:
            return .POST
        }
    }

    public var parameters: [String: AnyObject] {
        switch self {
        case .Chinese(let text):
            return QCloud.getRequestParameters(text)
        case .English(let text):
            return ["text": text]
        }
    }
    
    public var sampleData: NSData {
        switch self {
        case .Chinese:
            return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
        case .English:
            return "{\"probability\": {\"neg\": 0.22499999999999998,\"neutral\": 0.099999999999999978,\"pos\": 0.77500000000000002},\"label\": \"pos\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}