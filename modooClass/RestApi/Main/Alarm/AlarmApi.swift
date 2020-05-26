//
//  AlarmApi.swift
//  modooClass
//
//  Created by 조현민 on 18/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import Alamofire

class AlarmApi: NSObject {
    
    static let shared = AlarmApi()
    
//    MARK: - 알람 리스트
    func alarmList(page:Int,success: @escaping(_ data: AlarmModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/notify/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = AlarmModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/notify/\(page)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 알림 한개 읽음 처리
    func alarmRead(id:Int,success: @escaping(_ data: AlarmModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/notify/\(id)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = AlarmModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/notify/\(id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }

//    MARK: - 알림 전체 읽음 처리
    func alarmReadAll(success: @escaping(_ data: AlarmModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/notify/all", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = AlarmModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/notify/all"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
}
