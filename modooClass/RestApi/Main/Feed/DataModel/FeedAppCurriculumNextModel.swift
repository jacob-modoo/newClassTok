//
//  FeedAppCurriculumNextModel.swift
//  modooClass
//
//  Created by 조현민 on 12/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedAppCurriculumNextModel: NSObject {
    var code:String?
    var message:String?
    var results:FeedAppCurriculumNextResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = FeedAppCurriculumNextResult.init(dic: results)
        }
    }
}

class FeedAppCurriculumNextResult:NSObject{
    var id:Int?
    var mcClass_id:Int?
    var mcCurriculum_id:Int?
    var mcClassPayUser_id:Int?
    var user_id:Int?
    var created_at:String?
    var updated_at:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        mcClass_id = DictionaryToInt(dic: dic, intName: "mcClass_id")
        mcCurriculum_id = DictionaryToInt(dic: dic, intName: "mcCurriculum_id")
        mcClassPayUser_id = DictionaryToInt(dic: dic, intName: "mcClassPayUser_id")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        updated_at = DictionaryToString(dic: dic, strName: "updated_at")
    }
}
