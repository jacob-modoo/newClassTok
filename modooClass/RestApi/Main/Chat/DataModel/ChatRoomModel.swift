//
//  ChatRoomModel.swift
//  modooClass
//
//  Created by iOS|Dev on 2021/02/02.
//  Copyright © 2021 신민수. All rights reserved.
//

import UIKit

class ChatRoomModel: NSObject {
    var code:String?
    var message:String?
    var results:ChattingRoomModel?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ChattingRoomModel.init(dic: results)
        }
    }
}

class ChattingRoomModel: NSObject {
    var list:ChatRoomList?
    var list_arr:Array = Array<ChatRoomList>()
    var mcChat_id:String?
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        mcChat_id = DictionaryToString(dic: dic, strName: "mcChat_id")
        
        if let list = dic["list"] as? Array<Any> {
            let array:Array = list
            for listTemp in array {
                let temp = ChatRoomList.init(dic: listTemp as! Dictionary<String, Any>)
                list_arr.append(temp)
            }
        }
    }
}

class ChatRoomPModel: NSObject {
    var code:String?
    var message:String?
    var results:ChattingRoomPModel?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ChattingRoomPModel.init(dic: results)
        }
    }
}

class ChattingRoomPModel: NSObject {
    var list:ChatRoomList?
    var list_arr:Array = Array<ChatRoomList>()
    var mcChat_id:Int?
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        mcChat_id = DictionaryToInt(dic: dic, intName: "mcChat_id")
        
        if let list = dic["list"] as? Array<Any> {
            let array:Array = list
            for listTemp in array {
                let temp = ChatRoomList.init(dic: listTemp as! Dictionary<String, Any>)
                list_arr.append(temp)
            }
        }
    }
}

class ChatRoomList: NSObject {
    var user_id:Int?
    var user_name:String?
    var photo:String?
    var friend_state:String?
    
    convenience init(dic: Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        photo = DictionaryToString(dic: dic, strName: "photo")
        friend_state = DictionaryToString(dic: dic, strName: "friend_state")
    }
}


class ChatReadModel: NSObject {
    var code:String?
    var message:String?
    var results:ChatReadList?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ChatReadList.init(dic: results)
        }
    }
}

class ChatReadList: NSObject {
    var mcChatLog_read_count:Int?
    var mcChatData_count:Int?
    var count:Int?
    var user_id:Int?
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        mcChatLog_read_count = DictionaryToInt(dic: dic, intName: "mcChatLog_read_count")
        mcChatData_count = DictionaryToInt(dic: dic, intName: "mcChatData_count")
        count = DictionaryToInt(dic: dic, intName: "count")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
    }
}
