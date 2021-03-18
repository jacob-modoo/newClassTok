//
//  ProfileModel.swift
//  modooClass
//
//  Created by 조현민 on 19/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class ProfileModel: NSObject {
    var code:String?
    var message:String?
    var results:ProfileResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ProfileResults.init(dic: results)
        }
    }
}

class ProfileResults:NSObject{
    
    var user_id:Int?
    var social:String?
    var point:String?
    var user_name:String?
    var user_photo:String?
    var grade_name:String?
    var coachInfo:String?
    var scrap_count:Int?
    var total_active_point:Int?
    var payment_count:Int?
    var review_count:Int?
    var follower_address:String?
    var follower_count:Int?
    var following_address:String?
    var following_count:Int?
    var profile_edit_link:String?
    var point_link:String?
    var payment_link:String?
    var review_link:String?
    var class_open_link:String?
    var chat_link:String?
    var friend_state:String?
    var service_address:String?
    var policy_address:String?
    var support_address:String?
    var app_notify:String?
    var message_notify:String?
    var chat_notify:String?
    var class_count:Int?
    var scrap_link:String?
    var friend_link:String?
    var notice_address:String?
    
    var profileManageClass:ProfileManageClass?
    var profileManageClass_arr:Array = Array<ProfileManageClass>()
    var attendClassList:AttendClassList?
    var attendClassList_arr:Array = Array<AttendClassList>()
    var class_member_list:Profile_class_member_list?
    var class_member_list_arr:Array = Array<Profile_class_member_list>()
    
    var level_info:Profile_level_info_list?
    var level_history_address:String?
    var runTime:Float?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        point = DictionaryToString(dic: dic, strName: "point")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        grade_name = DictionaryToString(dic: dic, strName: "grade_name")
        profile_edit_link = DictionaryToString(dic: dic, strName: "profile_edit_link")
        point_link = DictionaryToString(dic: dic, strName: "point_link")
        payment_link = DictionaryToString(dic: dic, strName: "payment_link")
        friend_state = DictionaryToString(dic: dic, strName: "friend_state")
        follower_count = DictionaryToInt(dic: dic, intName: "follower_count")
        follower_address = DictionaryToString(dic: dic, strName: "follower_address")
        following_count = DictionaryToInt(dic: dic, intName: "following_count")
        following_address = DictionaryToString(dic: dic, strName: "following_address")
        coachInfo = DictionaryToString(dic: dic, strName: "coachInfo")
        social = DictionaryToString(dic: dic, strName: "social")
        scrap_count = DictionaryToInt(dic: dic, intName: "scrap_count")
        total_active_point = DictionaryToInt(dic: dic, intName: "total_active_point")
        payment_count = DictionaryToInt(dic: dic, intName: "payment_count")
        review_count = DictionaryToInt(dic: dic, intName: "review_count")
        review_link = DictionaryToString(dic: dic, strName: "review_link")
        class_open_link = DictionaryToString(dic: dic, strName: "class_open_link")
        chat_link = DictionaryToString(dic: dic, strName: "chat_link")
        friend_link = DictionaryToString(dic: dic, strName: "friend_link")
        notice_address = DictionaryToString(dic: dic, strName: "notice_address")
        service_address = DictionaryToString(dic: dic, strName: "service_address")
        policy_address = DictionaryToString(dic: dic, strName: "policy_address")
        support_address = DictionaryToString(dic: dic, strName: "support_address")
        app_notify = DictionaryToString(dic: dic, strName: "app_notify")
        message_notify = DictionaryToString(dic: dic, strName: "message_notify")
        chat_notify = DictionaryToString(dic: dic, strName: "chat_notify")
        class_count = DictionaryToInt(dic: dic, intName: "class_count")
        scrap_link = DictionaryToString(dic: dic, strName: "scrap_link")
        level_history_address = DictionaryToString(dic: dic, strName: "level_history_address")
        runTime = DictionaryToFloat(dic: dic, floatName: "runTime")
        
        if let list = dic["manage_class"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = ProfileManageClass.init(dic: listTemp as! Dictionary<String, Any>)
                profileManageClass_arr.append(temp)
            }
        }
        if let list = dic["class_list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = AttendClassList.init(dic: listTemp as! Dictionary<String, Any>)
                attendClassList_arr.append(temp)
            }
        }
        if let list = dic["class_member_list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = Profile_class_member_list.init(dic: listTemp as! Dictionary<String, Any>)
                class_member_list_arr.append(temp)
            }
        }
        if let level_info = dic["level_info"] as? Dictionary<String, Any> {
            self.level_info = Profile_level_info_list.init(dic: level_info)
        }
    }
}

class Profile_level_info_list: NSObject{
    var level_name:String?
    var level_code:String?
    var level_score:Int?
    var level_benefits:String?
    var next_level_name:String?
    var next_level_score:Int?
    var level_per:Int?
    var level_icon:String?
    var level_information_page:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        level_name = DictionaryToString(dic: dic, strName: "level_name")
        level_code = DictionaryToString(dic: dic, strName: "")
        level_score = DictionaryToInt(dic: dic, intName: "level_score")
        level_benefits = DictionaryToString(dic: dic, strName: "level_benefits")
        next_level_name = DictionaryToString(dic: dic, strName: "next_level_name")
        next_level_score = DictionaryToInt(dic: dic, intName: "next_level_score")
        level_per = DictionaryToInt(dic: dic, intName: "level_per")
        level_icon = DictionaryToString(dic: dic, strName: "level_icon")
        level_information_page = DictionaryToString(dic: dic, strName: "level_information_page")
    }
}

class Profile_class_member_list:NSObject{
    var class_id:Int?
    var class_short_name:String?
    var group_id:Int?
    var class_group_no:Int?
    var memberList:ProfileMemberList?
    var memberList_arr:Array = Array<ProfileMemberList>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        class_short_name = DictionaryToString(dic: dic, strName: "class_short_name")
        group_id = DictionaryToInt(dic: dic, intName: "group_id")
        class_group_no = DictionaryToInt(dic: dic, intName: "class_group_no")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = ProfileMemberList.init(dic: listTemp as! Dictionary<String, Any>)
                memberList_arr.append(temp)
            }
        }
    }
}

class ProfileMemberList:NSObject{
    var mcClass_id:Int?
    var user_id:Int?
    var user_name:String?
    var user_photo:String?
    var job_name:String?
    var gender:String?
    var link:String?
    var friend_status:String?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        mcClass_id = DictionaryToInt(dic: dic, intName: "mcClass_id")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        job_name = DictionaryToString(dic: dic, strName: "job_name")
        gender = DictionaryToString(dic: dic, strName: "gender")
        link = DictionaryToString(dic: dic, strName: "link")
        friend_status = DictionaryToString(dic: dic, strName: "friend_status")
    }
}

class ProfileManageClass:NSObject{
    var id:Int?
    var class_name:String?
    var link:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        link = DictionaryToString(dic: dic, strName: "link")
    }
}

class AttendClassList:NSObject{
    var id:Int?
    var class_name:String?
    var flag:String?
    var mcClassPayUser_id:Int?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        mcClassPayUser_id = DictionaryToInt(dic: dic, intName: "mcClassPayUser_id")
        flag = DictionaryToString(dic: dic, strName: "flag")
    }
}


class Manager_Class:NSObject{
    
    var title:String?
    var manage_link:String?
    var create_link:String?
    var create_comment:String?
    var list:Manager_Class_List?
    var manager_class_list:Array = Array<Manager_Class_List>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        title = DictionaryToString(dic: dic, strName: "title")
        manage_link = DictionaryToString(dic: dic, strName: "manage_link")
        create_link = DictionaryToString(dic: dic, strName: "create_link")
        create_comment = DictionaryToString(dic: dic, strName: "create_comment")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = Manager_Class_List.init(dic: listTemp as! Dictionary<String, Any>)
                manager_class_list.append(temp)
            }
        }
    }
}

class Manager_Class_List:NSObject{
    
    var id:Int?
    var class_name:String?
    var state_txt:String?
    var photo:String?
    var open_link:String?
    var share_link:String?
    var edit_link:String?
    var delete_possible:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        state_txt = DictionaryToString(dic: dic, strName: "state_txt")
        photo = DictionaryToString(dic: dic, strName: "photo")
        open_link = DictionaryToString(dic: dic, strName: "open_link")
        share_link = DictionaryToString(dic: dic, strName: "share_link")
        edit_link = DictionaryToString(dic: dic, strName: "edit_link")
        delete_possible = DictionaryToString(dic: dic, strName: "delete_possible")
    }
}

class Attend_class:NSObject{
    var title:String?
    var list:Attend_Class_List?
    var attend_class_List:Array = Array<Attend_Class_List>()
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        title = DictionaryToString(dic: dic, strName: "title")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = Attend_Class_List.init(dic: listTemp as! Dictionary<String, Any>)
                attend_class_List.append(temp)
            }
        }else{
            
        }
    }
}

class Attend_Class_List:NSObject{
    
    var id:Int?
    var class_name:String?
    var state_txt:String?
    var review_mode:String?
    var photo:String?
    var review_link:String?
    var share_link:String?
    var delete_possible:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        state_txt = DictionaryToString(dic: dic, strName: "state_txt")
        review_mode = DictionaryToString(dic: dic, strName: "review_mode")
        photo = DictionaryToString(dic: dic, strName: "photo")
        review_link = DictionaryToString(dic: dic, strName: "review_link")
        share_link = DictionaryToString(dic: dic, strName: "share_link")
        delete_possible = DictionaryToString(dic: dic, strName: "delete_possible")
    }
}

class Notify_class:NSObject{
    var title:String?
    var list:Notify_Class_List?
    var notify_class_list:Array = Array<Notify_Class_List>()
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        title = DictionaryToString(dic: dic, strName: "title")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = Notify_Class_List.init(dic: listTemp as! Dictionary<String, Any>)
                notify_class_list.append(temp)
            }
        }
        
    }
}

class Notify_Class_List:NSObject{
    var id:Int?
    var type:String?
    var video:String?
    var photo:String?
    var class_name:String?
    var category1:String?
    var category2:String?
    var point_text:String?
    var refund_text:String?
    var stamp_text:String?
    var start_day:String?
    var review_count:Int?
    var review_avg:String?
    var prehave:String?
    var list_type:Int?
    var review:String?
    var user_photo:String?
    var user_comment:String?
    var coach_photo:String?
    var coach_name:String?
    var class_open_state:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        type = DictionaryToString(dic: dic, strName: "type")
        video = DictionaryToString(dic: dic, strName: "video")
        photo = DictionaryToString(dic: dic, strName: "photo")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        category1 = DictionaryToString(dic: dic, strName: "category1")
        category2 = DictionaryToString(dic: dic, strName: "category2")
        point_text = DictionaryToString(dic: dic, strName: "point_text")
        refund_text = DictionaryToString(dic: dic, strName: "refund_text")
        stamp_text = DictionaryToString(dic: dic, strName: "stamp_text")
        start_day = DictionaryToString(dic: dic, strName: "start_day")
        review_count = DictionaryToInt(dic: dic, intName: "review_count")
        review_avg = DictionaryToString(dic: dic, strName: "review_avg")
        if review_avg == ""{review_avg = "0.0"}
        prehave = DictionaryToString(dic: dic, strName: "prehave")
        list_type = DictionaryToInt(dic: dic, intName: "list_type")
        review = DictionaryToString(dic: dic, strName: "review")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        user_comment = DictionaryToString(dic: dic, strName: "user_comment")
        coach_name = DictionaryToString(dic: dic, strName: "coach_name")
        coach_photo = DictionaryToString(dic: dic, strName: "coach_photo")
        class_open_state = DictionaryToString(dic: dic, strName: "class_open_state")
    }
}

class Prehave_class:NSObject{
    var title:String?
    var list:Prehave_Class_List?
    var prehave_class_list:Array = Array<Prehave_Class_List>()
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        title = DictionaryToString(dic: dic, strName: "title")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = Prehave_Class_List.init(dic: listTemp as! Dictionary<String, Any>)
                prehave_class_list.append(temp)
            }
        }
    }
}

class Prehave_Class_List:NSObject{
    
    var id:Int?
    var type:String?
    var video:String?
    var photo:String?
    var class_name:String?
    var category1:String?
    var category2:String?
    var point_text:String?
    var refund_text:String?
    var stamp_text:String?
    var start_day:String?
    var review_count:Int?
    var review_avg:String?
    var prehave:String?
    var list_type:Int?
    var user_photo:String?
    var user_comment:String?
    var coach_photo:String?
    var coach_name:String?
    var total_count:Int?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        type = DictionaryToString(dic: dic, strName: "type")
        video = DictionaryToString(dic: dic, strName: "video")
        photo = DictionaryToString(dic: dic, strName: "photo")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        category1 = DictionaryToString(dic: dic, strName: "category1")
        category2 = DictionaryToString(dic: dic, strName: "category2")
        point_text = DictionaryToString(dic: dic, strName: "point_text")
        refund_text = DictionaryToString(dic: dic, strName: "refund_text")
        stamp_text = DictionaryToString(dic: dic, strName: "stamp_text")
        start_day = DictionaryToString(dic: dic, strName: "start_day")
        review_count = DictionaryToInt(dic: dic, intName: "review_count")
        review_avg = DictionaryToString(dic: dic, strName: "review_avg")
        if review_avg == ""{review_avg = "0.0"}
        prehave = DictionaryToString(dic: dic, strName: "prehave")
        list_type = DictionaryToInt(dic: dic, intName: "list_type")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        user_comment = DictionaryToString(dic: dic, strName: "user_comment")
        coach_name = DictionaryToString(dic: dic, strName: "coach_name")
        coach_photo = DictionaryToString(dic: dic, strName: "coach_photo")
        total_count = DictionaryToInt(dic: dic, intName: "total_count")
    }
}

class ProfileV2Model: NSObject {
    var code:String?
    var message:String?
    var results:ProfileV2Results?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ProfileV2Results.init(dic: results)
        }
    }
}

class ProfileV2Results:NSObject{
    
    var page:Int?
    
    var manage_class_total_page:Int?
    var manage_class_total:Int?
    var manage_class_curr_count:Int?
    
    var active_comment_total_page:Int?
    var active_comment_total:Int?
    var active_comment_curr_count:Int?
    
    var class_review_total_page:Int?
    var class_review_total:Int?
    var class_review_curr_count:Int?
    
    var scrap_list_total_page:Int?
    var scrap_list_total:Int?
    var scrap_list_curr_count:Int?
    var chat_address:String?
    var profile_edit_address:String?
    var point_address:String?
    var friend_address:String?
    var review_address:String?
    var scrap_address:String?
    
    var user_info:User_info?
    var manage_class:Manage_class?
    var manage_class_list:Array = Array<Manage_class>()
    var active_comment:Active_comment?
    var active_comment_list:Array = Array<Active_comment>()
    var class_review:Class_review?
    var class_review_list:Array = Array<Class_review>()
    var scrap_list:Scrap_list?
    var scrap_list_list:Array = Array<Scrap_list>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        page = DictionaryToInt(dic: dic, intName: "page")
        
        manage_class_total_page = DictionaryToInt(dic: dic, intName: "manage_class_total_page")
        manage_class_total = DictionaryToInt(dic: dic, intName: "manage_class_total")
        manage_class_curr_count = DictionaryToInt(dic: dic, intName: "manage_class_curr_count")
        active_comment_total_page = DictionaryToInt(dic: dic, intName: "active_comment_total_page")
        active_comment_total = DictionaryToInt(dic: dic, intName: "active_comment_total")
        active_comment_curr_count = DictionaryToInt(dic: dic, intName: "active_comment_curr_count")
        class_review_total_page = DictionaryToInt(dic: dic, intName: "class_review_total_page")
        class_review_total = DictionaryToInt(dic: dic, intName: "class_review_total")
        class_review_curr_count = DictionaryToInt(dic: dic, intName: "class_review_curr_count")
        scrap_list_total_page = DictionaryToInt(dic: dic, intName: "scrap_list_total_page")
        scrap_list_total = DictionaryToInt(dic: dic, intName: "scrap_list_total")
        scrap_list_curr_count = DictionaryToInt(dic: dic, intName: "scrap_list_curr_count")
        chat_address = DictionaryToString(dic: dic, strName: "chat_address")
        profile_edit_address = DictionaryToString(dic: dic, strName: "profile_edit_address")
        point_address = DictionaryToString(dic: dic, strName: "point_address")
        friend_address = DictionaryToString(dic: dic, strName: "friend_address")
        review_address = DictionaryToString(dic: dic, strName: "review_address")
        scrap_address = DictionaryToString(dic: dic, strName: "scrap_address")
        
        if let user_info = dic["user_info"] as? Dictionary<String, Any> {
            self.user_info = User_info.init(dic: user_info)
        }
        if let list = dic["manage_class"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = Manage_class.init(dic: listTemp as! Dictionary<String, Any>)
                manage_class_list.append(temp)
            }
        }
        if let list = dic["active_comment"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = Active_comment.init(dic: listTemp as! Dictionary<String, Any>)
                active_comment_list.append(temp)
            }
        }
        if let list = dic["class_review"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = Class_review.init(dic: listTemp as! Dictionary<String, Any>)
                class_review_list.append(temp)
            }
        }
        if let list = dic["scrap_list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = Scrap_list.init(dic: listTemp as! Dictionary<String, Any>)
                scrap_list_list.append(temp)
            }
        }
        
    }
}

class User_info:NSObject{
    
    var user_id:Int?
    var gender:String?
    var coach_grade:Int?
    var user_photo:String?
    var user_name:String?
    var together_cnt:Int?
    var birthday_year:Int?
    var job_name:String?
    var profile_comment:String?
    var total_point:Int?
    var like_cnt:Int?
    var friend_status:String?
    var interest_list:Interest_list?
    var interest_list_list:Array = Array<Interest_list>()
    var photo:ProfilePhoto?
    var photo_list:Array = Array<ProfilePhoto>()
    var level_info:Profile_level_info_list?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        gender = DictionaryToString(dic: dic, strName: "gender")
        coach_grade = DictionaryToInt(dic: dic, intName: "coach_grade")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        together_cnt = DictionaryToInt(dic: dic, intName: "together_cnt")
        birthday_year = DictionaryToInt(dic: dic, intName: "birthday_year")
        job_name = DictionaryToString(dic: dic, strName: "job_name")
        profile_comment = DictionaryToString(dic: dic, strName: "profile_comment")
        total_point = DictionaryToInt(dic: dic, intName: "total_point")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        friend_status = DictionaryToString(dic: dic, strName: "friend_status")
        if let list = dic["interest_list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = Interest_list.init(dic: listTemp as! Dictionary<String, Any>)
                interest_list_list.append(temp)
            }
        }
        if let list = dic["photo"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = ProfilePhoto.init(dic: listTemp as! Dictionary<String, Any>)
                photo_list.append(temp)
            }
        }
        if let level_info = dic["level_info"] as? Dictionary<String, Any> {
            self.level_info = Profile_level_info_list.init(dic: level_info)
        }
    }
}

class ProfilePhoto:NSObject{
    var photo_url:String?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        
        photo_url = DictionaryToString(dic: dic, strName: "photo_url")
        
    }
}

class Manage_class:NSObject{
    var class_id:Int?
    var class_name:String?
    var photo_url:String?
    var click_event:String?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        photo_url = DictionaryToString(dic: dic, strName: "photo_url")
        click_event = DictionaryToString(dic: dic, strName: "click_event")
    }
}

class Active_comment:NSObject{
    var id:Int?
    var type:String?
    var class_id:Int?
    var class_name:String?
    var user_photo:String?
    var photo_url:String?
    var content:String?
    var reply_cnt:Int?
    var like_cnt:Int?
    var click_event:String?
    var like_status:String?
    var link:String?
    var comment_id:String?
    var youtu_address:String?
    var youtu_image_address:String?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        type = DictionaryToString(dic: dic, strName: "type")
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        photo_url = DictionaryToString(dic: dic, strName: "photo_url")
        content = DictionaryToString(dic: dic, strName: "content")
        reply_cnt = DictionaryToInt(dic: dic, intName: "reply_cnt")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        click_event = DictionaryToString(dic: dic, strName: "click_event")
        like_status = DictionaryToString(dic: dic, strName: "like_status")
        link = DictionaryToString(dic: dic, strName: "link")
        comment_id = DictionaryToString(dic: dic, strName: "comment_id")
        youtu_address = DictionaryToString(dic: dic, strName: "youtu_address")
        youtu_image_address = DictionaryToString(dic: dic, strName: "youtu_image_address")
    }
}

class Class_review:NSObject{
    var mcClassPayUser_id:Int?
    var review_star:Int?
    var content:String?
    var class_id:Int?
    var class_name:String?
    var photo_url:String?
    var review_photo:String?
    var click_event:String?
    var created_at:String?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        mcClassPayUser_id = DictionaryToInt(dic: dic, intName: "mcClassPayUser_id")
        review_star = DictionaryToInt(dic: dic, intName: "review_star")
        content = DictionaryToString(dic: dic, strName: "content")
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        photo_url = DictionaryToString(dic: dic, strName: "photo_url")
        review_photo = DictionaryToString(dic: dic, strName: "review_photo")
        click_event = DictionaryToString(dic: dic, strName: "click_event")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
    }
}

class Scrap_list:NSObject{
    var type:String?
    var created_at:String?
    var class_id:Int?
    var class_photo:String?
    var class_name:String?
    var content:String?
    var user_photo:String?
    var mission_photo:String?
    var click_event:String?
    var reply_cnt:Int?
    var like_cnt:Int?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        type = DictionaryToString(dic: dic, strName: "type")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        class_photo = DictionaryToString(dic: dic, strName: "class_photo")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        content = DictionaryToString(dic: dic, strName: "content")
        mission_photo = DictionaryToString(dic: dic, strName: "mission_photo")
        click_event = DictionaryToString(dic: dic, strName: "click_event")
        reply_cnt = DictionaryToInt(dic: dic, intName: "reply_cnt")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
    }
}
