//
//  Database.swift
//  Uther
//
//  Created by why on 7/31/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import SQLite

typealias Pid = Int64

struct DB {
    static let db = try! Connection(documentsDirectory.URLByAppendingPathComponent("uther.db").absoluteString)
    
    struct MessageDB {
        static let table = Table("message")
        // 唯一索引，主键
        static let pid = Expression<Pid>("pid")
        // 消息创建的时间
        static let createdTime = Expression<NSTimeInterval>("created_time")
        // 消息的内容
        static let content = Expression<String>("content")
        // 消息的类型
        static let type = Expression<MessageType.RawValue>("type")
        // 消息的其他附属内容， JSON 格式
        static let detail = Expression<String?>("detail")
    }

    static func setupDatabase() {
        do {
            try db.run(MessageDB.table.create(ifNotExists: true) { t in
                t.column(MessageDB.pid, primaryKey: true)
                t.column(MessageDB.createdTime)
                t.column(MessageDB.content)
                t.column(MessageDB.type)
                t.column(MessageDB.detail)
            })
        } catch {
            log.error("DB ERROR \(error)")
        }
    }
}