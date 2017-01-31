//
//  LOG.swift
//  Uther
//
//  Created by why on 7/30/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit
import XCGLogger

let log: XCGLogger = {
    let log = XCGLogger.default
    let logPath : NSURL = cacheDirectory.appendingPathComponent("XCGLogger.Log") as NSURL
    log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: false, writeToFile: logPath, fileLevel: .info)
    return log
    }()

var documentsDirectory: URL {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.endIndex-1]
}

var cacheDirectory: URL {
    let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    return urls[urls.endIndex-1]
}
