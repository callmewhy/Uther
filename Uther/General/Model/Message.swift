//
//  Message.swift
//  Uther
//
//  Created by why on 7/31/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit
import SQLite
import SwiftyJSON
import JSQMessagesViewController

enum MessageType: Double {
    case text = 1001
}

class Message: JSQMessage {
    var pid: Pid?
    var type: MessageType
    let content: String
    var detail: JSON?
    
    init(type: MessageType, content: String, date: Date = Date()) {
        self.content = content
        self.type = type
        super.init(senderId: "ME", senderDisplayName: "", date: date, text: content)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Convinince
extension Message {
    func saveToDatabase() {
        pid = DB.saveMessage(self)
    }
    func deleteFromDatabase() {
        DB.deleteMessage(self)
    }
}

// MARK: DB extension
extension DB {
    fileprivate static func saveMessage(_ message: Message) -> Pid? {
        var setters = [
            DB.MessageDB.createdTime    <- message.date.timeIntervalSince1970,
            DB.MessageDB.content        <- message.content,
            DB.MessageDB.type           <- message.type.rawValue,
            DB.MessageDB.detail         <- message.detail?.jsonString]
        
        if let pid = message.pid {
            setters += [DB.MessageDB.pid <- pid]
        }
        let insert = DB.MessageDB.table.insert(or: OnConflict.replace, setters)
        do {
            let rowid = try DB.db.run(insert)
            return rowid
        } catch {
            log.error("insertion failed: \(error)")
        }
        return nil
    }
    fileprivate static func deleteMessage(_ message: Message) {
        if let pid = message.pid {
            let query = DB.MessageDB.table.filter(DB.MessageDB.pid == pid)
            query.delete()
        }
    }
    
    static func getReverseMessages(_ offset: Int, limit: Int) -> [Message]{
        var messages = [Message]()
        let q = DB.MessageDB.table.order(DB.MessageDB.pid.desc).limit(limit, offset: offset)
        for row in try! DB.db.prepare(q) {
            let type = MessageType(rawValue: row[DB.MessageDB.type])
            if let type = type {
                let date = NSDate(timeIntervalSince1970: row[DB.MessageDB.createdTime])
                let message = Message(type: type, content: row[DB.MessageDB.content], date:date as Date)
                message.pid    = row[DB.MessageDB.pid]
                message.detail = row[DB.MessageDB.detail]?.json
                messages.append(message)
            }
        }
        return messages
    }
}
