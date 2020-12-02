//
//  HomeIntroWebViewController.swift
//  modooClass
//
//  Created by 조현민 on 2020/01/14.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit
import WebKit
import Lottie
import SafariServices
import AppsFlyerLib
import Firebase

class HomeIntroWebViewController : UIViewController ,WKNavigationDelegate,WKUIDelegate , SFSafariViewControllerDelegate {

    @IBOutlet weak var lottiSubView: UIView!
    @IBOutlet weak var lottiView: UIView!
    @IBOutlet weak var containerView: UIView!
    var keyboardShow = false
    var url = "https://www.modooclass.net/class/interest"
    var webView: WKWebView!
    var networkView:NetworkOutView!
    var tokenCheck = true
    var webViewScrollOffset:CGPoint?
    var animationView = AnimationView(name: "webViewLodingLottie3")
    let childWebViewStoryboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    let feedStoryboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
    let chattingStoryboard: UIStoryboard = UIStoryboard(name: "ChattingWebView", bundle: nil)
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    var currentContent: Int = 0
    var heightInset:CGFloat?
    @IBOutlet weak var launchView: UIView!
    
    //이 뷰에서만 네비게이션 안보이게 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if launchViewHide == true {
            launchView.isHidden = true
            launchViewHide = false
        }
    }
    
    //이 뷰를 벗어나면 네비게이션 보이게 설정
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /** **뷰가 나타나고 타는 메소드 */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.setScreenName("클래스", screenClass: "HomeIntroWebViewController")
        let time = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.animationView.stop()
            if self.lottiView != nil{
                self.lottiView.removeFromSuperview()
            }
        }
    }

    /** **뷰가 사라지고 타는 메소드 */
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
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
        
        contentController.add(LeakAvoider(delegate: self),name: "changeGroupHandler")
        contentController.add(LeakAvoider(delegate: self),name: "groupBackHandler")
        contentController.add(LeakAvoider(delegate: self),name: "gotoprofile")
        contentController.add(LeakAvoider(delegate: self),name: "shareHandler")
//        contentController.add(self,name: "classJoinHandler")
        contentController.add(LeakAvoider(delegate: self),name: "goToDetailClass")
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
        contentController.add(LeakAvoider(delegate: self),name: "inAppPurchase")
        contentController.add(LeakAvoider(delegate: self),name: "goToMainWebView")
        contentController.add(LeakAvoider(delegate: self),name: "goToAlarm")
        contentController.add(LeakAvoider(delegate: self),name: "goToSearch")
        contentController.add(LeakAvoider(delegate: self),name: "logout")
        contentController.add(LeakAvoider(delegate: self),name: "goToProfile")
        contentController.add(LeakAvoider(delegate: self),name: "goToFeedDetail")
        contentController.add(LeakAvoider(delegate: self),name: "goToFeedReply")
        
        config.userContentController = contentController
        config.allowsInlineMediaPlayback = true
//        config.applicationNameForUserAgent = "Modooclass"
        let infoDictionary = Bundle.main.infoDictionary
        let currentVersion = infoDictionary?["CFBundleShortVersionString"] as? String
        
        config.applicationNameForUserAgent = "Modoo_ios iOSVersion \(currentVersion ?? "1.8.0")"
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height) , configuration: config)
        self.containerView.addSubview(webView)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
    }
    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        print("keyboard will show!")
        self.view.layoutIfNeeded()
        if #available(iOS 12.0, *) {
            for v in webView.subviews {
                if v is UIScrollView {
                    let scrollView = v as! UIScrollView
                    self.webViewScrollOffset = scrollView.contentOffset
                }
            }
        }

        self.webView.evaluateJavaScript("onResize()", completionHandler: { (result,error) in
            if let result = result{
                print (result)
            }
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if #available(iOS 12.0, *) {
            for v in webView.subviews {
                if v is UIScrollView {
                    let scrollView = v as! UIScrollView
                    scrollView.setContentOffset(webViewScrollOffset!,animated: false)//(CGPoint(x: 0, y: 0), animated: false)
                }
            }
        }
        self.webView.evaluateJavaScript("onResize()", completionHandler: { (result,error) in
            if let result = result{
                print (result)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        versionCheck()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadWebView), name: NSNotification.Name(rawValue: "reloadWebViewCheck"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.purchasedCancle), name: NSNotification.Name(rawValue: "purchasedCancle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadingHide), name: NSNotification.Name(rawValue: "loadingHide"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.alarmNew), name: NSNotification.Name(rawValue: "alarmNew"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.messageNew), name: NSNotification.Name(rawValue: "messageNew"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.feedDetailViewMove), name: NSNotification.Name(rawValue: "feedDetailViewMove"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.alarmViewMove), name: NSNotification.Name(rawValue: "alarmViewMove"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.classDetailMove), name: NSNotification.Name(rawValue: "classDetailMoveWeb"), object: nil )
        
        DispatchQueue.main.async {
            self.animationView.center = self.lottiSubView.center
            
            self.animationView.loopMode = .loop
            self.animationView.contentMode = .scaleAspectFill
            self.animationView.animationSpeed = 0.5
            
            // Applying UIView animation
//            let minimizeTransform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//            self.animationView.transform = minimizeTransform
//            UIView.animate(withDuration: 0.8, delay: 0.0, options: [.repeat, .autoreverse], animations: {
//                self.animationView.transform = CGAffineTransform.identity
//            }, completion: nil)
            self.lottiSubView.addSubview(self.animationView)
            self.animationView.snp.makeConstraints{ (make) in
                make.centerY.equalToSuperview().offset(-self.view.frame.height/10)
                make.centerX.equalToSuperview()
                make.width.equalTo(self.view.frame.width/5)
                make.height.equalTo(self.view.frame.width/5)
            }
            self.animationView.backgroundColor = UIColor.clear
            self.animationView.layer.cornerRadius = 10
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
        refreshControl.addTarget(self, action: #selector(reloadWeb(_:)), for: .valueChanged)
        webView.scrollView.addSubview(refreshControl)
        
        var myURL:URL?
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        
//        url = url.replace(target: "https://www.modooclass.net", withString: "https://junghee.modooclass.net")
        if tokenCheck == true {
            print("url: \(url)")
            print("token : \(session)")
            print("url+token : \(url)?token=\(session)")
            if url.contains("?") == true{
                myURL = URL(string:"\(url)&token=\(session)")
            }else{
                myURL = URL(string:"\(url)?token=\(session)")
            }
        }else{
            myURL = URL(string:"\(url)")
        }
        
        
        var request = URLRequest(url: myURL! , cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy)
        
        let cookies = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies(for: request.url!)!)
        if let value = cookies["Cookie"] {
            request.addValue(value, forHTTPHeaderField: "Cookie")
        }
        
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.allowsLinkPreview = false
        webView.allowsBackForwardNavigationGestures = true
//        webView.configuration.suppressesIncrementalRendering = true
        
        webView.load(request)
        
        self.networkView = NetworkOutView.initWithNib(frame: self.view.frame)
        self.networkView?.submitBtnClicked{ [unowned self] eNumber in
            self.webView.load(request)
        }
        
        self.networkView?.backBtnClicked{ [unowned self] eNumber in
            self.navigationController?.popViewController(animated: true)
        }
//        self.networkView.submitClick = {
//            self.networkView.dismissNetworkView()
//            self.webView.load(request)
//        }
//        
//        self.networkView.backClick = {
//            self.networkView.dismissNetworkView()
//            self.navigationController?.popViewController(animated: true)
//        }
        
        self.view.addSubview(self.networkView)
        self.networkView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self.view)
        }
        print("launchViewHide : ",launchViewHide)
//        if launchViewHide == true {
//            launchView.isHidden = true
//            launchViewHide = false
//        }else{
//            launchView.isHidden = false
//        }
//        let insets = UIEdgeInsets(top: heightInset ?? 54, left: 0, bottom: 0, right: 0)
//        webView.scrollView.contentInset = insets
//        webView.scrollView.scrollIndicatorInsets = insets
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

//        self.animationView.stop()
//        self.lottiView.removeFromSuperview()
        self.animationView.stop()
        if self.lottiView != nil{
            self.lottiView.removeFromSuperview()
        }
        let time = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.launchView.isHidden = true
        }
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageNew"), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alarmNew"), object: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
//        Alert.With(self, title: "알림", content: "로딩에 문제가 생겼습니다\n네트워크를 확인해주세요", btn1Title: "확인", btn1Handler: {
//            self.navigationController?.popViewController(animated: false)
//        })
//        self.networkView.showNetworkView()
        if let err = error as? URLError {
            switch(err.code) {
                case .cancelled:
                    break
                case .cannotFindHost:
    //                    self.networkView.showNetworkView()
                    break
                case .notConnectedToInternet:
                    print("뭐여?")
                    self.networkView.showNetworkView()
                    break
                case .resourceUnavailable:
                    break
                case .timedOut:
                    print("뭐여?")
                    self.networkView.showNetworkView()
                    break
                default:
                    print("error code: " + String(describing: err.code) + "  does not fall under known failures")
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
//        Alert.With(self, title: "알림", content: "로딩에 문제가 생겼습니다\n네트워크를 확인해주세요", btn1Title: "확인", btn1Handler: {
//            self.navigationController?.popViewController(animated: false)
//        })
        if let err = error as? URLError {
            switch(err.code) {
                case .cancelled:
                    break
                case .cannotFindHost:
//                    self.networkView.showNetworkView()
                    break
                case .notConnectedToInternet:
                    self.networkView.showNetworkView()
                    break
                case .resourceUnavailable:
                    break
                case .timedOut:
                    self.networkView.showNetworkView()
                    break
                default:
                    print("error code: " + String(describing: err.code) + "  does not fall under known failures")
            }
        }
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
            }else{
                
            }
        }
        decisionHandler(.allow)
    }
    
    @objc func classDetailMove(notification:Notification){
        if let temp = notification.object {
            let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
            newViewController.class_id = temp as! Int
            newViewController.pushGubun = 1
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @objc func reloadWeb(_ sender: UIRefreshControl) {
        Indicator.showLottieActivityIndicator(uiView: self.view)
        webView.reload()
        sender.endRefreshing()
        let time = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: time) {
            Indicator.hideLottieActivityIndicator(uiView: self.view)
        }
    }
    
    @objc func alarmViewMove(notification:Notification){
        let storyboard: UIStoryboard = UIStoryboard(name: "Alarm", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "AlarmViewController") as! AlarmViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func feedDetailViewMove(notification:Notification){
        if let temp = notification.object {
            if (temp as? Int)! > 0 {
                let newViewController = self.feedStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                newViewController.class_id = (temp as? Int)!
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
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
        DispatchQueue.main.async {
            Indicator.hideActivityIndicator(uiView: self.view)
            Alert.With(self, title: "\(message)", btn1Title: "확인", btn1Handler: {
                self.webView.evaluateJavaScript("appCancel()", completionHandler: { (result,error) in
                    if let result = result{
                        print (result)
                    }
                })
            })
        }
        
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
        }
    }
    
    @objc func alarmNew(notification:Notification){
        self.webView.evaluateJavaScript("bridgeIFStateUpdateWatcher('alarm');", completionHandler: { (result,error) in
            if let result = result{
                print (result)
            }
        })
    }
    @objc func messageNew(notification:Notification){
        self.webView.evaluateJavaScript("bridgeIFStateUpdateWatcher('message');", completionHandler: { (result,error) in
            if let result = result{
                print (result)
            }
        })
    }
    
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

extension HomeIntroWebViewController:WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name , " : message.name")
        if message.name == "changeGroupHandler" {
            if message.body as! String == "close"{
                self.navigationController?.popViewControllers(viewsToPop: 1)
//                이 부분은 그룹채팅 부분 업데이트때문에 추가한 부분으로 영상 부분겹침 현상으로 인해 오류가 걸리는 사항으로 주석 처리
            }else{
                
            }
        }else if message.name == "groupBackHandler" {
            if message.body as! String == "close"{
//                webkit.messageHandlers.groupBackHandler.postMessage('close');
                self.navigationController?.popViewControllers(viewsToPop: 2)
            }
        }else if message.name == "gotoprofile"{
//            webkit.messageHandlers.profileHandler.postMessage("profile")
            if message.body as! Int > 0{
                let storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
                if UserManager.shared.userInfo.results?.user?.id == message.body as? Int {
                    newViewController.isMyProfile = true
                }else{
                    newViewController.isMyProfile = false
                }
                newViewController.user_id = (message.body as? Int)!
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else{
                
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
                
            }, failure: { (error) in
                // 실패
                print("error \(error)")
            })
        }else if message.name == "goToDetailClass" {
            
            if message.body as! Int != 0{
                self.navigationController?.popToRootViewController(animated: true)
                //            webkit.messageHandlers.goToClassDetail.postMessage(class_id)
                let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                newViewController.class_id = message.body as! Int
                newViewController.pushGubun = 1
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else{
                
            }
        }else if message.name == "classJoinHandler" {
            if message.body as! Int != 0{
                
            }else{
                
            }
            self.navigationController?.popToRootViewController(animated: true)
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabbarIndexChange"), object: 0)
//            webkit.messageHandlers.classJoinHandler.postMessage(class_id)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classDetailMoveWebView"), object: message.body)
        }else if message.name == "kakaoFriendHandler"{
            if message.body as! String == "kakao"{
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
                
            }
        }else if message.name == "homeHandler"{
            if message.body as! String == "home"{
//                webkit.messageHandlers.homeHandler.postMessage('home')
                self.navigationController?.popToRootViewController(animated: true)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabbarIndexChange"), object: 0)
            }else{
                
            }
        }else if message.name == "clipBoardHandler"{
            print("clipBoardHandler: alert \(message.body)")
            if message.body as! String != ""{
                UIPasteboard.general.string = (message.body as! String)
                Toast.showNotification(message: "클립보드에 복사했습니다.", controller: self)
            }else{
                
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
            }else{
                
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
                
                let storyboard: UIStoryboard = UIStoryboard(name: "ChattingWebView", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "ChattingFriendWebViewViewController") as! ChattingFriendWebViewViewController
//                newViewController.url = "https://chat.modooclass.net/class/chat/\(message.body as! String)"
                newViewController.url = "https://www.modooclass.net/class/chat/\(message.body as! String)"
                self.navigationController?.pushViewController(newViewController, animated: false)
            }else{
                
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
            }else{
                
            }
        }else if message.name == "gotofriendprofile"{
            print("gotofriendprofile: alert \(message.body)")
            if message.body as! Int != 0{
                //message.body = room_id
                let storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
                if UserManager.shared.userInfo.results?.user?.id == message.body as? Int {
                    newViewController.isMyProfile = true
                }else{
                    newViewController.isMyProfile = false
                }
                newViewController.user_id = (message.body as? Int)!
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else{
                
            }
        }else if message.name == "hideLoading"{
            print("hideloading: alert \(message.body)")
            if message.body as! String == "hide"{
                //webkit.messageHandlers.hideloading.postMessage('hide')
                self.animationView.stop()
                if self.lottiView != nil{
                    self.lottiView.removeFromSuperview()
                }
            }else{
                
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
        }else if message.name == "goToMainWebView"{
            print("goToWebView: alert \(message.body)")
            if message.body as? String != ""{
                //message.body = room_id
                
                let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                newViewController.url = (message.body as? String) ?? ""
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else{
                
            }
        }else if message.name == "goToAlarm"{
            print("goToAlarm: alert \(message.body)")
            if message.body as? String == "alarm"{
                let storyboard: UIStoryboard = UIStoryboard(name: "Alarm", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "AlarmViewController") as! AlarmViewController
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else{
                
            }
        }else if message.name == "logout"{
            if message.body as? String == "logout"{
                Alert.With(self, title: "알림", content: "정말 로그아웃 하시겠어요?", btn1Title: "취소", btn1Handler: {
                },btn2Title: "확인", btn2Handler: {
                    
                    if Reachability.isConnectedToNetwork() == true{
                        let providerCheck = UserDefaultSetting.getUserDefaultsString(forKey: userProvider)
                        
                        UserDefaults.standard.set(nil, forKey: userProvider)
                        UserDefaults.standard.set(nil, forKey: userId)
                        UserDefaults.standard.set(nil, forKey: userPw)
                        UserDefaults.standard.set(nil, forKey: userName)
                        UserDefaults.standard.set(nil, forKey: sessionToken)
                        if providerCheck != nil && providerCheck as? String != ""{
                            if providerCheck as? String == "kakao"{
                                Kakao().kakaoLogout()
                            }else if providerCheck as? String == "naver"{
                                Naver().naverLogout()
                            }else{
                                FaceBook().facebookLogout()
                            }
                        }
                        DispatchQueue.main.async {
                            let nextView = self.loginStoryboard.instantiateViewController(withIdentifier: "LoginNavViewController")
                            nextView.modalPresentationStyle = .fullScreen
                            self.present(nextView, animated:false,completion: nil)
                        }
                    }else{
                        Alert.With(self,title: "인터넷 연결을 확인해주세요.",btn1Title: "확인",btn1Handler: {})
                    }
                    
                })
            }
        }else if message.name == "goToSearch"{
            let checkMessage = (message.body as? String)?.isBlank
            if checkMessage == true{
                let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedbackSearchViewController") as! FeedbackSearchViewController
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else{
                let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedbackSearchViewController") as! FeedbackSearchViewController
                newViewController.searchWord = message.body as? String ?? "운동"
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }else if message.name == "goToProfile"{
            if message.body as! Int > 0{
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
                if UserManager.shared.userInfo.results?.user?.id == message.body as? Int {
                    newViewController.isMyProfile = true
                }else{
                    newViewController.isMyProfile = false
                }
                newViewController.user_id = (message.body as? Int)!
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }else if message.name == "goToFeedDetail"{
            if message.body as? String != ""{
                print(message.body)
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

extension HomeIntroWebViewController : UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if #available(iOS 12.0, *) {
            for v in webView.subviews {
                if v is UIScrollView {
                    let scrollView = v as! UIScrollView
                    self.webViewScrollOffset = scrollView.contentOffset
                    scrollView.contentOffset.x = 0.0
                }
            }
        }
    }
}
