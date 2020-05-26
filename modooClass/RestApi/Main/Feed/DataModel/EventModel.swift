//
//  EventModel.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/05/19.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

class EventModel: NSObject {
    var code:String?
    var message:String?
    var results:EventResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = EventResult.init(dic: results)
        }
    }
}

class EventResult: NSObject{
    var event_list:Event_class_list?
    var event_list_arr:Array = Array<Event_class_list>()
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        if let event_list = dic["event_list"] as? Array<Any>{
            let array:Array = event_list
            for list in array {
                let temp = Event_class_list.init(dic: list as! Dictionary<String, Any>)
                event_list_arr.append(temp)
            }
        }
    }
}

class Event_class_list: NSObject {
    var type:String?
    var icon:Int?
    var image:String?
    var link:String?
    var title:String?
    var event_text:String?
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        type = DictionaryToString(dic: dic, strName: "type")
        icon = DictionaryToInt(dic: dic, intName: "icon")
        image = DictionaryToString(dic: dic, strName: "image")
        link = DictionaryToString(dic: dic, strName: "link")
        title = DictionaryToString(dic: dic, strName: "title")
        event_text = DictionaryToString(dic: dic, strName: "event_text")
    }
}
