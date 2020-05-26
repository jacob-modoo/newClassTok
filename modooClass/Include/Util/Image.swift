//
//  Image.swift
//  modooClass
//
//  Created by 조현민 on 21/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
@IBDesignable extension UIImageView {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

public class ImageScale {
    func scaleImage(image:UIImage, view:UIImageView) -> UIImage {
        
        let oldWidth = image.size.width
        let oldHeight = image.size.height
        
        var scaleFactor:CGFloat
        var newHeight:CGFloat
        var newWidth:CGFloat
        let viewWidth:CGFloat = view.frame.width
        
        if oldWidth > oldHeight {
            
            scaleFactor = oldHeight/oldWidth
            newHeight = viewWidth * scaleFactor
            newWidth = viewWidth
        } else {
            
            scaleFactor = oldHeight/oldWidth
            newHeight = viewWidth * scaleFactor
            newWidth = viewWidth
        }
        
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
    func scaleImage(image:UIImage) -> UIImage {
        var new_image : UIImage!
        let size = CGSize(width:  image.size.width/2, height: image.size.height/2 )
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: rect)
        new_image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return new_image!
    }
}
