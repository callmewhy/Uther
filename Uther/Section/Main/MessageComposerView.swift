//
//  MessageComposerView.swift
//  Uther
//
//  Created by why on 7/29/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit

@objc protocol MessageComposerDelegate {
    func messageDidChange(textView: UITextView, height: CGFloat)
    func sendMessage(textView: UITextView, text: String)
}


private let kMaxHeight = CGFloat(150)

class MessageComposerView: UITextView {
    @IBOutlet weak var messageDelegate: AnyObject?
    
    let textPaddingH:CGFloat = 8.0
    let textPaddingV:CGFloat = 6.0

    override func awakeFromNib() {
        self.textContainerInset = UIEdgeInsetsMake(textPaddingV, textPaddingH, textPaddingV, textPaddingH)
        self.textContainer.lineFragmentPadding = 0
        self.layoutManager.allowsNonContiguousLayout = false
        self.delegate = self
    }
    
    override func scrollRectToVisible(rect: CGRect, animated: Bool) {
    }
    
    func scrollRectToVisible(rect: CGRect) {
        if contentSize.height < kMaxHeight {
            return
        }
        super.scrollRectToVisible(rect, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension MessageComposerView: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            messageDelegate?.sendMessage(self, text: self.text)
            self.text = ""
            textViewDidChange(self)
            return false;
        }
        return true;
    }
    
    func textViewDidChange(textView: UITextView) {
        resetContentSizeAndOffset()
    }
}

// MARK: - Private
extension MessageComposerView {
    func resetContentSizeAndOffset() {
        layoutIfNeeded()
        messageDelegate?.messageDidChange(self, height: min(self.contentSize.height, kMaxHeight))
        if let selectedTextRange = self.selectedTextRange {
            let caretRect = self.caretRectForPosition(selectedTextRange.end);
            let height = textContainerInset.bottom + caretRect.size.height
            self.scrollRectToVisible(CGRectMake(caretRect.origin.x, caretRect.origin.y, caretRect.size.width, height))
        }
    }
}