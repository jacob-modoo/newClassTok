//
//  UIView_Fade.swift
//  modooClass
//
//  Created by 조현민 on 25/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

@IBDesignable extension UIView {
    
    //UIView Fade In
    func fadeIn(_ duration: TimeInterval = 1.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    //UIView Fade Out
    func fadeOut(_ duration: TimeInterval = 1.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.3
        }, completion: completion)
    }
    
    func fadeInOut(_ duration: TimeInterval = 1.5, delay: TimeInterval = 0.0,alpha:CGFloat = 1.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = alpha//0.3
        }, completion: completion)
    }

    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func pageConstrainCentered(_ subview: UIView) {
      
      subview.translatesAutoresizingMaskIntoConstraints = false
      
      let verticalContraint = NSLayoutConstraint(
        item: subview,
        attribute: .centerY,
        relatedBy: .equal,
        toItem: self,
        attribute: .centerY,
        multiplier: 1.0,
        constant: 0)
      
      let horizontalContraint = NSLayoutConstraint(
        item: subview,
        attribute: .centerX,
        relatedBy: .equal,
        toItem: self,
        attribute: .centerX,
        multiplier: 1.0,
        constant: 0)
      
      let heightContraint = NSLayoutConstraint(
        item: subview,
        attribute: .height,
        relatedBy: .equal,
        toItem: nil,
        attribute: .notAnAttribute,
        multiplier: 1.0,
        constant: subview.frame.height)
      
      let widthContraint = NSLayoutConstraint(
        item: subview,
        attribute: .width,
        relatedBy: .equal,
        toItem: nil,
        attribute: .notAnAttribute,
        multiplier: 1.0,
        constant: subview.frame.width)
      
      addConstraints([
        horizontalContraint,
        verticalContraint,
        heightContraint,
        widthContraint])
      
    }
    
    func pageConstrainToEdges(_ subview: UIView) {
      
      subview.translatesAutoresizingMaskIntoConstraints = false
      
      let topContraint = NSLayoutConstraint(
        item: subview,
        attribute: .top,
        relatedBy: .equal,
        toItem: self,
        attribute: .top,
        multiplier: 1.0,
        constant: 0)
      
      let bottomConstraint = NSLayoutConstraint(
        item: subview,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: self,
        attribute: .bottom,
        multiplier: 1.0,
        constant: 0)
      
      let leadingContraint = NSLayoutConstraint(
        item: subview,
        attribute: .leading,
        relatedBy: .equal,
        toItem: self,
        attribute: .leading,
        multiplier: 1.0,
        constant: 0)
      
      let trailingContraint = NSLayoutConstraint(
        item: subview,
        attribute: .trailing,
        relatedBy: .equal,
        toItem: self,
        attribute: .trailing,
        multiplier: 1.0,
        constant: 0)
      
      addConstraints([
        topContraint,
        bottomConstraint,
        leadingContraint,
        trailingContraint])
    }
    
    /** the hitTest method is used to make likeCountBtn to be visible even out of bounds of its parent view***/
    func overlapHitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        // 1
        if !self.isUserInteractionEnabled || self.isHidden || self.alpha == 0 {
            return nil
        }
        //2
        var hitView: UIView? = self
        if !self.point(inside: point, with: event) {
            if self.clipsToBounds {
                return nil
            } else {
                hitView = nil
            }
        }
        //3
        for subview in self.subviews.reversed() {
            let insideSubview = self.convert(point, to: subview)
            if let sview = subview.overlapHitTest(point: insideSubview, withEvent: event) {
                return sview
            }
        }
        return hitView
    }
    
    /**the extension for  UIView to make corners rounded*/
    func roundedView(usingCorners corners: UIRectCorner, cornerRadii: CGSize)
    {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: cornerRadii)

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath

        self.layer.mask = maskLayer
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static func instantiate(autolayout: Bool = true) -> Self {
        func instantiateUsingNib<T: UIView>(autolayout: Bool) -> T {
            let view = self.nib.instantiate() as! T
            view.translatesAutoresizingMaskIntoConstraints = !autolayout
            return view
        }
        return instantiateUsingNib(autolayout: autolayout)
     }
}

extension UINib {
    func instantiate() -> Any? {
        return instantiate(withOwner: nil, options: nil).first
    }
}
