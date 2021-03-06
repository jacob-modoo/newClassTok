//
//  HomeMainViewController.swift
//  modooClass
//
//  Created by 조현민 on 2019/12/27.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import Firebase

class HomeMainViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var alarmNew: UIImageView!
    @IBOutlet weak var alarmBtn: UIButton!
    @IBOutlet weak var messageNew: UIImageView!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var pageTitle: UIFixedLabel!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tabImg1: UIImageView!
    @IBOutlet weak var tabImg2: UIImageView!
    @IBOutlet weak var tabImg3: UIImageView!
    @IBOutlet weak var tabImg4: UIImageView!
    @IBOutlet weak var tabLbl1: UILabel!
    @IBOutlet weak var tabLbl2: UILabel!
    @IBOutlet weak var tabLbl3: UILabel!
    @IBOutlet weak var tabLbl4: UILabel!
    @IBOutlet weak var storyView: UIView!
    @IBOutlet weak var tabImg5: UIImageView!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var tabViewBottomHeight: NSLayoutConstraint!
    
    let homeViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    let childWebViewStoryboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    let feedStoryboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
    let chattingStoryboard: UIStoryboard = UIStoryboard(name: "ChattingWebView", bundle: nil)
    let alarmStoryboard: UIStoryboard = UIStoryboard(name: "Alarm", bundle: nil)
    let chatStoryboard: UIStoryboard = UIStoryboard(name: "Chatting", bundle: nil)
    let window = UIApplication.shared.keyWindow
    let user_id =  UserManager.shared.userInfo.results?.user?.id ?? 0
    
    var height:CGFloat = 326
    var eventModel:EventModel?
    var pageControl: UIPageControl?
    var pendingPage: Int?
    var tableView = UITableView()
    var inFirstResponder:Bool = false
    var isShown:Bool = false
    var isProfilePage = false
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.isScrollEnabled = tableView.contentSize.height > tableView.frame.height
        
        deviceCheck()
        versionCheck()
        getDataForEvent()
        
        if UserManager.shared.userInfo.results?.event_yn ?? "" == "Y" {
            openPopupVC()
        }
        let storyboard = UIStoryboard(name: "Home2WebView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HMPageViewController") as! HMPageViewController
        
        vc.view.frame = CGRect(x: 0, y: 0, width: self.childView.frame.width, height: self.childView.frame.height)
        
        self.addChild(vc)
        self.childView.addSubview(vc.view)
        vc.view.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalTo(self.childView)
        }
        vc.didMove(toParent: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openEventPage), name: NSNotification.Name(rawValue: "openEventPage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.homeTitleChange), name: NSNotification.Name(rawValue: "homeTitleChange"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.home2MainChatBadgeChange), name: NSNotification.Name(rawValue: "home2MainChatBadgeChange"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.home2MainAlarmBadgeChange), name: NSNotification.Name(rawValue: "home2MainAlarmBadgeChange"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToPage), name: NSNotification.Name(rawValue: "moveToPage"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        Analytics.setAnalyticsCollectionEnabled(false)
        print("** Home Main View Controller!!!")
        let chatBadgeCheck = UserDefaultSetting.getUserDefaultsInteger(forKey: chattingBadgeValue)
        if chatBadgeCheck > 0 {
            messageNew.isHidden = false
        }else{
            messageNew.isHidden = true
        }
        let alarmBadgeCheck = UserDefaultSetting.getUserDefaultsInteger(forKey: alarmBadgeValue)
        print("** alarmBadgeCheck : \(alarmBadgeCheck)")
        if alarmBadgeCheck > 0 {
            alarmNew.isHidden = false
        }else{
            alarmNew.isHidden = true
        }
        
        tableView.reloadData()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //이 뷰를 벗어나면 네비게이션 보이게 설정
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    deinit {
        print("HomePage deinit")
        NotificationCenter.default.removeObserver(self)
        self.isShown = true
    }
    
    
    @IBAction func tabBtnClicked(_ sender: UIButton) {
        if let childVC = self.children.first as? HMPageViewController {
           // let currentPage = self.children.first as? HomeIntroWebViewController
            let tag = sender.tag
            tabCheck(index: tag)
            print("tag : ",tag)
            if tag == 0{
                onClickView()
                if (childVC.viewControllers?.firstIndex(of: childVC.orderedViewControllers[tag])) == 0 {
                    let webVC = childVC.children.first as? HomeIntroWebViewController
                    webVC?.webView.scrollView.setContentOffset(.zero, animated: true)
                } else {
                    childVC.scrollToViewController(index: 0)
                }
            } else if tag == 1 {
                onClickView()
                childVC.scrollToViewController(index: 1)
            } else if tag == 2 {
                onClickView()
                  if (childVC.viewControllers?.firstIndex(of: childVC.orderedViewControllers[tag])) == 0 {
                    let webVC = childVC.children.first as? HomeFeedWebViewController
                    webVC?.webView.scrollView.setContentOffset(.zero, animated: true)
                } else {
                    childVC.scrollToViewController(index: 2)
                }
                
            } else if tag == 3 {
                onClickView()
                childVC.scrollToViewController(index: 3)
            }
        }
    }
    
    @IBAction func tabPlusBtnClicked(_ sender: UIButton) {
        if FeedDetailManager.shared.eventModel.results?.event_list_arr[0].image ?? "" != ""{
            self.height = 326
        } else {
            self.height = 216
        }
        if inFirstResponder == true {
            onClickView()
        } else {
            self.view.bringSubviewToFront(storyView)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickView))
            storyView.addGestureRecognizer(tapGesture)
            storyView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            
            let screenSize = self.storyView.frame.size
            tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
            self.view.addSubview(tableView)
            self.view.insertSubview(tabView, aboveSubview: tableView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.storyView.alpha = 0.5
                self.tabImg5.transform = CGAffineTransform(rotationAngle: .pi/4)
                self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
            }, completion: nil)
            inFirstResponder = true
        }
    }
    
    @IBAction func messageBtnClicked(_ sender: UIButton) {
        print("messageBtnClicked")
//        let newViewController = self.chattingStoryboard.instantiateViewController(withIdentifier: "ChattingWebViewController") as! ChattingWebViewController
        let newViewController = chatStoryboard.instantiateViewController(withIdentifier: "ChattingViewController") as! ChattingViewController
        UserDefaultSetting.setUserDefaultsInteger(0, forKey: chattingBadgeValue)
        APPDELEGATE?.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        print("searchBtnClicked")
        let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedbackSearchViewController") as! FeedbackSearchViewController
        APPDELEGATE?.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func alarmBtnClicked(_ sender: UIButton) {
        print("alarmBtnClicked")
        let newViewController = alarmStoryboard.instantiateViewController(withIdentifier: "AlarmViewController") as! AlarmViewController
        UserDefaultSetting.setUserDefaultsInteger(0, forKey: alarmBadgeValue)
        APPDELEGATE?.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @objc func onClickView() {
        let screenSize = view.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.storyView.alpha = 0
            self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
            self.tabImg5.transform = CGAffineTransform(rotationAngle: 0)
        }) { _ in
            self.view.sendSubviewToBack(self.storyView)
            self.inFirstResponder = false
        }
        
    }
    
    @objc func homeTitleChange(notification:Notification){
        if let temp = notification.object {
            tabCheck(index: temp as? Int ?? 1)
        }
    }
    
    /** *this moves to required page*/
    @objc func moveToPage(notification: Notification) {
        let index = notification.object as! Int
        tabCheck(index: index)
        if let childVC = self.children.first as? HMPageViewController {
            childVC.scrollToViewController(index: index)
        }
    }
    
    @objc func home2MainChatBadgeChange(notification:Notification){
        let chatBadgeCheck = UserDefaultSetting.getUserDefaultsInteger(forKey: chattingBadgeValue)
        if chatBadgeCheck > 0 {
            messageNew.isHidden = false
        }else{
            messageNew.isHidden = true
        }
    }
    @objc func home2MainAlarmBadgeChange(notification:Notification){
        print("** new alarm : \(notification.object ?? 99)")
        let alarmBadgeCheck = UserDefaultSetting.getUserDefaultsInteger(forKey: alarmBadgeValue)
        if alarmBadgeCheck > 0 {
            alarmNew.isHidden = false
        }else{
            alarmNew.isHidden = true
        }
    }
    
    @objc func openEventPage(notification: Notification){
        let url = UserManager.shared.userInfo.results?.event_link ?? ""
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = url
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func tabCheck(index:Int){
        self.tabImg1.image = UIImage(named: "interest_iconV2")
        self.tabImg2.image = UIImage(named: "class_iconV2")
        self.tabImg3.image = UIImage(named: "tok_iconV2")
        self.tabImg4.image = UIImage(named: "profile_iconV2")
        self.tabImg5.image = UIImage(named: "add_btn")
        self.tabLbl1.textColor = UIColor(hexString:"#767676")
        self.tabLbl2.textColor = UIColor(hexString:"#767676")
        self.tabLbl3.textColor = UIColor(hexString:"#767676")
        self.tabLbl4.textColor = UIColor(hexString:"#767676")
        if index == 0{
            self.pageTitle.text = "클래스"
            self.tabImg1.image = UIImage(named: "interest_iconV2_active")
            self.tabLbl1.textColor = UIColor(hexString:"#1a1a1a")
            self.tabLbl1.font = UIFont.boldSystemFont(ofSize: 10)
            self.searchBtn.isHidden = false
        }else if index == 1{
            self.pageTitle.text = "내강좌"
            self.tabImg2.image = UIImage(named: "class_iconV2_Active")
            self.tabLbl2.textColor = UIColor(hexString:"#1a1a1a")
            self.tabLbl2.font = UIFont.boldSystemFont(ofSize: 10)
            self.searchBtn.isHidden = false
        }else if index == 2{
            self.pageTitle.text = "새소식"
            self.tabImg3.image = UIImage(named: "tok_iconV2_active")
            self.tabLbl3.textColor = UIColor(hexString:"#1a1a1a")
            self.tabLbl3.font = UIFont.boldSystemFont(ofSize: 10)
            self.searchBtn.isHidden = false
        }else if index == 3{
            self.pageTitle.text = "마이프로필"
            self.tabImg4.image = UIImage(named: "profile_iconV2_active")
            self.tabLbl4.textColor = UIColor(hexString:"#1a1a1a")
            self.tabLbl4.font = UIFont.boldSystemFont(ofSize: 10)
            self.searchBtn.isHidden = false
        }else{
            
        }
    }
    
    func openPopupVC(){
        let newRootVC = homeViewStoryboard.instantiateViewController(withIdentifier: "PopupShowViewController") as! PopupShowViewController
        let nc = UINavigationController(rootViewController: newRootVC)
        var lastEventSeen = UserDefaults.standard.object(forKey: "lastDate") as? Date ?? Date.distantPast
        let defaultTime = DateComponents(calendar: Calendar.current, year: 2000, month: 1, day: 1)
        let later = Calendar.current.date(byAdding: .day, value: 7, to: lastEventSeen)
        let currentTime = Date()
        
        if lastEventSeen == defaultTime.date {
            nc.navigationBar.isHidden = true
            navigationController?.present(nc, animated: true)
            FeedApi.shared.popupTracking(hash_id: "\(String(describing: UserManager.shared.userInfo.results?.user?.id))".md5(), success: { result in
            }) { error in
            }
        } else {
            if currentTime >= later! {
                nc.navigationBar.isHidden = true
                navigationController?.present(nc, animated: true)
                lastEventSeen = defaultTime.date! //lastEvenSeen time is changed to defaultTime
                UserDefaultSetting.setUserDefaultsObject(lastEventSeen, forKey: "lastDate")
                FeedApi.shared.popupTracking(hash_id: "\(String(describing: UserManager.shared.userInfo.results?.user?.id))".md5(), success: { result in
                }) { error in
                }
            } else {
                print("PopUp event will be shown after 7 days!!!")
            }
        }
    }
    
    /**
     the func below is used for getting the size of url image
     */
    func sizeOfImageAt(url: URL) -> CGSize? {
            // with CGImageSource we avoid loading the whole image into memory
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }

        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
            return nil
        }

        if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
            let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
            return CGSize(width: width, height: height)
        } else {
            return nil
        }
    }
    
    func deviceCheck() {
        if UIDevice.current.hasNotch {
            self.tabViewBottomHeight.constant = 34
        } else {
            self.tabViewBottomHeight.constant = 0
        }
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
    
    func getDataForEvent() {
//       getting data for event page
        FeedApi.shared.event_list(success: { result in
            if result.code! == "200"{
                FeedDetailManager.shared.eventModel = result
            }else{
            }
        }) { error in
            print("** get: error in calling event_list api")
        }
    }
}

extension HomeMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedDetailManager.shared.eventModel.results?.event_list_arr.count ?? 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        onClickView()
        let url = FeedDetailManager.shared.eventModel.results?.event_list_arr[row].link ?? ""
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = url
        self.navigationController?.pushViewController(newViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let row = indexPath.row
     
        let cellImage = [UIImage(named: ""),UIImage(named: "open_class_icon"), UIImage(named: "coach_studio_icon"), UIImage(named: "story_writing_icon")]
        let url = URL(string: "\(FeedDetailManager.shared.eventModel.results?.event_list_arr[row].image ?? "")")
//        let ratio = (sizeOfImageAt(url: url!)?.width ?? 0)/(sizeOfImageAt(url: url!)?.height ?? 0)
//        let newHeight = (cell.settingImage.frame.width)/ratio
//        cell.settingImage.frame.height =  newHeight
        
        cell.settingImage.sd_setImage(with: url)
        cell.cellImg.image = cellImage[row]
        cell.eventLbl.text = "\(FeedDetailManager.shared.eventModel.results?.event_list_arr[row].title ?? "")"
        cell.pointLbl.text = "\(FeedDetailManager.shared.eventModel.results?.event_list_arr[row].event_text ?? "")"
        
        if FeedDetailManager.shared.eventModel.results?.event_list_arr[row].event_text ?? "" != "" {
            cell.pointLbl.borderWidth = 1
            cell.pointLbl.cornerRadius = 11
            cell.pointLbl.borderColor = UIColor(hexString: "#FF5A5F")
        }
        

        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        switch row {
        case 0:
            if FeedDetailManager.shared.eventModel.results?.event_list_arr[0].image ?? "" != "" {
                return 110
            } else {
                return 0
            }
            
        case 1,2,3:
            return 72
        default:
            return 72
        }
    }
}
