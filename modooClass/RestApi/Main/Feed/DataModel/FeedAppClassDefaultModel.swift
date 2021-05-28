//
//  FeedAppClassReplyDeleteModel.swift
//  modooClass
//
//  Created by 조현민 on 11/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedAppClassDefaultModel: NSObject {
    var code:String?
    var message:String?
    var results:Int?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        results = DictionaryToInt(dic: dic, intName: "results")
    }
}
