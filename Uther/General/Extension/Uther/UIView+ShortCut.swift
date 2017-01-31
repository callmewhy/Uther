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
    
    func setWidth(_ width:CGFloat) {
        self.frame.size.width = width
    }
    
    func setHeight(_ height:CGFloat) {
        self.frame.size.height = height
    }
    
    func setSize(_ size:CGSize) {
        self.frame.size = size
    }
    
    func setOrigin(_ point:CGPoint) {
        self.frame.origin = point
    }
    
    func setX(_ x:CGFloat) {
        self.frame.origin = CGPoint(x: x, y: self.frame.origin.y)
    }
    
    func setY(_ y:CGFloat) {
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: y)
    }
    
    func setCenterX(_ x:CGFloat) {
        self.center = CGPoint(x: x, y: self.center.y)
    }
    
    func setCenterY(_ y:CGFloat) {
        self.center = CGPoint(x: self.center.x, y: y)
    }
    
    func roundCorner(_ radius:CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func setTop(_ top:CGFloat) {
        self.frame.origin.y = top
    }
    
    func setLeft(_ left:CGFloat) {
        self.frame.origin.x = left
    }
    
    func setRight(_ right:CGFloat) {
        self.frame.origin.x = right - self.frame.size.width
    }
    
    func setBottom(_ bottom:CGFloat) {
        self.frame.origin.y = bottom - self.frame.size.height
    }
}
