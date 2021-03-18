//
//  ChatHistoryModel.swift
//  modooClass
//
//  Created by iOS|Dev on 2021/02/03.
//  Copyright © 2021 신민수. All rights reserved.
//

import UIKit

class ChatHistoryModel: NSObject {
    var code:String?
    var message:String?
    var results:ChattingHistoryModel?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ChattingHistoryModel.init(dic: results)
        }
    }
}

class ChattingHistoryModel: NSObject {
    var total:Int?
    var page:String?
    var page_total:Int?
    var list:ChatHistoryList?
    var list_arr:Array = Array<ChatHistoryList>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        total = DictionaryToInt(dic: dic, intName: "total")
        page = DictionaryToString(dic: dic, strName: "page")
        page_total = DictionaryToInt(dic: dic, intName: "page_total")
        
        if let list = dic["list"] as? Array<Any> {
            let array:Array = list
            for listTemp in array {
                let temp = ChatHistoryList.init(dic: listTemp as! Dictionary<String, Any>)
                list_arr.append(temp)
            }
        }
    }
}

class ChatHistoryList: NSObject {
    var id:Int?
    var mcChat_id:Int?
    var user_id:Int?
    var user_only:String?
    var user_name:String?
    var photo:String?
    var message:String?
    var emoticon:String?
    var image:String?
    var date:String?
    var time:String?
    var curriculum:String?
    var unread_count:Int?
    var created_at:String?
    var updated_at:String?
    var friend_status:String?
    var idx:Int?
    var sender:Int?
    var sender_name:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic: Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        mcChat_id = DictionaryToInt(dic: dic, intName: "mcChat_id")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_only = DictionaryToString(dic: dic, strName: "user_only")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        photo = DictionaryToString(dic: dic, strName: "photo")
        message = DictionaryToString(dic: dic, strName: "message")
        emoticon = DictionaryToString(dic: dic, strName: "emoticon")
        image = DictionaryToString(dic: dic, strName: "image")
        date = DictionaryToString(dic: dic, strName: "date")
        time = DictionaryToString(dic: dic, strName: "time")
        curriculum = DictionaryToString(dic: dic, strName: "curriculum")
        unread_count = DictionaryToInt(dic: dic, intName: "unread_count")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        updated_at = DictionaryToString(dic: dic, strName: "updated_at")
        friend_status = DictionaryToString(dic: dic, strName: "friend_status")
        idx = DictionaryToInt(dic: dic, intName: "idx")
        sender = DictionaryToInt(dic: dic, intName: "sender")
        sender_name = DictionaryToString(dic: dic, strName: "sender_name")
    }
}


class ChatHistoryListModel: NSObject {
    var code:String?
    var message:String?
    var results:ChatHistoryMessageList?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ChatHistoryMessageList.init(dic: results)
        }
    }
}

class ChatHistoryMessageList: NSObject {
    
    var message:String?
    var date:String?
    var idx:Int?
    var photo:String?
    var read:Int?
    var sender:Int?
    var sender_name:String?
    var temp_idx:Int?
    var time:String?
    var emoticon:String?
    var image:String?
    var unread_count:Int?
    
//    var created_at:String?
//    var updated_at:String?
//    var friend_status:String?
    
    
    
    override init() {
        super.init()
    }
    
    convenience init(dic: Dictionary<String, Any>) {
        self.init()
        idx = DictionaryToInt(dic: dic, intName: "idx")
        photo = DictionaryToString(dic: dic, strName: "photo")
        message = DictionaryToString(dic: dic, strName: "message")
        emoticon = DictionaryToString(dic: dic, strName: "emoticon")
        image = DictionaryToString(dic: dic, strName: "image")
        date = DictionaryToString(dic: dic, strName: "date")
        time = DictionaryToString(dic: dic, strName: "time")
        read = DictionaryToInt(dic: dic, intName: "read")
//        created_at = DictionaryToString(dic: dic, strName: "created_at")
//        updated_at = DictionaryToString(dic: dic, strName: "updated_at")
//        friend_status = DictionaryToString(dic: dic, strName: "friend_status")
        temp_idx = DictionaryToInt(dic: dic, intName: "temp_idx")
        sender = DictionaryToInt(dic: dic, intName: "sender")
        sender_name = DictionaryToString(dic: dic, strName: "sender_name")
        unread_count = DictionaryToInt(dic: dic, intName: "unread_count")
    }
}

class ChatMessageImg2URLModel: NSObject {
    var code:String?
    var message:String?
    var results:ChatMessageImageList?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ChatMessageImageList.init(dic: results)
        }
    }
}

class ChatMessageImageList: NSObject {
    var photo_url:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic: Dictionary<String, Any>) {
        self.init()
    photo_url = DictionaryToString(dic: dic, strName: "photo_url")
        
    }
}

class ChatFirebaseDB: NSObject {
    
    var sender:String?
    var sender_name:String?
    var message:String?
    var emoticon:String?
    var image:String?
    var read:Int?
    var date:String?
    var photo:String?
    var time:String?
    var user_only:String?
    var idx:Int?
    var unread_count:Int?

    override init() {
        super.init()
    }
    
    convenience init(dic: Dictionary<String, Any>) {
        self.init()
        idx = DictionaryToInt(dic: dic, intName: "idx")
        photo = DictionaryToString(dic: dic, strName: "photo")
        message = DictionaryToString(dic: dic, strName: "message")
        emoticon = DictionaryToString(dic: dic, strName: "emoticon")
        image = DictionaryToString(dic: dic, strName: "image")
        date = DictionaryToString(dic: dic, strName: "date")
        time = DictionaryToString(dic: dic, strName: "time")
        read = DictionaryToInt(dic: dic, intName: "read")
        user_only = DictionaryToString(dic: dic, strName: "user_only")
        sender = DictionaryToString(dic: dic, strName: "sender")
        sender_name = DictionaryToString(dic: dic, strName: "sender_name")
        unread_count = DictionaryToInt(dic: dic, intName: "unread_count")
    }
}

