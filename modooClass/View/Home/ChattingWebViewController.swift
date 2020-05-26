//
//  ChattingWebViewController.swift
//  modooClass
//
//  Created by 조현민 on 23/07/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import WebKit
import Lottie
import SafariServices
import AppsFlyerLib
import Firebase

/**
# ChattingWebViewController.swift 클래스 설명
 
 ## UIViewController ,WKNavigationDelegate ,WKUIDelegate ,SFSafariViewControllerDelegate 상속 받음
 - 그룹채팅 웹뷰
 */
class ChattingWebViewController: UIViewController ,WKNavigationDelegate,WKUIDelegate , SFSafariViewControllerDelegate{
    
    /** **뒤로가기 버튼*/
    @IBOutlet var backBtn: UIButton!
    /** **로티 서브뷰*/
    @IBOutlet var lottiSubView: UIView!
    /** **로티 뷰*/
    @IBOutlet var lottiView: UIView!
    /** **로티를 감싸는 뷰*/
    @IBOutlet var containerView: UIView!
    /** **키보드 숨김 유무 */
    var keyboardShow = false
    /** **웹뷰 주소 */
    var url = ""
    /** **웹킷웹뷰 */
    var webView: WKWebView!
    /** **네트워크 오류 뷰 */
    var networkView:NetworkOutView!
    /** **토큰 포함 유무 */
    var tokenCheck = true
    /** **첫번째로 탭을 선택했는지 유무 */
    var firstTabCheck = true
    /** **로티 애니메이션 뷰 */
    let animationView = AnimationView(name: "webViewLodingLottie3")
    
    let feedStoryboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    let chattingStoryboard: UIStoryboard = UIStoryboard(name: "ChattingWebView", bundle: nil)
    
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstTabCheck == true{
           firstTabCheck = false
        }else{
            self.webView.evaluateJavaScript("checkActive()", completionHandler: { (result,error) in
                if let result = result{
                    print (result)
                }
            })
        }
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#ffffff")
    }
    
    /** **뷰가 사라지기 시작 할 때 타는 메소드 */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /** **뷰가 나타나고 타는 메소드 */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.setScreenName("채팅", screenClass: "ChattingWebViewController")
//        navigationController?.interactivePopGestureRecognizer?.delegate = nil
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    /** **뷰가 사라지고 타는 메소드 */
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    /** **뷰를 로드 할 때 타는 메소드 */
    override func loadView() {
        super.loadView()
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        
        //native -> js call (문서 시작시에만 가능한, 환경설정으로 사용)
        //        let userScript = WKUserScript(source: "iframId(302207632)", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        //        contentController.removeAllUserScripts()
        //        contentController.addUserScript(userScript)
        
        // js -> native call : name 값을 지정하여 js 에서 webkit.messageHandlers.NAME.postMessage(""); 와 연동되는것 userContenteController함수에서 처리한다.
        contentController.add(LeakAvoider(delegate: self),name: "changeGroupHandler")
        contentController.add(LeakAvoider(delegate: self),name: "groupBackHandler")
        contentController.add(LeakAvoider(delegate: self),name: "profileHandler")
        contentController.add(LeakAvoider(delegate: self),name: "shareHandler")
        contentController.add(LeakAvoider(delegate: self),name: "classJoinHandler")
        contentController.add(LeakAvoider(delegate: self),name: "kakaoFriendHandler")
        contentController.add(LeakAvoider(delegate: self),name: "homeHandler")
        contentController.add(LeakAvoider(delegate: self),name: "clipBoardHandler")
        contentController.add(LeakAvoider(delegate: self),name: "externalSaFariHandler")
        contentController.add(LeakAvoider(delegate: self),name: "inAppPurchaseHandler")
        contentController.add(LeakAvoider(delegate: self),name: "goToChatDetail")
        contentController.add(LeakAvoider(delegate: self),name: "outLinkForBrowser")
        contentController.add(LeakAvoider(delegate: self),name: "gotofriendprofile")
        contentController.add(LeakAvoider(delegate: self),name: "hideLoading")
        contentController.add(LeakAvoider(delegate: self),name: "clearCache")
        contentController.add(LeakAvoider(delegate: self),name: "goToReplyDetail")
        contentController.add(LeakAvoider(delegate: self),name: "goToFeedDetail")
        contentController.add(LeakAvoider(delegate: self),name: "goToFeedReply")
        
        config.userContentController = contentController
        config.allowsInlineMediaPlayback = true
        //        config.applicationNameForUserAgent = "Modooclass"
        config.applicationNameForUserAgent = "Modoo_ios"
        
        print("self.containerView.frame.height : ",self.containerView.frame.height)
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height) , configuration: config)
        self.containerView.addSubview(webView)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    deinit {
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
        webView.scrollView.delegate = nil
        NotificationCenter.default.removeObserver(self)
        print("deinit")
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 키보드가 보이는 경우
     
     - Parameters:
        - notification: 키보드 값이 유저인포에 담겨져서 넘어옴
     
     - Throws: `Error` 키보드가 구동이 안되는 경우 `Error`
     */
    @objc func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            print("keyboard will show!")
            self.view.layoutIfNeeded()
            self.webView.evaluateJavaScript("onResize()", completionHandler: { (result,error) in
                if let result = result{
                    print (result)
                }
            })
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 키보드가 사라지는 경우
     
     - Parameters:
        - notification: 키보드 값이 유저인포에 담겨져서 넘어옴
     
     - Throws: `Error` 키보드가 구동이 안되는 경우 `Error`
     */
    @objc func keyboardWillHide(notification: NSNotification) {
        if #available(iOS 12.0, *) {
            for v in webView.subviews {
                if v is UIScrollView {
                    let scrollView = v as! UIScrollView
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                }
            }
        }
        UIView.animate(withDuration: 0.5) {
            self.webView.evaluateJavaScript("onResize()", completionHandler: { (result,error) in
                if let result = result{
                    print (result)
                }
            })
        }
    }
    
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        DispatchQueue.main.async {
            self.animationView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
            self.animationView.center = self.lottiSubView.center
            
            self.animationView.loopMode = .loop
            self.animationView.contentMode = .scaleAspectFill
            self.animationView.animationSpeed = 0.5
            
            // Applying UIView animation
            let minimizeTransform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.animationView.transform = minimizeTransform
            UIView.animate(withDuration: 0.8, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                self.animationView.transform = CGAffineTransform.identity
            }, completion: nil)
            self.lottiSubView.addSubview(self.animationView)
            self.animationView.snp.makeConstraints{ (make) in
                make.centerX.centerY.equalToSuperview()
            }
            self.animationView.play()
        }
        
        let session:String = UserDefaultSetting.getUserDefaultsString(forKey: sessionToken) as! String
        
        self.webView.snp.makeConstraints { (make) in
            make.top.equalTo(self.containerView).offset(0)
            make.bottom.equalTo(self.containerView).offset(0)
            make.left.right.equalTo(self.containerView)
            make.height.equalTo(webView.snp.height).multipliedBy(1.0).priority(1000)
            make.width.equalTo(webView.snp.width).multipliedBy(1.0).priority(1000)
            make.top.equalTo(webView.snp.top).multipliedBy(1.0).priority(1000)
            make.bottom.equalTo(webView.snp.bottom).multipliedBy(1.0).priority(1000)
            make.leading.equalTo(webView.snp.leading).multipliedBy(1.0).priority(1000)
            make.trailing.equalTo(webView.snp.trailing).multipliedBy(1.0).priority(1000)
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadWebView(_:)), for: .valueChanged)
        webView.scrollView.addSubview(refreshControl)
        
        var myURL:URL?
        
        //        url = url.replace(target: "https://www.modooclass.net", withString: "http://drugsism.modooclass.net")
//                url = url.replace(target: "https://www.modooclass.net", withString: "https://hyejin.modooclass.net")
        //        url = url.replace(target: "https://www.modooclass.net", withString: "https://junghee.modooclass.net")
        myURL = URL(string:"https://www.modooclass.net/class/chat?token=\(session)")
//        myURL = URL(string:"https://hyejin.modooclass.net/class/chat?token=\(session)")
//        myURL = URL(string:"https://chat.modooclass.net/class/chat?token=\(session)")
        
        
        var request = URLRequest(url: myURL! , cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy)
        
        let cookies = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies(for: request.url!)!)
        if let value = cookies["Cookie"] {
            request.addValue(value, forHTTPHeaderField: "Cookie") 
        }
        
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.allowsLinkPreview = false
        webView.load(request)
        
        self.networkView = NetworkOutView.initWithNib(frame: self.view.frame)
        self.networkView?.submitBtnClicked{ [unowned self] eNumber in
            self.webView.load(request)
        }

        self.networkView?.backBtnClicked{ [unowned self] eNumber in
            self.navigationController?.popViewController(animated: true)
        }
        self.view.addSubview(self.networkView)
        self.networkView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.view)
        }
    }
    
    @objc func reloadWebView(_ sender: UIRefreshControl) {
        webView.reload()
        sender.endRefreshing()
    }
    
    /** **뒤로가기 버튼 클릭 > 전 화면으로 이동 */
    @IBAction func backBtnClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 웹뷰 호출 시작할때
     
     - Parameters:
        - webView: 웹킷웹뷰
        - navigation: 웹뷰 네비게이션
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 웹뷰 호출 끝났을때
     
     - Parameters:
        - webView: 웹킷웹뷰
        - navigation: 웹뷰 네비게이션
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation!) {
        //        self.webView.evaluateJavaScript("loadVideo(302207632)", completionHandler: { (result,error) in
        //            if let result = result{
        //                print (result)
        //            }
        //        })
        self.animationView.stop()
        self.lottiView.removeFromSuperview()
        self.backBtn.isHidden = true
        
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 웹뷰 에러 발생시
     
     - Parameters:
        - webView: 웹킷웹뷰
        - navigation: 웹뷰 네비게이션
        - error: 웹뷰 에러
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        //        Alert.With(self, title: "알림", content: "로딩에 문제가 생겼습니다\n네트워크를 확인해주세요", btn1Title: "확인", btn1Handler: {
        //            self.navigationController?.popViewController(animated: false)
        //        })
        //        self.networkView.showNetworkView()
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 웹뷰 보안 에러 발생시
     
     - Parameters:
        - webView: 웹킷웹뷰
        - navigation: 웹뷰 네비게이션
        - error: 웹뷰 에러
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        //        Alert.With(self, title: "알림", content: "로딩에 문제가 생겼습니다\n네트워크를 확인해주세요", btn1Title: "확인", btn1Handler: {
        //            self.navigationController?.popViewController(animated: false)
        //        })
        //        self.networkView.showNetworkView()
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 웹뷰 정책 발생시
     
     - Parameters:
        - webView: 웹킷웹뷰
        - navigationResponse: 네비게이션 받는 내용
        - decisionHandler: 결정 핸들러
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            print(response.statusCode)
            if response.statusCode >= 400 && response.statusCode != 404{
                self.networkView.showNetworkView()
            }
        }
        decisionHandler(.allow)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 웹뷰 윈도우 오픈 액션 발생시
     
     - Parameters:
        - webView: 웹킷웹뷰
        - configuration: 웹뷰 설정
        - navigationAction: 네비게이션 액션
        - windowFeatures: 윈도우에 보일때
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            //webView.load(navigationAction.request)
            
            //            UIApplication.shared.canOpenURL(navigationAction.request.url!)
            
            //            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            
            
            var vc: SFSafariViewController? = nil
            vc = SFSafariViewController(url: navigationAction.request.url!)
            
            vc?.modalPresentationStyle = .fullScreen
            vc?.delegate = (self as SFSafariViewControllerDelegate)
            
            vc?.modalPresentationStyle = .popover
            
            if let vc = vc {
                present(vc, animated: true) {
                    
                }
            }
            
        }
        return nil
    }
}

extension ChattingWebViewController:WKScriptMessageHandler {
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > JS에서 iOS 호출시
     
     - Parameters:
        - userContentController: JS 에서 함수 호출
        - message: 메세지 내용
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name , " : message.name")
        if message.name == "changeGroupHandler" {
            if message.body as! String == "close"{
                self.webView.evaluateJavaScript("loggingToApp('changeGroupHandler','\((message.body as? String)!)','success')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
                self.navigationController?.popViewControllers(viewsToPop: 1)
            }else{
                self.webView.evaluateJavaScript("loggingToApp('changeGroupHandler','\((message.body as? String)!)','fail')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }
        }else if message.name == "groupBackHandler" {
            if message.body as! String == "close"{
                //                webkit.messageHandlers.groupBackHandler.postMessage('close');
                self.navigationController?.popViewControllers(viewsToPop: 2)
            }
        }else if message.name == "profileHandler"{
            //            webkit.messageHandlers.profileHandler.postMessage("profile")
            if message.body as! String == "profile"{
                self.webView.evaluateJavaScript("loggingToApp('profile','\((message.body as? String)!)','success')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
                Alert.With(self, title: "알림", content: "나의 프로필로 이동하시겠습니까?", btn1Title: "취소", btn1Handler: {}, btn2Title: "확인", btn2Handler: {
                    self.navigationController?.popToRootViewController(animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabbarIndexChange"), object: 3)
                })
            }else{
                self.webView.evaluateJavaScript("loggingToApp('profile','\((message.body as? String)!)','fail')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }
        }else if message.name == "shareHandler" {
            //            let messageDic = message.body as! Dictionary<String,Any>
            var url:String?
            var photoUrl:String?
            var title:String?
            
            //var param = {"url":"https://www.modooclass.net/class/classDetail/2323","photoUrl":"https://www.modooclass.net/class/classDetail/qweqwe.png","title":"조싀앤바믜의 5000kcal 추천 나도 할수있다!!"}
            //webkit.messageHandlers.shareHandler.postMessage(param);
            
            if let dictionary: [String: String] = message.body as? Dictionary {
                if let urlCheck = dictionary["url"] {
                    url = urlCheck
                }else{
                    url = "https://www.modooclass.net/"
                }
                
                if let photoUrlCheck = dictionary["photoUrl"] {
                    photoUrl = photoUrlCheck
                }else{
                    photoUrl = "https://rlp7v3kse.cdn.toastcloud.com/img/class/icon_user_profile.png"
                }
                
                if let titleCheck = dictionary["title"] {
                    title = titleCheck
                }else{
                    title = "클래스톡 입니다."
                }
            }
            
            let template = KMTFeedTemplate { (feedTemplateBuilder) in
                feedTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                    contentBuilder.title = title ?? ""
                    contentBuilder.imageURL = URL(string: "\(photoUrl ?? "")")!
                    contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                        linkBuilder.webURL = URL(string: "\(url ?? "")")!
                        linkBuilder.mobileWebURL = URL(string: "\(url ?? "")")!
                    })
                })
                feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                    buttonBuilder.title = "클래스 보기"
                    buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                        linkBuilder.webURL = URL(string: "\(url ?? "")")!
                        linkBuilder.mobileWebURL = URL(string: "\(url ?? "")")!
                    })
                }))
                //                feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                //                    buttonBuilder.title = "앱 실행하기"
                //                    buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                //                        linkBuilder.iosExecutionParams = url
                //                    })
                //                }))
            }
            // 카카오링크 실행
            KLKTalkLinkCenter.shared().sendDefault(with: template, success: { (warningMsg, argumentMsg) in
                // 성공
                
                print("warning message: \(String(describing: warningMsg))")
                print("argument message: \(String(describing: argumentMsg))")
                
                self.webView.evaluateJavaScript("loggingToApp('shareHandler','\((message.body as? Dictionary<String, String>)!)','success')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
                
            }, failure: { (error) in
                // 실패
                //            self.alert(error.localizedDescription)
                self.webView.evaluateJavaScript("loggingToApp('shareHandler','\((message.body as? Dictionary<String, String>)!)','fail')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
                print("error \(error)")
            })
        }else if message.name == "classJoinHandler" {
            if message.body as! Int != 0{
                self.webView.evaluateJavaScript("loggingToApp('classJoinHandler','\((message.body as? Int)!)','success')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }else{
                self.webView.evaluateJavaScript("loggingToApp('classJoinHandler','\((message.body as? Int)!)','fail')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabbarIndexChange"), object: 0)
            //            webkit.messageHandlers.classJoinHandler.postMessage(class_id)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classDetailMoveWebView"), object: message.body)
        }else if message.name == "kakaoFriendHandler"{
            if message.body as! String == "kakao"{
                self.webView.evaluateJavaScript("loggingToApp('kakaoFriendHandler','\((message.body as? String)!)','success')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
                if UIApplication.shared.canOpenURL(URL( string: "kakaoplus://" )!) {
                    //                webkit.messageHandlers.kakaoFriendHandler.postMessage()
                    if #available(iOS 10.0, *) {
                        //  Converted to Swift 4 by Swiftify v4.2.30733 - https://objectivec2swift.com/
                        let param = "plusfriend/friend/@모두의트레이닝".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
                        
                        if let url = URL(string: "kakaoplus://\(param ?? "")") {
                            UIApplication.shared.open(url, options: [:])
                        }
                    } else {
                        UIApplication.shared.openURL(URL(string:"kakaoplus://")!)
                    }
                    
                }else {
                    DispatchQueue.main.async {
                        Alert.With(self, title: "카카오톡 설치 후,\n 이용해 주시기 바랍니다.", btn1Title: "확인") {}
                    }
                }
            }else{
                self.webView.evaluateJavaScript("loggingToApp('kakaoFriendHandler','\((message.body as? String)!)','fail')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }
        }else if message.name == "homeHandler"{
            if message.body as! String == "home"{
                //                webkit.messageHandlers.homeHandler.postMessage('home')
                self.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabbarIndexChange"), object: 0)
                self.webView.evaluateJavaScript("loggingToApp('homeHandler','\((message.body as? String)!)','success')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }else{
                self.webView.evaluateJavaScript("loggingToApp('homeHandler','\((message.body as? String)!)','fail')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }
        }else if message.name == "clipBoardHandler"{
            print("clipBoardHandler: alert \(message.body)")
            if message.body as! String != ""{
                UIPasteboard.general.string = (message.body as! String)
                Toast.showNotification(message: "클립보드에 복사했습니다.", controller: self)
                self.webView.evaluateJavaScript("loggingToApp('clipBoardHandler','\((message.body as? String)!)','success')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }else{
                self.webView.evaluateJavaScript("loggingToApp('clipBoardHandler','\((message.body as? String)!)','fail')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }
        }else if message.name == "externalSaFariHandler"{
            print("externalSaFariHandler: alert \(message.body)")
            if message.body as! String == "safafi"{
                //                webkit.messageHandlers.externalSaFariHandler.postMessage('safafi')
                let session:String = UserDefaultSetting.getUserDefaultsString(forKey: sessionToken) as! String
                UIPasteboard.general.string = (message.body as! String)
                var vc: SFSafariViewController? = nil
                
                if let url = URL(string: "\(url)?token=\(session)") {
                    vc = SFSafariViewController(url: url)
                }
                
                vc?.modalPresentationStyle = .fullScreen
                vc?.delegate = (self as SFSafariViewControllerDelegate)
                
                vc?.modalPresentationStyle = .popover
                
                if let vc = vc {
                    present(vc, animated: true) {
                        
                    }
                }
                self.webView.evaluateJavaScript("loggingToApp('externalSaFariHandler','\((message.body as? String)!)','success')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }else{
                self.webView.evaluateJavaScript("loggingToApp('externalSaFariHandler','\((message.body as? String)!)','fail')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }
        }else if message.name == "inAppPurchaseHandler"{
            
            var id:String?
            var price:String?
            var category:String?
            
            //var param = {"url":"https://www.modooclass.net/class/classDetail/2323","photoUrl":"https://www.modooclass.net/class/classDetail/qweqwe.png","title":"조싀앤바믜의 5000kcal 추천 나도 할수있다!!"}
            //webkit.messageHandlers.inAppPurchaseHandler.postMessage(param);
            
            if let dictionary: [String: String] = message.body as? Dictionary {
                if let idCheck = dictionary["id"] {
                    id = idCheck
                }else{
                    id = "0"
                }
                
                if let priceCheck = dictionary["price"] {
                    price = priceCheck
                }else{
                    price = "0"
                }
                
                if let categoryCheck = dictionary["category"] {
                    category = categoryCheck
                }else{
                    category = ""
                }
            }
            
            if category != ""{
                AppsFlyerTracker.shared().trackEvent(AFEventPurchase,
                     withValues: [
                        AFEventParamContentId:id!,
                        AFEventParamContentType : category!,
                        AFEventParamRevenue: price!,
                        AFEventParamCurrency:"KRW"
                    ]);
            }else{
                AppsFlyerTracker.shared().trackEvent(AFEventPurchase,
                     withValues: [
                        AFEventParamContentId:id!,
                        AFEventParamRevenue: price!,
                        AFEventParamCurrency:"KRW"
                    ]);
            }
        }else if message.name == "goToChatDetail"{
            print("goToChatDetail: alert \(message.body)")
            if message.body as! String != ""{
                //message.body = room_id
                let newViewController = chattingStoryboard.instantiateViewController(withIdentifier: "ChattingFriendWebViewViewController") as! ChattingFriendWebViewViewController
//                newViewController.url = "https://chat.modooclass.net/class/chat/\(message.body as! String)"
                newViewController.url = "https://www.modooclass.net/class/chat/\(message.body as! String)"
                self.navigationController?.pushViewController(newViewController, animated: true)
                
                self.webView.evaluateJavaScript("loggingToApp('goToChatDetail','\((message.body as? String)!)','success')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }else{
                self.webView.evaluateJavaScript("loggingToApp('goToChatDetail','\((message.body as? String)!)','fail')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }
        }else if message.name == "outLinkForBrowser"{
            print("outLinkForBrowser: alert \(message.body)")
            if message.body as! String != ""{
                //message.body = room_id
                
                let myURL:URL = URL(string:"\(message.body as! String)")!
                
                var vc: SFSafariViewController? = nil
                vc = SFSafariViewController(url: myURL)
                
                vc?.modalPresentationStyle = .fullScreen
                vc?.delegate = (self as SFSafariViewControllerDelegate)
                
                vc?.modalPresentationStyle = .popover
                
                if let vc = vc {
                    present(vc, animated: true) {
                        
                    }
                }
                
                self.webView.evaluateJavaScript("loggingToApp('goToChatDetail','\((message.body as? String)!)','success')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }else{
                self.webView.evaluateJavaScript("loggingToApp('goToChatDetail','\((message.body as? String)!)','fail')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }
        }else if message.name == "gotofriendprofile"{
            print("gotofriendprofile: alert \(message.body)")
            if message.body as! Int != 0{
                //message.body = room_id
//                let newViewController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileFriendViewController") as! ProfileFriendViewController
                let newViewController = home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
                newViewController.user_id = (message.body as? Int)!
                self.navigationController?.pushViewController(newViewController, animated: true)
                
                self.webView.evaluateJavaScript("loggingToApp('gotofriendprofile','\((message.body as? Int)!)','success')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }else{
                self.webView.evaluateJavaScript("loggingToApp('gotofriendprofile','\((message.body as? Int)!)','fail')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }
        }else if message.name == "hideLoading"{
            print("hideloading: alert \(message.body)")
            if message.body as! String == "hide"{
                //webkit.messageHandlers.hideloading.postMessage('hide')
                self.animationView.stop()
                self.lottiView.removeFromSuperview()
                self.backBtn.isHidden = true
                
                self.webView.evaluateJavaScript("loggingToApp('gotofriendprofile','\((message.body as? String)!)','success')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }else{
                self.webView.evaluateJavaScript("loggingToApp('gotofriendprofile','\((message.body as? String)!)','fail')", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            }
        }else if message.name == "clearCache"{
            //            webkit.messageHandlers.clearCache.postMessage('clear')
            if message.body as! String == "clear"{
                if #available(iOS 9.0, *) {
                    let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
                    let date = NSDate(timeIntervalSince1970: 0)
                    WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
                }else{
                    URLCache.shared.removeAllCachedResponses()
                }
            }else{
                
            }
        }else if message.name == "goToReplyDetail"{
            var class_id:Int?
            var comment_id:Int?
            
            //            var param = {"class_id":122,"comment_id":123123}
            //            webkit.messageHandlers.goToReplyDetail.postMessage(param);
            
            if let dictionary: [String: Int] = message.body as? Dictionary {
                if let idCheck = dictionary["class_id"] {
                    class_id = idCheck
                }else{
                    class_id = 0
                }
                
                if let priceCheck = dictionary["comment_id"] {
                    comment_id = priceCheck
                }else{
                    comment_id = 0
                }
            }
            let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "DetailReplyViewController") as! DetailReplyViewController
            newViewController.comment_id = comment_id ?? 0
            newViewController.class_id = class_id ?? 0
            newViewController.commentType = "class"
            newViewController.missionCheck = false
            self.navigationController?.pushViewController(newViewController, animated: true)
        }else if message.name == "goToFeedDetail"{
            if message.body as? String != ""{
                self.navigationController?.storyPopOrPushController(feedId: "\(message.body)")
            }
        }else if message.name == "goToFeedReply"{
            if message.body as? String != ""{
                let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "StoryReplyDetailViewController") as! StoryReplyDetailViewController
                newViewController.feedId = "\(message.body)"
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > iOS에서 html 알림 보이기
     
     - Parameters:
        - webView: 웹킷웹뷰
        - message: 메세지 내용
        - frame: 아이폰 크기
        - completionHandler: 완료후 핸들러
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in
            completionHandler()
        }
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > iOS에서 html 알림 보이기
     
     - Parameters:
        - webView: 웹킷웹뷰
        - message: 메세지 내용
        - frame: 아이폰 크기
        - completionHandler: 완료후 핸들러
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            completionHandler(false)
        }
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
