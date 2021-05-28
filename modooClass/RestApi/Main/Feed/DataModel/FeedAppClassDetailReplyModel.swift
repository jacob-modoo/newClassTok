//
//  FeedAppClassDetailReplyModel.swift
//  modooClass
//
//  Created by 조현민 on 07/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedAppClassDetailReplyModel: NSObject {
    var code:String?
    var message:String?
    var results:AppClassComment?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = AppClassComment.init(dic: results)
        }
    }
}


class FeedAppClassDetailReplySendModel: NSObject {
    var code:String?
    var message:String?
    var results:AppClassReply?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = AppClassReply.init(dic: results)
        }
    }
}

class AppClassReply: NSObject {
    var id:Int?
    var user_id:Int?
    var user_name:String?
    var user_photo:String?
    var content:String?
    var original_content:String?
    var emoticon:Int?
    var photo_url:String?
    var photo:String?
    var time_spilled:String?
    var like:Int?
    var reply_count:Int?
    var friend_status:String?
    var profile_url:String?
    var feed_id:String?
    var mention_id:String?
    var mention_name:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        content = DictionaryToString(dic: dic, strName: "content")
        original_content = DictionaryToString(dic: dic, strName: "original_content")
        emoticon = DictionaryToInt(dic: dic, intName: "emoticon")
        photo_url = DictionaryToString(dic: dic, strName: "photo_url")
        photo = DictionaryToString(dic: dic, strName: "photo")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
        like = DictionaryToInt(dic: dic, intName: "like")
        reply_count = DictionaryToInt(dic: dic, intName: "reply_count")
        friend_status = DictionaryToString(dic: dic, strName: "friend_status")
        profile_url = DictionaryToString(dic: dic, strName: "profile_url")
        feed_id = DictionaryToString(dic: dic, strName: "feed_id")
        mention_id = DictionaryToString(dic: dic, strName: "mention_id")
        mention_name = DictionaryToString(dic: dic, strName: "mention_name")
    }
}
