//
//  TabBarItem+Extension.swift
//  modooClass
//
//  Created by 조현민 on 03/09/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

extension UITabBarItem {
    func tabBarItemShowingOnlyImage() -> UITabBarItem {
        // offset to center
        self.imageInsets = UIEdgeInsets(top:6,left:0,bottom:-6,right:0)
        // displace to hide
        self.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 300 * 20)
        return self
    }
}
