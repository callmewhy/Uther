//
//  MainDataSource.swift
//  Uther
//
//  Created by why on 7/30/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SwiftDate
import SwiftHEXColors

class MainDataSource: NSObject {
    private var messages:[Message] = []

    func loadFromDatabase() -> Int {
        let offset = messages.count
        messages = DB.getReverseMessages(offset, limit: 3).reverse() + messages
        return messages.count - offset
    }
    
    func addTextMessage(text:String, saved:([Message])->(), received:(EventType)->()) {
        let message = TextMessage(text: text)
        message.saveToDatabase()
        messages.append(message)
        saved(messages)
        
        Uther.handleMessage(text, completion: { e in
            switch e {
            case let .Emoji(p):
                message.positive = p
                message.saveToDatabase()
            default:
                break
            }
            received(e)
        })
    }

    func removeMessageAtIndex(i: Int) -> Message? {
        if i >= 0 && i < messages.count {
            return messages.removeAtIndex(i)
        }
        return nil
    }
}

// MARK: - UICollectionViewDataSource
extension MainDataSource: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionView = collectionView as! JSQMessagesCollectionView
        let dataSource = collectionView.dataSource!
        let message = dataSource.collectionView(collectionView, messageDataForItemAtIndexPath: indexPath)
        
        // cell
        let identifier: String = JSQMessagesCollectionViewCellOutgoing.cellReuseIdentifier()
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        cell.delegate = collectionView
        cell.backgroundColor = UIColor.clearColor()
        
        // label
        cell.cellTopLabel!.attributedText = dataSource.collectionView?(collectionView, attributedTextForCellTopLabelAtIndexPath: indexPath)
        cell.messageBubbleTopLabel!.attributedText = dataSource.collectionView?(collectionView, attributedTextForMessageBubbleTopLabelAtIndexPath: indexPath)
        cell.cellBottomLabel!.attributedText = dataSource.collectionView?(collectionView, attributedTextForCellBottomLabelAtIndexPath: indexPath)
        
        // text
        cell.textView!.text = message.text!()
        cell.textView!.textColor = UIColor(hexString: "#F5F5F5")!
        cell.textView!.userInteractionEnabled = false
        
        // bubble image
        if let bubbleDataSource = dataSource.collectionView(collectionView, messageBubbleImageDataForItemAtIndexPath: indexPath) {
            cell.messageBubbleImageView!.image = bubbleDataSource.messageBubbleImage()
            cell.messageBubbleImageView!.highlightedImage = bubbleDataSource.messageBubbleHighlightedImage()
        }
        
        return cell
    }
}

// MARK: - JSQMessagesCollectionViewDataSource
extension MainDataSource: JSQMessagesCollectionViewDataSource {
    func senderDisplayName() -> String! {
        return ""
    }
    
    func senderId() -> String! {
        return "ME"
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let factory = JSQMessagesBubbleImageFactory()
        return factory.outgoingMessagesBubbleImageWithColor(UIColor(white: 1, alpha: 0.2))
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        let attributes = [ NSForegroundColorAttributeName: UIColor(hexString: "#F5F5F5")!.colorWithAlphaComponent(0.5) ]
        // FIXME
        let time = NSAttributedString(string: message.date.toString()!, attributes: attributes)
        return time
    }
}
