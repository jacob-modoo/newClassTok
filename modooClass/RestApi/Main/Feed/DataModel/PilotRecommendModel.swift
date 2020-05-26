//
//  PilotRecommendModel.swift
//  modooClass
//
//  Created by 조현민 on 2019/12/30.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class PilotRecommendModel: NSObject {
    var code:String?
    var message:String?
    var results:PilotRecommendResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = PilotRecommendResult.init(dic: results)
        }
    }
}

class PilotRecommendResult: NSObject{
    var experience:Experience_pilot?
    var experience_arr:Array = Array<Experience_pilot>()
    var mcInterest1:String?
    var mcInterest2:String?
    var mcInterest3:String?
    var mcCategory:McCategory?
    var mcCategory_arr:Array = Array<McCategory>()
    var coach_together:Coach_together?
    var product:Product_list?
    var product_best:Product_list?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        
        if let experience = dic["experience"] as? Array<Any>{
            let array:Array = experience
            for experience in array {
                let temp = Experience_pilot.init(dic: experience as! Dictionary<String, Any>)
                experience_arr.append(temp)
            }
        }
        mcInterest1 = DictionaryToString(dic: dic, strName: "mcInterest1")
        mcInterest2 = DictionaryToString(dic: dic, strName: "mcInterest2")
        mcInterest3 = DictionaryToString(dic: dic, strName: "mcInterest3")
        if let mcCategory = dic["mcCategory"] as? Array<Any>{
            let array:Array = mcCategory
            for mcCategory in array {
                let temp = McCategory.init(dic: mcCategory as! Dictionary<String, Any>)
                mcCategory_arr.append(temp)
            }
        }
        if let coach_together = dic["coach_together"] as? Dictionary<String, Any> {
            self.coach_together = Coach_together.init(dic: coach_together)
        }
        if let product = dic["product"] as? Dictionary<String, Any> {
            self.product = Product_list.init(dic: product)
        }
        if let product_best = dic["product_best"] as? Dictionary<String, Any> {
            self.product_best = Product_list.init(dic: product_best)
        }
    }
}

class Experience_pilot:NSObject{
    var id:String?
    var source_type:String?
    var source_link_id:Int?
    var user_id:Int?
    var user_name:String?
    var job_name:String?
    var user_photo:String?
    var class_id:Int?
    var class_name:String?
    var class_photo:String?
    var class_photo1:String?
    var class_photo2:String?
    var source_photo:String?
    var play_address:String?
    var youtu_address:String?
    var emoticon:String?
    var video_duration:String?
    var content:String?
    var reply_content:String?
    var review_star:Int?
    var fixed_interest1:String?
    var fixed_interest2:String?
    var fixed_interest3:String?
    var reply_cnt:Int?
    var like_cnt:Int?
    var coach_yn:String?
    var created_at:String?
    
    override init() {
            super.init()
        }
        
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToString(dic: dic, strName: "id")
        source_type = DictionaryToString(dic: dic, strName: "source_type")
        source_link_id = DictionaryToInt(dic: dic, intName: "source_link_id")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        job_name = DictionaryToString(dic: dic, strName: "job_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        class_photo = DictionaryToString(dic: dic, strName: "class_photo")
        class_photo1 = DictionaryToString(dic: dic, strName: "class_photo1")
        class_photo2 = DictionaryToString(dic: dic, strName: "class_photo2")
        source_photo = DictionaryToString(dic: dic, strName: "source_photo")
        play_address = DictionaryToString(dic: dic, strName: "play_address")
        youtu_address = DictionaryToString(dic: dic, strName: "youtu_address")
        emoticon = DictionaryToString(dic: dic, strName: "emoticon")
        video_duration = DictionaryToString(dic: dic, strName: "video_duration")
        content = DictionaryToString(dic: dic, strName: "content")
        reply_content = DictionaryToString(dic: dic, strName: "reply_content")
        review_star = DictionaryToInt(dic: dic, intName: "review_star")
        fixed_interest1 = DictionaryToString(dic: dic, strName: "fixed_interest1")
        fixed_interest2 = DictionaryToString(dic: dic, strName: "fixed_interest2")
        fixed_interest3 = DictionaryToString(dic: dic, strName: "fixed_interest3")
        reply_cnt = DictionaryToInt(dic: dic, intName: "reply_cnt")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        coach_yn = DictionaryToString(dic: dic, strName: "coach_yn")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
    }
}

class McCategory:NSObject{
    
    var id:Int?
    var name:String?
    var photo:String?
    var list:McCategoryList?
    var list_arr:Array = Array<McCategoryList>()
    
    override init() {
            super.init()
        }
        
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        name = DictionaryToString(dic: dic, strName: "name")
        photo = DictionaryToString(dic: dic, strName: "photo")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = McCategoryList.init(dic: list as! Dictionary<String, Any>)
                list_arr.append(temp)
            }
        }
    }
}

class McCategoryList:NSObject{
    var id:String?
    var source_type:String?
    var source_link_id:Int?
    var user_id:Int?
    var user_name:String?
    var job_name:String?
    var user_photo:String?
    var class_id:Int?
    var class_name:String?
    var class_photo:String?
    var class_photo1:String?
    var class_photo2:String?
    var source_photo:String?
    var play_address:String?
    var youtu_address:String?
    var emoticon:String?
    var video_duration:String?
    var content:String?
    var reply_content:String?
    var review_star:Int?
    var fixed_interest1:String?
    var fixed_interest2:String?
    var fixed_interest3:String?
    var reply_cnt:Int?
    var like_cnt:Int?
    var coach_yn:String?
    var created_at:String?
    
    var signup_count_24:String?
    var interest1:String?
    var interest2:String?
    var main_category:Int?
    
    override init() {
            super.init()
        }
        
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToString(dic: dic, strName: "id")
        source_type = DictionaryToString(dic: dic, strName: "source_type")
        source_link_id = DictionaryToInt(dic: dic, intName: "source_link_id")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        job_name = DictionaryToString(dic: dic, strName: "job_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        class_photo = DictionaryToString(dic: dic, strName: "class_photo")
        class_photo1 = DictionaryToString(dic: dic, strName: "class_photo1")
        class_photo2 = DictionaryToString(dic: dic, strName: "class_photo2")
        source_photo = DictionaryToString(dic: dic, strName: "source_photo")
        play_address = DictionaryToString(dic: dic, strName: "play_address")
        youtu_address = DictionaryToString(dic: dic, strName: "youtu_address")
        emoticon = DictionaryToString(dic: dic, strName: "emoticon")
        video_duration = DictionaryToString(dic: dic, strName: "video_duration")
        content = DictionaryToString(dic: dic, strName: "content")
        reply_content = DictionaryToString(dic: dic, strName: "reply_content")
        review_star = DictionaryToInt(dic: dic, intName: "review_star")
        fixed_interest1 = DictionaryToString(dic: dic, strName: "fixed_interest1")
        fixed_interest2 = DictionaryToString(dic: dic, strName: "fixed_interest2")
        fixed_interest3 = DictionaryToString(dic: dic, strName: "fixed_interest3")
        reply_cnt = DictionaryToInt(dic: dic, intName: "reply_cnt")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        coach_yn = DictionaryToString(dic: dic, strName: "coach_yn")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        signup_count_24 = DictionaryToString(dic: dic, strName: "signup_count_24")
        interest1 = DictionaryToString(dic: dic, strName: "interest1")
        interest2 = DictionaryToString(dic: dic, strName: "interest2")
        main_category = DictionaryToInt(dic: dic, intName: "main_category")
    }
}

class Coach_together:NSObject{
    
    var mcInterest1:String?
    var mcInterest2:String?
    var mcInterest3:String?
    
    var list:Coach_together_List?
    var coach_together_List_arr:Array = Array<Coach_together_List>()

    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        mcInterest1 = DictionaryToString(dic: dic, strName: "mcInterest1")
        mcInterest2 = DictionaryToString(dic: dic, strName: "mcInterest2")
        mcInterest3 = DictionaryToString(dic: dic, strName: "mcInterest3")
        
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = Coach_together_List.init(dic: list as! Dictionary<String, Any>)
                coach_together_List_arr.append(temp)
            }
        }
    }
}

class Coach_together_List:NSObject{
    var user_id:Int?
    var user_name:String?
    var gender:String?
    var user_photo:String?
    var fixed_interest1:String?
    var fixed_interest2:String?
    var fixed_interest3:String?
    var friend_status:String?
    
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        gender = DictionaryToString(dic: dic, strName: "gender")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        fixed_interest1 = DictionaryToString(dic: dic, strName: "fixed_interest1")
        fixed_interest2 = DictionaryToString(dic: dic, strName: "fixed_interest2")
        fixed_interest3 = DictionaryToString(dic: dic, strName: "fixed_interest3")
        friend_status = DictionaryToString(dic: dic, strName: "friend_status")
    }
}

class Product_list:NSObject{
    var list:Product_pilot_list?
    var list_arr:Array = Array<Product_pilot_list>()
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = Product_pilot_list.init(dic: list as! Dictionary<String, Any>)
                list_arr.append(temp)
            }
        }
    }
}

class Product_pilot_list:NSObject{
    var class_id:Int?
    var class_photo:String?
    var class_name:String?
    var coach_name:String?
    var interest1:String?
    var interest2:String?
    var payment_info_data1:String?
    var payment_info_data2:String?
    var payment_info_data3:String?
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        class_photo = DictionaryToString(dic: dic, strName: "class_photo")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        coach_name = DictionaryToString(dic: dic, strName: "coach_name")
        interest1 = DictionaryToString(dic: dic, strName: "interest1")
        interest2 = DictionaryToString(dic: dic, strName: "interest2")
        payment_info_data1 = DictionaryToString(dic: dic, strName: "payment_info_data1")
        payment_info_data2 = DictionaryToString(dic: dic, strName: "payment_info_data2")
        payment_info_data3 = DictionaryToString(dic: dic, strName: "payment_info_data3")
    }
}
