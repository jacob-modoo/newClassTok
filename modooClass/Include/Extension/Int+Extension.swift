//
//  Int+Extension.swift
//  modooClass
//
//  Created by 조현민 on 26/08/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

extension Int {
    
    func numberFormatterModooClass(to : Int ) -> String{
        if to > 999{
            let rounding = (to + 50)/10*10
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let roundNumber = rounding
            let resultComma = numberFormatter.string(from: NSNumber(value:roundNumber))!
            let result = "\(resultComma.substring(0..<resultComma.count-2))천".replace(target: ",", withString: ".")
            return "\(result)"
        }else{
            return "\(to)"
        }
    }
    
    
}
func convertCurrency( money : NSNumber, style : NumberFormatter.Style ) -> String {
    
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = style
    
    return numberFormatter.string( from: money )!
}
