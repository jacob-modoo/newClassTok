//
//  Naver.swift
//  modooClass
//
//  Created by 조현민 on 07/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
import NaverThirdPartyLogin
import Alamofire


class Naver{
    var thirdPartyLoginConn: NaverThirdPartyLoginConnection?
    
    func naverLogin(viewController:UIViewController){
        let tlogin = NaverThirdPartyLoginConnection.getSharedInstance()
        tlogin!.delegate = (viewController.self as! NaverThirdPartyLoginConnectionDelegate)
        tlogin!.serviceUrlScheme = kServiceAppUrlScheme
        tlogin!.requestThirdPartyLogin()
    }
    
    func naverLogout(){
        //resetToken
        let tlogin = NaverThirdPartyLoginConnection.getSharedInstance()
        tlogin?.resetToken() // 로그아웃
    }
    
    func requestAccessTokenWithRefreshToken() {
        let tlogin = NaverThirdPartyLoginConnection.getSharedInstance()
        tlogin?.requestAccessTokenWithRefreshToken()
    }
    
    func checkRequestNaver()-> Bool{
        return NaverThirdPartyLoginConnection.getSharedInstance().isValidAccessTokenExpireTimeNow()
    }
    
    func requestDeleteToken() {
        let tlogin = NaverThirdPartyLoginConnection.getSharedInstance()
        tlogin!.requestDeleteToken()
    }
    
    
}


extension LoginViewController: NaverThirdPartyLoginConnectionDelegate{
//    public func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
//        print("Success oauth20ConnectionDidOpenInAppBrowser")
//        let naverSignInViewController = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
//        present(naverSignInViewController, animated: true, completion: nil)
//    }
//    // ---- 4
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode(){
        print("Success oauth20ConnectionDidFinishRequestACTokenWithAuthCode")
        getNaverEmailFromURL()

    }
//    // ---- 5
    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
        getNaverEmailFromURL()
    }
//    // ---- 6
    public func oauth20ConnectionDidFinishDeleteToken() {
        print("Success oauth20ConnectionDidFinishDeleteToken")
    }
//    // ---- 7
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("Success oauth20Connection")
    }
//    // ---- 8
    public func getNaverEmailFromURL() {
        print("Success getNaverEmailFromURL")
        guard let loginConn = NaverThirdPartyLoginConnection.getSharedInstance() else {return}
        guard let tokenType = loginConn.tokenType else {return}
        guard let accessToken = loginConn.accessToken else {return}

        let authorization = "\(tokenType) \(accessToken)"
        var dataValue:Any?

        DispatchQueue.main.async {
            AF.request("https://openapi.naver.com/v1/nid/me", method: .get, parameters: nil ,headers: ["Authorization" : authorization]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("naver api request success")
                    dataValue = value
                case .failure(let error):
                    print("Error while fetching remote rooms: \(String(describing:error))")
                }
                
//                guard response.result.isSuccess else {
//                    print("Error while fetching remote rooms: \(String(describing:response.result.error))")
//                    return
//                }
                guard let result = dataValue as? [String: Any] else {return}
                guard let object = result["response"] as? [String: Any] else {return}
                //            guard let birthday = object["birthday"] as? String else {return}
                //            guard let name = object["name"] as? String else {return}
                //            guard let email = object["email"] as? String else {return}
                guard let naverId = object["id"] as? String else {return}
                guard let naverName = object["name"] as? String else {return}
                LoginApi.shared.socialAuth(provider: "naver", social_id: naverId, name: naverName, payload: result, success: { result in
                    if result.code! == "200"{
                        Indicator.hideActivityIndicator(uiView: self.view)
                        UserManager.shared.userInfo = result
                        self.loginMove(socialId: naverId, socialName: naverName, socialProvider: "naver", token: result.results!.token!)
                    }else{
                        Indicator.hideActivityIndicator(uiView: self.view)
                        Alert.With(self, title: isNoLoginString, btn1Title: "확인", btn1Handler: {})
                    }
                }) { error in
                    Indicator.hideActivityIndicator(uiView: self.view)
                    print("error : \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
}
