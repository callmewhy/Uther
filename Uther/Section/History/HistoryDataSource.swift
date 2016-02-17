//
//  HistoryDataSource.swift
//  Uther
//
//  Created by why on 8/13/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SwiftDate
import SwiftHEXColors

class HistoryDataSource: NSObject {
    private var messages = [NSDate: [Message]]() {
        didSet {
            dataSource = Array(messages.keys).sort(>).map { date -> [Message] in self.messages[date]! }
        }
    }
    private var dataSource = [[Message]]()
    
    func loadFromDatabase() -> Int {
        let offset = dataSource.reduce(0) { $0 + $1.count }
        let newMessages = DB.getReverseMessages(offset, limit: 20)
        for message in newMessages {
            let date = message.date.startOf(NSCalendarUnit.Day, inRegion: Region.defaultRegion())
            var tMessages = messages[date] ?? []
            tMessages.append(message)
            messages[date] = tMessages
        }
        return dataSource.reduce(0) { $0 + $1.count } - offset
    }
}

// MARK: - Private
extension HistoryDataSource {
    private func removeMessage(indexPath: NSIndexPath) {
        let message = dataSource[indexPath.section][indexPath.row]
        var cMessages = messages[message.date.startOf(NSCalendarUnit.Day, inRegion: Region.defaultRegion())]
        if let index = cMessages!.indexOf(message) {
            cMessages!.removeAtIndex(index)
            messages[message.date.startOf(NSCalendarUnit.Day, inRegion: Region.defaultRegion())] = cMessages
            message.deleteFromDatabase()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HistoryDataSource: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath) as! HistoryCell
        let tMessages = dataSource[indexPath.section]
        let message = tMessages[indexPath.row]
        let isLast = (tMessages.count - 1 == indexPath.row)
        cell.update(message.text, seperatorHidden:isLast)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section][0].date.toString()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            removeMessage(indexPath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            break
        }
    }
}

