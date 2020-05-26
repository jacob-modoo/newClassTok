//
//  FeedAppClassCommunityReplyModel.swift
//  modooClass
//
//  Created by 조현민 on 10/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedAppClassCommunityReplyModel: NSObject {
    var code:String?
    var message:String?
    var results:FeedAppClassCommunityReplyResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = FeedAppClassCommunityReplyResult.init(dic: results)
        }
    }
    
}

class FeedAppClassCommunityReplyResult:NSObject{
    var mcCurriculum_id:Int?
    var class_name:String?
    var page:Int?
    var total:Int?
    var total_page:Int?
    var curr:Int?
    var list:AppClassReply?
    var replyList:Array = Array<AppClassReply>()
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        mcCurriculum_id = DictionaryToInt(dic: dic, intName: "mcCurriculum_id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        page = DictionaryToInt(dic: dic, intName: "page")
        total = DictionaryToInt(dic: dic, intName: "total")
        total_page = DictionaryToInt(dic: dic, intName: "total_page")
        curr = DictionaryToInt(dic: dic, intName: "curr")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = AppClassReply.init(dic: listTemp as! Dictionary<String, Any>)
                replyList.append(temp)
            }
        }
    }
}
