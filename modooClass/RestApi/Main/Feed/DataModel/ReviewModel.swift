//
//  ReviewModel.swift
//  modooClass
//
//  Created by 조현민 on 2020/01/13.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit

class ReviewModel: NSObject {
    var code:String?
    var message:String?
    var results:ReviewListResult?
    
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ReviewListResult.init(dic: results)
        }
    }
}

class ReviewListResult:NSObject{
    var page:Int?
    var page_total:Int?
    var total:Int?
    var reviewList:ReviewList?
    var reviewList_arr:Array = Array<ReviewList>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        page = DictionaryToInt(dic: dic, intName: "page")
        page_total = DictionaryToInt(dic: dic, intName: "page_total")
        total = DictionaryToInt(dic: dic, intName: "total")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = ReviewList.init(dic: list as! Dictionary<String, Any>)
                reviewList_arr.append(temp)
            }
        }
    }
}

class ReviewList:NSObject{
    var id:Int?
    var created_at:String?
    var star:Int?
    var content:String?
    var user_id:Int?
    var coach_content:String?
    var class_group_no:Int?
    var coach_name:String?
    var coach_photo:String?
    var review_photo:String?
    var photo:String?
    var friend_state:Int?
    var user_name:String?
    var gap:Int?
    var gap_text:String?
    var coach_id:Int?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        star = DictionaryToInt(dic: dic, intName: "star")
        content = DictionaryToString(dic: dic, strName: "content")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        coach_content = DictionaryToString(dic: dic, strName: "coach_content")
        class_group_no = DictionaryToInt(dic: dic, intName: "class_group_no")
        coach_name = DictionaryToString(dic: dic, strName: "coach_name")
        coach_photo = DictionaryToString(dic: dic, strName: "coach_photo")
        review_photo = DictionaryToString(dic: dic, strName: "review_photo")
        photo = DictionaryToString(dic: dic, strName: "photo")
        friend_state = DictionaryToInt(dic: dic, intName: "friend_state")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        gap = DictionaryToInt(dic: dic, intName: "gap")
        gap_text = DictionaryToString(dic: dic, strName: "gap_text")
        coach_id = DictionaryToInt(dic: dic, intName: "coach_id")
    }
}

class ReviewDashboardModel:NSObject{
    var code:String?
    var message:String?
    var results:DashboardResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = DashboardResult.init(dic: results)
        }
    }
}

class DashboardResult:NSObject{
    var total:Int?
    var avg:String?
    var data:ReviewDashboardData?
    var data_arr:Array = Array<ReviewDashboardData>()
    var data_per:ReviewDashboardDataPer?
    var data_per_arr:Array = Array<ReviewDashboardDataPer>()
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        total = DictionaryToInt(dic: dic, intName: "total")
        avg = DictionaryToString(dic: dic, strName: "avg")
        if let list = dic["data"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = ReviewDashboardData.init(dic: list as! Dictionary<String, Any>)
                data_arr.append(temp)
            }
        }
        if let list = dic["data_per"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = ReviewDashboardDataPer.init(dic: list as! Dictionary<String, Any>)
                data_per_arr.append(temp)
            }
        }
    }
}

class ReviewDashboardData:NSObject{
    var score:Int?
    var value:Int?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        score = DictionaryToInt(dic: dic, intName: "score")
        value = DictionaryToInt(dic: dic, intName: "value")
    }
}

class ReviewDashboardDataPer:NSObject{
    var score:Int?
    var value:String?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        score = DictionaryToInt(dic: dic, intName: "score")
        value = DictionaryToString(dic: dic, strName: "value")
    }
}

