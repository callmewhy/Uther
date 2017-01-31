//
//  MessageComposerView.swift
//  Uther
//
//  Created by why on 7/29/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit

@objc protocol MessageComposerDelegate {
    func messageDidChange(_ textView: UITextView, height: CGFloat)
    func sendMessage(_ textView: UITextView, text: String)
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
    
    override func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
    }
    
    func scrollRectToVisible(_ rect: CGRect) {
        if contentSize.height < kMaxHeight {
            return
        }
        super.scrollRectToVisible(rect, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension MessageComposerView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            messageDelegate?.sendMessage(self, text: self.text)
            self.text = ""
            textViewDidChange(self)
            return false;
        }
        return true;
    }
    
    func textViewDidChange(_ textView: UITextView) {
        resetContentSizeAndOffset()
    }
}

// MARK: - Private
extension MessageComposerView {
    func resetContentSizeAndOffset() {
        layoutIfNeeded()
        messageDelegate?.messageDidChange(self, height: min(self.contentSize.height, kMaxHeight))
        if let selectedTextRange = self.selectedTextRange {
            let caretRect = self.caretRect(for: selectedTextRange.end);
            let height = textContainerInset.bottom + caretRect.size.height
            self.scrollRectToVisible(CGRect(x: caretRect.origin.x, y: caretRect.origin.y, width: caretRect.size.width, height: height))
        }
    }
}
