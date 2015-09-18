//
//  MainViewController.swift
//  Uther
//
//  Created by why on 7/29/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit
import KeyboardMan
import JSQMessagesViewController

class MainViewController: UIViewController {
    
    let keyboardMan = KeyboardMan()
    let chatDataSource = MainDataSource()
    var keyboardShowing = false

    var utherViewController: UtherDisplayViewController!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionContainerView: UIView!
    @IBOutlet weak var collectionView: JSQMessagesCollectionView!
    
    @IBOutlet weak var composerView: UITextView! {
        didSet {
            composerView.textColor = UIColor(hexString: "#F4FFF8")
            composerView.backgroundColor = UIColor(white: 1, alpha: 0.05)
            composerView.layer.borderColor = UIColor(hexString: "#F4FFF8", alpha: 0.2)?.CGColor
            composerView.layer.borderWidth = 1
            composerView.layer.cornerRadius = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardAnimation()
        chatDataSource.loadFromDatabase()
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.keyboardDismissMode = .OnDrag
        collectionView.dataSource = chatDataSource
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        if collectionContainerView.layer.mask == nil {
            self.setupGradientMask();
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "uther_display" {
            utherViewController = segue.destinationViewController as! UtherDisplayViewController;
        }
    }
    
    @IBAction func backgroundTaped(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func inputBackgroundTaped(sender: AnyObject) {
        composerView.becomeFirstResponder()
    }
}

// MARK: - Setup
extension MainViewController {
    func setupKeyboardAnimation() {
        keyboardMan.animateWhenKeyboardAppear = { [unowned self] _, keyboardHeight, _ in
            self.bottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
            self.collectionView.scrollToBottom()
            self.keyboardShowing = true
        }
        keyboardMan.animateWhenKeyboardDisappear = { [unowned self] keyboardHeight in
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.keyboardShowing = false
        }
    }
    
    func setupGradientMask() {
        let gradient = CAGradientLayer();
        gradient.frame = collectionContainerView.bounds
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor];
        gradient.locations = [0, 0.3]
        collectionContainerView.layer.mask = gradient
    }
}

// MARK: - Private
extension MainViewController {
    private func updateCollectionViewWithMessages(messages: [Message]) {
        if messages.count <= 3 {
            return
        }
        let layout = collectionView.collectionViewLayout
        let firstIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        let firstCellHeight = layout.sizeForItemAtIndexPath(firstIndexPath).height + layout.minimumLineSpacing
        let oldOffsetY = collectionView.contentOffset.y
        let oldContentHeight = layout.collectionViewContentSize().height
        
        let c = collectionView
        UIView.animateWithDuration(0) { _ in
            c.performBatchUpdates({
                    self.chatDataSource.removeMessageAtIndex(0)
                    c.deleteItemsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)])
                    c.contentOffset = CGPointMake(0, oldOffsetY - firstCellHeight)
                },completion:nil)
        }
        
        let y = max(oldContentHeight - firstCellHeight - collectionView.height, 0.0)
        UIView.animateWithDuration(kDefaultAnimationDuration) { _ in
            c.contentOffset = CGPointMake(0, y)
        }
    }
}

// MARK: - MessageComposerDelegate
extension MainViewController: MessageComposerDelegate {
    func sendMessage(textView: UITextView, text: String) {
        Flurry.Message.sendMessage(text.characters.count)
        chatDataSource.addTextMessage(text,
            saved: { messages in
                self.collectionView.reloadData()
                self.updateCollectionViewWithMessages(messages)
            },
            received: { event in
                self.utherViewController.updateWithEventType(event)
            }
        )
    }
    
    func messageDidChange(textView: UITextView, height: CGFloat) {
        let oldH = heightConstraint.constant;
        let newH = height
        if (fabs(newH - oldH) > 1) {
            heightConstraint.constant = newH
            UIView.animateWithDuration(kDefaultAnimationDuration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
            collectionView.scrollToBottom(true)
        }
    }
}

// MARK: -  UICollectionDelegate
extension MainViewController: JSQMessagesCollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let layout = collectionViewLayout as! JSQMessagesCollectionViewFlowLayout
        return layout.sizeForItemAtIndexPath(indexPath)
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        view.endEditing(true)
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        view.endEditing(true)
    }
}