//
//  BannerModel.swift
//  modooClass
//
//  Created by 조현민 on 23/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class BannerModel: NSObject {
    var code:String?
    var message:String?
    var results:BannerResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = BannerResults.init(dic: results)
        }
    }
}


class BannerResults: NSObject {
    var recommend1_title:String?
    var recommend1:Class_list?
    var recommend2_title:String?
    var recommend2:Class_list?
    var recommend3_title:String?
    var recommend3:Class_list?
    var banner1:Banner1?
    var banner2:Banner2?
    
    var recommend1_button:String?
    var recommend2_button:String?
    var recommend3_button:String?
    var recommend1_api:String?
    var recommend2_api:String?
    var recommend3_api:String?
    
    var recommend1List:Array = Array<Class_list>()
    var recommend2List:Array = Array<Class_list>()
    var recommend3List:Array = Array<Class_list>()
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        recommend1_title = DictionaryToString(dic: dic, strName: "recommend1_title")
        if let recommend1 = dic["recommend1"] as? Array<Any>{
            let array:Array = recommend1
            for list in array {
                let temp = Class_list.init(dic: list as! Dictionary<String, Any>)
                recommend1List.append(temp)
            }
        }
        recommend2_title = DictionaryToString(dic: dic, strName: "recommend2_title")
        
        if let recommend2 = dic["recommend2"] as? Array<Any>{
            let array:Array = recommend2
            for list in array {
                let temp = Class_list.init(dic: list as! Dictionary<String, Any>)
                recommend2List.append(temp)
            }
        }
        recommend3_title = DictionaryToString(dic: dic, strName: "recommend3_title")
        
        if let recommend3 = dic["recommend3"] as? Array<Any>{
            let array:Array = recommend3
            for list in array {
                let temp = Class_list.init(dic: list as! Dictionary<String, Any>)
                recommend3List.append(temp)
            }
        }
        if let banner1 = dic["banner1"] as? Dictionary<String, Any> {
            self.banner1 = Banner1.init(dic: banner1)
        }
        if let banner2 = dic["banner2"] as? Dictionary<String, Any> {
            self.banner2 = Banner2.init(dic: banner2)
        }
        recommend1_button = DictionaryToString(dic: dic, strName: "recommend1_button")
        recommend2_button = DictionaryToString(dic: dic, strName: "recommend2_button")
        recommend3_button = DictionaryToString(dic: dic, strName: "recommend3_button")
        recommend1_api = DictionaryToString(dic: dic, strName: "recommend1_api")
        recommend2_api = DictionaryToString(dic: dic, strName: "recommend2_api")
        recommend3_api = DictionaryToString(dic: dic, strName: "recommend3_api")
    }
}

class Banner1 : NSObject{
    var link_url:String?
    var photo:String?
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        link_url = DictionaryToString(dic: dic, strName: "link_url")
        photo = DictionaryToString(dic: dic, strName: "photo")
    }
}

class Banner2 : NSObject{
    var link_url:String?
    var photo:String?
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        link_url = DictionaryToString(dic: dic, strName: "link_url")
        photo = DictionaryToString(dic: dic, strName: "photo")
    }
}


