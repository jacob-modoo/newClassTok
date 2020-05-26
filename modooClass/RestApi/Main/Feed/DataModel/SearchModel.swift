//
//  SearchModel.swift
//  modooClass
//
//  Created by 조현민 on 29/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class SearchModel: NSObject {
    var code:String?
    var message:String?
    var results:SearchResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = SearchResults.init(dic: results)
        }
    }
}

class SearchResults : NSObject{
    
    var search:String?
    var order:String?
    var list:SearchList?
    var list_arr:Array = Array<SearchList>()
    var category:McCategory?
    var category_arr:Array = Array<McCategory>()
    var total_count:Int?
    var total:Int?
    var total_page:Int?
    var curr_count:Int?
    var page:Int?
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        search = DictionaryToString(dic: dic, strName: "search")
        order = DictionaryToString(dic: dic, strName: "order")
        total_count = DictionaryToInt(dic: dic, intName: "total_count")
        total = DictionaryToInt(dic: dic, intName: "total")
        total_page = DictionaryToInt(dic: dic, intName: "total_page")
        curr_count = DictionaryToInt(dic: dic, intName: "curr_count")
        page = DictionaryToInt(dic: dic, intName: "page")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = SearchList.init(dic: list as! Dictionary<String, Any>)
                list_arr.append(temp)
            }
        }
        if let list = dic["category"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = McCategory.init(dic: list as! Dictionary<String, Any>)
                category_arr.append(temp)
            }
        }
    }
}

class SearchList:NSObject{
    var class_id:Int?
    var class_name:String?
    var class_short_name:String?
    var class_photo:String?
    var coach_id:Int?
    var coach_name:String?
    var class_star_avg:Double?
    var class_star_cnt:Int?
    var price_sale:String?
    var original_price:String?
    var payment_price:String?
    var signup_cnt:Int?
    var mission_cnt:Int?
    var class_have_status:String?
    var coach_photo:String?
    var class_member_list:Class_member_list?
    var class_member_list_arr:Array = Array<Class_member_list>()
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        class_short_name = DictionaryToString(dic: dic, strName: "class_short_name")
        class_photo = DictionaryToString(dic: dic, strName: "class_photo")
        coach_id = DictionaryToInt(dic: dic, intName: "coach_id")
        coach_name = DictionaryToString(dic: dic, strName: "coach_name")
        class_star_avg = DictionaryToDouble(dic: dic, doubleName: "class_star_avg")
        class_star_cnt = DictionaryToInt(dic: dic, intName: "class_star_cnt")
        price_sale = DictionaryToString(dic: dic, strName: "price_sale")
        original_price = DictionaryToString(dic: dic, strName: "original_price")
        payment_price = DictionaryToString(dic: dic, strName: "payment_price")
        signup_cnt = DictionaryToInt(dic: dic, intName: "signup_cnt")
        mission_cnt = DictionaryToInt(dic: dic, intName: "mission_cnt")
        class_have_status = DictionaryToString(dic: dic, strName: "class_have_status")
        coach_photo = DictionaryToString(dic: dic, strName: "coach_photo")
        if let list = dic["class_member_list"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = Class_member_list.init(dic: list as! Dictionary<String, Any>)
                class_member_list_arr.append(temp)
            }
        }
    }
}

class Class_member_list:NSObject{
    var user_id:Int?
    var mcClass_id:Int?
    var user_photo:String?
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        mcClass_id = DictionaryToInt(dic: dic, intName: "mcClass_id")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
    }
}

class SearchResultList : NSObject{
    var id:Int?
    var photo:String?
    var class_name:String?
    var category1:String?
    var category2:String?
    var stamp_text:String?
    var review_count:Int?
    var review_avg:String?
    var prehave:String?
    var point_type:Int?
    var point_text:String?
    var total_count:Int?
    var refund_text:String?
    var list_type:Int?
    var list_type_comment:String?
    var start_day:String?
    var curriculum_name:String?
    var user_photo:String?
    var user_comment:String?
    var coach_name:String?
    var coach_photo:String?
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        photo = DictionaryToString(dic: dic, strName: "photo")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        category1 = DictionaryToString(dic: dic, strName: "category1")
        category2 = DictionaryToString(dic: dic, strName: "category2")
        stamp_text = DictionaryToString(dic: dic, strName: "stamp_text")
        review_count = DictionaryToInt(dic: dic, intName: "review_count")
        review_avg = DictionaryToString(dic: dic, strName: "review_avg")
        if review_avg == ""{review_avg = "0.0"}
        prehave = DictionaryToString(dic: dic, strName: "prehave")
        point_type = DictionaryToInt(dic: dic, intName: "point_type")
        point_text = DictionaryToString(dic: dic, strName: "point_text")
        total_count = DictionaryToInt(dic: dic, intName: "total_count")
        refund_text = DictionaryToString(dic: dic, strName: "refund_text")
        list_type = DictionaryToInt(dic: dic, intName: "list_type")
        list_type_comment = DictionaryToString(dic: dic, strName: "list_type_comment")
        start_day = DictionaryToString(dic: dic, strName: "start_day")
        curriculum_name = DictionaryToString(dic: dic, strName: "curriculum_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        user_comment = DictionaryToString(dic: dic, strName: "user_comment")
        coach_photo = DictionaryToString(dic: dic, strName: "coach_photo")
        coach_name = DictionaryToString(dic: dic, strName: "coach_name")
    }
}
