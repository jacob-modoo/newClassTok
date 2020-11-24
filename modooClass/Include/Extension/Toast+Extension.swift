//
//  Toast+Extension.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/11/18.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

extension UIViewController {

    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height - 43, width: self.view.frame.size.width, height: 43))
        toastLabel.backgroundColor = UIColor(hexString: "#1A1A1A")
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .left
        toastLabel.text = message
        toastLabel.alpha = 1.0
        //toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.2, animations: {
         toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToast2(message : String, font: UIFont) {
        let toastWidth = CGFloat(message.count*13)
        let positionX = self.view.frame.width/2-(toastWidth/2)
        let positionY = self.view.frame.height-120
        let toastLabel = UILabel(frame: CGRect(x: positionX, y: positionY, width: toastWidth, height: 35))
        
        toastLabel.backgroundColor = UIColor(hexString: "#1A1A1A")
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .left
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.textAlignment = NSTextAlignment.center
        toastLabel.layer.cornerRadius = 17;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.2, animations: {
         toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
