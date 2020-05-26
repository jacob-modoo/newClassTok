//
//  FeedAppCurriculumModel.swift
//  modooClass
//
//  Created by 조현민 on 11/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedAppCurriculumModel: NSObject {
    var code:String?
    var message:String?
    var results:FeedAppCurriculumResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = FeedAppCurriculumResult.init(dic: results)
        }
    }
}

class FeedAppCurriculumResult:NSObject{
    var class_name:String?
    var comment:String?
    var class_type:String?
    var refund_total:String?
    var stamp:String?
    var progress:String?
    var curriculumList:Array = Array<CurriculumList>()
    var manage:CurriculumDetail?
    var manageList:Array = Array<CurriculumDetail>()
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        comment = DictionaryToString(dic: dic, strName: "comment")
        class_type = DictionaryToString(dic: dic, strName: "class_type")
        refund_total = DictionaryToString(dic: dic, strName: "refund_total")
        stamp = DictionaryToString(dic: dic, strName: "stamp")
        progress = DictionaryToString(dic: dic, strName: "progress")
        if let list = dic["list"] as? Array<Dictionary<String, Any>>{
            let array:Array = list
            for listTemp in array {
                let temp = CurriculumList.init(dic: listTemp)
                curriculumList.append(temp)
            }
        }
        if let list = dic["manage_list"] as? Array<Dictionary<String, Any>>{
            let array:Array = list
            for listTemp in array {
                let temp = CurriculumDetail.init(dic: listTemp)
                manageList.append(temp)
            }
        }
    }
}

class CurriculumList:NSObject{

    var major:Int?
    var detail:CurriculumDetail?
    var detailList:Array = Array<CurriculumDetail>()
    
    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        major = DictionaryToInt(dic: dic, intName: "major")
        if let detail = dic["detail"] as? Array<Any>{
            let array:Array = detail
            for listTemp in array {
                let temp = CurriculumDetail.init(dic: listTemp as! Dictionary<String, Any>)
                detailList.append(temp)
            }
        }
    }
}

class CurriculumDetail:NSObject{
    
    var id:Int?
    var data:Int?
    var title:String?
    var duration:String?
    var status:String?
    var stamp:Int?
    var photo:String?
    var mcMission_stamp_id:Int?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        data = DictionaryToInt(dic: dic, intName: "data")
        title = DictionaryToString(dic: dic, strName: "title")
        duration = DictionaryToString(dic: dic, strName: "duration")
        status = DictionaryToString(dic: dic, strName: "status")
        stamp = DictionaryToInt(dic: dic, intName: "stamp")
        photo = DictionaryToString(dic: dic, strName: "photo")
        mcMission_stamp_id = DictionaryToInt(dic: dic, intName: "mcMission_stamp_id")
    }
}
