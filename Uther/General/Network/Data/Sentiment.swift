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
    case chinese(String)
    case english(String)
}

// MARK: - MoyaProvider
let SentimentProvider = MoyaProvider<Sentiment>()

// TODO: extension MoyaTarget to handle respose
extension MoyaProvider {
    typealias positiveHandler = (PositiveValue?) -> Void
    func requestCPositive(_ endpoint: Target, completion: @escaping positiveHandler) -> Cancellable {
        return self.requestJSON(endpoint, completion: { json in
            if let json = json {
                let code = json["code"].intValue
                if code == 0 {
                    let p = json["positive"].double
                    log.info("服务器返回解析结果：开心概率 = \(p)")
                    completion(p)
                    return
                } else {
                    let message = json["message"].stringValue
                }
            }
            completion(nil)
        })
    }
    
    func requestEPositive(_ endpoint: Target, completion: @escaping positiveHandler) -> Cancellable {
        return self.requestJSON(endpoint, completion: { json in
            if let json = json {
                let probability = json["probability"]
                let p = probability["pos"].double
                log.info("服务器返回解析结果：开心概率 = \(p)")
                completion(p)
                return
            }
            completion(nil)
        })
    }
}

// MARK: - MoyaTarget
extension Sentiment: TargetType {
    public var task: Task {
        return Task.request
    }

    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    public var baseURL: URL {
        switch self {
        case .chinese:
            return URL(string: "https://wenzhi.api.qcloud.com")!
        case .english:
            return URL(string: "http://text-processing.com")!
        }
    }
    
    public var path: String {
        switch self {
        case .chinese:
            return "v2/index.php"
        case .english:
            return "api/sentiment/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .chinese:
            return .get
        case .english:
            return .post
        }
    }

    public var parameters: [String : Any]? {
        switch self {
        case .chinese(let text):
            return QCloud.getRequestParameters(text)
        case .english(let text):
            return ["text": text as AnyObject]
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .chinese:
            return "{}".data(using: String.Encoding.utf8)!
        case .english:
            return "{\"probability\": {\"neg\": 0.22499999999999998,\"neutral\": 0.099999999999999978,\"pos\": 0.77500000000000002},\"label\": \"pos\"}".data(using: String.Encoding.utf8)!
        }
    }
    
    public var multipartBody: [Moya.MultipartFormData]? {
        return nil
    }
}
