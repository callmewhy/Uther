//
//  UICollectionView+Uther.swift
//  Uther
//
//  Created by why on 7/31/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit

extension UICollectionView {
    func scrollToBottom(_ animated:Bool = false) {
        let contentHeight = self.collectionViewLayout.collectionViewContentSize.height
        if contentHeight < self.bounds.height {
            self.scrollRectToVisible(CGRect(x: 0.0, y: 0, width: 1.0, height: 1.0), animated:animated)
            return;
        }
        self.scrollRectToVisible(CGRect(x: 0.0, y: contentHeight - 1.0, width: 1.0, height: 1.0), animated:animated)
    }
}
