//
//  LaunchViewController.swift
//  modooClass
//
//  Created by 조현민 on 22/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import AuthenticationServices
import SDWebImage

/**
# LaunchViewController.swift 클래스 설명
 
## UIViewController 상속 받음
- 앱 처음 시작 했을시 타는 뷰컨트롤러
*/
class LaunchViewController: UIViewController {
    
    /** **첫시작 유무 */
    var isFisrtAppRun:Bool = false
    /** **아이디 체크  */
    var idCheck:String = ""
    /** **제공사 체크  */
    var providerCheck:String = ""
    /** **암호 체크  */
    var pwCheck:String = ""
    /** **이름 체크  */
    var nameCheck:String = ""
    
    let home2Storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
//    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        isFisrtAppRun = UserDefaultSetting.getUserDefaultsBool(forKey: bool_isFirstAppRun)
        idCheck = "\(UserDefaultSetting.getUserDefaultsString(forKey: userId) ?? "")"
        providerCheck = "\(UserDefaultSetting.getUserDefaultsString(forKey: userProvider) ?? "")"
        pwCheck = "\(UserDefaultSetting.getUserDefaultsString(forKey: userPw) ?? "")"
        nameCheck = "\(UserDefaultSetting.getUserDefaultsString(forKey: userName) ?? "")"
        loginCheck()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 로그인 체크를 하여 어느 뷰로 보낼지 분기처리
     
    1. 로그인뷰 ( LoginNavViewController )
    2. 로그인후 메인 뷰 ( MainNavController )
    3. 첫 시작 뷰 ( FirstStartViewController )
     
     - Throws: `Error` UserDefault에 값이 제대로 세팅되어 있지 않을때 `Error`
    */
    func loginCheck(){
        
        
        if isFisrtAppRun == false{
            UserDefaultSetting.setUserDefaultsBool(false, forKey: lodingViewCheck)
            self.viewMove(StoryBoard:"FirstStart",StoryBoardName:"FirstStartViewController")
        }else{
            if idCheck != ""{
                if providerCheck != ""{
                    print(providerCheck)
                    if providerCheck == "apple"{
                        appleAuthorization()
                    }else{
                        DispatchQueue.main.async {
                            LoginApi.shared.socialAuth(provider: self.providerCheck, social_id: self.idCheck, name: self.nameCheck, success: { result in
                                if result.code! == "200"{
                                    header = ["Content-Type":"application/x-www-form-urlencoded","Authorization": "bearer \((result.results?.token)!)"]
                                    multipartHeader = ["Content-Type":"multipart/form-data","Authorization": "bearer \((result.results?.token)!)"]
                                    UserDefaultSetting.setUserDefaultsString((result.results?.token)!, forKey: sessionToken)
                                    UserManager.shared.userInfo = result
                                    if UserManager.shared.userInfo.results?.user_info_yn == "N"{
                                        UserDefaultSetting.setUserDefaultsString(self.idCheck, forKey: tempUserId)
                                        UserDefaultSetting.setUserDefaultsString(self.pwCheck, forKey: tempUserPw)
                                        let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoNickViewController") as! AddInfoNickViewController
                                        UserDefaultSetting.setUserDefaultsString("P", forKey: loginGubun)
                                        self.navigationController?.pushViewController(newViewController, animated: false)
                                    }else{
                                        UserDefaultSetting.setUserDefaultsString(self.idCheck, forKey: userId)
                                        UserDefaultSetting.setUserDefaultsString(self.pwCheck, forKey: userPw)
        //                                let nextView = self.mainStoryboard.instantiateViewController(withIdentifier: "MainNavController")
                                        let nextView = self.home2Storyboard.instantiateViewController(withIdentifier: "HomeMainViewNavController")
                                        nextView.modalPresentationStyle = .fullScreen
                                        launchViewHide = true
                                        self.present(nextView, animated:false,completion: nil)
                                    }
                                }else{
                                    self.viewMove(StoryBoard:"Login",StoryBoardName:"LoginNavViewController")
                                }
                            }) { error in
                                self.viewMove(StoryBoard:"Login",StoryBoardName:"LoginNavViewController")
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        LoginApi.shared.auth(id: self.idCheck, password: self.pwCheck, success: { result in
                            if result.code! == "200"{
//                                UserManager.shared.userInfo = result
//                                UserDefaultSetting.setUserDefaultsString((result.results?.token)!, forKey: sessionToken)
//                                header = ["Content-Type":"application/x-www-form-urlencoded","Authorization": "bearer \((result.results?.token)!)"]
//                                multipartHeader = ["Content-Type":"multipart/form-data","Authorization": "bearer \((result.results?.token)!)"]
////                                self.viewMove(StoryBoard:"Main",StoryBoardName:"MainNavController")
//                                self.viewMove(StoryBoard:"Home2WebView",StoryBoardName:"Home2WebViewNavController")
                                header = ["Content-Type":"application/x-www-form-urlencoded","Authorization": "bearer \((result.results?.token)!)"]
                                multipartHeader = ["Content-Type":"multipart/form-data","Authorization": "bearer \((result.results?.token)!)"]
                                UserDefaultSetting.setUserDefaultsString((result.results?.token)!, forKey: sessionToken)
                                UserManager.shared.userInfo = result
                                if UserManager.shared.userInfo.results?.user_info_yn == "N"{
                                    UserDefaultSetting.setUserDefaultsString(self.idCheck, forKey: tempUserId)
                                    UserDefaultSetting.setUserDefaultsString(self.pwCheck, forKey: tempUserPw)
                                    let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoNickViewController") as! AddInfoNickViewController
                                    UserDefaultSetting.setUserDefaultsString("P", forKey: loginGubun)
                                    self.navigationController?.pushViewController(newViewController, animated: false)
                                }else{
                                    UserDefaultSetting.setUserDefaultsString(self.idCheck, forKey: userId)
                                    UserDefaultSetting.setUserDefaultsString(self.pwCheck, forKey: userPw)
    //                                let nextView = self.mainStoryboard.instantiateViewController(withIdentifier: "MainNavController")                 Home2MainViewController    PageNavViewcontroller  Home2MainViewNavController
                                    let nextView = self.home2Storyboard.instantiateViewController(withIdentifier: "HomeMainViewNavController")
                                    nextView.modalPresentationStyle = .fullScreen
                                    launchViewHide = true
                                    self.present(nextView, animated:false,completion: nil)
                                }
                            }else{
                                self.viewMove(StoryBoard:"Login",StoryBoardName:"LoginNavViewController")
                            }
                        }) { error in
                            self.viewMove(StoryBoard:"Login",StoryBoardName:"LoginNavViewController")
                        }
                    }
                }
            }else{
                viewMove(StoryBoard:"Login",StoryBoardName:"LoginNavViewController")
            }
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 뷰 애니메이션을 하기 위한 함수
     
    - Parameters:
        - storyBoard: 스토리보드
        - storyBoardName: 스토리보드 명
     
    - Throws: `Error` 잘못된 스토리보드 이거나 이름이 정확하지 않을시 `Error`
    */
    func viewMove(StoryBoard:String,StoryBoardName:String){
        let storyboard: UIStoryboard = UIStoryboard(name: StoryBoard, bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: StoryBoardName)
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView, animated:false,completion: nil)
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 애플 로그인 자격 증명
     
    - Throws: `Error` 애플 자격증명이 잘못되었거나 버츄얼 디바이스 인 경우 `Error`
    */
    func appleAuthorization(){
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
                        print("credentialState: ",credentialState)
                        switch credentialState {
                        case .authorized:
                            // Apple ID 자격 증명이 유효합니다.
                            DispatchQueue.main.async {
                                LoginApi.shared.socialAuth(provider: self.providerCheck, social_id: self.idCheck, name: self.nameCheck, success: { result in
                                    if result.code! == "200"{
                                        UserManager.shared.userInfo = result
                                        UserDefaultSetting.setUserDefaultsString((result.results?.token)!, forKey: sessionToken)
                                        header = ["Content-Type":"application/x-www-form-urlencoded","Authorization": "bearer \((result.results?.token)!)"]
                                        multipartHeader = ["Content-Type":"multipart/form-data","Authorization": "bearer \((result.results?.token)!)"]
//                                        self.viewMove(StoryBoard:"Main",StoryBoardName:"MainNavController")
                                        self.viewMove(StoryBoard:"Home2WebView",StoryBoardName:"HomeMainViewNavController")
                                    }else{
                                        self.viewMove(StoryBoard:"Login",StoryBoardName:"LoginNavViewController")
                                    }
                                }) { error in
                                    self.viewMove(StoryBoard:"Login",StoryBoardName:"LoginNavViewController")
                                }
                            }
                            break
                        case .revoked:
                            // Apple ID 자격 증명이 취소되었습니다.
                            DispatchQueue.main.async {
                                self.logout()
                                self.viewMove(StoryBoard:"Login",StoryBoardName:"LoginNavViewController")
                            }
                            break
                        case .notFound:
                            // 자격 증명이 없으므로 로그인 UI를 표시합니다.
                            DispatchQueue.main.async {
                                self.logout()
                                self.viewMove(StoryBoard:"Login",StoryBoardName:"LoginNavViewController")
                            }
                            break
                        default:
                            break
                        }
                    }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func logout(){
        UserDefaults.standard.set(nil, forKey: userProvider)
        UserDefaults.standard.set(nil, forKey: userId)
        UserDefaults.standard.set(nil, forKey: userPw)
        UserDefaults.standard.set(nil, forKey: userName)
        UserDefaults.standard.set(nil, forKey: sessionToken)
    }
}
