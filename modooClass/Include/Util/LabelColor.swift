//
//  LabelColor.swift
//  modooClass
//
//  Created by 조현민 on 14/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class LabelColor {
    
    static func colorLabelUpdateWithRage(mainMessage:String , ChangeMessage:String) -> NSMutableAttributedString{
        let main_string = mainMessage
        let string_to_color = ChangeMessage
        
        // With Text.
        let range = (main_string as NSString).range(of: string_to_color)
        
        let attributedString = NSMutableAttributedString(string: main_string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
        
        // With position
//        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#7461f2"), range: NSRange(location: 0, length: 7))
        
//        colorLabel.attributedText = attributedString
        return attributedString
    }
    
}
