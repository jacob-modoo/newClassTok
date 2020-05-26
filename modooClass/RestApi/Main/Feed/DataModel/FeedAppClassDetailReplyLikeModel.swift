//
//  FeedAppClassDetailReplyLikeModel.swift
//  modooClass
//
//  Created by 조현민 on 07/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedAppClassDetailReplyLikeModel: NSObject {
    var code:String?
    var message:String?
    var results:AppClassLikeSave?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = AppClassLikeSave.init(dic: results)
        }
    }
}

class AppClassLikeSave:NSObject{
    var like:Int?
    var like_user:String?
    var mcComment_id:Int?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        like = DictionaryToInt(dic: dic, intName: "like")
        mcComment_id = DictionaryToInt(dic: dic, intName: "mcComment_id")
        like_user = DictionaryToString(dic: dic, strName: "like_user")
    }
}
