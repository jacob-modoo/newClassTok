//
//  JobModel.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/04.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class JobModel: NSObject {
    var code:String?
    var message:String?
    var results:JobResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = JobResults.init(dic: results)
        }
    }
}

class JobResults: NSObject{
    var job_list:Job_list?
    var job_list_arr:Array = Array<Job_list>()
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        if let job_list = dic["list"] as? Array<Any>{
            let array:Array = job_list
            for list in array {
                let temp = Job_list.init(dic: list as! Dictionary<String, Any>)
                job_list_arr.append(temp)
            }
        }
    }
}

class Job_list:NSObject{
    var id:Int?
    var name:String?
    var created_at:String?
    var updated_at:String?
    var mcUserInterest_id:Int?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        name = DictionaryToString(dic: dic, strName: "name")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        updated_at = DictionaryToString(dic: dic, strName: "updated_at")
        mcUserInterest_id = DictionaryToInt(dic: dic, intName: "mcUserInterest_id")
    }
}
