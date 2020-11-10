//
//  SquareLikeModel.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/10/29.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

class SquareLikeModel: NSObject {
    var code:String?
    var message:String?
    var results:SquareLikeModelResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = SquareLikeModelResult.init(dic: results)
        }
    }
}

class SquareLikeModelResult:NSObject{
    var cnt:Int?
    var comment_id:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        cnt = DictionaryToInt(dic: dic, intName: "cnt")
        comment_id = DictionaryToString(dic: dic, strName: "comment_id")
    }
}
