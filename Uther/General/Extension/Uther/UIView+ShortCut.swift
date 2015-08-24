//
//  UIView+ShortCut.swift
//  Uther
//
//  Created by why on 8/5/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit

//UIView
extension UIView {
    var width:      CGFloat { return self.frame.size.width }
    var height:     CGFloat { return self.frame.size.height }
    var size:       CGSize  { return self.frame.size}
    
    var origin:     CGPoint { return self.frame.origin }
    var x:          CGFloat { return self.frame.origin.x }
    var y:          CGFloat { return self.frame.origin.y }
    var centerX:    CGFloat { return self.center.x }
    var centerY:    CGFloat { return self.center.y }
    
    var left:       CGFloat { return self.frame.origin.x }
    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    var top:        CGFloat { return self.frame.origin.y }
    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
    
    func setWidth(width:CGFloat) {
        self.frame.size.width = width
    }
    
    func setHeight(height:CGFloat) {
        self.frame.size.height = height
    }
    
    func setSize(size:CGSize) {
        self.frame.size = size
    }
    
    func setOrigin(point:CGPoint) {
        self.frame.origin = point
    }
    
    func setX(x:CGFloat) {
        self.frame.origin = CGPointMake(x, self.frame.origin.y)
    }
    
    func setY(y:CGFloat) {
        self.frame.origin = CGPointMake(self.frame.origin.x, y)
    }
    
    func setCenterX(x:CGFloat) {
        self.center = CGPointMake(x, self.center.y)
    }
    
    func setCenterY(y:CGFloat) {
        self.center = CGPointMake(self.center.x, y)
    }
    
    func roundCorner(radius:CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func setTop(top:CGFloat) {
        self.frame.origin.y = top
    }
    
    func setLeft(left:CGFloat) {
        self.frame.origin.x = left
    }
    
    func setRight(right:CGFloat) {
        self.frame.origin.x = right - self.frame.size.width
    }
    
    func setBottom(bottom:CGFloat) {
        self.frame.origin.y = bottom - self.frame.size.height
    }
}