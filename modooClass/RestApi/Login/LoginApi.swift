//
//  LoginApi.swift
//  modooClass
//
//  Created by 조현민 on 17/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import Alamofire

class LoginApi: NSObject {
    
    static let shared = LoginApi()
    
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    let systemVersion = UIDevice.current.systemVersion
    let deviceModel = UIDevice.current.identifierForVendor?.uuidString
    let loginHeader = ["Content-Type": "application/x-www-form-urlencoded"]
    
//    MARK: - 일반 로그인
    func auth(id:String,password:String,success: @escaping(_ data: LoginModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        #if targetEnvironment(simulator)
        UserDefaultSetting.setUserDefaultsString("VirtualDevice Login", forKey: apnsToken)
        #else
        
        #endif
        let param = [
            "user_id":id,
            "passwd":password,
            "push_token":"\(UserDefaultSetting.getUserDefaultsString(forKey:apnsToken) ?? "")",
            "device_type":"I",
            "device_info":"\(systemVersion)",
            "device_model":"\(String(describing: deviceModel))",
            "app_info":"\(appVersion ?? "")"
        ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/login/Auth", method: .post, parameters: param, encoding: URLEncoding.default, headers: loginHeader)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = LoginModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/login/Auth")) 
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - 소셜로그인
    func socialAuth(provider:String,social_id:String,name:String,success: @escaping(_ data: LoginModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        #if targetEnvironment(simulator)
        UserDefaultSetting.setUserDefaultsString("VirtualDevice Login", forKey: apnsToken)
        #else
        
        #endif
        
        let parameter = [
            "provider":provider,
            "social_id":social_id,
            "name":name,
            "push_token":"\(UserDefaultSetting.getUserDefaultsString(forKey:apnsToken) ?? "")",
            "device_type":"I",
            "device_info":"\(systemVersion)",
            "device_model":"\(String(describing: deviceModel))",
            "app_info":"\(appVersion ?? "")"
        ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/login/socialAuth", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: loginHeader)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = LoginModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/login/socialAuth"))
                success(dic)
            }else {
                fail(response.error)
            }
            
        }
    }
    
//    MARK: - 핸드폰번호 가입 조회 auth = false / 인증요청 auth = true
    func phoneAuth(phone:String,auth:String,success: @escaping(_ data: JoinModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let parameter = [
            "phone":phone,
            "auth":auth
        ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/login/phoneAuth", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: loginHeader)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = JoinModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/login/phoneAuth"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - 핸드폰번호 인증 확인
    func phoneVerification(phone:String,code:String,success: @escaping(_ data: JoinModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let parameter = [
            "phone":phone,
            "code":code
        ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/login/phoneVerification", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: loginHeader)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = JoinModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/login/phoneVerification"))
                success(dic)
            }else {
                fail(response.error)
            }
            
        }
    }
    
//    MARK: - 비밀번호/이름 저장 - 회원가입처리 (인증과정 안걷칠 경우 에러)
    func memberJoin(phone:String,password:String,name:String,success: @escaping(_ data: JoinModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let parameter = [
            "phone":phone,
            "passwd":password,
            "name":name
        ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/login/profile", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: loginHeader)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = JoinModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/login/profile"))
                success(dic)
            }else {
                fail(response.error)
            }
            
        }
    }
    
//    MARK: - 비밀번호 리셋
    func passworReset(phone:String,password:String,auth:String,success: @escaping(_ data: LoginModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let parameter = [
            "phone":phone,
            "passwd":password,
            "auth":auth
            ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/login/passwd", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: loginHeader)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = LoginModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/login/passwd"))
                success(dic)
            }else {
                fail(response.error)
            }
            
        }
    }
    
//    MARK: - 프로필 추가정보 저장
    func profileAddSave(nickname:String,gender:String,birthday_year:String,mcInterest_id:Array<Int>,mcJob_id:Array<Int>,url_1:String,url_2:String,url_3:String,file_1:UIImage,file_2:UIImage,file_3:UIImage,profile_comment:String,success: @escaping(_ data: LoginModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let parameter:[String : Any] = [
            "nickname":nickname,
            "gender":gender,
            "birthday_year":birthday_year,
            "mcInterest_id":mcInterest_id,
            "mcJob_id":mcJob_id,
            "url_1":url_1,
            "url_2":url_2,
            "url_3":url_3,
            "profile_comment":profile_comment
        ]
        print("url_1 : \(url_1)")
        print("url_2 : \(url_2)")
        print("url_3 : \(url_3)")
        print("parameter : ",parameter)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if url_1 == ""{
                let imageData1 = file_1.jpegData(compressionQuality: 1)
                multipartFormData.append(imageData1!, withName: "file_1", fileName: "file_1.jpeg", mimeType: "image/jpeg")
            }
            if url_2 == ""{
                let imageData2 = file_2.jpegData(compressionQuality: 1)
                multipartFormData.append(imageData2!, withName: "file_2", fileName: "file_2.jpeg", mimeType: "image/jpeg")
            }
            if url_3 == ""{
                let imageData3 = file_3.jpegData(compressionQuality: 1)
                multipartFormData.append(imageData3!, withName: "file_3", fileName: "file_3.jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in parameter {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: "\(apiUrl)/user" , method: .post, headers: multipartHeader){ (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("uploading \(progress)")
                })
                upload.response { response in
                    let statusCode = response.response?.statusCode
                    if statusCode == 200 {
                        let dic = LoginModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/user"))
                        success(dic)
                    }else {
                        fail(response.error)
                    }
                }
            case .failure( _): break
                //print encodingError.description
            }
        }
    }
    
    
//    MARK: - 관심사 리스트
    
    func interestList(success: @escaping(_ data: InterestModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        print(header)
        let request = Alamofire.request("\(apiUrl)/interest", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = InterestModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/interest"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - 직업 리스트
    func jobList(success: @escaping(_ data: JobModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        print(header)
        let request = Alamofire.request("\(apiUrl)/job", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = JobModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/job"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
}
