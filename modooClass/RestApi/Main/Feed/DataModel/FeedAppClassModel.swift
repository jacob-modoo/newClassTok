//
//  FeedAppClassModel.swift
//  modooClass
//
//  Created by 조현민 on 03/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedAppClassModel: NSObject {
    var code:String?
    var message:String?
    var results:AppClassCurriculumResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = AppClassCurriculumResult.init(dic: results)
        }
    }
}

class AppClassCurriculumResult:NSObject{
    var mcClass_id:Int?
    var class_type:String?
    var curriculum:Curriculum?
    var chatState:String?
    var chatAddress:String?
    var managerAddress:String?
    var memberAddress:String?
    var reportAddress:String?
    var head_comment:String?
    var url:String?
    var class_photo:String?
    var list:CheerList?
    var cheerList:Array = Array<CheerList>()
    var condition_list:Condition_list?
    var conditionList:Array = Array<Condition_list>()
    var cheerAddress:String?
    var user_status:String?
    var coachMemberAddress:String?
    var coachCommunityAddress:String?
    var star_avg:Double?
    var star_cnt:Int?
    var class_info:String?
    var class_name:String?
    var sale_per:String?
    var price:String?
    var class_recommend:Class_recommend?
    var class_recommend_arr:Array = Array<Class_recommend>()
    var coach_chat_address:String?
    var coach_id:Int?
    var coach_name:String?
    var coach_photo:String?
    var friend_status:String?
    var package_address:String?
    var photo:String?
    var origin_price:String?
    var review_list:ClassDetailReview_list?
    var review_list_arr:Array = Array<ClassDetailReview_list>()
    var class_recom_list:Class_recom_list?
    var classScrap_status:String?
    var classScrap_cnt:Int?
    var mission_yn:String?
    var mission_count:Int?
    var curriculum_head:CurriculumHead?
    var curriculum_before_id:Int?
    var curriculum_after_id:Int?
    var curriculum_list:CurriculumDetail_list?
    var curriculum_list_array:Array = Array<CurriculumDetail_list>()
    var share_address:String?
    var share_content:String?
    var share_point:String?
    var share_image:String?
    
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        mcClass_id = DictionaryToInt(dic: dic, intName: "mcClass_id")
        class_type = DictionaryToString(dic: dic, strName: "class_type")
        chatState = DictionaryToString(dic: dic, strName: "chatState")
        chatAddress = DictionaryToString(dic: dic, strName: "chatAddress")
        managerAddress = DictionaryToString(dic: dic, strName: "managerAddress")
        url = DictionaryToString(dic: dic, strName: "url")
        class_photo = DictionaryToString(dic: dic, strName: "class_photo")
        memberAddress = DictionaryToString(dic: dic, strName: "memberAddress")
        reportAddress = DictionaryToString(dic: dic, strName: "reportAddress")
        head_comment = DictionaryToString(dic: dic, strName: "head_comment")
        cheerAddress = DictionaryToString(dic: dic, strName: "cheerAddress")
        user_status = DictionaryToString(dic: dic, strName: "user_status")
        coachMemberAddress = DictionaryToString(dic: dic, strName: "coachMemberAddress")
        coachCommunityAddress = DictionaryToString(dic: dic, strName: "coachCommunityAddress")
        star_avg = DictionaryToDouble(dic: dic, doubleName: "star_avg")
        star_cnt = DictionaryToInt(dic: dic, intName: "star_cnt")
        class_info = DictionaryToString(dic: dic, strName: "class_info")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        sale_per = DictionaryToString(dic: dic, strName: "sale_per")
        price = DictionaryToString(dic: dic, strName: "price")
        coach_chat_address = DictionaryToString(dic: dic, strName: "coach_chat_address")
        coach_id = DictionaryToInt(dic: dic, intName: "coach_id")
        coach_name = DictionaryToString(dic: dic, strName: "coach_name")
        coach_photo = DictionaryToString(dic: dic, strName: "coach_photo")
        friend_status = DictionaryToString(dic: dic, strName: "friend_status")
        package_address = DictionaryToString(dic: dic, strName: "package_address")
        photo = DictionaryToString(dic: dic, strName: "photo")
        origin_price = DictionaryToString(dic: dic, strName: "origin_price")
        classScrap_status = DictionaryToString(dic: dic, strName: "classScrap_status")
        classScrap_cnt = DictionaryToInt(dic: dic, intName: "classScrap_cnt")
        mission_yn = DictionaryToString(dic: dic, strName: "mission_yn")
        mission_count = DictionaryToInt(dic: dic, intName: "mission_count")
        curriculum_before_id = DictionaryToInt(dic: dic, intName: "curriculum_before_id")
        curriculum_after_id = DictionaryToInt(dic: dic, intName: "curriculum_after_id")
        share_address = DictionaryToString(dic: dic, strName: "share_address")
        share_content = DictionaryToString(dic: dic, strName: "share_content")
        share_point = DictionaryToString(dic: dic, strName: "share_point")
        share_image = DictionaryToString(dic: dic, strName: "share_image")
        
        if let curriculum = dic["curriculum"] as? Dictionary<String, Any> {
            self.curriculum = Curriculum.init(dic: curriculum)
        }
        if let curriculum_head = dic["curriculum_head"] as? Dictionary<String, Any> {
            self.curriculum_head = CurriculumHead.init(dic: curriculum_head)
        }
        if let class_recom_list = dic["class_recom_list"] as? Dictionary<String, Any> {
            self.class_recom_list = Class_recom_list.init(dic: class_recom_list)
        }
        if let list = dic["curriculum_list"] as? Array<Dictionary<String, Any>> {
            let array:Array = list
            for listTemp in array {
                let temp = CurriculumDetail_list.init(dic: listTemp)
                curriculum_list_array.append(temp)
            }
        }
        if let list = dic["member_list"] as? Array<Dictionary<String, Any>>{
            let array:Array = list
            for listTemp in array {
                let temp = CheerList.init(dic: listTemp)
                cheerList.append(temp)
            }
        }
        if let list = dic["condition_list"] as? Array<Dictionary<String, Any>>{
            let array:Array = list
            for listTemp in array {
                let temp = Condition_list.init(dic: listTemp)
                conditionList.append(temp)
            }
        }
        if let list = dic["class_recommend"] as? Array<Dictionary<String, Any>>{
            let array:Array = list
            for listTemp in array {
                let temp = Class_recommend.init(dic: listTemp)
                class_recommend_arr.append(temp)
            }
        }
        if let list = dic["review_list"] as? Array<Dictionary<String, Any>>{
            let array:Array = list
            for listTemp in array {
                let temp = ClassDetailReview_list.init(dic: listTemp)
                review_list_arr.append(temp)
            }
        }
    }
}

class Class_recom_list: NSObject {
    
    var user_id:Int?
    var user_name:String?
    var curr_count:Int?
    var list: RecommendationList?
    var list_arr:Array = Array<RecommendationList>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        curr_count = DictionaryToInt(dic: dic, intName: "curr_count")
        
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = RecommendationList.init(dic: list as! Dictionary<String, Any>)
                list_arr.append(temp)
            }
        }
    }
}

class RecommendationList: NSObject {
    var name:String?
    var package_payment:String?
    var package_sale_per:Int?
    var photo:String?
    var user_name:String?
    var helpful_cnt:Int?
    var class_id:Int?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        name = DictionaryToString(dic: dic, strName: "name")
        package_payment = DictionaryToString(dic: dic, strName: "package_payment")
        package_sale_per = DictionaryToInt(dic: dic, intName: "package_sale_per")
        photo = DictionaryToString(dic: dic, strName: "photo")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        helpful_cnt = DictionaryToInt(dic: dic, intName: "helpful_cnt")
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
    }
}

class CurriculumHead: NSObject {
    var title: String?
    var duration: String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String,Any>){
        self.init()
        title = DictionaryToString(dic: dic, strName: "title")
        duration = DictionaryToString(dic: dic, strName: "duration")
    }
}

class ClassDetailReview_list:NSObject{
    var id:Int?
    var best_flag:String?
    var created_at:String?
    var star:Int?
    var review_star_status:String?
    var content:String?
    var user_id:Int?
    var coach_content:String?
    var class_group_no:Int?
    var coach_name:String?
    var coach_photo:String?
    var review_photo:String?
    var photo:String?
    var user_name:String?
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        best_flag = DictionaryToString(dic: dic, strName: "best_flag")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        star = DictionaryToInt(dic: dic, intName: "star")
        review_star_status = DictionaryToString(dic: dic, strName: "review_star_status")
        content = DictionaryToString(dic: dic, strName: "content")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        coach_content = DictionaryToString(dic: dic, strName: "coach_content")
        class_group_no = DictionaryToInt(dic: dic, intName: "class_group_no")
        coach_photo = DictionaryToString(dic: dic, strName: "coach_photo")
        review_photo = DictionaryToString(dic: dic, strName: "review_photo")
        photo = DictionaryToString(dic: dic, strName: "photo")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
    }
}

class CurriculumDetail_list:NSObject{
    var id:Int?
    var head:String?
    var title:String?
    var freeview:String?
    var mission_yn:String?
    var cur_description:String?
    var video_url:String?
    var video_id:String?
    var video_object_id:String?
    var video_image:String?
    var video_duration:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>){
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        head = DictionaryToString(dic: dic, strName: "head")
        title = DictionaryToString(dic: dic, strName: "title")
        freeview = DictionaryToString(dic: dic, strName: "freeview")
        mission_yn = DictionaryToString(dic: dic, strName: "mission_yn")
        cur_description = DictionaryToString(dic: dic, strName: "description")
        video_url = DictionaryToString(dic: dic, strName: "video_url")
        video_id = DictionaryToString(dic: dic, strName: "video_id")
        video_object_id = DictionaryToString(dic: dic, strName: "video_object_id")
        video_image = DictionaryToString(dic: dic, strName: "video_image")
        video_duration = DictionaryToString(dic: dic, strName: "video_duration")
    }
}

class Class_recommend:NSObject{
    var photo:String?
    var recommend:String?
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        photo = DictionaryToString(dic: dic, strName: "photo")
        recommend = DictionaryToString(dic: dic, strName: "recommend")
    }
}

class Condition_list:NSObject{
    var user_id:Int?
    var mcClassPayUser_id:Int?
    var user_name:String?
    var photo:String?
    var cnt:Int?
    var per:Int?
    var status:String?
    
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        mcClassPayUser_id = DictionaryToInt(dic: dic, intName: "mcClassPayUser_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        photo = DictionaryToString(dic: dic, strName: "photo")
        cnt = DictionaryToInt(dic: dic, intName: "cnt")
        per = DictionaryToInt(dic: dic, intName: "per")
        status = DictionaryToString(dic: dic, strName: "status")
    }
}

class Curriculum:NSObject{
    var id:Int?
    var title:String?
    var mission:AppClassMission?
    var study:AppClassStudy?
    var comment:AppClassComment?
    var coach_class:AppClassCoach?
    var button_api:String?
    var button_api_format:String?
    var button_id:Int?
    var button_text:String?
    var button_text2:String?
    var materials_file:String?
    var materials_subject:String?
    var head:String?
    var button_before_id:Int?
    var button_next_curriculum_id:Int?
    var background_play_yn:String?
    var button_review:String?
    var like_count:Int?
    var like_me:String?
    var helpful_flag:String?
    var nohelpful_flag:String?
    var helpful_count:Int?
    var nohelpful_count:Int?

    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        title = DictionaryToString(dic: dic, strName: "title")
        button_api = DictionaryToString(dic: dic, strName: "button_api")
        button_api_format = DictionaryToString(dic: dic, strName: "button_api_format")
        button_id = DictionaryToInt(dic: dic, intName: "button_id")
        button_text = DictionaryToString(dic: dic, strName: "button_text")
        button_text2 = DictionaryToString(dic: dic, strName: "button_text2")
        materials_file = DictionaryToString(dic: dic, strName: "materials_file")
        materials_subject = DictionaryToString(dic: dic, strName: "materials_subject")
        head = DictionaryToString(dic: dic, strName: "head")
        button_before_id = DictionaryToInt(dic: dic, intName: "button_before_id")
        button_next_curriculum_id = DictionaryToInt(dic: dic, intName: "button_next_curriculum_id")
        background_play_yn = DictionaryToString(dic: dic, strName: "background_play_yn")
        button_review = DictionaryToString(dic: dic, strName: "button_review")
        like_count = DictionaryToInt(dic: dic, intName: "like_count")
        like_me = DictionaryToString(dic: dic, strName: "like_me")
        helpful_flag = DictionaryToString(dic: dic, strName: "helpful_flag")
        nohelpful_flag = DictionaryToString(dic: dic, strName: "nohelpful_flag")
        helpful_count = DictionaryToInt(dic: dic, intName: "heplful_count")
        nohelpful_count = DictionaryToInt(dic: dic, intName: "nohelpful_count")
        
        if let mission = dic["mission"] as? Dictionary<String, Any> {
            self.mission = AppClassMission.init(dic: mission)
        }
        if let study = dic["study"] as? Dictionary<String, Any> {
            self.study = AppClassStudy.init(dic: study)
        }
        if let comment = dic["comment"] as? Dictionary<String, Any> {
            self.comment = AppClassComment.init(dic: comment)
        }
        if let coach_class = dic["coach_class"] as? Dictionary<String, Any> {
            self.coach_class = AppClassCoach.init(dic: coach_class)
        }
    }
}

class AppClassMission:NSObject{
    var id:Int?
    var title:String?
    var stamp:Int?
    var missionDescription:String?
    var mission_end_text:String?
    var review_total:Int?
    var review_avg:String?
    var list:AppClassMissionList?
    var appClassMissionList:Array = Array<AppClassMissionList>()
    var page:Int?
    var total_page:Int?
    
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        title = DictionaryToString(dic: dic, strName: "title")
        stamp = DictionaryToInt(dic: dic, intName: "stamp")
        missionDescription = DictionaryToString(dic: dic, strName: "description")
        mission_end_text = DictionaryToString(dic: dic, strName: "mission_end_text")
        review_total = DictionaryToInt(dic: dic, intName: "review_total")
        review_avg = DictionaryToString(dic: dic, strName: "review_avg")
        if review_avg == ""{review_avg = "0.0"}
        page = DictionaryToInt(dic: dic, intName: "page")
        total_page = DictionaryToInt(dic: dic, intName: "total_page")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = AppClassMissionList.init(dic: listTemp as! Dictionary<String, Any>)
                appClassMissionList.append(temp)
            }
        }
    }
}

class AppClassMissionPageList:NSObject{
    var code:String?
    var message:String?
    var results:AppClassMissionPage?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = AppClassMissionPage.init(dic: results)
        }
    }
}

class AppClassMissionPage:NSObject{
    var total:Int?
    var total_page:Int?
    var curr:Int?
    var page:Int?
    var list:AppClassMissionList?
    var appClassMissionList:Array = Array<AppClassMissionList>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
    self.init()
        total = DictionaryToInt(dic: dic, intName: "total")
        total_page = DictionaryToInt(dic: dic, intName: "total_page")
        curr = DictionaryToInt(dic: dic, intName: "curr")
        page = DictionaryToInt(dic: dic, intName: "page")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = AppClassMissionList.init(dic: listTemp as! Dictionary<String, Any>)
                appClassMissionList.append(temp)
            }
        }
    }
}

class AppClassMissionList:NSObject{
    var user_id:Int?
    var user_photo:String?
    var user_name:String?
    var photo_url:String?
    var stamp:Int?
    var review_point:Int?
    var comment:String?
    var like_me:String?
    var like_cnt:Int?
    var mcComment_id:Int?
    
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        photo_url = DictionaryToString(dic: dic, strName: "photo_url")
        stamp = DictionaryToInt(dic: dic, intName: "stamp")
        review_point = DictionaryToInt(dic: dic, intName: "review_point")
        comment = DictionaryToString(dic: dic, strName: "comment")
        like_me = DictionaryToString(dic: dic, strName: "like_me")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        mcComment_id = DictionaryToInt(dic: dic, intName: "mcComment_id")
    }
}

class AppClassStudy:NSObject{
    var head:String?
    var title:String?
    var content:String?
    var id:Int?
    var video:String?
    var video_object_id:String?
    var data:Int?
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        head = DictionaryToString(dic: dic, strName: "head")
        title = DictionaryToString(dic: dic, strName: "title")
        content = DictionaryToString(dic: dic, strName: "content")
        video = DictionaryToString(dic: dic, strName: "video")
        id = DictionaryToInt(dic: dic, intName: "id")
        video_object_id = DictionaryToString(dic: dic, strName: "video_object_id")
        data = DictionaryToInt(dic: dic, intName: "data")
    }
}

class AppClassCoach:NSObject{
    var coach_name:String?
    var coach_id:Int?
    var coach_photo:String?
    var coach_friend:Int?
    var coach_friend_me:String?
    var _notin:Int?
    var profile_url:String?
    var list:AppClassCoachList?
    var appClassCoachList:Array = Array<AppClassCoachList>()
    var notice:AppClassCurriculumNotice?
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        coach_id = DictionaryToInt(dic: dic, intName: "coach_id")
        coach_name = DictionaryToString(dic: dic, strName: "coach_name")
        coach_photo = DictionaryToString(dic: dic, strName: "coach_photo")
        coach_friend = DictionaryToInt(dic: dic, intName: "coach_friend")
        coach_friend_me = DictionaryToString(dic: dic, strName: "coach_friend_me")
        profile_url = DictionaryToString(dic: dic, strName: "profile_url")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = AppClassCoachList.init(dic: listTemp as! Dictionary<String, Any>)
                appClassCoachList.append(temp)
            }
        }
        if let notice = dic["notice"] as? Dictionary<String, Any> {
            self.notice = AppClassCurriculumNotice.init(dic: notice)
        }
    }
}

class AppClassCurriculumNotice: NSObject{
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
    var security_content:String?
    var coach_content:String?
    var mcComment_id:Int?
    var step:String?
    var delete_yn:String?
    var coach_created_at:String?
    var created_at:String?
    var updated_at:String?
    var photo_url:String?
    var like_me:String?
    var like_cnt:Int?
    var reply_cnt:Int?
    var time_spilled:String?
    var play_file:String?
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
        security_content = DictionaryToString(dic: dic, strName: "security_content")
        coach_content = DictionaryToString(dic: dic, strName: "coach_content")
        mcComment_id = DictionaryToInt(dic: dic, intName: "mcComment_id")
        step = DictionaryToString(dic: dic, strName: "step")
        delete_yn = DictionaryToString(dic: dic, strName: "delete_yn")
        coach_created_at = DictionaryToString(dic: dic, strName: "coach_created_at")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        updated_at = DictionaryToString(dic: dic, strName: "updated_at")
        photo_url = DictionaryToString(dic: dic, strName: "photo_url")
        like_me = DictionaryToString(dic: dic, strName: "like_me")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        reply_cnt = DictionaryToInt(dic: dic, intName: "reply_cnt")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
        play_file = DictionaryToString(dic: dic, strName: "play_file")
    }
}

class AppClassCoachList:NSObject{
    var id:Int?
    var class_name:String?
    var photo:String?
    var star_avg:String?
    var star_count:Int?
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        photo = DictionaryToString(dic: dic, strName: "photo")
        star_avg = DictionaryToString(dic: dic, strName: "star_avg")
        star_count = DictionaryToInt(dic: dic, intName: "star_count")
    }
}

class AppClassComment:NSObject{
    var page:Int?
    var total:Int?
    var total_page:Int?
    var curr:Int?
    var list:AppClassCommentList?
    var appClassCommentList:Array = Array<AppClassCommentList>()
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        page = DictionaryToInt(dic: dic, intName: "page")
        total = DictionaryToInt(dic: dic, intName: "total")
        total_page = DictionaryToInt(dic: dic, intName: "total_page")
        curr = DictionaryToInt(dic: dic, intName: "curr")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = AppClassCommentList.init(dic: listTemp as! Dictionary<String, Any>)
                appClassCommentList.append(temp)
            }
        }
    }
}

class AppClassCommentList:NSObject{
    var id:Int?
    var type:String?
    var user_id:Int?
    var user_photo:String?
    var user_name:String?
    var time_spilled:String?
    var content:String?
    var like:Int?
    var reply_count:Int?
    var like_me:String?
    var photo:String?
    var roll:String?
    var like_user:String?
    var emoticon:Int?
    var job_name:String?
    var interest:String?
    var friend_yn:String?
    var coach_reply_status:String?
    var play_file:String?
    var youtu_address:String?
    var coach_yn:String?
    var profile_url:String?
    var mcCurriculum_id:Int?

    var replyInReply:ReplyInReply?

    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        type = DictionaryToString(dic: dic, strName: "type")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
        content = DictionaryToString(dic: dic, strName: "content")
        like = DictionaryToInt(dic: dic, intName: "like")
        reply_count = DictionaryToInt(dic: dic, intName: "reply_count")
        like_me = DictionaryToString(dic: dic, strName: "like_me")
        photo = DictionaryToString(dic: dic, strName: "photo")
        roll = DictionaryToString(dic: dic, strName: "roll")
        like_user = DictionaryToString(dic: dic, strName: "like_user")
        emoticon = DictionaryToInt(dic: dic, intName: "emoticon")
        job_name = DictionaryToString(dic: dic, strName: "job_name")
        interest = DictionaryToString(dic: dic, strName: "interest")
        friend_yn = DictionaryToString(dic: dic, strName: "friend_yn")
        coach_reply_status = DictionaryToString(dic: dic, strName: "coach_reply_status")
        play_file = DictionaryToString(dic: dic, strName: "play_file")
        youtu_address = DictionaryToString(dic: dic, strName: "youtu_address")
        coach_yn = DictionaryToString(dic: dic, strName: "coach_yn")
        profile_url = DictionaryToString(dic: dic, strName: "profile_url")
        mcCurriculum_id = DictionaryToInt(dic: dic, intName: "mcCurriculum_id")
        if let replyInReply = dic["reply"] as? Dictionary<String, Any> {
            self.replyInReply = ReplyInReply.init(dic: replyInReply)
        }
    }
}

class ReplyInReply:NSObject{
    var id:Int?
    var type:String?
    var user_id:Int?
    var user_photo:String?
    var user_name:String?
    var time_spilled:String?
    var content:String?
    var like:Int?
    var reply_count:Int?
    var like_me:String?
    var photo:String?
    var roll:String?
    var like_user:String?


    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        type = DictionaryToString(dic: dic, strName: "type")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
        content = DictionaryToString(dic: dic, strName: "content")
        like = DictionaryToInt(dic: dic, intName: "like")
        reply_count = DictionaryToInt(dic: dic, intName: "reply_count")
        like_me = DictionaryToString(dic: dic, strName: "like_me")
        photo = DictionaryToString(dic: dic, strName: "photo")
        roll = DictionaryToString(dic: dic, strName: "roll")
        like_user = DictionaryToString(dic: dic, strName: "like_user")
    }
}

class FeedAppClassConditionInfoModel: NSObject {
    var code:String?
    var message:String?
    var results:AppClassConditionInfoResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = AppClassConditionInfoResult.init(dic: results)
        }
    }
}

class AppClassConditionInfoResult:NSObject{
    var member_list:Member_list?
    var member_list_arr:Array = Array<Member_list>()
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        if let member_list = dic["all_list"] as? Array<Any>{
            let array:Array = member_list
            for list in array {
                let temp = Member_list.init(dic: list as! Dictionary<String, Any>)
                member_list_arr.append(temp)
            }
        }
    }
}


class CommentReplyDataModel: NSObject {
    var code:String?
    var message:String?
    var results:CommentReplyData?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = CommentReplyData.init(dic: results)
        }
    }
}

class CommentReplyData:NSObject {
    var comment_id:Int?
    var writer_id:Int?
    var comment:ParentComment?
    var list:CommentReplyList?
    var list_arr:Array = Array<CommentReplyList>()
    var total:Int?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        comment_id = DictionaryToInt(dic: dic, intName: "comment_id")
        writer_id = DictionaryToInt(dic: dic, intName: "writer_id")
        total = DictionaryToInt(dic: dic, intName: "total")
        
        if let comment = dic["comment"] as? Dictionary<String, Any> {
            self.comment = ParentComment.init(dic: comment)
        }
        
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = CommentReplyList.init(dic: listTemp as! Dictionary<String, Any>)
                list_arr.append(temp)
            }
        }
    }
}

class ParentComment: NSObject {
    var _id:String?
    var id:Int?
    var class_id:Int?
    var user_id:Int?
    var emoticon:Int?
    var content:String?
    var photo_data:String?
    var user_name:String?
    var user_photo:String?
    var created_at:String?
    var reply_cnt:Int?
    var like_cnt:Int?
    var writer_flag:String?
    var like_flag:String?
    var coach_flag:String?
    var reply_flag:String?
    var time_spilled:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        _id = DictionaryToString(dic: dic, strName: "_id")
        id = DictionaryToInt(dic: dic, intName: "id")
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        emoticon = DictionaryToInt(dic: dic, intName: "emoticon")
        content = DictionaryToString(dic: dic, strName: "content")
        photo_data = DictionaryToString(dic: dic, strName: "photo_data")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        reply_cnt = DictionaryToInt(dic: dic, intName: "reply_cnt")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        writer_flag = DictionaryToString(dic: dic, strName: "writer_flag")
        like_flag = DictionaryToString(dic: dic, strName: "like_flag")
        coach_flag = DictionaryToString(dic: dic, strName: "coach_flag")
        reply_flag = DictionaryToString(dic: dic, strName: "reply_flag")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
    }
}

class CommentReplyList:NSObject {
    var _id:String?
    var id:Int?
    var content:String?
    var created_at:String?
    var emoticon:Int?
    var photo_data:String?
    var parent_id:Int?
    var user_id:Int?
    var user_name:String?
    var user_photo:String?
    var like_cnt:Int?
    var writer_flag:String?
    var like_flag:String?
    var coach_flag:String?
    var time_spilled:String?
    var mention_id:Int?
    var mention_name:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        _id = DictionaryToString(dic: dic, strName: "_id")
        id = DictionaryToInt(dic: dic, intName: "id")
        content = DictionaryToString(dic: dic, strName: "content")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        emoticon = DictionaryToInt(dic: dic, intName: "emoticon")
        photo_data = DictionaryToString(dic: dic, strName: "photo_data")
        parent_id = DictionaryToInt(dic: dic, intName: "parent_id")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        writer_flag = DictionaryToString(dic: dic, strName: "writer_flag")
        like_flag = DictionaryToString(dic: dic, strName: "like_flag")
        coach_flag = DictionaryToString(dic: dic, strName: "coach_flag")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
        mention_id = DictionaryToInt(dic: dic, intName: "mention_id")
        mention_name = DictionaryToString(dic: dic, strName: "mention_name")
    }
}
