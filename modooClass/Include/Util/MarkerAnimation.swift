//
//  MarkerAnimation.swift
//  modooClass
//
//  Created by 조현민 on 01/10/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

class DisplayLinkAnimation {
    
    var displayLink:CADisplayLink!
    var invert:Bool = false
    let sparkle = UIView()
    open var value:CGFloat = 0.0
    open var corner:CGFloat = 0.0
    open var viewBackgroundColor:UIColor = UIColor.white
    
    @objc fileprivate func handleAnimation(){
        invert ? (value -= 1) : (value += 1)
        sparkle.backgroundColor = viewBackgroundColor.withAlphaComponent(value/100)
        if value > 100 || value < 0{
            invert = !invert
        }
    }

    open func setupCircle(vc:UIViewController ,view:UIView){
        displayLink = CADisplayLink(target: vc, selector: #selector(handleAnimation))
        displayLink.add(to: RunLoop.main, forMode: .default)
        view.addSubview(sparkle)
        sparkle.layer.cornerRadius = corner
        sparkle.backgroundColor = viewBackgroundColor
        sparkle.translatesAutoresizingMaskIntoConstraints = false
        sparkle.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sparkle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sparkle.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sparkle.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
