//
//  FeedInAppPurchaseModel.swift
//  modooClass
//
//  Created by 조현민 on 16/10/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
class FeedInAppPurchaseModel: NSObject {
    var code:String?
    var message:String?
    var results:FeedInAppPurchaseResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = FeedInAppPurchaseResult.init(dic: results)
        }
    }
}

class FeedInAppPurchaseResult:NSObject{
    var return_url:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        return_url = DictionaryToString(dic: dic, strName: "return_url")
    }
}
