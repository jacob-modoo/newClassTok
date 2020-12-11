//
//  FeedDetailViewController.swift
//  modooClass
//
//  Created by 조현민 on 31/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import BMPlayer
import AVKit
import AVFoundation
import MediaPlayer
import Firebase
/**
 # FeedDetailViewController.swift 클래스 설명
 
 ## UIViewController 상속 받음
 - 클래스 참여 화면을 보기위한 뷰 컨트롤러
 */
class FeedDetailViewController: UIViewController,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var blackView: UIView!
    /** **클래스오픈 준비뷰 */
    @IBOutlet weak var openReadyView: UIView!
    /** **영상 플레이어 준비뷰 */
    @IBOutlet weak var player: BMPlayer!
    /** **자식 컨트롤러 디테일클래스 뷰 */
    @IBOutlet weak var textView: UIView!
    /** **자식 컨트롤러 디테일커리큘럼 뷰 */
    @IBOutlet weak var textView1: UIView!
    /** **자식 컨트롤러 디테일응원하기 뷰 */
    @IBOutlet weak var textView2: UIView!
    /** **자식 컨트롤러 디테일응원하기 뷰 */
    @IBOutlet weak var textView3: UIView!
    /** *a view for ShareViewController */
    @IBOutlet weak var textView4: UIView!
    /** *textView for descriptionVC */
    @IBOutlet weak var textView5: UIView!
    
    /** **자식 컨트롤러 디테일클래스 뷰 추가 여부 */
     var textViewAddCheck = false
    /** **자식 컨트롤러 디테일커리큘럼 뷰 추가 여부 */
    var textView1AddCheck = false
    /** **자식 컨트롤러 디테일응원하기 뷰 추가 여부 */
    var textView2AddCheck = false
    /** **자식 컨트롤러 디테일응원하기 뷰 추가 여부 */
    var textView3AddCheck = false
    /** **자식 컨트롤러 디테일응원하기 뷰 추가 여부 */
    var textView4AddCheck = false
    /** **자식 컨트롤러 디테일응원하기 뷰 추가 여부 */
    var textView5AddCheck = false
    /** **처음 로딩시 클래스 가입이 제대로 되어있는지 체크 인덱스 */
    var viewCheck = 1
    /** **자식 컨트롤러 몇번째 뷰 포커스 인덱스 */
    var tableViewCheck = 1
    /** **자식 컨트롤러 디테일클래스 뷰 데이터 리로딩 여부 */
    var tab1DataChange = true
    /** **자식 컨트롤러 디테일커리큘럼 뷰 데이터 리로딩 여부 */
    var tab2DataChange = true
    /** **자식 컨트롤러 디테일응원하기 뷰 데이터 리로딩 여부 */
    var tab3DataChange = true
    /** **자식 컨트롤러 디테일응원하기 뷰 데이터 리로딩 여부 */
    var tab4DataChange = true
    var tab5DataChange = true
    /** **영상 플레이어 데이터 리로딩 여부 */
    var videoDataChange = true
    /** **클래스 아이디 */
    var class_id = 0
    /** **댓글 아이디 */
    var comment_id = 0
    /** **푸쉬가 들어올 경우 인덱스 2로 댓글 상세 뷰로 이동 ( DetailReplyViewController ) */
    var pushGubun = 1
    /** **영상 총 재생시간 */
    var duration = 0
    /** **커리큘럼 아이디 */
    var curriculum_id = 0
    /** **영상 재생 시간 */
    var trakingTime = 0
    /** **시간 타이머 */
    var timer:Timer?
    /** **비디오 URL */
    var loadUrl:String?
    /** **클래스 커리큘럼 소개 리스트 */
    var feedDetailList:FeedAppClassModel?
    var isSwipePop:Bool = false
    var share_address:String?
    var share_content:String?
    var share_img:String?
    var share_point:String?
    var class_name:String?
    var class_photo:String?
    
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    let feedStoryboard = UIStoryboard(name: "Feed", bundle: nil)
//    let webViewStoryboard: UIStoryboard = UIStoryboard(name: "WebView", bundle: nil)
//    let profileStoryboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    

    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.videoStop), name: NSNotification.Name(rawValue: "videoStopCheck"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.curriculumUpdate), name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.reviewWebView), name: NSNotification.Name(rawValue: "reviewWebViewCheck"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.classDetailFriend), name: NSNotification.Name(rawValue: "classDetailFriend"), object: nil )
//        Indicator.showActivityIndicator(uiView: self.view)
        
        player.delegate = self
        
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true {
                return
            }
            
            if let childVC = self.children.first as? ChildDetailClassViewController {
                childVC.view.endEditing(true)
                childVC.emoticonSelectView.isHidden = true
                if childVC.replyTextView.text.isEmpty != true || childVC.emoticonImg.image != nil{
                    Alert.WithReply(self, btn1Title: "삭제", btn1Handler: {
                        childVC.replyTextView.text = nil
                        childVC.emoticonImg.image = nil
                        childVC.replyTextViewHeight.constant = 44
                        if childVC.customView != nil{
                            childVC.customView?.removeFromSuperview()
                            childVC.customView = nil
                        }
                    }, btn2Title: "이어서 작성", btn2Handler: {
                        if childVC.emoticonImg.image != nil {
                            childVC.emoticonSelectView.isHidden = false
                        }
                        childVC.replyTextView.becomeFirstResponder()
                    })
                }else{
                    self.deinitObserve()
                    let _ = self.navigationController?.popViewController(animated: true)
                }
            }else{
                self.deinitObserve()
                let _ = self.navigationController?.popViewController(animated: true)
            }
            
        }
        BMPlayerConf.enableVolumeGestures = false
        BMPlayerConf.enablePlaytimeGestures = false
        BMPlayerConf.enableBrightnessGestures = false
        BMPlayerConf.enablePlayControlGestures = true
        BMPlayerConf.enableChooseDefinition = true
        
        player.layer.masksToBounds = true
        
        FeedDetailManager.shared.feedDetailList.results = nil// = FeedAppClassModel()
        FeedDetailManager.shared.feedAppCurriculumModel.results = nil//FeedAppCurriculumModel()
        FeedDetailManager.shared.reviewDashboardModel.results = nil
        FeedDetailManager.shared.feedAppCheerModel.results = nil//FeedAppCheerModel()
        
        detailClassData()
        
    }
    
    deinit {
        print("deinit")
        deinitObserve()
    }
    
    func deinitObserve(){
        FeedDetailManager.shared.feedDetailList.results = nil// = FeedAppClassModel()
        FeedDetailManager.shared.feedAppCurriculumModel.results = nil//FeedAppCurriculumModel()
        FeedDetailManager.shared.reviewDashboardModel.results = nil
        FeedDetailManager.shared.feedAppCheerModel.results = nil//FeedAppCheerModel()
        self.player = nil
        player?.delegate = nil
        self.timer?.invalidate()
        self.timer = nil
        NotificationCenter.default.removeObserver(self)
        if self.children.count > 0{
            let childViewControllers:[UIViewController] = self.children
            for childVC in childViewControllers{
                childVC.view.removeFromSuperview()
                childVC.removeFromParent()
                childVC.willMove(toParent: nil)
            }
            textView.removeFromSuperview()
            textView1.removeFromSuperview()
            textView2.removeFromSuperview()
            textView3.removeFromSuperview()
            textView4.removeFromSuperview()
            textView5.removeFromSuperview()
        }
    }
    
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.all)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    /** **뷰가 사라지기 시작 할 때 타는 메소드 */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(.portrait)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    /** **뷰가 나타나고 타는 메소드 */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate? = self
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.logEvent("참여단", parameters: [AnalyticsParameterScreenName : "FeedDetailViewController"])
        if self.pushGubun == 2{
            DispatchQueue.main.async {
                let newViewController = self.feedStoryboard.instantiateViewController(withIdentifier: "DetailReplyViewController") as! DetailReplyViewController
                newViewController.comment_id = self.comment_id
                newViewController.class_id = self.class_id
                newViewController.commentType = "class"
                self.pushGubun = 1
                self.player.pause()
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }else{
            
        }
    }

    /** **뷰가 사라지고 타는 메소드 */
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.player?.pause()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    /** **뷰가 전환될때 타는 메소드 */
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.blackView.isHidden = false
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            if UIDevice.current.orientation.isLandscape {
                self.view.endEditing(true)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                deviceOrient = "Landscape"
            } else {
                if let childVC = self.children.first as? ChildDetailClassViewController {
                    if childVC.replyTextView.text.isEmpty != true || childVC.emoticonImg.image != nil{
                        DispatchQueue.main.async {
                            childVC.replyTextView.becomeFirstResponder()
                        }
                    }
                }
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                deviceOrient = "Portrait"
            }
        }) { [unowned self] _ in
            if UIDevice.current.orientation.isLandscape {
                self.blackView.isHidden = false
            }else{
                self.blackView.isHidden = true
            }
        }
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        switch gestureRecognizer.state {
        case .possible, .began, .changed:
            isSwipePop = true
            self.player?.pause()
        case .ended:
            isSwipePop = true
        default:
            isSwipePop = false
        }
        return true
    }
    
    /** **아이폰 홈 인디케이터 숨김처리 */
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    /** **이전 버튼 클릭 > 앞단계 뷰로 이동 */
    @IBAction func openBackBtnClicked(_ sender: UIButton) {
        self.deinitObserve()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func manageVideoPlayerBtnClicked(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name("videoManagerBtnClicked"), object: sender.tag)
    }
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 리뷰를 남기는 웹뷰로 이동하는 함수 ( WebViewViewController )
     
     - Parameters:
        - notification: 오브젝트에 review Url 담겨저옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func reviewWebView(notification:Notification){
        self.player?.pause()
        if let temp = notification.object {
            let newViewController = UIStoryboard(name: "ChildWebView", bundle: nil).instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = temp as! String
            Indicator.hideActivityIndicator(uiView: self.view)
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @objc func classDetailFriend(notification:Notification){
        if let temp = notification.object {
            self.videoStop()
            let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
            if UserManager.shared.userInfo.results?.user?.id == temp as? Int {
                newViewController.isMyProfile = true
            }else{
                newViewController.isMyProfile = false
            }
            newViewController.user_id = temp as! Int
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 비디오를 새로 로드하는 함수
    
    - Parameters:
        - notification: 오브젝트
         1. button_api: 버튼의 타입값
         2. curriculumId: 커리큘럼 아이디
         3. videoUrl: 비디오 경로
    
    - Throws: `Error` 스크롤이 이상한 값으로 넘어올 경우 `Error`
    */
    
    func videoLoadCheck(button_api:String,curriculum_id:Int,loadUrl:String){
        self.loadUrl = loadUrl
        self.curriculum_id = curriculum_id
        if button_api == "none"{
            AppDelegate.AppUtility.lockOrientation(.portrait)
            self.player?.isHidden = true
            self.openReadyView.isHidden = false
        }else{
            self.player?.isHidden = false
            self.openReadyView.isHidden = true
            if videoDataChange == true{
                if loadUrl != ""{
                    DispatchQueue.main.async {
                        let asset = BMPlayerResource(url: URL(string: "\(loadUrl)")!, name: "", cover: nil, subtitle: nil)
                        self.player?.setVideo(resource: asset)
                        self.videoDataChange = false
                        if self.pushGubun == 2{
                            DispatchQueue.main.async {
                                self.player?.pause()
                                self.pushGubun = 1
                            }
                        }else{
                            
                        }
                    }
                }
            }
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 재생중인 비디오를 멈추는 함수
     
     - Throws: `Error` 비디오가 로드되어있지 않은 경우 `Error`
     */
//    @objc func videoStop(notification: NSNotification){
//        self.player.pause()
//    }
    
    func videoStop(){
        self.player?.pause()
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 커리큘럼 데이터를 바꿔주도록 유도하는 함수
     
     - Parameters:
        - notification: 다음 강의 이동 타입
     
     - Throws: `Error` 데이터 오브젝트가 제대로 넘어오지 않는 경우 `Error`
     */
    @objc func curriculumUpdate(notification: NSNotification){
        self.tableViewCheck = 1
        if let temp = notification.object {
            if temp as! String == "review"{
                videoDataChange = false
            }else{
                videoDataChange = true
            }
        }else{
            videoDataChange = true
        }
        tab1DataChange = true
        tab2DataChange = true
        tab3DataChange = true
        tab4DataChange = true
        tab5DataChange = true
        FeedDetailManager.shared.feedDetailList = FeedAppClassModel()
        FeedDetailManager.shared.feedAppCurriculumModel = FeedAppCurriculumModel()
        FeedDetailManager.shared.reviewDashboardModel = ReviewDashboardModel()
        DispatchQueue.main.async {
            self.detailClassData()
        }
    }
    
    /**
     This function is used to move to classRoom and back to classRoom
     */
    func moveToClass(){
        DispatchQueue.main.async {
            let controller: ChildDetailClassViewController = self.feedStoryboard.instantiateViewController(withIdentifier: "ChildDetailClassViewController") as! ChildDetailClassViewController
            controller.view.frame = CGRect(x: 0, y: 0, width: self.textView.frame.width, height: self.textView.frame.height)
            if self.textViewAddCheck == false {
                self.addChild(controller)
                self.textView.addSubview(controller.view)
                controller.view.snp.makeConstraints{ (make) in
                    make.top.bottom.leading.trailing.equalTo(self.textView)
                }
                self.textViewAddCheck = true
            }
            controller.didMove(toParent: self)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DetailClassIdSend"), object: self.class_id)
            self.tab1DataChange = false
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 커리큘럼 데이터를 바꿔주는 함수
     
     - Throws: `Error` 뷰 데이터가 존속되어있지 않은 경우 `Error`
     */
    func detailClassData() {
        let textViewY = self.textView.frame.origin.y
        
        self.textView1.isHidden = true
        self.textView2.isHidden = true
        self.textView3.isHidden = true
        self.textView4.isHidden = true
        self.textView5.isHidden = true
        if self.tableViewCheck == 1{
            if self.tab1DataChange == true{
                FeedApi.shared.appClassData(class_id:class_id,success: { [unowned self] result in
                    Indicator.hideActivityIndicator(uiView: self.view)
                    if result.code == "200"{
                        FeedDetailManager.shared.feedDetailList = result
                        moveToClass()
                    }else if result.code == "102"{
                        Alert.With(self, title: "클래스 가입이 되지 않았습니다.", btn1Title: "확인", btn1Handler: {
                            self.deinitObserve()
                            self.navigationController?.popViewController(animated: true)
                        })
                    }else if result.code == "103"{
                        Alert.With(self, title: "서비스 기간이 만료되었습니다.", btn1Title: "확인", btn1Handler: {
                            self.deinitObserve()
                            self.navigationController?.popViewController(animated: true)
                        })
                    }else if result.code == "106"{ /**this response code will open 1:1 training info page*/
                        if self.viewCheck == 1{
                            let newViewController = UIStoryboard(name: "ChildWebView", bundle: nil).instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                            newViewController.url = result.results!.url!
                            newViewController.tokenCheck = false
                            newViewController.classOpenCheck = true
                            Indicator.hideActivityIndicator(uiView: self.view)
                            self.viewCheck = 2
                            self.navigationController?.pushViewController(newViewController, animated: true)
                            
                        }else{
                            self.deinitObserve()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else if result.code == "107"{ /**this response code will open 첫인사 page*/
                        if self.viewCheck == 1{
                            FeedDetailManager.shared.feedDetailList = result
                            moveToClass()
                            let newViewController = UIStoryboard(name: "ChildWebView", bundle: nil).instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                            newViewController.url = result.results!.url!
                            newViewController.tokenCheck = false
                            newViewController.classOpenCheck = true
                            Indicator.hideActivityIndicator(uiView: self.view)
                            self.viewCheck = 2
                            self.navigationController?.pushViewController(newViewController, animated: true)
                        }else{
                            self.deinitObserve()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }) { error in
                    Indicator.hideActivityIndicator(uiView: self.view)
                    Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                    })
                }
            }else{
                let controller: ChildDetailClassViewController = feedStoryboard.instantiateViewController(withIdentifier: "ChildDetailClassViewController") as! ChildDetailClassViewController
                controller.didMove(toParent: self)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DetailClassIdSend"), object: class_id)
            }
        }else if self.tableViewCheck == 2{
            let controller: ChildDetailCurriculumViewController = feedStoryboard.instantiateViewController(withIdentifier: "ChildDetailCurriculumViewController") as! ChildDetailCurriculumViewController
            
            if self.tab2DataChange == true{
                DispatchQueue.main.async {
                    controller.view.frame = CGRect(x: 0, y: 0, width: self.textView.frame.width, height: self.textView.frame.height)
                    if self.textView1AddCheck == false{
                        self.addChild(controller)
                        self.textView1.addSubview(controller.view)
                        controller.view.snp.makeConstraints{ (make) in
                            make.top.bottom.leading.trailing.equalTo(self.textView1)
                        }
                        self.textView1AddCheck = true
                    }
                    DispatchQueue.main.async {
                        self.textView1.frame.origin.y = (self.textView1.frame.origin.y * 4)
                        self.textView1.isHidden = false
                        controller.didMove(toParent: self)
                        UIView.animate(withDuration: 0.3,delay: 0.0, animations: {
                            self.textView1.frame.origin.y = textViewY
                        }, completion: { (isCompleted) in
                        })
                    }
                }
                FeedApi.shared.app_curriculum(class_id:self.class_id,success: { [unowned self] result in
                    if result.code == "200"{
                        FeedDetailManager.shared.feedAppCurriculumModel = result
                        if FeedDetailManager.shared.feedDetailList.results?.user_status ?? "" == "spectator"{
                            controller.freeCheck = true
                        }else{
                            controller.freeCheck = false
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DetailCurriculumSend"), object: self.class_id)
                        self.tab2DataChange = false
                    }
                }) { error in
                    Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                        
                    })
                }
            }else{
                DispatchQueue.main.async {
                    self.textView1.frame.origin.y = (self.textView1.frame.origin.y * 4)
                    self.textView1.isHidden = false
                    controller.didMove(toParent: self)
                    UIView.animate(withDuration: 0.3,delay: 0.0, animations: {
                        self.textView1.frame.origin.y = textViewY
                    }, completion: { (isCompleted) in
                    })
                }
                if FeedDetailManager.shared.feedDetailList.results?.user_status ?? "" == "spectator"{
                    controller.freeCheck = true
                }else{
                    controller.freeCheck = false
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DetailCurriculumSend"), object: self.class_id)
            }
        }else if self.tableViewCheck == 3{
            if self.tab3DataChange == true{
                let controller: ChildDetailReviewViewController = feedStoryboard.instantiateViewController(withIdentifier: "ChildDetailReviewViewController") as! ChildDetailReviewViewController
                controller.view.frame = CGRect(x: 0, y: 0, width: self.textView.frame.width, height: self.textView.frame.height)
                print("textView2AddCheck :", textView2AddCheck)
                if self.textView2AddCheck == false{
                    self.addChild(controller)
                    self.textView2.addSubview(controller.view)
                    controller.view.snp.makeConstraints{ (make) in
                        make.top.bottom.leading.trailing.equalTo(self.textView2)
                    }
                    self.textView2AddCheck = true
                }
                DispatchQueue.main.async {
                    self.textView2.frame.origin.y = (self.textView2.frame.origin.y * 4)
                    self.textView2.isHidden = false
                    controller.didMove(toParent: self)
                    UIView.animate(withDuration: 0.3,delay: 0.0, animations: {
                        self.textView2.frame.origin.y = textViewY
                    }, completion: { (isCompleted) in
                        
                    })
                }
                FeedApi.shared.appMainPilotReviewDashboardV2(class_id: self.class_id, success: { [unowned self] result in
                    FeedDetailManager.shared.reviewDashboardModel = result
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DetailReviewSend"), object: self.class_id)
                    self.tab3DataChange = false
                }) { error in
                    Indicator.hideActivityIndicator(uiView: self.view)
                    Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {

                    })
                }
            }else{
                let controller: ChildDetailReviewViewController = feedStoryboard.instantiateViewController(withIdentifier: "ChildDetailReviewViewController") as! ChildDetailReviewViewController
                DispatchQueue.main.async {
                    self.textView2.frame.origin.y = (self.textView2.frame.origin.y * 4)
                    self.textView2.isHidden = false
                    controller.didMove(toParent: self)
                    UIView.animate(withDuration: 0.3,delay: 0.0, animations: {
                        self.textView2.frame.origin.y = textViewY
                    }, completion: { (isCompleted) in
                        
                    })
                }
            }
        }else if self.tableViewCheck == 4{
            if self.tab4DataChange == true{
                let controller: ChildDetailIntroViewController = feedStoryboard.instantiateViewController(withIdentifier: "ChildDetailIntroViewController") as! ChildDetailIntroViewController
                controller.view.frame = CGRect(x: 0, y: 0, width: self.textView.frame.width, height: self.textView.frame.height)
                if self.textView3AddCheck == false{
                    self.addChild(controller)
                    self.textView3.addSubview(controller.view)
                    controller.view.snp.makeConstraints{ (make) in
                        make.top.bottom.leading.trailing.equalTo(self.textView3)
                    }
                    self.textView3AddCheck = true
                }
                DispatchQueue.main.async {
                    self.textView3.frame.origin.y = (self.textView3.frame.origin.y * 4)
                    self.textView3.isHidden = false
                    controller.didMove(toParent: self)
                    UIView.animate(withDuration: 0.3,delay: 0.0, animations: {
                        self.textView3.frame.origin.y = textViewY
                    }, completion: { (isCompleted) in
                        
                    })
                }
                
                FeedApi.shared.app_cheer(class_id: self.class_id) { result in
                    FeedDetailManager.shared.feedAppCheerModel = result
                    NotificationCenter.default.post(name: NSNotification.Name("DetailCheerSend"), object: self.class_id)
                    self.tab4DataChange = false
                } fail: { error in
                    
                }

                
            }else{
                let controller: ChildDetailIntroViewController = feedStoryboard.instantiateViewController(withIdentifier: "ChildDetailIntroViewController") as! ChildDetailIntroViewController
                DispatchQueue.main.async {
                    self.textView3.frame.origin.y = (self.textView3.frame.origin.y * 4)
                    self.textView3.isHidden = false
                    controller.didMove(toParent: self)
                    UIView.animate(withDuration: 0.3,delay: 0.0, animations: {
                        self.textView3.frame.origin.y = textViewY
                    }, completion: { (isCompleted) in
                        
                    })
                }
            }
        } else if self.tableViewCheck == 5 {
            let controller: ShareAppViewController = feedStoryboard.instantiateViewController(withIdentifier: "ShareAppViewController") as! ShareAppViewController
            controller.share_point = self.share_point
            controller.share_address = self.share_address
            controller.share_img = self.share_img ?? ""
            controller.share_content = self.share_content
            controller.class_photo = self.class_photo
            controller.class_name = self.class_name
            controller.class_id = self.class_id
            
            controller.view.frame = CGRect(x: 0, y: 0, width: self.textView.frame.width, height: self.textView.frame.height)
            if self.textView4AddCheck == false{
                self.addChild(controller)
                self.textView4.addSubview(controller.view)
                self.textView4.isHidden = false
                controller.view.snp.makeConstraints{ (make) in
                    make.top.bottom.leading.trailing.equalTo(self.textView4)
                }
                self.textView4AddCheck = true
            }
            DispatchQueue.main.async {
                self.textView4.frame.origin.y = (self.textView4.frame.origin.y * 4)
                self.textView4.isHidden = false
                controller.didMove(toParent: self)
                UIView.animate(withDuration: 0.3,delay: 0.0, animations: {
                    self.textView4.frame.origin.y = textViewY
                }, completion: { (isCompleted) in
                    
                })
            }
            
        } else {
            if tab5DataChange == true {
                let controller = feedStoryboard.instantiateViewController(withIdentifier: "ChildDetailDescriptionViewController") as! ChildDetailDescriptionViewController
                controller.feedDetailList = self.feedDetailList

                controller.view.frame = CGRect(x: 0, y: 0, width: self.textView.frame.width, height: self.textView.frame.height)
                if self.textView5AddCheck == false{
                    self.addChild(controller)
                    self.textView5.addSubview(controller.view)
                    self.textView5.isHidden = false
                    controller.view.snp.makeConstraints{ (make) in
                        make.top.bottom.leading.trailing.equalTo(self.textView5)
                    }
                    self.textView5AddCheck = true
                }
                DispatchQueue.main.async {
                    self.textView5.frame.origin.y = (self.textView5.frame.origin.y * 4)
                    self.textView5.isHidden = false
                    controller.didMove(toParent: self)
                    UIView.animate(withDuration: 0.3,delay: 0.0, animations: {
                        self.textView5.frame.origin.y = textViewY
                    }, completion: { (isCompleted) in
                        
                    })
                }
                FeedApi.shared.appClassData(class_id:class_id) { result in
                    FeedDetailManager.shared.feedDetailList = result
                    NotificationCenter.default.post(name: NSNotification.Name("ClassDescriptionSend"), object: self.class_id)
                    self.tab5DataChange = false
                } fail: { error in
                    Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                        print("api hatosiiiiiiii 55555555")
                    })
                }
                
            } else {
                let controller = feedStoryboard.instantiateViewController(withIdentifier: "ChildDetailDescriptionViewController") as! ChildDetailDescriptionViewController
                DispatchQueue.main.async {
                    self.textView5.frame.origin.y = (self.textView5.frame.origin.y * 4)
                    self.textView5.isHidden = false
                    controller.didMove(toParent: self)
                    UIView.animate(withDuration: 0.3,delay: 0.0, animations: {
                        self.textView5.frame.origin.y = textViewY
                    }, completion: { (isCompleted) in
                        
                    })
                }
            }
            
        }
    }
}

extension FeedDetailViewController:BMPlayerDelegate{
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 플레이어 상태 변경 감지 함수
     
     - Parameters:
         - player: 플레이어
         - state: 플레이어 상태
     
     - Throws: `Error` 비디오가 없는데 타는 경우 `Error`
     */
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        switch state {
        case .readyToPlay:
            if let duration = self.player?.avPlayer?.currentItem?.asset.duration {
                let seconds = CMTimeGetSeconds(duration)
                self.duration = Int(seconds)
                FeedApi.shared.playTracking(duration : self.duration,curriculum_id: self.curriculum_id ,success: { result in
                    if result.code == "200"{
                    }
                }) { error in
                }
            }
            break
        default:
            break
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 플레이어 비디오 로드된 시간 감지 함수
     
     - Parameters:
         - player: 플레이어
         - loadedDuration: 비디오 로드 시간
         - totalDuration: 비디오 총 시간
     
     - Throws: `Error` 비디오가 없는데 타는 경우 `Error`
     */
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 플레이어 비디오 플레이 시간 감지 함수
     
     - Parameters:
         - player: 플레이어
         - currentTime: 현재 플레이 시간
         - totalTime: 비디오 총 플레이 시간
     
     - Throws: `Error` 비디오가 없는데 타는 경우 `Error`
     */
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        if trakingTime > 9{
            let user_id = UserManager.shared.userInfo.results?.user?.id ?? 0
            if FeedDetailManager.shared.feedDetailList.results?.user_status ?? "" == "spectator" {
                FeedApi.shared.playTrackingTimeSpectator(class_id: self.class_id, user_id: user_id, success: { result in
                    }) { error in
                        print("Error in POST for playTrackingTimeSpectator API: \(String(describing: error))")
                }
            } else {
                FeedApi.shared.playTrackingTime(user_id: user_id , duration : Int(currentTime),curriculum_id: self.curriculum_id ,success: { result in
                }) { error in
                }
            }
            trakingTime = 0
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 플레이어 비디오 플레이 시간 감지 함수
     
     - Parameters:
         - player: 플레이어
         - playing: 플레이 재생 유무
     
     - Throws: `Error` 비디오가 없는데 타는 경우 `Error`
     */
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        if playing == true{
            if "\(UserDefaultSetting.getUserDefaultsString(forKey: videoPlayUrl) ?? "")" == loadUrl{
                player.seek(UserDefaultSetting.getUserDefaultsDouble(forKey: videoPlayTime))
            }
            UserDefaultSetting.setUserDefaultsString("", forKey: videoPlayUrl)
            UserDefaultSetting.setUserDefaultsDouble(0.0, forKey: videoPlayTime)
            print("123123123")
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        }else{
            timer?.invalidate()
            timer = nil
            trakingTime = 0
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 플레이어 비디오 플레이 풀 스크린 감지
     
     - Parameters:
         - player: 플레이어
         - isFullscreen: 풀스크린 여부
     
     - Throws: `Error` 비디오가 없는데 타는 경우 `Error`
     */
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 비디오 플레이 시간 체크 함수
     
     - Throws: `Error` 타이머가 없는데 타는 경우 `Error`
     */
    @objc func onTimerFires(){
        trakingTime = trakingTime + 1
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 앱이 백그라운드로 넘어갈 시에 타는 함수
     
     - Parameters:
        - notification: 백그라운드 변수
     
     - Throws: `Error` 앱이 죽을경우 `Error`
     */
    @objc func applicationDidEnterBackground(_ notification: Notification?) {
        if FeedDetailManager.shared.feedDetailList.results?.curriculum?.background_play_yn ?? "N" == "Y"{
            UIView.animate(withDuration: 0.0, delay: 0.01, options: [], animations: {
                self.player?.playerLayer!.playerLayer?.player = nil
            }) { (finished) in
                self.setNowPlayingInfo()
                self.setupRemoteTransportControls()
            }
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 앱이 백그라운드에서 포그라운드로 넘어올 시에 타는 함수
     
     - Parameters:
        - notification: 백그라운드 변수
     
     - Throws: `Error` 앱이 죽을경우 `Error`
     */
    @objc func applicationWillEnterForeground(_ notification: Notification?) {
        if FeedDetailManager.shared.feedDetailList.results?.curriculum?.background_play_yn ?? "N" == "Y"{
            UIView.animate(withDuration: 0.0, delay: 0.01, options: [], animations: {
                self.player?.playerLayer!.playerLayer?.player = self.player?.playerLayer?.player
            }) { (finished) in
                self.deinitNowPlayingInfo()
            }
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 앱 백그라운드 오디오 플레이에 값을 넘기기 위한 함수
     
     - Throws: `Error` 앱이 죽을경우 `Error`
     */
    func setNowPlayingInfo(){
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        let title = "\(FeedDetailManager.shared.feedDetailList.results?.curriculum?.title ?? "클래스톡")"
        let album = ""
        let image = UIImage(named: "app_icon")
        let artwork = MPMediaItemArtwork(boundsSize: image!.size) { size in
            return image!
        }
        
        self.player?.avPlayer?.allowsExternalPlayback = true
        self.player?.playerLayer?.player?.allowsExternalPlayback = true
        
        if let duration = self.player?.avPlayer?.currentItem?.asset.duration {
            let seconds = CMTimeGetSeconds((duration))
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
            nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = album
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = Float(seconds)
            nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0//Double((self.player.avPlayer?.rate)!)
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0//Double((self.player.avPlayer?.rate)!)
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Float((self.player?.playerLayer?.player?.currentItem!.currentTime().seconds)!)
            nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = NSNumber(value: MPNowPlayingInfoMediaType.video.rawValue)
            
            nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
            
        }
        
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 앱 백그라운드 오디오 플레이에 값을 새로고쳐 넘기기 위한 함수
     
     - Throws: `Error` 앱이 죽을경우 `Error`
     */
    func updateNowPlayingInfo(){
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        if let duration = self.player?.avPlayer?.currentItem?.asset.duration {
            let seconds = CMTimeGetSeconds((duration))
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = Float(seconds)
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Float((self.player?.playerLayer?.player?.currentItem!.currentTime().seconds)!)
        }
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 앱 백그라운드 오디오 플레이에 리모트를 컨트롤 하기 위한 함수
     
     - Throws: `Error` 앱이 죽을경우 `Error`
     */
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.isEnabled = true
        
        let skipBackwardCommand = commandCenter.skipBackwardCommand
        skipBackwardCommand.isEnabled = true
        skipBackwardCommand.addTarget(handler: skipBackward)
        skipBackwardCommand.preferredIntervals = [15]
        
        let skipForwardCommand = commandCenter.skipForwardCommand
        skipForwardCommand.isEnabled = true
        skipForwardCommand.addTarget(handler: skipForward)
        skipForwardCommand.preferredIntervals = [15]
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player?.avPlayer?.rate == 0.0 {
                //            if 0.0 == 0.0 {
                self.player?.play()
                self.updateNowPlayingInfo()
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player?.avPlayer?.rate == 1.0 {
                //            if 1.0 == 1.0 {
                self.player?.pause()
                self.updateNowPlayingInfo()
                return .success
            }
            return .commandFailed
        }
        
//          슬라이더
//        commandCenter.changePlaybackPositionCommand.addTarget { [weak self](remoteEvent) -> MPRemoteCommandHandlerStatus in
//            guard let self = self else {return .commandFailed}
//            self.player.pause()
//            if let player = self.player {
//                if let event = remoteEvent as? MPChangePlaybackPositionCommandEvent {
//                    player.seek(event.positionTime)
//                    self.player.seek(event.positionTime, completion: {
//                        self.setNowPlayingInfo()
//                        self.player.play()
//                    })
//                    return .success
//                }
//            }
//            return .commandFailed
//        }
// Register to receive events
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 앱 백그라운드 오디오 플레이에 리모트를 컨트롤을 삭제 하기 위한 함수
     
     - Throws: `Error` 앱이 죽을경우 `Error`
     */
    func deinitNowPlayingInfo(){
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "클래스톡"
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = 0
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 0
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        self.deinitsetupRemoteTransportControls()
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 앱 백그라운드 오디오 플레이에 리모트를 컨트롤을 삭제 하기 위한 함수
     
     - Throws: `Error` 앱이 죽을경우 `Error`
     */
    func deinitsetupRemoteTransportControls(){
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.skipBackwardCommand.isEnabled = false
        commandCenter.skipForwardCommand.isEnabled = false
        commandCenter.skipBackwardCommand.isEnabled = false
        commandCenter.skipForwardCommand.isEnabled = false
        commandCenter.playCommand.isEnabled = false
        commandCenter.pauseCommand.isEnabled = false
        
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 앱 백그라운드 오디오 플레이에 시간을 뒤로감기 위한 함수
     
     - Parameters:
     - event: 오디오 플레이 이벤트
     
     - Throws: `Error` 앱이 죽을경우 `Error`
     */
    func skipBackward(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        guard let command = event.command as? MPSkipIntervalCommand else {
            return .noSuchContent
        }
        
        let interval = command.preferredIntervals[0]
        let checkTime = Double((self.player?.playerLayer?.player?.currentItem!.currentTime().seconds)!)
        self.player?.pause()
        self.player?.seek(TimeInterval(truncating: (NSNumber(value: checkTime-Double(truncating: interval)))), completion: {
            self.updateNowPlayingInfo()
            self.player?.play()
        })
        return .success
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 앱 백그라운드 오디오 플레이에 시간을 앞으로 감기 위한 함수
     
     - Parameters:
     - event: 오디오 플레이 이벤트
     
     - Throws: `Error` 앱이 죽을경우 `Error`
     */
    func skipForward(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        guard let command = event.command as? MPSkipIntervalCommand else {
            return .noSuchContent
        }
        
        let interval = command.preferredIntervals[0]
        let checkTime = Double((self.player?.playerLayer?.player?.currentItem!.currentTime().seconds)!)
        self.player?.pause()
        self.player?.seek(TimeInterval(truncating: (NSNumber(value: checkTime+Double(truncating: interval)))), completion: {
            self.updateNowPlayingInfo()
            self.player?.play()
        })
        
        return .success
    }
    
}

extension FeedDetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        CustomPresentationViewController(presentedViewController: presented, presenting: presenting)
    }
}
