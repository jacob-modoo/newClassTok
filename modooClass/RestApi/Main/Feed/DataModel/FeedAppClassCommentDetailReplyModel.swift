//
//  AppClassCommentDetailReplyModel.swift
//  modooClass
//
//  Created by 조현민 on 10/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedAppClassCommentDetailReplyModel: NSObject {
    var code:String?
    var message:String?
    var results:AppClassCommentDetailReply?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = AppClassCommentDetailReply.init(dic: results)
        }
    }
}

class AppClassCommentDetailReply:NSObject{
    var id:Int?
    var type:String?
    var type_id:Int?
    var mcCurriculum_id:Int?
    var grade_code:String?
    var user_id:Int?
    var user_name:String?
    var phone:Int?
    var character_priority:String?
    var review_star:Int?
    var content:String?
    var coach_content:String?
    var mcComment_id:Int?
    var step:String?
    var delete_yn:String?
    var created_at:String?
    var updated_at:String?
    var user_photo:String?
    var time_spilled:String?
    var comment_type:String?
    var reply_count:Int?
    var like:Int?
    var like_me:String?
    var photo:String?
    var roll:String?
    var emoticon:Int?
    var coach_yn:String?
    var friend_status:String?
    var reply:AppClassComment?
    var play_file:String?
    var youtu_address:String?
    var profile_url:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        type = DictionaryToString(dic: dic, strName: "type")
        type_id = DictionaryToInt(dic: dic, intName: "type_id")
        mcCurriculum_id = DictionaryToInt(dic: dic, intName: "mcCurriculum_id")
        grade_code = DictionaryToString(dic: dic, strName: "grade_code")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        phone = DictionaryToInt(dic: dic, intName: "phone")
        character_priority = DictionaryToString(dic: dic, strName: "character_priority")
        review_star = DictionaryToInt(dic: dic, intName: "review_star")
        content = DictionaryToString(dic: dic, strName: "content")
        coach_content = DictionaryToString(dic: dic, strName: "coach_content")
        mcComment_id = DictionaryToInt(dic: dic, intName: "mcComment_id")
        step = DictionaryToString(dic: dic, strName: "step")
        delete_yn = DictionaryToString(dic: dic, strName: "delete_yn")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        updated_at = DictionaryToString(dic: dic, strName: "updated_at")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
        comment_type = DictionaryToString(dic: dic, strName: "comment_type")
        reply_count = DictionaryToInt(dic: dic, intName: "reply_count")
        like = DictionaryToInt(dic: dic, intName: "like")
        like_me = DictionaryToString(dic: dic, strName: "like_me")
        photo = DictionaryToString(dic: dic, strName: "photo")
        roll = DictionaryToString(dic: dic, strName: "roll")
        emoticon = DictionaryToInt(dic: dic, intName: "emoticon")
        coach_yn = DictionaryToString(dic: dic, strName: "coach_yn")
        play_file = DictionaryToString(dic: dic, strName: "play_file")
        youtu_address = DictionaryToString(dic: dic, strName: "youtu_address")
        profile_url = DictionaryToString(dic: dic, strName: "profile_url")
        if let reply = dic["reply"] as? Dictionary<String, Any> {
            self.reply = AppClassComment.init(dic: reply)
        }
    }
}

