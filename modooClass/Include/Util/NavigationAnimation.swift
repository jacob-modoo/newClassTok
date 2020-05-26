//
//  navigationAnimation.swift
//  modooClass
//
//  Created by 조현민 on 01/10/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation


public func navigationChange(navigation:UINavigationController){
    navigation.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigation.navigationBar.shadowImage = UIImage()
}

public func scrollViewAnimation(_ scrollView: UIScrollView , navigation:UINavigationController) {
    var offset = scrollView.contentOffset.y / 300
    
    if offset > 1{
        offset = 1
        navigation.navigationBar.tintColor = UIColor(hue: 1, saturation: offset, brightness: 1, alpha: 1)
        navigation.navigationBar.backgroundColor = UIColor(red: 116/255, green: 97/255, blue: 242/255, alpha: offset)
    }else{
        navigation.navigationBar.tintColor = UIColor(hue: 1, saturation: offset, brightness: 1, alpha: 1)
        navigation.navigationBar.backgroundColor = UIColor(red: 116/255, green: 97/255, blue: 242/255, alpha: offset)
    }
}
