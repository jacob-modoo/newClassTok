//
//  SearchRank.swift
//  modooClass
//
//  Created by 조현민 on 29/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class SearchRankModel: NSObject {
    var code:String?
    var message:String?
    var results:RankResults?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = RankResults.init(dic: results)
        }
    }
}

class RankResults : NSObject{
    var searchRank:SearchRank?
    var searchBanner:SearchBanner?
    var rankList:Array = Array<SearchRank>()
    var search_list:SearchWord?
    var search_list_arr:Array = Array<SearchWord>()
    var interest_list:SearchWord?
    var interest_list_arr:Array = Array<SearchWord>()
    var category:McCategory?
    var category_arr:Array = Array<McCategory>()
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        if let searchRank = dic["rank"] as? Array<Any>{
            let array:Array = searchRank
            for list in array {
                let temp = SearchRank.init(dic: list as! Dictionary<String, Any>)
                rankList.append(temp)
            }
        }
        if let searchBanner = dic["banner"] as? Dictionary<String, Any> {
            self.searchBanner = SearchBanner.init(dic: searchBanner)
        }
        if let search_list = dic["search_list"] as? Array<Any>{
            let array:Array = search_list
            for list in array {
                let temp = SearchWord.init(dic: list as! Dictionary<String, Any>)
                search_list_arr.append(temp)
            }
        }
        if let interest_list = dic["interest_list"] as? Array<Any>{
            let array:Array = interest_list
            for list in array {
                let temp = SearchWord.init(dic: list as! Dictionary<String, Any>)
                interest_list_arr.append(temp)
            }
        }
        if let list = dic["category_list"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = McCategory.init(dic: list as! Dictionary<String, Any>)
                category_arr.append(temp)
            }
        }
    }
}

class SearchWord:NSObject{
    var name:String?
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        name = DictionaryToString(dic: dic, strName: "name")
    }
}

class SearchRank : NSObject{
    var rank:Int?
    var title:String?
    var rank_change:Int?
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        rank = DictionaryToInt(dic: dic, intName: "rank")
        title = DictionaryToString(dic: dic, strName: "title")
        rank_change = DictionaryToInt(dic: dic, intName: "rank_change")
    }
}

class SearchBanner : NSObject{
    var payment_title:String?
    var payment:Payment?
    var best_title:String?
    var best:Best?
    
    var payment_api:String?
    var payment_button:String?
    var best_api:String?
    var best_button:String?
    
    var paymentList:Array = Array<Payment>()
    var bestList:Array = Array<Best>()
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        payment_title = DictionaryToString(dic: dic, strName: "payment_title")
        payment_api = DictionaryToString(dic: dic, strName: "payment_api")
        payment_button = DictionaryToString(dic: dic, strName: "payment_button")
        best_api = DictionaryToString(dic: dic, strName: "best_api")
        best_button = DictionaryToString(dic: dic, strName: "best_button")
        best_title = DictionaryToString(dic: dic, strName: "best_title")
        if let payment = dic["payment"] as? Array<Any>{
            let array:Array = payment
            for list in array {
                let temp = Payment.init(dic: list as! Dictionary<String, Any>)
                paymentList.append(temp)
            }
        }
        
        if let best = dic["best"] as? Array<Any>{
            let array:Array = best
            for list in array {
                let temp = Best.init(dic: list as! Dictionary<String, Any>)
                bestList.append(temp)
            }
        }
    }
}

class Payment : NSObject{
    var id:Int?
    var rank:Int?
    var photo:String?
    var category1:String?
    var category2:String?
    var class_name:String?
    var review_count:Int?
    var review_avg:String?
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        rank = DictionaryToInt(dic: dic, intName: "rank")
        photo = DictionaryToString(dic: dic, strName: "photo")
        category1 = DictionaryToString(dic: dic, strName: "category1")
        category2 = DictionaryToString(dic: dic, strName: "category2")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        review_count = DictionaryToInt(dic: dic, intName: "review_count")
        review_avg = DictionaryToString(dic: dic, strName: "review_avg")
        if review_avg == ""{review_avg = "0.0"}
    }
}

class Best : NSObject{
    var id:Int?
    var rank:Int?
    var photo:String?
    var category1:String?
    var category2:String?
    var class_name:String?
    var review_count:Int?
    var review_avg:String?
    var review:BestReview?
    var reviewList:Array = Array<BestReview>()
    
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        rank = DictionaryToInt(dic: dic, intName: "rank")
        photo = DictionaryToString(dic: dic, strName: "photo")
        category1 = DictionaryToString(dic: dic, strName: "category1")
        category2 = DictionaryToString(dic: dic, strName: "category2")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        review_count = DictionaryToInt(dic: dic, intName: "review_count")
        review_avg = DictionaryToString(dic: dic, strName: "review_avg")
        if review_avg == ""{review_avg = "0.0"}
        if let review = dic["review"] as? Array<Any>{
            let array:Array = review
            for list in array {
                let temp = BestReview.init(dic: list as! Dictionary<String, Any>) 
                reviewList.append(temp)
            }
        }
    }
}

class BestReview:NSObject{
    var name:String?
    var review_avg:Int?
    var review_content:String?
    override init() {
        super.init()
    }
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        name = DictionaryToString(dic: dic, strName: "name")
        review_avg = DictionaryToInt(dic: dic, intName: "review_avg")
        review_content = DictionaryToString(dic: dic, strName: "review_content")
    }
}
