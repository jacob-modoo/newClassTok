//
//  AutoSearchModel.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/06/05.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

class AutoSearchModel: NSObject {
    var code:String?
    var message:String?
    var process_time:Int?
    var results:AutoSearchResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        process_time = DictionaryToInt(dic: dic, intName: "process_time")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = AutoSearchResults.init(dic: results)
        }
    }
}

class AutoSearchResults : NSObject {
    var data_list:DataList?
    var data_list_arr:Array = Array<DataList>()
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        if let data_list = dic["data_list"] as? Array<Any>{
            let array:Array = data_list
            for list in array {
                let temp = DataList.init(dic: list as! Dictionary<String, Any>)
                data_list_arr.append(temp)
            }
        }
    }
}

class DataList : NSObject{
    
    var key:String?
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        key = DictionaryToString(dic: dic, strName: "key")
    }
}
