//
//  Indicator.swift
//  modooClass
//
//  Created by 조현민 on 08/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class Indicator {
    
    static var container: UIView = UIView()
    static var loadingView: UIView = UIView()
    static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    static var lottieView = AnimationView(name: "webViewLodingLottie3")
    
    /*
     Show customized activity indicator,
     actually add activity indicator to passing view
     
     @param uiView - add activity indicator to this view
     */
    static func showActivityIndicator(uiView: UIView) {
//        print(uiView.frame)
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x:0, y:0, width:80, height:80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x:0.0, y:0.0, width:40.0, height:40.0);
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x:loadingView.frame.size.width / 2, y:loadingView.frame.size.height / 2);
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    static func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    static func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
/*
     Show customized activity indicator,
     actually add activity indicator to passing view
     
     @param uiView - add activity indicator to this view
     */
    static func showLottieActivityIndicator(uiView: UIView) {
//        print(uiView.frame)
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.width/5, height:UIScreen.main.bounds.width/5)
//        loadingView.frame = CGRect(x:0, y:0, width:40, height:40)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.0)//0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        lottieView.loopMode = .loop
        lottieView.contentMode = .scaleAspectFill
        lottieView.animationSpeed = 0.5
        
        lottieView.frame = CGRect(x:0.0, y:0.0, width:UIScreen.main.bounds.width/5, height:UIScreen.main.bounds.width/5);
//        lottieView.frame = CGRect(x:0.0, y:0.0, width:40, height:40);
        lottieView.center = CGPoint(x:loadingView.frame.size.width / 2, y:loadingView.frame.size.height / 2);
//        activityIndicator.frame = CGRect(x:0.0, y:0.0, width:40.0, height:40.0);
//        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
//        activityIndicator.center = CGPoint(x:loadingView.frame.size.width / 2, y:loadingView.frame.size.height / 2);
        
        loadingView.addSubview(lottieView)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        lottieView.play()
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    static func hideLottieActivityIndicator(uiView: UIView) { 
        lottieView.stop()
        container.removeFromSuperview()
        
    }
    
}
