//
//  SquareReplyCommentListModel.swift
//  modooClass
//
//  Created by 조현민 on 2020/02/21.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit

class SquareReplyCommentListModel: NSObject {
    var code:String?
    var message:String?
    var results:SquareReplyCommentListModelResult?

    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = SquareReplyCommentListModelResult.init(dic: results)
        }
    }
}

class SquareReplyCommentListModelResult:NSObject{
    var page:String?
    var reply_total:Int?
    var reply_curr_count:Int?
    var total_page:Int?
    var list:SquareReply_list?
    var list_arr:Array = Array<SquareReply_list>()
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        
        page = DictionaryToString(dic: dic, strName: "page")
        reply_total = DictionaryToInt(dic: dic, intName: "reply_total")
        reply_curr_count = DictionaryToInt(dic: dic, intName: "reply_curr_count")
        total_page = DictionaryToInt(dic: dic, intName: "total_page")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = SquareReply_list.init(dic: list as! Dictionary<String, Any>)
                list_arr.append(temp)
            }
        }
    }
}
