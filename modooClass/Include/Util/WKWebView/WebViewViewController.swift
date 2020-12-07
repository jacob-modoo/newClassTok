//
//  WebViewViewController.swift
//  modooClass
//
//  Created by 조현민 on 20/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import WebKit
import Lottie
import SafariServices
import AppsFlyerLib

class WebViewViewController: UIViewController ,WKNavigationDelegate,WKUIDelegate , SFSafariViewControllerDelegate{

    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var lottiSubView: UIView!
    @IBOutlet var lottiView: UIView!
    @IBOutlet var containerView: UIView!
    var keyboardShow = false
    var url = ""
    var webView: WKWebView!
    var networkView:NetworkOutView!
    var tokenCheck = true
    let animationView = AnimationView(name: "webViewLodingLottie2")
    
    //이 뷰에서만 네비게이션 안보이게 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //이 뷰를 벗어나면 네비게이션 보이게 설정
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func loadView() {
        super.loadView()
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        
        //native -> js call (문서 시작시에만 가능한, 환경설정으로 사용)
        //        let userScript = WKUserScript(source: "iframId(302207632)", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        //        contentController.removeAllUserScripts()
        //        contentController.addUserScript(userScript)
        
        // js -> native call : name 값을 지정하여 js 에서 webkit.messageHandlers.NAME.postMessage(""); 와 연동되는것 userContenteController함수에서 처리한다.
        contentController.add(self,name: "changeGroupHandler")
        contentController.add(self,name: "groupBackHandler")
        contentController.add(self,name: "profileHandler")
        contentController.add(self,name: "shareHandler")
        contentController.add(self,name: "classJoinHandler")
        contentController.add(self,name: "kakaoFriendHandler")
        contentController.add(self,name: "homeHandler")
        contentController.add(self,name: "clipBoardHandler")
        contentController.add(self,name: "externalSaFariHandler")
        contentController.add(self,name: "inAppPurchaseHandler")
        contentController.add(self,name: "goToChatDetail")
        contentController.add(self,name: "outLinkForBrowser")
        contentController.add(self,name: "gotofriendprofile")
        contentController.add(self,name: "hideLoading")
        contentController.add(self,name: "clearCache")
        contentController.add(self,name: "goToReplyDetail")
        contentController.add(self,name: "inAppPurchase")
        
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
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        print("keyboard will show!")
        self.view.layoutIfNeeded()
        // To obtain the size of the keyboard:
//        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
//        let keyboardRectangle = keyboardFrame.cgRectValue
//        let keyboardHeight = keyboardRectangle.height
//        print("keyboardHeight : ", keyboardHeight)

        self.webView.evaluateJavaScript("onResize()", completionHandler: { (result,error) in
            if let result = result{
                print (result)
            }
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
//        if #available(iOS 12.0, *) {
//            for v in webView.subviews {
//                if v is UIScrollView {
//                    let scrollView = v as! UIScrollView
//                    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
//                }
//            }
//        }
        self.webView.evaluateJavaScript("onResize()", completionHandler: { (result,error) in
            if let result = result{
                print (result)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadWebView), name: NSNotification.Name(rawValue: "reloadWebViewCheck"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.purchasedCancle), name: NSNotification.Name(rawValue: "purchasedCancle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadingHide), name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
        
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
        
        var myURL:URL?
        
//        url = url.replace(target: "https://www.modooclass.net", withString: "http://drugsism.modooclass.net")
//        url = url.replace(target: "https://www.modooclass.net", withString: "https://hyejin.modooclass.net")
//        url = url.replace(target: "https://www.modooclass.net", withString: "https://junghee.modooclass.net")
        if tokenCheck == true {
            print("url: \(url)")
            print("token : \(session)")
            print("url+token : \(url)?token=\(session)")
            myURL = URL(string:"\(url)?token=\(session)")
        }else{
            myURL = URL(string:"\(url)")
        }
        
        
        var request = URLRequest(url: myURL! , cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy)
        
        let cookies = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies(for: request.url!)!)
        if let value = cookies["Cookie"] {
            request.addValue(value, forHTTPHeaderField: "Cookie")
        }
        
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.load(request)
        
        self.networkView = NetworkOutView.initWithNib(frame: self.view.frame)
//        self.networkView.submitClick = {
//            self.networkView.dismissNetworkView()
//            self.webView.load(request)
//        }
        self.view.addSubview(self.networkView)
        self.networkView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.view)
        }
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //웹뷰 호출 시작할때
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    
    //웹뷰 호출 끝났을때
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
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
//        Alert.With(self, title: "알림", content: "로딩에 문제가 생겼습니다\n네트워크를 확인해주세요", btn1Title: "확인", btn1Handler: {
//            self.navigationController?.popViewController(animated: false)
//        })
//        self.networkView.showNetworkView()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
//        Alert.With(self, title: "알림", content: "로딩에 문제가 생겼습니다\n네트워크를 확인해주세요", btn1Title: "확인", btn1Handler: {
//            self.navigationController?.popViewController(animated: false)
//        })
//        self.networkView.showNetworkView()
    }
    
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
    @objc func loadingHide(notification:Notification){
        DispatchQueue.main.async {
            Indicator.hideActivityIndicator(uiView: self.view)
        }
    }
    
    @objc func purchasedCancle(notification:Notification){
        var message = "취소되었습니다."
        if let temp = notification.object {
            if temp as? Int == 1{
                message = "결제를 실행할수 없는 환경입니다."
            }else if temp as? Int == 2{
                message = "결제 오류가 발생했습니다."
            }else if temp as? Int == 3{
                message = "결제 할 수 있는 제품이 없습니다."
            }else if temp as? Int == 4{
                message = "결제가 취소되었습니다."
            }
        }
        Indicator.hideActivityIndicator(uiView: self.view)
        Alert.With(self, title: "\(message)", btn1Title: "확인", btn1Handler: {
            self.webView.evaluateJavaScript("appCancel()", completionHandler: { (result,error) in
                if let result = result{
                    print (result)
                }
            })
        })
    }
    
    @objc func reloadWebView(notification:Notification){
        Indicator.hideActivityIndicator(uiView: self.view)
        if let temp = notification.object {
            self.url = temp as! String
            self.webView.evaluateJavaScript("appReload()", completionHandler: { (result,error) in
                if let result = result{
                    print (result)
                }
            })
//            var myURL:URL?
//            let session:String = UserDefaultSetting.getUserDefaultsString(forKey: sessionToken) as! String
//            if tokenCheck == true {
//                print("url: \(url)")
//                print("token : \(session)")
//                print("url+token : \(url)?token=\(session)")
//                myURL = URL(string:"\(url)?token=\(session)")
//            }else{
//                myURL = URL(string:"\(url)")
//            }
//            var request = URLRequest(url: myURL! , cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy)
//
//            let cookies = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies(for: request.url!)!)
//            if let value = cookies["Cookie"] {
//                request.addValue(value, forHTTPHeaderField: "Cookie")
//            }
//
//            webView.scrollView.contentInsetAdjustmentBehavior = .never
//            webView.scrollView.showsVerticalScrollIndicator = false
//            webView.scrollView.showsHorizontalScrollIndicator = false
//            webView.load(request)
        }
    }
}

extension WebViewViewController:WKScriptMessageHandler {
    
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
//                이 부분은 그룹채팅 부분 업데이트때문에 추가한 부분으로 영상 부분겹침 현상으로 인해 오류가 걸리는 사항으로 주석 처리
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
                AppsFlyerLib.shared().logEvent(AFEventPurchase,
                     withValues: [
                        AFEventParamContentId:id!,
                        AFEventParamContentType : category!,
                        AFEventParamRevenue: price!,
                        AFEventParamCurrency:"KRW"
                    ]);
            }else{
                AppsFlyerLib.shared().logEvent(AFEventPurchase,
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
                
                let storyboard: UIStoryboard = UIStoryboard(name: "ChattingWebView", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "ChattingFriendWebViewViewController") as! ChattingFriendWebViewViewController
//                newViewController.url = "https://chat.modooclass.net/class/chat/\(message.body as! String)"
                newViewController.url = "https://www.modooclass.net/class/chat/\(message.body as! String)"
                self.navigationController?.pushViewController(newViewController, animated: false)
                
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
                let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
//                let newViewController = storyboard.instantiateViewController(withIdentifier: "ProfileFriendViewController") as! ProfileFriendViewController
                let newViewController = storyboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
                if UserManager.shared.userInfo.results?.user?.id == message.body as? Int {
                    newViewController.isMyProfile = true
                }else{
                    newViewController.isMyProfile = false
                }
                newViewController.user_id = (message.body as? Int)!
                self.navigationController?.pushViewController(newViewController, animated: false)
                
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
            let storyboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "DetailReplyViewController") as! DetailReplyViewController
            newViewController.comment_id = comment_id ?? 0
            newViewController.class_id = class_id ?? 0
            newViewController.commentType = "class"
            newViewController.missionCheck = false
            self.navigationController?.pushViewController(newViewController, animated: false)
        }else if message.name == "inAppPurchase"{
            var class_id:Int?
            var package_id:Int?
            var inAppPurchase_id:String?
//            var param = {"mcClass_id":122,"mcPackage_id":122,"iap_id":"com.modooclass.iap1"}
//            webkit.messageHandlers.inAppPurchase.postMessage(param);
            if let dictionary: [String: Any] = message.body as? Dictionary {
                if let idCheck = dictionary["mcClass_id"] as? Int{
                    class_id = idCheck
                }else{
                    class_id = 0
                }
                
                if let packageCheck = dictionary["mcPackage_id"] as? Int {
                    package_id = packageCheck
                }else{
                    package_id = 0
                }
                
                if let inAppPurchaseCheck = dictionary["iap_id"] as? String {
                    inAppPurchase_id = inAppPurchaseCheck
                }else{
                    inAppPurchase_id = ""
                }
            }
            if class_id != 0 && package_id != 0 && inAppPurchase_id != ""{
                Indicator.showActivityIndicator(uiView: self.view)
                InAppPurchase.sharedInstance.buyUnlockTestInAppPurchase1(productId:inAppPurchase_id!,class_id:class_id!,package_id:package_id!)
            }else{
                Alert.With(self, title: "관리자에게 문의해주세요", btn1Title: "확인", btn1Handler: {})
            }
        }
    }
    
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
