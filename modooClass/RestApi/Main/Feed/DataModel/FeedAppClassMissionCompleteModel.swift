//
//  FeedAppClassMissionCompleteModel.swift
//  modooClass
//
//  Created by 조현민 on 13/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedAppClassMissionCompleteModel: NSObject {
    var code:String?
    var message:String?
    var results:FeedAppClassMissionCompleteResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = FeedAppClassMissionCompleteResult.init(dic: results)
        }
    }
}

class FeedAppClassMissionCompleteResult:NSObject{
    var type:String?
    var title:String?
    var content:String?
    var study_address:String?
    var study_type:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        type = DictionaryToString(dic: dic, strName: "type")
        title = DictionaryToString(dic: dic, strName: "title")
        content = DictionaryToString(dic: dic, strName: "content")
        study_address = DictionaryToString(dic: dic, strName: "study_address")
        study_type = DictionaryToString(dic: dic, strName: "study_type")
    }
}
