//
//  FeedReplyLikeModel.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/27.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedReplyLikeModel: NSObject {
    var code:String?
    var message:String?
    var results:FeedLikeResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = FeedLikeResult.init(dic: results)
        }
    }
}

class FeedLikeResult:NSObject{
    var page:Int?
    var total:Int?
    var total_page:Int?
    var curr:Int?
    var list:LikeFriendList?
    var friend_list:Array = Array<LikeFriendList>()
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        page = DictionaryToInt(dic: dic, intName: "page")
        total = DictionaryToInt(dic: dic, intName: "total")
        total_page = DictionaryToInt(dic: dic, intName: "total_page")
        curr = DictionaryToInt(dic: dic, intName: "curr")
        if let friendList = dic["list"] as? Array<Any>{
            let array:Array = friendList
            for list in array {
                let temp = LikeFriendList.init(dic: list as! Dictionary<String, Any>)
                friend_list.append(temp)
            }
        }
    }
}

class LikeFriendList:NSObject{
    var user_id:Int?
    var user_name:String?
    var user_photo:String?
    var coach_yn:String?
    var friend_status:String?
    var profile_comment:String?
    var chat_address:String?
    var profile_url:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        coach_yn = DictionaryToString(dic: dic, strName: "coach_yn")
        friend_status = DictionaryToString(dic: dic, strName: "friend_status")
        profile_comment = DictionaryToString(dic: dic, strName: "profile_comment")
        chat_address = DictionaryToString(dic: dic, strName: "chat_address")
        profile_url = DictionaryToString(dic: dic, strName: "profile_url")
    }
}
