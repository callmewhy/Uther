//
//  UICollectionView+Uther.swift
//  Uther
//
//  Created by why on 7/31/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit

extension UICollectionView {
    func scrollToBottom(animated:Bool = false) {
        let contentHeight = self.collectionViewLayout.collectionViewContentSize().height
        if contentHeight < CGRectGetHeight(self.bounds) {
            self.scrollRectToVisible(CGRectMake(0.0, 0, 1.0, 1.0), animated:animated)
            return;
        }
        self.scrollRectToVisible(CGRectMake(0.0, contentHeight - 1.0, 1.0, 1.0), animated:animated)
    }
}