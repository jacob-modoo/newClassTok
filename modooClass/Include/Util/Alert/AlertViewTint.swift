//
//  AlertViewTint.swift
//  modooClass
//
//  Created by 조현민 on 17/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
extension UIAlertController{
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.tintColor = UIColor(hexString: "#38384d")
    }
}
