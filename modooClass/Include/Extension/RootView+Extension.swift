//
//  TopViewControllerCheck.swift
//  modooClass
//
//  Created by 조현민 on 03/07/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}
