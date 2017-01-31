//
//  HistoryDataSource.swift
//  Uther
//
//  Created by why on 8/13/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit
import SwiftDate
import SwiftHEXColors

class HistoryDataSource: NSObject {
    fileprivate var messages = [Date: [Message]]() {
        didSet {
            dataSource = Array(messages.keys).sorted(by: >).map { date -> [Message] in self.messages[date]! }
        }
    }
    fileprivate var dataSource = [[Message]]()
    
    func loadFromDatabase() -> Int {
        let offset = dataSource.reduce(0) { $0 + $1.count }
        let newMessages = DB.getReverseMessages(offset, limit: 20)
        for message in newMessages {
            let date = message.date.startOfDay
            var tMessages = messages[date] ?? []
            tMessages.append(message)
            messages[date] = tMessages
        }
        return dataSource.reduce(0) { $0 + $1.count } - offset
    }
}

// MARK: - Private
extension HistoryDataSource {
    fileprivate func removeMessage(_ indexPath: IndexPath) {
        let message = dataSource[indexPath.section][indexPath.row]
        var cMessages = messages[message.date.startOfDay]
        if let index = cMessages!.index(of: message) {
            cMessages!.remove(at: index)
            messages[message.date.startOfDay] = cMessages
            message.deleteFromDatabase()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HistoryDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        let tMessages = dataSource[indexPath.section]
        let message = tMessages[indexPath.row]
        let isLast = (tMessages.count - 1 == indexPath.row)
        cell.update(message.text, seperatorHidden:isLast)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section][0].date.toString()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            removeMessage(indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
}

