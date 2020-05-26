//
//  Join.swift
//  modooClass
//
//  Created by 조현민 on 17/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//
import UIKit

class JoinModel: NSObject {
    var code:String?
    var message:String?
    var results:Message?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = Message.init(dic: results)
        }
    }
}

class Message:NSObject {
    var msg:String?
    var token:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        msg = DictionaryToString(dic: dic, strName: "msg")
        token = DictionaryToString(dic: dic, strName: "token")
    }
}
