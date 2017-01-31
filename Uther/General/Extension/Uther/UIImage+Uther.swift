//
//  UIImage+Uther.swift
//  Uther
//
//  Created by why on 8/5/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit

extension UIImage {
    static func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
