//
//  FeedModel.swift
//  modooClass
//
//  Created by 조현민 on 23/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedModel: NSObject {
    var code:String?
    var message:String?
    var results:FeedResultsV2?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = FeedResultsV2.init(dic: results)
        }
    }
}

class FeedResultsV2: NSObject{
    var user_id:Int?
    var head_title:String?
    var user_type:String?
    var class_list:Main_class_list?
    var class_list_arr:Array = Array<Main_class_list>()
    var banner1:Banner1?
    var condition_status:String?
    var friend_cnt:Int?
    var friend_address:String?
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        if let class_list = dic["class_list"] as? Array<Any>{
            let array:Array = class_list
            for list in array {
                let temp = Main_class_list.init(dic: list as! Dictionary<String, Any>)
                class_list_arr.append(temp)
            }
        }
        if let banner1 = dic["banner1"] as? Dictionary<String, Any> {
            self.banner1 = Banner1.init(dic: banner1)
        }
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        head_title = DictionaryToString(dic: dic, strName: "head_title")
        user_type = DictionaryToString(dic: dic, strName: "user_type")
        condition_status = DictionaryToString(dic: dic, strName: "condition_status")
        friend_cnt = DictionaryToInt(dic: dic, intName: "friend_cnt")
        friend_address = DictionaryToString(dic: dic, strName: "friend_address")
    }
}

class Main_class_list:NSObject{
    var class_id:Int?
    var photo:String?
    var class_coach:Int?
    var class_name:String?
    var mcClass_status:Int?
    var firstCateEtc:String?
    var firstCate:String?
    var secondCate:String?
    var wait_movie:String?
    var coach_photo:String?
    var activeWeek:Int?
    var openDday:Int?
    var mcCurriculum_cnt:Int?
    var week_curriculum_cnt:Int?
    var end_date:Int?
    var end_date_info:String?
    var class_open_date:String?
    var start_date:String?
    var mission_per:Int?
    var week_mission_per:Int?
    var class_active_updated_at:String?
    var mcClassGroup_id:Int?
    var mcClassPayUser_id:Int?
    var mcCurriculumUser_cnt:Int?
    var member:Int?
    var mcActivePoint_updated_at:String?
    var unread_count:Int?
    var last_message:String?
    var last_time:String?
    var duration:String?
    var cover_file:String?
    var group_member_count:Int?
    var mission_group_status:Int?
    var total_mission_use:Int?
    var mission_status:Int?
    var memberAddress:String?
    var button_type:Int?
    var button_point1:String?
    var button_point2:String?
    var button_link1:String?
    var button_link2:String?
    var button_type_comment:String?
    var wait_page:String?
    var category1:String?
    var category2:String?
    var cover_title:String?
    var chat_page:String?
    var total_curriculum_cnt:Int?
    var my_mission_per:Int?
    var class_group_no:Int?
    var progress_rate:Int?
    var week_best:Week_best?
    var week_best_list:Array = Array<Week_best>()
    var member_list:Member_list?
    var member_list_arr:Array = Array<Member_list>()
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        if let week_best = dic["week_best"] as? Array<Any>{
            let array:Array = week_best
            for list in array {
                let temp = Week_best.init(dic: list as! Dictionary<String, Any>)
                week_best_list.append(temp)
            }
        }
        if let member_list = dic["member_list"] as? Array<Any>{
            let array:Array = member_list
            for list in array {
                let temp = Member_list.init(dic: list as! Dictionary<String, Any>)
                member_list_arr.append(temp)
            }
        }
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        photo = DictionaryToString(dic: dic, strName: "photo")
        class_coach = DictionaryToInt(dic: dic, intName: "class_coach")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        mcClass_status = DictionaryToInt(dic: dic, intName: "mcClass_status")
        firstCateEtc = DictionaryToString(dic: dic, strName: "firstCateEtc")
        firstCate = DictionaryToString(dic: dic, strName: "firstCate")
        secondCate = DictionaryToString(dic: dic, strName: "secondCate")
        wait_movie = DictionaryToString(dic: dic, strName: "wait_movie")
        coach_photo = DictionaryToString(dic: dic, strName: "coach_photo")
        activeWeek = DictionaryToInt(dic: dic, intName: "activeWeek")
        openDday = DictionaryToInt(dic: dic, intName: "openDday")
        mcCurriculum_cnt = DictionaryToInt(dic: dic, intName: "mcCurriculum_cnt")
        week_curriculum_cnt = DictionaryToInt(dic: dic, intName: "week_curriculum_cnt")
        end_date = DictionaryToInt(dic: dic, intName: "end_date")
        end_date_info = DictionaryToString(dic: dic, strName: "end_date_info")
        class_open_date = DictionaryToString(dic: dic, strName: "class_open_date")
        start_date = DictionaryToString(dic: dic, strName: "start_date")
        mission_per = DictionaryToInt(dic: dic, intName: "mission_per")
        mission_status = DictionaryToInt(dic: dic, intName: "mission_status")
        class_active_updated_at = DictionaryToString(dic: dic, strName: "class_active_updated_at")
        mcClassGroup_id = DictionaryToInt(dic: dic, intName: "mcClassGroup_id")
        mcClassPayUser_id = DictionaryToInt(dic: dic, intName: "mcClassPayUser_id")
        mcCurriculumUser_cnt = DictionaryToInt(dic: dic, intName: "mcCurriculumUser_cnt")
        member = DictionaryToInt(dic: dic, intName: "member")
        mcActivePoint_updated_at = DictionaryToString(dic: dic, strName: "mcActivePoint_updated_at")
        unread_count = DictionaryToInt(dic: dic, intName: "unread_count")
        last_message = DictionaryToString(dic: dic, strName: "last_message")
        duration = DictionaryToString(dic: dic, strName: "duration")
        cover_file = DictionaryToString(dic: dic, strName: "cover_file")
        last_time = DictionaryToString(dic: dic, strName: "last_time")
        group_member_count = DictionaryToInt(dic: dic, intName: "group_member_count")
        mission_group_status = DictionaryToInt(dic: dic, intName: "mission_group_status")
        total_mission_use = DictionaryToInt(dic: dic, intName: "total_mission_use")
        week_mission_per = DictionaryToInt(dic: dic, intName: "week_mission_per")
        memberAddress = DictionaryToString(dic: dic, strName: "memberAddress")
        button_type = DictionaryToInt(dic: dic, intName: "button_type")
        button_point1 = DictionaryToString(dic: dic, strName: "button_point1")
        button_point2 = DictionaryToString(dic: dic, strName: "button_point2")
        button_link1 = DictionaryToString(dic: dic, strName: "button_link1")
        button_link2 = DictionaryToString(dic: dic, strName: "button_link2")
        button_type_comment = DictionaryToString(dic: dic, strName: "button_type_comment")
        category1 = DictionaryToString(dic: dic, strName: "category1")
        category2 = DictionaryToString(dic: dic, strName: "category2")
        cover_title = DictionaryToString(dic: dic, strName: "cover_title")
        chat_page = DictionaryToString(dic: dic, strName: "chat_page")
        wait_page = DictionaryToString(dic: dic, strName: "wait_page")
        total_curriculum_cnt = DictionaryToInt(dic: dic, intName: "total_curriculum_cnt")
        my_mission_per = DictionaryToInt(dic: dic, intName: "my_mission_per")
        class_group_no = DictionaryToInt(dic: dic, intName: "class_group_no")
        progress_rate = DictionaryToInt(dic: dic, intName: "progress_rate")
    }
}

class Member_list:NSObject{
    var user_id:Int?
    var mcFriend_id:Int?
    var mcClassPayUser_id:Int?
    var user_name:String?
    var photo:String?
    var cnt:Int?
    var per:Int?
    var status:String?
    var job_name:String?
    var birthday_year:Int?
    var gender:String?
    var interest:String?
    var care_history:Int?
    var profile_comment:String?
    
    override init() {
           super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        mcFriend_id = DictionaryToInt(dic: dic, intName: "mcFriend_id")
        mcClassPayUser_id = DictionaryToInt(dic: dic, intName: "mcClassPayUser_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        photo = DictionaryToString(dic: dic, strName: "photo")
        cnt = DictionaryToInt(dic: dic, intName: "cnt")
        per = DictionaryToInt(dic: dic, intName: "per")
        status = DictionaryToString(dic: dic, strName: "status")
        job_name = DictionaryToString(dic: dic, strName: "job_name")
        birthday_year = DictionaryToInt(dic: dic, intName: "birthday_year")
        gender = DictionaryToString(dic: dic, strName: "gender")
        interest = DictionaryToString(dic: dic, strName: "interest")
        care_history = DictionaryToInt(dic: dic, intName: "care_history")
        profile_comment = DictionaryToString(dic: dic, strName: "profile_comment")
    }
}

class Week_best:NSObject{
    var user_id:Int?
    var total_point:Int?
    var user_name:String?
    override init() {
           super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        total_point = DictionaryToInt(dic: dic, intName: "total_point")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
    }
}
    
class FeedResults: NSObject {

    var my_mission:My_mission?
    var search_comment:String?
    var mission_title:String?
    var mission_list:Class_list?
    var alarm_title:String?
    var alarm_list:Class_list?
    var review_title:String?
    var review_list:Class_list?
    var mission_button:String?
    var alarm_button:String?
    var review_button:String?
    var mission_api:String?
    var alarm_api:String?
    var review_api:String?
    var best_title:String?
    var best_list:Class_list?
    var best_api:String?
    var best_button:String?
    var class_open_link:String?
    
    var myMission:Array = Array<My_mission>()
    var missionList:Array = Array<Class_list>()
    var alarmList:Array = Array<Class_list>()
    var reviewList:Array = Array<Class_list>()
    var bestList:Array = Array<Class_list>()
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        if let my_mission = dic["my_mission"] as? Array<Any>{
            let array:Array = my_mission
            for list in array {
                let temp = My_mission.init(dic: list as! Dictionary<String, Any>)
                myMission.append(temp)
            }
        }
        if let mission_list = dic["mission_list"] as? Array<Any>{
            let array:Array = mission_list
            for list in array {
                let temp = Class_list.init(dic: list as! Dictionary<String, Any>)
                missionList.append(temp)
            }
        }
        if let alarm_list = dic["alarm_list"] as? Array<Any>{
            let array:Array = alarm_list
            for list in array {
                let temp = Class_list.init(dic: list as! Dictionary<String, Any>)
                alarmList.append(temp)
            }
        }
        if let review_list = dic["review_list"] as? Array<Any>{
            let array:Array = review_list
            for list in array {
                let temp = Class_list.init(dic: list as! Dictionary<String, Any>)
                reviewList.append(temp)
            }
        }
        if let best_list = dic["best_list"] as? Array<Any>{
            let array:Array = best_list
            for list in array {
                let temp = Class_list.init(dic: list as! Dictionary<String, Any>)
                bestList.append(temp)
            }
        }
        search_comment = DictionaryToString(dic: dic, strName: "search_comment")
        mission_title = DictionaryToString(dic: dic, strName: "mission_title")
        alarm_title = DictionaryToString(dic: dic, strName: "alarm_title")
        review_title = DictionaryToString(dic: dic, strName: "review_title")
        mission_button = DictionaryToString(dic: dic, strName: "mission_button")
        alarm_button = DictionaryToString(dic: dic, strName: "alarm_button")
        review_button = DictionaryToString(dic: dic, strName: "review_button")
        mission_api = DictionaryToString(dic: dic, strName: "mission_api")
        alarm_api = DictionaryToString(dic: dic, strName: "alarm_api")
        review_api = DictionaryToString(dic: dic, strName: "review_api")
        best_title = DictionaryToString(dic: dic, strName: "best_title")
        best_api = DictionaryToString(dic: dic, strName: "best_api")
        best_button = DictionaryToString(dic: dic, strName: "best_button")
        class_open_link = DictionaryToString(dic: dic, strName: "class_open_link")
    }
}


class My_mission : NSObject{
    var id:Int?
    var photo:String?
    var class_name:String?
    var progress:String?
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        photo = DictionaryToString(dic: dic, strName: "photo")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        progress = DictionaryToString(dic: dic, strName: "progress")
    }
}

class Class_list:NSObject{
    var id:Int?
    var type:String?
    var video:String?
    var status:Int?
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
        status = DictionaryToInt(dic: dic, intName: "status")
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
        coach_photo = DictionaryToString(dic: dic, strName: "coach_photo")
        coach_name = DictionaryToString(dic: dic, strName: "coach_name")
        total_count = DictionaryToInt(dic: dic, intName: "total_count")
        
    }
}
