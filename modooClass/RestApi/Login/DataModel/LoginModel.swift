//
//  NomalLogin.swift
//  modooClass
//
//  Created by 조현민 on 17/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class LoginModel: NSObject {
    
    var code:String?
    var message:String?
    var results:LoginResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = LoginResults.init(dic: results)
        }
    }
}

class LoginResults: NSObject {
    var token:String?
    var user:User?
    var user_info_yn:String?
    var class_yn:String?
    var coach_yn:String?
    var event_open_date:String?
    var event_close_date:String?
    var event_image:String?
    var event_link:String?
    var event_text:String?
    var event_yn:String?
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        token = DictionaryToString(dic: dic, strName: "token")
        if let user = dic["user"] as? Dictionary<String, Any> {
            self.user = User.init(dic: user)
        }
        user_info_yn = DictionaryToString(dic: dic, strName: "user_info_yn")
        class_yn = DictionaryToString(dic: dic, strName: "class_yn")
        coach_yn = DictionaryToString(dic: dic, strName: "coach_yn")
        event_open_date = DictionaryToString(dic: dic, strName: "event_open_date")
        event_close_date = DictionaryToString(dic: dic, strName: "event_close_date")
        event_image = DictionaryToString(dic: dic, strName: "event_image")
        event_link = DictionaryToString(dic: dic, strName: "event_link")
        event_text = DictionaryToString(dic: dic, strName: "event_text")
        event_yn = DictionaryToString(dic: dic, strName: "event_yn")
    }
}

class User:NSObject{
    var id:Int?
    var username:String?
    var nickname:String?
    var userLogin:Int?
    var email:String?
    var addr:String?
    var addr2:String?
    var zipcode:Int?
    var delivery_status:String?
    var delivery_date:String?
    var permissions:Permission?
    var activated:Int?
    var activation_code:String?
    var activated_at:String?
    var last_login:String?
    var persist_code:String?
    var reset_password_code:String?
    var push_token:String?
    var fcm_token:String?
    var device_type:String?
    var phone:Int?
    var photo:String?
    var photo2:String?
    var photo3:String?
    var birthday:String?
    var ageRange:Int?
    var gender:String?
    var formsite:Int?
    var cate:Int?
    var social:String?
    var recommeal_id:Int?
    var main_t_id:Int?
    var msg_alram:String?
    var mission_alram:String?
    var created_t_id:Int?
    var created_at:String?
    var updated_at:String?
    var created_ip:String?
    var last_ip:String?
    var youtube:String?
    var course_youtube:String?
    var profile_photo:String?
    var active_photo:String?
    var tag:String?
    var open_flag:String?
    var birthday_year:String?
    var profile_comment:String?
    var payple_id:String?
    var payple_no:Int?

    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        username = DictionaryToString(dic: dic, strName: "username")
        nickname = DictionaryToString(dic: dic, strName: "nickname")
        userLogin = DictionaryToInt(dic: dic, intName: "userLogin")
        email = DictionaryToString(dic: dic, strName: "email")
        addr = DictionaryToString(dic: dic, strName: "addr")
        addr2 = DictionaryToString(dic: dic, strName: "addr2")
        zipcode = DictionaryToInt(dic: dic, intName: "zipcode")
        delivery_status = DictionaryToString(dic: dic, strName: "delivery_status")
        delivery_date = DictionaryToString(dic: dic, strName: "delivery_date")
        if let permissions = dic["permissions"] as? Dictionary<String, Any> {
            self.permissions = Permission.init(dictionary: permissions)
        }
        activated = DictionaryToInt(dic: dic, intName: "activated")
        activation_code = DictionaryToString(dic: dic, strName: "activation_code")
        activated_at = DictionaryToString(dic: dic, strName: "activated_at")
        last_login = DictionaryToString(dic: dic, strName: "last_login")
        persist_code = DictionaryToString(dic: dic, strName: "persist_code")
        reset_password_code = DictionaryToString(dic: dic, strName: "reset_password_code")
        push_token = DictionaryToString(dic: dic, strName: "push_token")
        fcm_token = DictionaryToString(dic: dic, strName: "fcm_token")
        device_type = DictionaryToString(dic: dic, strName: "device_type")
        phone = DictionaryToInt(dic: dic, intName: "phone")
        photo = DictionaryToString(dic: dic, strName: "photo")
        photo2 = DictionaryToString(dic: dic, strName: "photo2")
        photo3 = DictionaryToString(dic: dic, strName: "photo3")
        birthday = DictionaryToString(dic: dic, strName: "birthday")
        ageRange = DictionaryToInt(dic: dic, intName: "ageRange")
        gender = DictionaryToString(dic: dic, strName: "gender")
        formsite = DictionaryToInt(dic: dic, intName: "formsite")
        cate = DictionaryToInt(dic: dic, intName: "cate")
        social = DictionaryToString(dic: dic, strName: "social")
        recommeal_id = DictionaryToInt(dic: dic, intName: "recommeal_id")
        main_t_id = DictionaryToInt(dic: dic, intName: "main_t_id")
        msg_alram = DictionaryToString(dic: dic, strName: "msg_alram")
        mission_alram = DictionaryToString(dic: dic, strName: "mission_alram")
        created_t_id = DictionaryToInt(dic: dic, intName: "created_t_id")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        updated_at = DictionaryToString(dic: dic, strName: "updated_at")
        created_ip = DictionaryToString(dic: dic, strName: "created_ip")
        last_ip = DictionaryToString(dic: dic, strName: "last_ip")
        youtube = DictionaryToString(dic: dic, strName: "youtube")
        course_youtube = DictionaryToString(dic: dic, strName: "course_youtube")
        profile_photo = DictionaryToString(dic: dic, strName: "profile_photo")
        active_photo = DictionaryToString(dic: dic, strName: "active_photo")
        tag = DictionaryToString(dic: dic, strName: "tag")
        open_flag = DictionaryToString(dic: dic, strName: "open_flag")
        birthday_year = DictionaryToString(dic: dic, strName: "birthday_year")
        profile_comment = DictionaryToString(dic: dic, strName: "profile_comment")
        payple_id = DictionaryToString(dic: dic, strName: "payple_id")
        payple_no = DictionaryToInt(dic: dic, intName: "payple_no")
    }
}

class Permission:NSObject{
    override init() {
        super.init()
    }
    
    convenience init(dictionary:Dictionary<String, Any>) {
        self.init()
        
    }
}
