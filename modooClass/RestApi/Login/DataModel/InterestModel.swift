//
//  InterestModel.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/04.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class InterestModel: NSObject {
    var code:String?
    var message:String?
    var results:InterestResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = InterestResults.init(dic: results)
        }
    }
}

class InterestResults: NSObject{
    var interest_list:Interest_list?
    var interest_list_arr:Array = Array<Interest_list>()
    var all_list:All_list?
    var all_list_arr:Array = Array<All_list>()
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        if let interest_list = dic["list"] as? Array<Any>{
            let array:Array = interest_list
            for list in array {
                let temp = Interest_list.init(dic: list as! Dictionary<String, Any>)
                interest_list_arr.append(temp)
            }
        }
        if let all_list = dic["all"] as? Array<Any>{
            let array:Array = all_list
            for list in array {
                let temp = All_list.init(dic: list as! Dictionary<String, Any>)
                all_list_arr.append(temp)
            }
        }
    }
}

class Interest_list:NSObject{
    var id:Int?
    var name:String?
    var created_at:String?
    var updated_at:String?
    var mcInterest_id:Int?
    var selectCheck:Bool = false
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        name = DictionaryToString(dic: dic, strName: "name")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        updated_at = DictionaryToString(dic: dic, strName: "updated_at")
        mcInterest_id = DictionaryToInt(dic: dic, intName: "mcInterest_id")
    }
}

class All_list:NSObject{
    var id:Int?
    var name:String?
    var interest_list:Interest_list?
    var interest_list_arr:Array = Array<Interest_list>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        name = DictionaryToString(dic: dic, strName: "name")
        if let interest_list = dic["list"] as? Array<Any>{
            let array:Array = interest_list
            for list in array {
                let temp = Interest_list.init(dic: list as! Dictionary<String, Any>)
                interest_list_arr.append(temp)
            }
        }
    }
}
