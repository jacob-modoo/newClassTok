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
    
//    MARK: - Chat room
    func chatRoom(chatRoomId:Int, success: @escaping(_ data: ChatRoomModel)->Void, fail: @escaping(_ error: Error?)->Void) {
        
        let request = AF.request("\(apiUrl)/chatRoomData/\(chatRoomId)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ChatRoomModel.init(dic: convertToDictionary(data: response.data!, apiURL: "get : \(apiUrl)/chatRoomData/\(chatRoomId)"))
                success(dic)
            } else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - Chat reply save
    func chatReplySave(tempIdx:Int, sender:Int, sender_name:String, message:String, emoticon:String, image:UIImage?, read:Int, chat_room_id:Int, success: @escaping(_ data: ChatHistoryListModel)->Void, fail: @escaping(_ error: Error?)->Void) {
        
        var param:Dictionary = [:] as [String : Any]
//        var param:Dictionary = [
//            "temp_idx":tempIdx,
//            "sender":sender,
//            "sender_name":sender_name,
//            "message":message,
//            "emoticon":emoticon,
//            "image":image,
//            "read":read
//        ] as [String:Any]
        
        if image != nil {
//            param["emoticon"] = nil
//            param["message"] = ""
            param = [
                "temp_idx":tempIdx,
                "sender":sender,
                "sender_name":sender_name,
                "message":message,
                "emoticon":emoticon,
                "image":image!,
                "read":read
            ]

        } else {
            param = [
                "temp_idx":tempIdx,
                "sender":sender,
                "sender_name":sender_name,
                "message":message,
                "emoticon":emoticon,
//                "image":image!,
                "read":read
            ]
//            param["image"] = nil
            if emoticon == "" {
                param = [
                    "temp_idx":tempIdx,
                    "sender":sender,
                    "sender_name":sender_name,
                    "message":message,
                    "emoticon":emoticon,
                    "image":image!,
                    "read":read
                ]
//                param["emoticon"] = nil
            }
        }
        
//        var param1:Dictionary = [
//            "temp_idx":tempIdx,
//            "sender":sender,
//            "sender_name":sender_name,
//            "message":message,
//            "emoticon":emoticon,
//            "read":read
//            ] as [String : Any]

//        if emoticon != 100{
//            param1 = [
//                "message":message,
//                "emoticon":emoticon
//            ] as [String : Any]
//        }else{
//
//        }

//        var param:Dictionary = [:] as [String : Any]
//        param = param1
        
        AF.upload(multipartFormData: { (multipartFormData) in
            if image != nil {
                let imageData = image!.jpegData(compressionQuality: 0.5)
                multipartFormData.append(imageData!, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
            }
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: "\(apiUrl)/chat_app/\(chat_room_id)", method: .post, headers: multipartHeader)
        
        .uploadProgress(queue: .main) { progress in
            print("Upload progress: \(progress.fractionCompleted)")
        }
        
        .response { result in
            switch result.result {
            case .success( _):
                let statusCode = result.response?.statusCode
                if statusCode == 200 {
                    let dic = ChatHistoryListModel.init(dic: convertToDictionary(data: result.data!, apiURL: "post : \(apiUrl)/chat_app/\(chat_room_id)"))
                    success(dic)
                } else {
                    fail(result.error)
                }
            case .failure( _): break
                
            }
        }
    }
    
//    MARK: - Chat history
    func chatHistory(chat_room_id:Int, page:Int, success: @escaping(_ data: ChatHistoryModel)->Void, fail: @escaping(_ error: Error?)->Void) {
        
        let request = AF.request("\(apiUrl)/chat_history/\(chat_room_id)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ChatHistoryModel.init(dic: convertToDictionary(data: response.data!, apiURL: "get : \(apiUrl)/chat_history/\(chat_room_id)/\(page)"))
                success(dic)
            } else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - Chat image to url
//    func chatImage2URL(image:UIImage?, success: @escaping(_ data: ChatMessageImg2URLModel)->Void, fail: @escaping(_ error: Error?)->Void) {
//        let param = [
//
//            "image":image
//
//        ] as  [String:UIImage]
//        AF.upload(multipartFormData: { (multipartFormData) in
//            if image != nil {
//                let imageData = image!.jpegData(compressionQuality: 0.5)
//                multipartFormData.append(imageData!, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
//            }
//            for (key, value) in param {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//            }
//        }, to: "\(apiUrl)/\(image!)", method: .post, headers: multipartHeader)
//
//        .uploadProgress(queue: .main) { progress in
//            print("Upload progress: \(progress.fractionCompleted)")
//        }
//
//        .response { result in
//            switch result.result {
//            case .success( _):
//                let statusCode = result.response?.statusCode
//                if statusCode == 200 {
//                    let dic = ChatMessageImg2URLModel.init(dic: convertToDictionary(data: result.data!, apiURL: "post : \(apiUrl)/\(image!)"))
//                    success(dic)
//                } else {
//                    fail(result.error)
//                }
//            case .failure( _): break
//
//            }
//        }
//
//    }
}
