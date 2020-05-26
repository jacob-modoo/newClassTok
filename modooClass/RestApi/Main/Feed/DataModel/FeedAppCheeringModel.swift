//
//  FeedAppCheeringModel.swift
//  modooClass
//
//  Created by 조현민 on 12/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedAppCheeringModel: NSObject {
    var code:String?
    var message:String?
    var results:FeedAppCheeringResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = FeedAppCheeringResult.init(dic: results)
        }
    }
}

class FeedAppCheeringResult:NSObject{
    var to_id:Int?
    var comment:String?
    var point:Int?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        to_id = DictionaryToInt(dic: dic, intName: "to_id")
        comment = DictionaryToString(dic: dic, strName: "comment")
        point = DictionaryToInt(dic: dic, intName: "point")
    }
}
