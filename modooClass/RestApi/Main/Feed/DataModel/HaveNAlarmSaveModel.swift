//
//  alarmSaveModel.swift
//  modooClass
//
//  Created by 조현민 on 31/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class HaveNAlarmSaveModel: NSObject {
    var code:String?
    var message:String?
    var results:AlarmSaveResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = AlarmSaveResults.init(dic: results)
        }
    }
}

class AlarmSaveResults:NSObject{
    var mcClass_id:Int?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        mcClass_id = DictionaryToInt(dic: dic, intName: "mcClass_id")
    }
}
