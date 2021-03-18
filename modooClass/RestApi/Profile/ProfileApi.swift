//
//  ProfileApi.swift
//  modooClass
//
//  Created by 조현민 on 19/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import Alamofire

class ProfileApi: NSObject {
    
    static let shared = ProfileApi()
    
//    MARK: - 프로필 리스트
    func profileList(success: @escaping(_ data: ProfileModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = AF.request("\(apiUrl)/profile_app", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ProfileModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/profile_app"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - 친구프로필 리스트
    func profileFriendList(user_id:Int,success: @escaping(_ data: ProfileFriendModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = AF.request("\(apiUrl)/profile_app/\(user_id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ProfileFriendModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/profile_app/\(user_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 세팅 리스트
    func settingList(success: @escaping(_ data: ProfileSettingModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = AF.request("\(apiUrl)/config", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ProfileSettingModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/config"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 클래스 혹은 알림 메세지 받을지 유무 체크
    func alarmChange(type:String,id:Int,flag:String,success: @escaping(_ data: ProfileSettingModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let param1 = [
            "flag":flag
            ] as [String : Any]
        let param2 = [
            "id":id,
            "flag":flag
            ] as [String : Any]
        
        if type == "class"{
            let request = AF.request("\(apiUrl)/config/\(type)", method: .post, parameters: param2, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = ProfileSettingModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/config/\(type)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }else{
            let request = AF.request("\(apiUrl)/config/\(type)", method: .post, parameters: param1, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = ProfileSettingModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/config/\(type)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }
        
    }
    
//    MARK: - 알림 취소하기
    func opencallDelete(class_id:Int,success: @escaping(_ data: ProfileSettingModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = AF.request("\(apiUrl)/opencall/\(class_id)", method: .delete, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ProfileSettingModel.init(dic: convertToDictionary(data: response.data!,apiURL: "delete : \(apiUrl)/opencall/\(class_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
    //    MARK: - 프로필 리스트
    func profileFriendInfo(user_id:Int,success: @escaping(_ data: ProfileFriendInfoModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = AF.request("\(apiUrl)/friendInfo/\(user_id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ProfileFriendInfoModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/friendInfo/\(user_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
    //    MARK: - 프로필 리스트
       func profileV2AllList(success: @escaping(_ data: ProfileV2Model)-> Void, fail: @escaping (_ error: Error?)-> Void){
           
           let request = AF.request("\(apiUrl)/profileInfo", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
           
           request.response { response in
               let statusCode = response.response?.statusCode
               if statusCode == 200 {
                   let dic = ProfileV2Model.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/profileInfo"))
                   success(dic)
               }else {
                   fail(response.error)
               }
           }
       }
    
    //    MARK: - 프로필 리스트 V2
    func profileV2List(user_id:Int,success: @escaping(_ data: ProfileV2Model)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = AF.request("\(apiUrl)/profileInfo/\(user_id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ProfileV2Model.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/profileInfo/\(user_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
    //    MARK: - ProfileNewModel
    func profileV3List(user_id:Int, page:Int, success: @escaping(_ data: ProfileNewModel)-> Void, fail: @escaping(_ error: Error?)->Void) {
        
        let request = AF.request("\(apiUrl)/interested/profile/\(user_id)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode  == 200 {
                let dic = ProfileNewModel.init(dic: convertToDictionary(data: response.data!, apiURL: "get : \(apiUrl)/interested/profile/\(user_id)/\(page)"))
                success(dic)
            } else {
                fail(response.error)
            }
        }
    }
    
    //    MARK: - 프로필 클래스 리스트
    func profileV2ActiveList(user_id:Int,page:Int,success: @escaping(_ data: ProfileV2Model)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = AF.request("\(apiUrl)/profileInfo_active/\(user_id)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ProfileV2Model.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/profileInfo_active/\(user_id)/\(page)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
    //    MARK: - 프로필 운영클래스 리스트
    func profileV2ClassList(user_id:Int,page:Int,success: @escaping(_ data: ProfileV2Model)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = AF.request("\(apiUrl)/profileInfo_class/\(user_id)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ProfileV2Model.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/profileInfo_class/\(user_id)/\(page)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
    //    MARK: - 프로필 리뷰 리스트
    func profileV2ReviewList(user_id:Int,page:Int,success: @escaping(_ data: ProfileV2Model)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = AF.request("\(apiUrl)/profileInfo_review/\(user_id)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ProfileV2Model.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/profileInfo_review/\(user_id)/\(page)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
    //    MARK: - 프로필 스크랩 리스트
    func profileV2ScrapList(user_id:Int,page:Int,success: @escaping(_ data: ProfileV2Model)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = AF.request("\(apiUrl)/profileInfo_scrap/\(user_id)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ProfileV2Model.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/profileInfo_scrap/\(user_id)/\(page)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
    //    MARK: - 프로필 코멘트 좋아요
    func profileV2CommentLike(comment_id:String,type:String,success: @escaping(_ data: ProfileV2Model)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let param1 = [
            "comment_id":comment_id
            ] as [String : Any]
        let param2 = [
            "comment_id":comment_id,
            "type":type
            ] as [String : Any]
        if type == "delete"{
            let request = AF.request("\(apiUrl)/squareLike", method: .post, parameters: param2, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = ProfileV2Model.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/squareLike"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }else{
            let request = AF.request("\(apiUrl)/squareLike", method: .post, parameters: param1, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = ProfileV2Model.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/squareLike"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }
        
    }
}
