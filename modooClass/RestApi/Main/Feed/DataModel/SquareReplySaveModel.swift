//
//  SquareReplySaveModel.swift
//  modooClass
//
//  Created by 조현민 on 2020/02/20.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit

class SquareReplySaveModel: NSObject {
    var code:String?
    var message:String?
    var results:SquareSaveResult?

    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = SquareSaveResult.init(dic: results)
        }
    }
}

class SquareSaveResult:NSObject{
    var id:Int?
    var user_id:Int?
    var user_name:String?
    var user_photo:String?
    var content:String?
    var emoticon:Int?
    var job_name:String?
    var like_cnt:Int?
    var like_me:String?
    var photo_url:String?
    var created_at:String?
    var comment_id:String?
    var coach_yn:String?
    var friend_yn:String?
    var time_spilled:String?
    
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
        emoticon = DictionaryToInt(dic: dic, intName: "emoticon")
        job_name = DictionaryToString(dic: dic, strName: "job_name")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        like_me = DictionaryToString(dic: dic, strName: "like_me")
        photo_url = DictionaryToString(dic: dic, strName: "photo_url")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        comment_id = DictionaryToString(dic: dic, strName: "comment_id")
        coach_yn = DictionaryToString(dic: dic, strName: "coach_yn")
        friend_yn = DictionaryToString(dic: dic, strName: "friend_yn")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
    }
}
