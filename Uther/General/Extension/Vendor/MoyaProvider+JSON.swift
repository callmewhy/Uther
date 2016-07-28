//
//  MoyaProvider+JSON.swift
//  Uther
//
//  Created by why on 8/11/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

extension MoyaProvider {
    func requestJSON(endpoint: Target, completion: (JSON?) -> Void) -> Cancellable {
        return self.request(endpoint) { result in
            switch result {
            case .Success(let data):
                let json = JSON(data: data.data)
                log.debug("\(json)")
                completion(json)
            case .Failure(let error):
                log.error("\(error)")
                completion(nil)
            }
        }
    }
}