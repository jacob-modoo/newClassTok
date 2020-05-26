//
//  FeedAppCheerModel.swift
//  modooClass
//
//  Created by 조현민 on 12/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedAppCheerModel: NSObject {
    var code:String?
    var message:String?
    var results:FeedAppCheerResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = FeedAppCheerResult.init(dic: results)
        }
    }
}

class FeedAppCheerResult:NSObject{
    var id:Int?
    var title:String?
    var total:Int?
    var list:CheerList?
    var cheerList:Array = Array<CheerList>()
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        title = DictionaryToString(dic: dic, strName: "title")
        total = DictionaryToInt(dic: dic, intName: "total")
        if let list = dic["list"] as? Array<Dictionary<String, Any>>{
            let array:Array = list
            for listTemp in array {
                let temp = CheerList.init(dic: listTemp)
                cheerList.append(temp)
            }
        }
    }
}

class CheerList:NSObject{
    
    var user_id:Int?
    var user_name:String?
    var photo:String?
    var stamp_total:Int?
    var friend_id:Int?
    var mcClassRoll_id:Int?
    var mcClassRoll_name:String?
    var last_time:Int?
    var friend_status:String?
    var roll:String?
    var grade:String?
    var progress_num:Int?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        photo = DictionaryToString(dic: dic, strName: "photo")
        stamp_total = DictionaryToInt(dic: dic, intName: "stamp_total")
        friend_id = DictionaryToInt(dic: dic, intName: "friend_id")
        mcClassRoll_id = DictionaryToInt(dic: dic, intName: "mcClassRoll_id")
        mcClassRoll_name = DictionaryToString(dic: dic, strName: "mcClassRoll_name")
        last_time = DictionaryToInt(dic: dic, intName: "last_time")
        friend_status = DictionaryToString(dic: dic, strName: "friend_status")
        roll = DictionaryToString(dic: dic, strName: "roll")
        grade = DictionaryToString(dic: dic, strName: "grade")
        progress_num = DictionaryToInt(dic: dic, intName: "progress_num")
    }
}
