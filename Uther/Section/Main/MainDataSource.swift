//
//  MainDataSource.swift
//  Uther
//
//  Created by why on 7/30/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit
import SwiftDate
import SwiftHEXColors
import JSQMessagesViewController

class MainDataSource: NSObject {
    fileprivate var messages:[Message] = []

    func loadFromDatabase() -> Int {
        let offset = messages.count
        messages = DB.getReverseMessages(offset, limit: 3).reversed() + messages
        return messages.count - offset
    }
    
    func addTextMessage(_ text:String, saved:([Message])->(), received:@escaping (EventType)->()) {
        let message = TextMessage(text: text)
        message.saveToDatabase()
        messages.append(message)
        saved(messages)
        
        Uther.handleMessage(text, completion: { e in
            switch e {
            case let .emoji(p):
                message.positive = p
                message.saveToDatabase()
            default:
                break
            }
            received(e)
        })
    }

    func removeMessageAtIndex(_ i: Int) -> Message? {
        if i >= 0 && i < messages.count {
            return messages.remove(at: i)
        }
        return nil
    }
}

// MARK: - UICollectionViewDataSource
extension MainDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionView = collectionView as! JSQMessagesCollectionView
        let dataSource = collectionView.dataSource!
        let message = dataSource.collectionView(collectionView, messageDataForItemAt: indexPath)
        
        // cell
        let identifier: String = JSQMessagesCollectionViewCellOutgoing.cellReuseIdentifier()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! JSQMessagesCollectionViewCell
        cell.delegate = collectionView
        cell.backgroundColor = UIColor.clear
        
        // label
        cell.cellTopLabel!.attributedText = dataSource.collectionView?(collectionView, attributedTextForCellTopLabelAt: indexPath)
        cell.messageBubbleTopLabel!.attributedText = dataSource.collectionView?(collectionView, attributedTextForMessageBubbleTopLabelAt: indexPath)
        cell.cellBottomLabel!.attributedText = dataSource.collectionView?(collectionView, attributedTextForCellBottomLabelAt: indexPath)
        
        // text
        cell.textView!.text = message?.text!()
        cell.textView!.textColor = UIColor(hexString: "#F5F5F5")!
        cell.textView!.isUserInteractionEnabled = false
        
        // bubble image
        if let bubbleDataSource = dataSource.collectionView(collectionView, messageBubbleImageDataForItemAt: indexPath) {
            cell.messageBubbleImageView!.image = bubbleDataSource.messageBubbleImage()
            cell.messageBubbleImageView!.highlightedImage = bubbleDataSource.messageBubbleHighlightedImage()
        }
        
        return cell
    }
}

// MARK: - JSQMessagesCollectionViewDataSource
extension MainDataSource: JSQMessagesCollectionViewDataSource {
    public func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }

    public func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let factory = JSQMessagesBubbleImageFactory()
        return factory!.outgoingMessagesBubbleImage(with: UIColor(white: 1, alpha: 0.2))
    }

    public func senderDisplayName() -> String! {
        return ""
    }
    
    public func senderId() -> String! {
        return "ME"
    }
    
    public func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    public func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
        
    }
    
    public func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        let attributes = [ NSForegroundColorAttributeName: UIColor(hexString: "#F5F5F5")!.withAlphaComponent(0.5) ]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: message.date)
        let time = NSAttributedString(string: dateString, attributes: attributes)
        return time
    }
}
