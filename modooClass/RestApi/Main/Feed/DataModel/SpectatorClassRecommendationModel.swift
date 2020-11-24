//
//  SpectatorClassRecommendationModel.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/11/24.
//  Copyright © 2020 신민수. All rights reserved.
//

import Foundation

class SpectatorClassRecomModel: NSObject {
    var code:String?
    var message:String?
    var results:RecommendationModelResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = RecommendationModelResult.init(dic: results)
        }
    }
}

class RecommendationModelResult: NSObject {
    
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
//    var category:String?
//    var class_study_cnt:Int?
//    var class_type:String?
//    var id:Int?
    var name:String?
    var package_payment:String?
    var package_sale_per:String?
//    var payment_info_data1:String?
//    var payment_info_data4:String?
//    var payment_type:String?
    var photo:String?
//    var similarity:Int?
//    var start_date:String?
//    var status:Int?
    var user_name:String?
    var helpful_cnt:Int?
//    var curriculum_cnt:Int?
    var class_id:Int?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
//        category = DictionaryToString(dic: dic, strName: "category")
//        class_study_cnt = DictionaryToInt(dic: dic, intName: "class_study_cnt")
//        class_type = DictionaryToString(dic: dic, strName: "class_type")
//        id = DictionaryToInt(dic: dic, intName: "id")
        name = DictionaryToString(dic: dic, strName: "name")
        package_payment = DictionaryToString(dic: dic, strName: "package_payment")
        package_sale_per = DictionaryToString(dic: dic, strName: "package_sale_per")
//        payment_info_data1 = DictionaryToString(dic: dic, strName: "payment_info_data1")
//        payment_info_data4 = DictionaryToString(dic: dic, strName: "payment_info_data4")
//        payment_type = DictionaryToString(dic: dic, strName: "payment_type")
        photo = DictionaryToString(dic: dic, strName: "photo")
//        similarity = DictionaryToInt(dic: dic, intName: "similarity")
//        start_date = DictionaryToString(dic: dic, strName: "start_date")
//        status = DictionaryToInt(dic: dic, intName: "status")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        helpful_cnt = DictionaryToInt(dic: dic, intName: "helpful_cnt")
//        curriculum_cnt = DictionaryToInt(dic: dic, intName: "curriculum_cnt")
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
    }
}
