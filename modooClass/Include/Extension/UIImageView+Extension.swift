//
//  UIImageView+Extension.swift
//  modooClass
//
//  Created by 조현민 on 17/10/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}

//public protocol SizeOfImage {
//    var url: URL { get set }
//    func sizeOfImageAt(url: URL) -> CGSize? {
//            // with CGImageSource we avoid loading the whole image into memory
//            guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
//                return nil
//            }
//
//            let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
//            guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
//                return nil
//            }
//
//            if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
//                let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
//                return CGSize(width: width, height: height)
//            } else {
//                return nil
//            }
//        }
//}
