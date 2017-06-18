//
//  UIImage.swift
//  caloriedonate
//
//  Created by Hiroki Tanaka on 6/18/17.
//  Copyright © 2017 cobol. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    // 比率だけ指定する場合
    func resize(ratio: CGFloat) -> UIImage {
        let resizedSize = CGSize(width: Int(self.size.width * ratio), height: Int(self.size.height * ratio))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
