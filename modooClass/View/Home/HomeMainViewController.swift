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
    
    let homeViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    let childWebViewStoryboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    let feedStoryboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
    let chattingStoryboard: UIStoryboard = UIStoryboard(name: "ChattingWebView", bundle: nil)
    let alarmStoryboard: UIStoryboard = UIStoryboard(name: "Alarm", bundle: nil)
    let window = UIApplication.shared.keyWindow
    let height:CGFloat = 326
    
    var pageControl: UIPageControl?
    var pendingPage: Int?
    var transparentView = UIView()
    var tableView = UITableView()
    var inFirstResponder:Bool = false
    var isShown:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FeedApi.shared.event_list(success: { result in
            
            if result.code! == "200"{
                FeedDetailManager.shared.eventModel = result
                
            }else{
                
            }
        }) { error in
//            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
//
//            })
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.isScrollEnabled = tableView.contentSize.height > tableView.frame.height
        
        versionCheck()
        openPopupVC()
        
        let storyboard = UIStoryboard(name: "Home2WebView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HMPageViewController") as! HMPageViewController
        
        vc.view.frame = CGRect(x: 0, y: 0, width: self.childView.frame.width, height: self.childView.frame.height)
        
        self.addChild(vc)
        self.childView.addSubview(vc.view)
        vc.view.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalTo(self.childView)
        }
        vc.didMove(toParent: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.homeTitleChange), name: NSNotification.Name(rawValue: "homeTitleChange"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.home2MainChatBadgeChange), name: NSNotification.Name(rawValue: "home2MainChatBadgeChange"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.home2MainAlarmBadgeChange), name: NSNotification.Name(rawValue: "home2MainAlarmBadgeChange"), object: nil )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        Analytics.setAnalyticsCollectionEnabled(false)
        let chatBadgeCheck = UserDefaultSetting.getUserDefaultsInteger(forKey: chattingBadgeValue)
        if chatBadgeCheck > 0 {
            messageNew.isHidden = false
        }else{
            messageNew.isHidden = true
        }
        let alarmBadgeCheck = UserDefaultSetting.getUserDefaultsInteger(forKey: alarmBadgeValue)
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
            self.searchBtn.isHidden = true
        }else if index == 1{
            self.pageTitle.text = "내강좌"
            self.tabImg2.image = UIImage(named: "class_iconV2_Active")
            self.tabLbl2.textColor = UIColor(hexString:"#1a1a1a")
            self.searchBtn.isHidden = false
        }else if index == 2{
            self.pageTitle.text = "새소식"
            self.tabImg3.image = UIImage(named: "tok_iconV2_active")
            self.tabLbl3.textColor = UIColor(hexString:"#1a1a1a")
            self.searchBtn.isHidden = false
        }else if index == 3{
            self.pageTitle.text = "내정보"
            self.tabImg4.image = UIImage(named: "profile_iconV2_active")
            self.tabLbl4.textColor = UIColor(hexString:"#1a1a1a")
            self.searchBtn.isHidden = false
        }else{
            
        }
    }
    
    func openPopupVC(){
        let newRootVC = homeViewStoryboard.instantiateViewController(withIdentifier: "PopupShowViewController") as! PopupShowViewController

        let lastEventSeen = UserDefaults.standard.object(forKey: "lastDate") as? Date ?? Date.distantPast
        let currentTime = Date() //newRootVC.popUpOpenDate
    
         if Calendar.current.compare(currentTime, to: lastEventSeen, toGranularity: .day) == .orderedDescending {
            UserDefaultSetting.setUserDefaultsObject(currentTime, forKey: "lastDate")
        
         let nc = UINavigationController(rootViewController: newRootVC)
         nc.navigationBar.isHidden = true
         navigationController?.present(nc, animated: true)
         print("current time: \(currentTime)\nLast event seen: \(lastEventSeen)")
        }
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
                    print("Scroll to top function called")
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
                    print("Scroll to top function called")
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
         
        if inFirstResponder == true {
            onClickView()
        } else {
            window?.bringSubviewToFront(storyView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickView))
            self.view.addGestureRecognizer(tapGesture)
            transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
            transparentView.frame = CGRect(x: 0, y: 0, width: self.storyView.frame.width, height: self.storyView.frame.height)
            window?.addSubview(transparentView)
            transparentView.snp.makeConstraints { (make) in
                make.top.bottom.leading.trailing.equalTo(self.storyView)
            }
            
            let screenSize = self.storyView.frame.size
            tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
            window?.addSubview(tableView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.transparentView.alpha = 0.5
                self.tabImg5.transform = CGAffineTransform(rotationAngle: .pi/4)
                self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
            }, completion: nil)
            inFirstResponder = true
        }
    }
    
    
    @objc func onClickView() {
        let screenSize = view.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
            self.tabImg5.transform = CGAffineTransform(rotationAngle: 0)
        }, completion: nil)
        window?.sendSubviewToBack(storyView)
        inFirstResponder = false
    }
    
    @objc func homeTitleChange(notification:Notification){
        if let temp = notification.object {
            tabCheck(index: temp as? Int ?? 1)
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
        let alarmBadgeCheck = UserDefaultSetting.getUserDefaultsInteger(forKey: alarmBadgeValue)
        if alarmBadgeCheck > 0 {
            alarmNew.isHidden = false
        }else{
            alarmNew.isHidden = true
        }
    }
    
    @IBAction func messageBtnClicked(_ sender: UIButton) {
        print("messageBtnClicked")
        let newViewController = self.chattingStoryboard.instantiateViewController(withIdentifier: "ChattingWebViewController") as! ChattingWebViewController
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
     
        cell.settingImage.sd_setImage(with: URL(string: "\(FeedDetailManager.shared.eventModel.results?.event_list_arr[row].image ?? "no data")"))
            
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
            return 110
        case 1,2,3:
            return 72
        default:
            return 72
        }
    }
}
