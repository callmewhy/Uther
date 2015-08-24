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
    func requestJSON(endpoint: T, completion: (JSON?) -> Void) -> Cancellable {
        return self.request(endpoint) { (data, status, response, error) in
            if let d = data {
                let json = JSON(data: d)
                log.debug("\(json)")
                completion(json)
            } else {
                log.error("\(error)")
                completion(nil)
            }
        }
    }
}