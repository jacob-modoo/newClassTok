
//
//  LoginViewController.swift
//  modooClass
//
//  Created by 조현민 on 08/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import NaverThirdPartyLogin
import SafariServices
import UserNotifications
import AuthenticationServices

/**
# LoginViewController.swift 클래스 설명
 
## BaseViewController , SFSafariViewControllerDelegate 상속 받음
- 로그인 화면 타는 뷰컨트롤러
*/
class LoginViewController: BaseViewController ,SFSafariViewControllerDelegate{
    
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let home2Storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    
    /** **카카오로그인 버튼 */
    @IBOutlet weak var kakaoLoginBtn: KOLoginButton!
    /** **페이스북로그인 버튼 */
    @IBOutlet weak var facebookLoginBtn: FBLoginButton!
    /** **네이버로그인 버튼 */
    @IBOutlet weak var naverLoginBtn: UIButton!
    /** **핸드폰로그인 버튼 */
    @IBOutlet weak var phoneLoginBtn: UIButton!
    /** **애플로그인 버튼 */
    @IBOutlet weak var appleLoginBtn: UIFixedButton!
//    @IBOutlet weak var loginProviderView: UIView!
    /** **제목 라벨 */
//    @IBOutlet var titleLbl: UIFixedLabel!
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isFisrtAppRun = UserDefaultSetting.getUserDefaultsBool(forKey: bool_isFirstAppRun)
        if isFisrtAppRun == false {
            UserDefaultSetting.setUserDefaultsBool(true, forKey: bool_isFirstAppRun)
        }
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        versionCheck()
//        setupProviderLoginView()
//        let text = titleLbl.text ?? ""
//        let attributedString = NSMutableAttributedString(string: text)
//        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "MainPoint_mainColor") ?? UIColor(hexString: "#FF5A5F"), range: (text as NSString).range(of:"."))
//        titleLbl.attributedText = attributedString
        
//        loginProviderView.layer.cornerRadius = 22
//        loginProviderView.layer.borderColor = UIColor(hexString: "#484848").cgColor
//        loginProviderView.layer.borderWidth = 1
//        loginProviderView.layer.masksToBounds = true
    }
    
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
//        setupProviderLoginView()
    }
    
    /** **뷰가 사라지기 시작 할 때 타는 메소드 */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        alamofireNetCheck()
//        performExistingAccountSetupFlows()
    }
    
    @IBAction func appleLoginBtnClicked(_ sender: UIButton) {
        handleAuthorizationAppleIDButtonPress()
    }
//    func setupProviderLoginView() {
//        if #available(iOS 13.0, *) {
//            let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: ASAuthorizationAppleIDButton.ButtonType.signIn, authorizationButtonStyle: ASAuthorizationAppleIDButton.Style.whiteOutline )
//            authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
//            self.loginProviderView.addSubview(authorizationButton)
//            authorizationButton.snp.makeConstraints{ (make) in
//                make.top.right.equalTo(self.loginProviderView).offset(-3)
//                make.bottom.left.equalTo(self.loginProviderView).offset(3)
//                make.top.equalTo(self.loginProviderView).offset(5)
//                make.bottom.equalTo(self.loginProviderView).offset(-5)
//                make.left.equalTo(self.loginProviderView).offset(5)
//                make.right.equalTo(self.loginProviderView).offset(-5)
//            }
//            authorizationButton.cornerRadius = 5
//        } else {
//            // Fallback on earlier versions
//        }
//    }
    
    /// 기존 iCloud Keychain 자격 증명 또는 Apple ID 자격 증명이 있는지 묻는 메시지를 표시합니다.
    func performExistingAccountSetupFlows() {
        // Apple ID 및 암호 공급자 모두에 대한 요청을 준비합니다.
        if #available(iOS 13.0, *) {
            let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                            ASAuthorizationPasswordProvider().createRequest()]
            // 주어진 요청으로 인증 컨트롤러를 만듭니다.
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
        
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            Alert.With(self, title: "Apple 로그인은 iOS 13.0 이상 버전에서만 사용할 수 있습니다.\n다른 옵션을 선택하십시오.", btn1Title: "확인", btn1Handler: {
            })
        }
    }
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // 시스템에서 계정을 만듭니다.
            //이 데모 앱을 위해 userIdentifier를 키 체인에 저장합니다.
            do {
                try KeychainItem(service: "kr.co.enfit.modooClass", account: "userIdentifier").saveItem(userIdentifier)
            } catch {
                print("Unable to save userIdentifier to keychain.")
            }
            
            print("userIdentifier : \(userIdentifier) , fullName?.givenName : \(fullName?.familyName ?? "") , fullName?.familyName : \(fullName?.givenName ?? "") , email : \(email ?? "")")
            
            LoginApi.shared.socialAuth(provider: "apple", social_id: userIdentifier, name: "\(fullName?.familyName ?? "")\(fullName?.givenName ?? "")", payload: appleIDCredential, success: { result in
                if result.code! == "200"{
                    UserManager.shared.userInfo = result
                    self.loginMove(socialId: userIdentifier, socialName: "\(fullName?.givenName ?? "")\(fullName?.familyName ?? "")", socialProvider: "apple", token: result.results!.token!)
                }else{
                    Indicator.hideActivityIndicator(uiView: self.view)
                    Alert.With(self, title: isNoLoginString, btn1Title: "확인", btn1Handler: {})
                }
            }) { error in
                Indicator.hideActivityIndicator(uiView: self.view)
                print("error : \(String(describing: error?.localizedDescription))")
            }
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // 기존 iCloud Keychain 자격 증명을 사용하여 로그인합니다.
            let username = passwordCredential.user
            let password = passwordCredential.password
            print("username : \(username) , password : \(password)")
            //이 데모 앱의 목적을 위해 비밀번호 자격 증명을 경고로 표시합니다.
//            DispatchQueue.main.async {
//                let message = "앱이 키 체인에서 선택한 자격 증명을 받았습니다. \n\n Username: \(username)\n Password: \(password)"
//                let alertController = UIAlertController(title: "받은 키 체인 자격 증명",
//                                                        message: message,
//                                                        preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "나가기", style: .cancel, handler: nil))
//                self.present(alertController, animated: true, completion: nil)
//            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


extension LoginViewController{
    
    /** **카카오로그인 버튼 클릭 > 카카오연동 시작 */
    @IBAction func kakaoLoginBtnClicked(_ sender: UIButton) {
        if Kakao().checkRequestKakao(){
            //접속 상태
            Kakao().kakaoLogout()
        }else{
            //미접속 상태
            KOSession.shared()?.close()
            
            //카카오 로그인
            KOSession.shared()?.open(completionHandler: { error in
                if error != nil{
                }else{
                    if (KOSession.shared()?.isOpen())! {
                        print("login succeeded.")
                        KOSessionTask.userMeTask(completion: { error, me in
                            if error != nil {
                                // fail
                            } else {
                                // success
                                Indicator.showActivityIndicator(uiView: self.view)
                                LoginApi.shared.socialAuth(provider: "kakao", social_id: (me?.id)!, name: (me?.nickname)!, payload: me!, success: { result in
                                    if result.code! == "200"{
                                        UserManager.shared.userInfo = result
                                        self.loginMove(socialId: (me?.id)!, socialName: (me?.nickname)!, socialProvider: "kakao", token: result.results!.token!)
                                    }else{
                                        Alert.With(self, title: isNoLoginString, btn1Title: "확인", btn1Handler: {})
                                    }
                                    Indicator.hideActivityIndicator(uiView: self.view)
                                }) { error in
                                    Indicator.hideActivityIndicator(uiView: self.view)
                                    print("error : \(String(describing: error?.localizedDescription))")
                                }
                            }
                        })
                    }else{
                        print("login failed.")
                    }
                }
                
            })
        }
    }
    
    /** **페이스북로그인 버튼 클릭 > 페이스북연동 시작 */
    @IBAction func facebookLoginBtnClicked(_ sender: UIButton) {
        if FaceBook().checkRequestFacebook(){
            //접속 상태
            FaceBook().facebookLogout()
        }else{
            //미접속 상태
            let login = LoginManager()
            Indicator.showActivityIndicator(uiView: self.view)
            login.logIn(permissions: [.publicProfile], viewController: self) { result in
                switch result {
                case .cancelled:
                    Indicator.hideActivityIndicator(uiView: self.view)
                    print("로그인이 취소되었습니다.")
                case .failed(let error):
                    Indicator.hideActivityIndicator(uiView: self.view)
                    print("로그인 실패 \(error)")
                case .success(let grantedPermissions, _, _):
                    print("로그인 성공 \(grantedPermissions)")
                    GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                        if (error == nil){
                            let dict = result as! [String : AnyObject]
                            let facebookId = dict["id"] as! String
                            let facebookName = dict["name"] as! String
                            
                            LoginApi.shared.socialAuth(provider: "facebook", social_id: facebookId, name: facebookName, payload: dict, success: { result in
                                if result.code! == "200"{
                                    UserManager.shared.userInfo = result
                                    self.loginMove(socialId: facebookId, socialName: facebookName, socialProvider: "facebook", token: result.results!.token!)
                                }else{
                                    Indicator.hideActivityIndicator(uiView: self.view)
                                    Alert.With(self, title: isNoLoginString, btn1Title: "확인", btn1Handler: {})
                                }
                            }) { error in
                                Indicator.hideActivityIndicator(uiView: self.view)
                                print("error : \(String(describing: error?.localizedDescription))")
                            }
                        }else{
                            Indicator.hideActivityIndicator(uiView: self.view)
                        }
                    })
                }
            }
        }
    }
    
    /** **네이버로그인 버튼 클릭 > 네이버연동 시작 */
    @IBAction func naverLoginBtnClicked(_ sender: UIButton) {
        Indicator.showActivityIndicator(uiView: self.view)
        let tlogin = NaverThirdPartyLoginConnection.getSharedInstance()
        tlogin!.delegate = self as NaverThirdPartyLoginConnectionDelegate
        tlogin!.serviceUrlScheme = kServiceAppUrlScheme
        tlogin!.requestThirdPartyLogin()
        Indicator.hideActivityIndicator(uiView: self.view)
    }
    
    /** **핸드폰로그인 버튼 클릭 > 뷰 이동 ( PhoneLoginViewController ) */
    @IBAction func phoneLoginBtnClicked(_ sender: UIButton) {
        let newViewController = loginStoryboard.instantiateViewController(withIdentifier: "PhoneLoginViewController") as! PhoneLoginViewController
        self.navigationController?.pushViewController(newViewController, animated: false)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 소셜로그인 처리 함수
     
    - Parameters:
        - socialId: 소셜 아이디
        - socialName: 소셜 이름
        - socialProvider: 소셜 제공사
        - token: 세션토큰
     
    - Throws: `Error` UserDefault 세팅이 제대로 되어있지 않을 경우 `Error`
    */
    func loginMove(socialId:String,socialName:String,socialProvider:String,token:String){
        UserDefaultSetting.setUserDefaultsString(token, forKey: sessionToken)
        header = ["Content-Type":"application/x-www-form-urlencoded","Authorization": "bearer \(token)"]
        multipartHeader = ["Content-Type":"multipart/form-data","Authorization": "bearer \(token)"]
        Indicator.hideActivityIndicator(uiView: self.view)
        if UserManager.shared.userInfo.results?.user_info_yn == "N"{
            UserDefaultSetting.setUserDefaultsString(socialId, forKey: tempUserId)
            UserDefaultSetting.setUserDefaultsString(socialName, forKey: tempUserName)
            UserDefaultSetting.setUserDefaultsString(socialProvider, forKey: tempUserProvider)
            let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoNickViewController") as! AddInfoNickViewController
            newViewController.nickname = UserManager.shared.userInfo.results?.user?.nickname ?? ""
            if UserManager.shared.userInfo.results?.user?.photo ?? "" != "" {
                newViewController.profile_photo = UserManager.shared.userInfo.results?.user?.photo ?? ""
            }
            UserDefaultSetting.setUserDefaultsString("S", forKey: loginGubun)
            self.navigationController?.pushViewController(newViewController, animated: false)
        }else{
            UserDefaultSetting.setUserDefaultsString(socialId, forKey: userId)
            UserDefaultSetting.setUserDefaultsString(socialName, forKey: userName)
            UserDefaultSetting.setUserDefaultsString(socialProvider, forKey: userProvider)
//            let nextView = self.mainStoryboard.instantiateViewController(withIdentifier: "MainNavController")
             UserDefaultSetting.setUserDefaultsString(socialId, forKey: userId)
            let nextView = self.home2Storyboard.instantiateViewController(withIdentifier: "HomeMainViewNavController")
            nextView.modalPresentationStyle = .fullScreen
            launchViewHide = true
            self.present(nextView, animated:false,completion: nil)
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > firebase remote config 에서 받아온 값으로 버전 체크 메소드 분기처리
     
    1. 강제 업데이트
    2. 권유 업데이트
     
    - Throws: `Error` 파이어베이스에서 버전정보가 제대로 넘어오지 않을 경우 `Error`
    */
    func versionCheck(){
        let overIdx = UserDefaultSetting.getUserDefaultsInteger(forKey: "updateGubun")
        let date = Int(Date().cmpString())
        if overIdx != 0{
            if overIdx == 1{
                print("Must Update")
                DispatchQueue.main.async {
                    Alert.UpdateMustAlert(self, updateBtnTitle: "업그레이드", btn1Handler: {
                        if let url = URL(string: "https://itunes.apple.com/app/id1464482964") {
                            UIApplication.shared.open(url, options: [:], completionHandler: { success in
                                
                            })
                        }
                    }, updateBtnCancleTitle: "어플종료", btn2Handler: {
                        exit(0)
                    })
                }
            }else if overIdx == 2{
                print("Update")
                let compareDate = UserDefaultSetting.getUserDefaultsInteger(forKey: "updateDate")
                if compareDate < date! {
                    DispatchQueue.main.async {
                        Alert.UpdateAlert(self, updateBtnTitle: "업그레이드", btn1Handler: {
                            if let url = URL(string: "https://itunes.apple.com/app/id1464482964") {
                                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                                    
                                })  // https://itunes.apple.com/app/id1464482964
                            }
                        }, updateBtnCancleTitle: "나중에 하기", btn2Handler: {
                            UserDefaultSetting.setUserDefaultsInteger(date!, forKey: "updateDate")
                        })
                    }
                }
            }else{
                print("parameterError")
            }
        }
    }
}
