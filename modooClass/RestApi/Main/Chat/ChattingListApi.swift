//
//  ChattingListApi.swift
//  modooClass
//
//  Created by iOS|Dev on 2021/01/20.
//  Copyright © 2021 신민수. All rights reserved.
//

import UIKit
import Alamofire

class ChattingListApi: NSObject {

    static let shared = ChattingListApi()
    
//    MARK: - Chat list
    func chatList(page:Int, success: @escaping(_ data: ChatListModel)->Void, fail: @escaping(_ error: Error?)->Void) {
        
        let reqeust = AF.request("\(apiUrl)/chat_list/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        reqeust.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ChatListModel.init(dic: convertToDictionary(data: response.data!, apiURL: "get : \(apiUrl)/chat_list/\(page)"))
                success(dic)
            } else {
                fail(response.error)
            }
        }
    }
}
