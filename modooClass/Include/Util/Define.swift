//
//  Define.swift
//  modooClass
//
//  Created by 조현민 on 07/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

// 앱 최초 실행했는지
let bool_isFirstAppRun = "isFirstAppRunKey"

//session아이디
let sessionToken = "sessionToken"

//apns 토큰
let apnsToken = "apnsToken"

let userId = "userId"
let userPw = "userPw"
let userName = "userName"
let userProvider = "userProvider"
let loginGubun = "loginGubun"

let tempUserId = "tempUserId"
let tempUserName = "tempUserName"
let tempUserProvider = "tempUserProvider"
let tempUserPw = "tempUserPw"

let imgUrl = "https://app-cdn.enfit.net"

//let apiUrl = "https://api.enfit.co.kr/api/v3"
let apiUrl = "https://api2.enfit.net/api/v3"
//let apiUrl = "https://api-gw.cloud.toast.com/modooclass/api/v3"
//let mission_doneApi = "https://cms.enfit.net/api/v3/mission_done"
let mission_doneApi = "https://api2.enfit.net/api/v3/mission_done"
var deviceOrient = "Portrait" // Portrait , Landscape


//let snsProvider = "snsProvider"

let chattingBadgeValue = "chattingBadgeValue"
let alarmBadgeValue = "alarmBadgeValue"

let videoPlayTime = "videoPlayTime"
let videoPlayUrl = "videoPlayUrl"
let lodingViewCheck = "lodingViewCheck"
var launchViewHide = false

let APPDELEGATE = UIApplication.shared.delegate as? AppDelegate

let DEVICE_IPHONE5 = 5
let DEVICE_IPHONE6 = 6
let DEVICE_IPHONE6PLUS = 7
let DEVICE_IPHONEX = 10
let DEVICE_IPHONEXR = 11
let DEVICE_IPHONEXSMAX = 12
let DEVICE_ETC = 0
let DEVICE_IPAD = 50

var header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]//,"Authorization": "bearer \(UserDefaultSetting.getUserDefaultsString(forKey: sessionToken) as! String)"]
var multipartHeader : HTTPHeaders = [
    "Content-Type":"multipart/form-data",
    "Content-Disposition":"form-data"
]//,"Authorization": "bearer \(UserDefaultSetting.getUserDefaultsString(forKey: sessionToken) as! String)"]

// 스크린 크기
let DEF_SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
let DEF_SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height

// 스케일 기준 사이즈
let DEF_SCREEN_375_WIDTH: CGFloat = 375.0
let DEF_SCREEN_375_HEIGHT: CGFloat = 667.0

// 375화면 기준 스케일값
let DEF_WIDTH_375_SCALE: CGFloat = (DEF_SCREEN_WIDTH < DEF_SCREEN_HEIGHT) ? (DEF_SCREEN_WIDTH / DEF_SCREEN_375_WIDTH) : (DEF_SCREEN_HEIGHT / DEF_SCREEN_375_WIDTH)


