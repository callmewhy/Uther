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
            composerView.layer.borderColor = UIColor(hexString: "#F4FFF8", alpha: 0.2)?.cgColor
            composerView.layer.borderWidth = 1
            composerView.layer.cornerRadius = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardAnimation()
        let _ = chatDataSource.loadFromDatabase()
        collectionView.backgroundColor = UIColor.clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.dataSource = chatDataSource
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        if collectionContainerView.layer.mask == nil {
            self.setupGradientMask();
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "uther_display" {
            utherViewController = segue.destination as! UtherDisplayViewController;
        }
    }
    
    @IBAction func backgroundTaped(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func inputBackgroundTaped(_ sender: AnyObject) {
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
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor];
        gradient.locations = [0, 0.3]
        collectionContainerView.layer.mask = gradient
    }
}

// MARK: - Private
extension MainViewController {
    fileprivate func updateCollectionViewWithMessages(_ messages: [Message]) {
        if messages.count <= 3 {
            return
        }
        let layout = collectionView.collectionViewLayout!
        let firstIndexPath = IndexPath(row: 0, section: 0)
        let firstCellHeight = layout.sizeForItem(at: firstIndexPath).height + layout.minimumLineSpacing
        let oldOffsetY = collectionView.contentOffset.y
        let oldContentHeight = layout.collectionViewContentSize.height
        
        let c = collectionView!
        UIView.animate(withDuration: 0) { _ in
            c.performBatchUpdates({
                let _ = self.chatDataSource.removeMessageAtIndex(0)
                c.deleteItems(at: [NSIndexPath(row: 0, section: 0) as IndexPath])
                c.contentOffset = CGPoint(x: 0, y: oldOffsetY - firstCellHeight)
            }, completion:nil)
        }
        
        let y = max(oldContentHeight - firstCellHeight - collectionView.height, 0.0)
        UIView.animate(withDuration: kDefaultAnimationDuration) { _ in
            c.contentOffset = CGPoint(x: 0, y: y)
        }
    }
}

// MARK: - MessageComposerDelegate
extension MainViewController: MessageComposerDelegate {
    func sendMessage(_ textView: UITextView, text: String) {
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
    
    func messageDidChange(_ textView: UITextView, height: CGFloat) {
        let oldH = heightConstraint.constant;
        let newH = height
        if (fabs(newH - oldH) > 1) {
            heightConstraint.constant = newH
            UIView.animate(withDuration: kDefaultAnimationDuration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
            collectionView.scrollToBottom(true)
        }
    }
}

// MARK: -  UICollectionDelegate
extension MainViewController: JSQMessagesCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! JSQMessagesCollectionViewFlowLayout
        return layout.sizeForItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, at indexPath: IndexPath!) {
        
    }
    
    func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapCellAt indexPath: IndexPath!, touchLocation: CGPoint) {
        view.endEditing(true)
    }
}
