//
//  ChatListModel.swift
//  modooClass
//
//  Created by iOS|Dev on 2021/01/20.
//  Copyright © 2021 신민수. All rights reserved.
//

import UIKit

class ChatListModel: NSObject {
    var code:String?
    var message:String?
    var results:ChattingModel?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ChattingModel.init(dic: results)
        }
    }
    
}

class ChattingModel: NSObject {
    var support_mcChat_id:Int?
    var page:String?
    var limit:Int?
    var total:Int?
    var page_total:Int?
    var curr_total:Int?
    var list:Chat_list?
    var list_arr:Array = Array<Chat_list>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        support_mcChat_id = DictionaryToInt(dic: dic, intName: "support_mcChat_id")
        page = DictionaryToString(dic: dic, strName: "page")
        limit = DictionaryToInt(dic: dic, intName: "limit")
        total = DictionaryToInt(dic: dic, intName: "total")
        page_total = DictionaryToInt(dic: dic, intName: "page_total")
        curr_total = DictionaryToInt(dic: dic, intName: "curr_total")
        
        if let list = dic["list"] as? Array<Any> {
            let array:Array = list
            for listTemp in array {
                let temp = Chat_list.init(dic: listTemp as! Dictionary<String, Any>)
                list_arr.append(temp)
            }
        }
    }
}

class Chat_list: NSObject {
    var id:Int?
    var mcClass_id:Int?
    var mcClassGroup_id:Int?
    var type:String?
    var member_id1:Int?
    var member_id2:Int?
    var line_id:Int?
    var title:String?
    var last_message:String?
    var created_at:String?
    var updated_at:String?
    var unread_order:Int?
    var unread_count:Int?
    var user_id:Array = [Int]()
    var user_name:Array = [String]()
    var photo:Array = [String]()
    var login:Array = [Bool]()
    var time:String?
    var chatId:Int?
    var unread:Int?
    var date:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String,Any>)  {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        mcClass_id = DictionaryToInt(dic: dic, intName: "mcClass_id")
        mcClassGroup_id = DictionaryToInt(dic: dic, intName: "mcClassGroup_id")
        type = DictionaryToString(dic: dic, strName: "type")
        member_id1 = DictionaryToInt(dic: dic, intName: "member_id1")
        member_id2 = DictionaryToInt(dic: dic, intName: "member_id2")
        line_id = DictionaryToInt(dic: dic, intName: "line_id")
        title = DictionaryToString(dic: dic, strName: "title")
        last_message = DictionaryToString(dic: dic, strName: "last_message")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        updated_at = DictionaryToString(dic: dic, strName: "updated_at")
        unread_order = DictionaryToInt(dic: dic, intName: "unread_order")
        unread_count = DictionaryToInt(dic: dic, intName: "unread_count")
        time = DictionaryToString(dic: dic, strName: "time")
        chatId = DictionaryToInt(dic: dic, intName: "chatId")
        unread = DictionaryToInt(dic: dic, intName: "unread")  
        date = DictionaryToString(dic: dic, strName: "date")
        
        if let list = dic["user_id"] as? [Int] {
            let array:Array = list
            for listTemp in array {
                user_id.append(listTemp)
            }
        }
        
        if let list = dic["user_name"] as? [String] {
            let array:Array = list
            for listTemp in array {
                user_name.append(listTemp)
            }
        }
        
        if let list = dic["photo"] as? [String] {
            let array:Array = list
            for listTemp in array {
                photo.append(listTemp)
            }
        }
        
        if let list = dic["login"] as? [Bool] {
            let array:Array = list
            for listTemp in array {
                login.append(listTemp)
            }
        }
    }
}
