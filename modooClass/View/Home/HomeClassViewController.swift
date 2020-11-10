//
//  HomeClassViewController.swift
//  modooClass
//
//  Created by 조현민 on 2019/12/26.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import Firebase

class HomeClassViewController: UIViewController {
    
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    let childWebViewStoryboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    let feedStoryboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
    @IBOutlet weak var checkingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if HomeMain2Manager.shared.pilotAppMain.results == nil{
            DispatchQueue.main.async {
                self.appMainPilotList()
            }
        }
        tableView.addSubview(refreshControl)
        pushCheck()
    }
    
    //이 뷰에서만 네비게이션 안보이게 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tableView.reloadData()
    }
    
    //이 뷰를 벗어나면 네비게이션 보이게 설정
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /** **뷰가 나타나고 타는 메소드 */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.setScreenName("내강좌", screenClass: "HomeClassViewController")
    }
    /** **뷰가 사라지고 타는 메소드 */
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    
    func pushCheck(){
        if APPDELEGATE?.firstExecPushType == 0 {
            if APPDELEGATE?.push_type == 0{ // 웹앱
                let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                newViewController.url = APPDELEGATE?.push_url ?? ""
                self.navigationController?.pushViewController(newViewController, animated: true)
                APPDELEGATE?.firstExecPushType = 100
            }else if APPDELEGATE?.push_type == 1{ // 클래스디테일 수업
                let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                newViewController.class_id = APPDELEGATE?.mcClass_id ?? 0
                newViewController.pushGubun = 1
                self.navigationController?.pushViewController(newViewController, animated: true)
                APPDELEGATE?.firstExecPushType = 100
            }else if APPDELEGATE?.push_type == 2{ // 클래스 디테일 커뮤니티
                let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                newViewController.class_id = APPDELEGATE?.mcClass_id ?? 0
                newViewController.comment_id = APPDELEGATE?.mcComment_id ?? 0
                newViewController.pushGubun = 2
                self.navigationController?.pushViewController(newViewController, animated: true)
                APPDELEGATE?.firstExecPushType = 100
            }else if APPDELEGATE?.push_type == 3{ // 댓글창
                let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "DetailReplyViewController") as! DetailReplyViewController
                newViewController.comment_id = APPDELEGATE?.mcComment_id ?? 0
                newViewController.curriculum_id = APPDELEGATE?.mcCurriculum_id ?? 0
                newViewController.class_id = APPDELEGATE?.mcClass_id ?? 0
                
                if APPDELEGATE?.mcCurriculum_id ?? 0 == 0{
                    newViewController.commentType = "class"
                }else{
                    newViewController.commentType = "curriculum"
                    newViewController.curriculum_id = APPDELEGATE?.mcCurriculum_id ?? 0
                }
                self.navigationController?.pushViewController(newViewController, animated: true)
                APPDELEGATE?.firstExecPushType = 100
            }else if APPDELEGATE?.push_type == 4{ // 친구
                let storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
                if APPDELEGATE?.friend_id ?? 0 > 0 {
                    newViewController.user_id = APPDELEGATE?.friend_id ?? 0
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }
                APPDELEGATE?.firstExecPushType = 100
            }else if APPDELEGATE?.push_type == 5{
                APPDELEGATE?.firstExecPushType = 100
            }else if APPDELEGATE?.push_type == 6{
                let storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
                if APPDELEGATE?.friend_id ?? 0 > 0 {
                    newViewController.user_id = APPDELEGATE?.friend_id ?? 0
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }
                APPDELEGATE?.firstExecPushType = 100
            }else if APPDELEGATE?.push_type == 7{
                let storyboard: UIStoryboard = UIStoryboard(name: "Alarm", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "AlarmViewController") as! AlarmViewController
                self.navigationController?.pushViewController(newViewController, animated: true)
                APPDELEGATE?.firstExecPushType = 100
            }else if APPDELEGATE?.push_type == 8{ // 메세지
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabbarIndexChange"), object: 1)
                let time = DispatchTime.now() + .seconds(1)
                DispatchQueue.main.asyncAfter(deadline: time) {
                    let newViewController = self.childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                    newViewController.url = APPDELEGATE?.push_url ?? ""
                    APPDELEGATE?.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: true)
                    APPDELEGATE?.firstExecPushType = 100
                }
            }else{
                APPDELEGATE?.firstExecPushType = 100
            }
        }
    }
    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func classManagerQuestionBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        if HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[tag].chat_link ?? "" != ""{
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[tag].chat_link ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func classManagerBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        print(tag)
        if HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[tag].manager_link ?? "" != ""{
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[tag].manager_link ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    @IBAction func classMemberListBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        if HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[tag].memberAddress ?? "" != ""{
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[tag].memberAddress ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func classAttendBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        
        tableView.beginUpdates()
        HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[tag].button_point1 = ""
        tableView.endUpdates()
        if HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[tag].wait_page ?? "" != "" {
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[tag].wait_page ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        } else {
            let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
            newViewController.class_id = HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[tag].class_id ?? 0
            newViewController.pushGubun = 1
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func reviewWriteBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        if HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr[tag].review_address ?? "" != ""{
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr[tag].review_address ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func classRePurchaseBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr[tag].payment_address ?? ""
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func classRecommendBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        if HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr[tag].category ?? "" != ""{
            let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedbackSearchViewController") as! FeedbackSearchViewController
            newViewController.searchWord = HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr[tag].category ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    
    @IBAction func myProfileBtnClicked(_ sender: UIButton) {
        if sender.tag == 1 {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveToProfilePage"), object: nil)
            }
        } else {
            let newViewController = home2WebViewStoryboard.instantiateViewController(withIdentifier: "HomeProfileViewController") as! HomeProfileViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func notificationBtnClicked(_ sender: UIButton) {
        let url = HomeMain2Manager.shared.pilotAppMain.results?.app_notice_link ?? ""
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = url
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func classGuideBtnClicked(_ sender: UIButton) {
        if HomeMain2Manager.shared.pilotAppMain.results?.guide_address ?? "" != ""{
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = HomeMain2Manager.shared.pilotAppMain.results?.guide_address ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func classInBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        if HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[tag].status ?? 0 == 6 || HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[tag].status ?? 0 == 9 {
            let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
            newViewController.class_id = HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[tag].id ?? 0
            newViewController.pushGubun = 1
            self.navigationController?.pushViewController(newViewController, animated: true)
        } else {
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[tag].manager_link ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func favouriteClassInBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        if tag != 0 {
            let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
            newViewController.class_id = tag
            newViewController.pushGubun = 1
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func classFavoriteRecommendBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        if HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[tag].category ?? "" != ""{
            let newViewController = feedStoryboard.instantiateViewController(withIdentifier: "FeedbackSearchViewController") as! FeedbackSearchViewController
            newViewController.searchWord = HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[tag].category ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func classScrapBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        if HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[tag].favorites_status ?? "" == "Y"{
            Alert.With(self, title: "알림", content: "스크랩을 정말 취소하시겠습니까?", btn1Title: "취소", btn1Handler: {}, btn2Title: "확인", btn2Handler: {
                self.haveSave(sender: sender)
            })
        }else{
            self.haveSave(sender: sender)
        }
        
    }
    
    @IBAction func interestTabMoveBtnClicked(_ sender: UIButton) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "home2TabbarIndexChange"), object: 0)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "home2TabMove"), object: 0)
    }
}

extension HomeClassViewController{
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 해당 클래스에 찜을하거나 찜을 취소하는 함수
     
     - Parameters:
        - sender: 버튼 태그값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func haveSave(sender:UIButton){
        let tag = sender.tag
        let class_id = HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[tag].class_id ?? 0
        var type = ""
        if HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[tag].favorites_status ?? "" == "Y"{
            type = "delete"
        }else{
            type = "post"
        }
        
        FeedApi.shared.class_have(class_id:class_id,type:type,success: { [unowned self] result in
            if result.code == "200"{
                if HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[tag].favorites_status ?? "" == "Y"{
                    HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[tag].favorites_status = "N"
                    sender.setImage(UIImage(named:"search_scrap_icon_defaultV2"), for: .normal)
                }else{
                    HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[tag].favorites_status = "Y"
                    sender.setImage(UIImage(named:"search_scrap_icon_activeV2"), for: .normal)
                }
                self.tableView.reloadData()
            }
        }) { error in
            
        }
    }
    
    func appMainPilotList(){
        FeedApi.shared.appMainPilotV2(success: { [unowned self] result in
            
            if result.code! == "200"{
                HomeMain2Manager.shared.pilotAppMain = result
                self.endOfWork()
            }else{
                
            }
        }) {
            error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                self.endOfWork()
            })
        }
        
        ProfileApi.shared.profileList(success: { [unowned self] result in
            if result.code! == "200"{
                HomeMain2Manager.shared.profileModel = result
                print(self.view.frame)
            }
        }) { error in
        }
    }
    
    func scrollViewBestRank(cell:HomeClassTableViewCell,row:Int){
        let subViews = cell.class_best_scrollview.subviews
        let viewWidth = Int(cell.class_best_scrollview.bounds.width)
        let viewHeight = Int(cell.class_best_scrollview.bounds.height)
        var indexCount = 0
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        cell.class_best_scrollview.contentSize.width = CGFloat(viewWidth)
        cell.class_best_scrollview.contentSize.height = CGFloat((HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].week_best_list.count)!*viewHeight)
        for temp in (HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].week_best_list)! {
            let subView = UIView(frame: CGRect(x: 0, y: (viewHeight*indexCount), width: viewWidth, height: viewHeight))
            let bestLable = UILabel(frame: CGRect.zero)
            bestLable.text = "\(indexCount+1). \(temp.user_name ?? "") \(temp.total_point ?? 0)점"
            bestLable.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
            bestLable.textAlignment = .left
            bestLable.sizeToFit()
            bestLable.textColor = UIColor(hexString: "#757575")
            bestLable.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
            subView.addSubview(bestLable)
            bestLable.leadingAnchor.constraint(equalTo: subView.leadingAnchor).isActive = true
            bestLable.trailingAnchor.constraint(equalTo: subView.trailingAnchor).isActive = true
            bestLable.topAnchor.constraint(equalTo: subView.topAnchor).isActive = true
            bestLable.bottomAnchor.constraint(equalTo: subView.bottomAnchor).isActive = true
            indexCount = indexCount + 1
            cell.class_best_scrollview.addSubview(subView)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.handleScroll()
    }
        
    func handleScroll() {
        if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows, indexPathsForVisibleRows.count > 0 {
            var focusCell: HomeClassTableViewCell?
            
            for indexPath in indexPathsForVisibleRows {
                if let cell = tableView.cellForRow(at: indexPath) as? HomeClassTableViewCell {
                    if indexPath.section == 2{
                        if focusCell == nil {
                            let rect = tableView.rectForRow(at: indexPath)
                            if tableView.bounds.contains(rect) {
                                if HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[indexPath.row].week_best_list.count ?? 0 > 1{
                                    DispatchQueue.main.async {
                                        let seconds = Double(HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[indexPath.row].week_best_list.count ?? 0) * 3 + 3
                                        if (HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[indexPath.row].week_best_list.count)! == 2 {
                                            UIView.animateKeyframes(withDuration: seconds, delay: 0, options: [.repeat], animations: {
                                                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0) {
                                                    cell.class_best_scrollview.contentOffset.y = 0
                                                }
                                                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.05) {
                                                    cell.class_best_scrollview.contentOffset.y = cell.class_best_scrollview.frame.height
                                                }
                                            }, completion: nil)
                                        }else if (HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[indexPath.row].week_best_list.count)! == 3{
                                            UIView.animateKeyframes(withDuration: seconds, delay: 0, options: [.repeat], animations: {
                                                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0) {
                                                    cell.class_best_scrollview.contentOffset.y = 0
                                                }
                                                UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.05) {
                                                    cell.class_best_scrollview.contentOffset.y = cell.class_best_scrollview.frame.height
                                                }
                                                UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.05) {
                                                    cell.class_best_scrollview.contentOffset.y = cell.class_best_scrollview.frame.height*2
                                                }
                                            }, completion: nil)
                                        }else if (HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[indexPath.row].week_best_list.count)! == 4{
                                                UIView.animateKeyframes(withDuration: seconds, delay: 0, options: [.repeat], animations: {
                                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0) {
                                                        cell.class_best_scrollview.contentOffset.y = 0
                                                    }
                                                    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.05) {
                                                        cell.class_best_scrollview.contentOffset.y = cell.class_best_scrollview.frame.height
                                                    }
                                                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.05) {
                                                        cell.class_best_scrollview.contentOffset.y = cell.class_best_scrollview.frame.height*2
                                                    }
                                                    UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.05) {
                                                        cell.class_best_scrollview.contentOffset.y = cell.class_best_scrollview.frame.height*2
                                                    }
                                                }, completion: nil)
                                        }else{
                                            UIView.animateKeyframes(withDuration: seconds, delay: 0, options: [.repeat], animations: {
                                                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.0) {
                                                    cell.class_best_scrollview.contentOffset.y = 0
                                                }
                                                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.05) {
                                                    cell.class_best_scrollview.contentOffset.y = cell.class_best_scrollview.frame.height
                                                }
                                                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.05) {
                                                    cell.class_best_scrollview.contentOffset.y = cell.class_best_scrollview.frame.height*2
                                                }
                                                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.05) {
                                                    cell.class_best_scrollview.contentOffset.y = cell.class_best_scrollview.frame.height*3
                                                }
                                                UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.05) {
                                                    cell.class_best_scrollview.contentOffset.y = cell.class_best_scrollview.frame.height*4
                                                }
                                            }, completion: nil)
                                        }
                                    }
                                }
                                focusCell = cell
                            } else {
                                cell.contentView.layer.removeAllAnimations()
//                                cell.class_best_scrollview.layer.removeAllAnimations()
//                                cell.class_best_scrollview.contentOffset.y = 0
                            }
                        } else {
                            cell.contentView.layer.removeAllAnimations()
//                            cell.class_best_scrollview.layer.removeAllAnimations()
//                            cell.class_best_scrollview.contentOffset.y = 0
                        }
                    }
                }
            }
        }
    }
}

extension HomeClassViewController : UITableViewDelegate,UITableViewDataSource{
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 스크롤이 멈췄을시 타는 함수
     
     - Parameters:
        - scrollView: 스크롤뷰 관련 된 처리 가능하도록 스크롤뷰 넘어옴
     
     - Throws: `Error` 스크롤이 이상한 값으로 넘어올 경우 `Error`
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.handleScroll()
        if refreshControl.isRefreshing {
            DispatchQueue.main.async {
                
                HomeMain2Manager.shared.pilotAppMain = PilotModel()
                HomeMain2Manager.shared.pilotRecommendMain = PilotRecommendModel()
                self.appMainPilotList()
            }
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 새로고침 컨트롤이 끝났을때 타는 함수
     
     - Throws: `Error` 새로고침이 끝나지 않는 경우 `Error`
     */
    func endOfWork() {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func emptyCheck() -> Bool{
        var empty = false
        if HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr.count ?? 0 == 0 && HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr.count ?? 0 == 0 && HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr.count ?? 0 == 0 && HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr.count ?? 0 == 0{
            empty = true
        }else{
            empty = false
        }
        return empty
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            if emptyCheck(){
                return 0
            }else{
                if HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr.count ?? 0 > 0{
                    return HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr.count ?? 0
                }else{
                    return 0
                }
            }
            
        case 2:
            if emptyCheck(){
                return 0
            }else{
                if HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr.count ?? 0 > 0{
                    return 1
                }else{
                    return 0
                }
            }
        case 3:
            if emptyCheck(){
                return 0
            }else{
                if HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr.count ?? 0 > 0{
                    return HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr.count ?? 0
                }else{
                    return 0
                }
            }
        case 4:
            if emptyCheck(){
                return 0
            }else{
                if HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr.count ?? 0 > 0{
                    return 1
                }else{
                    return 0
                }
            }
        case 5:
            if emptyCheck(){
                return 0
            }else{
                if HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr.count ?? 0 > 0{
                    return HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr.count ?? 0
                }else{
                    return 0
                }
            }
        case 6:
            if emptyCheck(){
                return 0
            }else{
                if HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr.count ?? 0 > 0{
                    return 1
                }else{
                    return 0
                }
            }
        case 7:
            if HomeMain2Manager.shared.pilotAppMain.results != nil{
                if emptyCheck(){
                    return 0
                }else{
                    if HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr.count ?? 0 > 0{
                        return HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr.count ?? 0
                    }else{
                        return 0
                    }
                }
            }else{
                return 0
            }
        case 8:
            if HomeMain2Manager.shared.pilotAppMain.results != nil{
                if emptyCheck(){
                    return 1
                }else{
                    return 0
                }
            }else{
                return 0
            }
            
        case 9:
            if HomeMain2Manager.shared.pilotAppMain.results != nil{
                return 1
            }else{
                return 0
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMainClassTitleCell", for: indexPath) as! HomeClassTableViewCell
            
            cell.classTitle.text = "\(HomeMain2Manager.shared.pilotAppMain.results?.user_info?.user_name ?? "")님\n반갑습니다."
            cell.userImage.sd_setImage(with: URL(string: "\(HomeMain2Manager.shared.pilotAppMain.results?.user_info?.user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
            cell.iconLevelImg.sd_setImage(with: URL(string: "\(HomeMain2Manager.shared.pilotAppMain.results?.user_info?.level_info?.level_icon ?? "")"))
            cell.userBackgroundImg.sd_setImage(with: URL(string: "\(HomeMain2Manager.shared.pilotAppMain.results?.user_info?.level_info?.level_icon ?? "")"))
            cell.classTitle.font = cell.classTitle.font.withSize(20)
            if HomeMain2Manager.shared.pilotAppMain.results?.app_notice_link ?? "" != ""{
                cell.notificationBtn.isHidden = false
                cell.notificationBtn.setTitle(" 📢  "+"\(HomeMain2Manager.shared.pilotAppMain.results?.app_notice ?? "")"+"  ", for: .normal)
            } else {
                cell.notificationBtn.isHidden = true
            }
            if HomeMain2Manager.shared.pilotAppMain.results?.guide_address ?? "" != ""{
                cell.classTitleBtn.isHidden = false
            }else{
                cell.classTitleBtn.isHidden = true
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeClassManagerCell", for: indexPath) as! HomeClassTableViewCell
            cell.selectionStyle = .none
            if HomeMain2Manager.shared.pilotAppMain.results != nil{
                cell.classImg.sd_setImage(with: URL(string: "\(HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[row].class_photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.className.text = "\(HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[row].class_short_name ?? "")"
                if HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[row].class_signup_data ?? 0 > 0 {
                    cell.classMember.text = "수강인원 \(HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[row].class_signup_data ?? 0)명"
                } else {
                    cell.classMember.isHidden = true
                }
                
                if HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[row].coach_wait_cnt ?? 0 > 0{
                    cell.managerReplyView.isHidden = false
                }else{
                    cell.managerReplyView.isHidden = true
                }
                cell.replyCount.text = "\(HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[row].coach_wait_cnt ?? 0)"
                cell.classManagerBtn.tag = row
                cell.classManagerBtn.setTitle("\(HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[row].button_text2 ?? "")", for: .normal)
                cell.classManagerQuestionBtn.tag = row
                cell.classManagerQuestionBtn.setTitle("\(HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[row].button_text1 ?? "")", for: .normal)
                cell.classInBtn.tag = row
            }
            return cell
       case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeClassTitleCell", for: indexPath) as! HomeClassTableViewCell
            if HomeMain2Manager.shared.pilotAppMain.results != nil{
                cell.classTitle.text = "클래스 참여하기"
                cell.classTitle.font = cell.classTitle.font.withSize(18)
                cell.classTitleBtn.isHidden = true
            }
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFeedMyClassCell", for: indexPath) as! HomeClassTableViewCell
            
            if HomeMain2Manager.shared.pilotAppMain.results != nil{
                if HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr.count ?? 0 > 0{
                
                    let progressNum:CGFloat = CGFloat(Double((HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].mission_per ?? 0))/Double(100))
                    let golePoint:CGFloat = CGFloat(Double((HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].week_mission_per ?? 0))/Double(100))
                    let circleView = CircleProgressBar().circleAddProgress(width:cell.class_progress_view.frame.width,height:cell.class_progress_view.frame.height,progress:progressNum,golePoint:golePoint,action:false)
                    for subview in cell.class_progress_view.subviews {
                        subview.removeFromSuperview()
                    }
                    cell.class_progress_view.addSubview(circleView)
                    cell.class_progress_view.bringSubviewToFront(cell.class_progress_inView)
                    circleView.translatesAutoresizingMaskIntoConstraints = false
                    circleView.leadingAnchor.constraint(equalTo: cell.class_progress_view.leadingAnchor).isActive = true
                    circleView.trailingAnchor.constraint(equalTo: cell.class_progress_view.trailingAnchor).isActive = true
                    circleView.topAnchor.constraint(equalTo: cell.class_progress_view.topAnchor).isActive = true
                    circleView.bottomAnchor.constraint(equalTo: cell.class_progress_view.bottomAnchor).isActive = true
                    
                    let mission_persent = HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].mission_per ?? 0
                    if mission_persent == 0 {
                        cell.class_group_emoji.image = UIImage(named: "mission_icon1")
                    } else if mission_persent > 0 && mission_persent <= 20 {
                        cell.class_group_emoji.image = UIImage(named: "mission_icon2")
                    } else if mission_persent > 20 && mission_persent <= 40 {
                        cell.class_group_emoji.image = UIImage(named: "mission_icon3")
                    } else if mission_persent > 40 && mission_persent <= 60 {
                        cell.class_group_emoji.image = UIImage(named: "mission_icon4")
                    } else if mission_persent > 60 && mission_persent <= 80 {
                        cell.class_group_emoji.image = UIImage(named: "mission_icon5")
                    } else {
                        cell.class_group_emoji.image = UIImage(named: "mission_icon6")
                    }
                    cell.class_progress_value.text = "\(mission_persent)%"
                    cell.class_group_btn.tag = row
                    cell.class_name.text = HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].class_name ?? ""
                    cell.class_desc.text = "총 \(HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].total_curriculum_cnt ?? 0)강 · 주 \(HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].week_curriculum_cnt ?? 0)회 미션 · "
                    cell.class_desc_progress.text = "진도율 \(HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].progress_rate ?? 0)%"
                    
                    cell.class_my_progress.transform = CGAffineTransform.identity
                    
                    let myProgressNum:CGFloat = CGFloat(Double((HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].progress_rate ?? 0))/Double(100))
                    cell.class_my_progress.progress = Float(myProgressNum)
                    cell.class_my_progress.layer.cornerRadius = 2
                    cell.class_my_progress.clipsToBounds = true

                    // Set the rounded edge for the inner bar
                    cell.class_my_progress.layer.sublayers![1].cornerRadius = 2
                    cell.class_my_progress.subviews[1].clipsToBounds = true
                    
                    cell.class_my_progress.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
                    
                    cell.class_group_mamber_count.text = "멤버 \(HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].group_member_count ?? 0)"
                    cell.coachImg.sd_setImage(with: URL(string: "\(HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].coach_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                    cell.class_participation_btn.tag = row
                    cell.class_participation_btn1.tag = row
                    if HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].button_point1 ?? "" != "0" && HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].button_point1 ?? "" != ""{
                        cell.class_new_count.isHidden = false
                        cell.class_new_count_badge.isHidden = false
                        cell.class_new_count.text = "\(HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].button_point1 ?? "")"
                    }else{
                        cell.class_new_count_badge.isHidden = true
                        cell.class_new_count.isHidden = true
                    }
                    
                    let days = HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].openDday ?? -1
                    if days <= 0{
                        if HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].end_date ?? 0 >= 300{
                            cell.class_week.text = "무료"
                        }else{
                            cell.class_week.text = "  \(HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].end_date ?? 0)일 남음  "
                        }
                        cell.class_open_view.isHidden = true
                    }else{
                        cell.class_week.text = " \(HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].start_date ?? "10/17") 시작 "
                        cell.class_open_view.isHidden = false
                        cell.class_open_dDay.text = "D-\(days)"
                    }
                    if HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].week_best_list.count ?? 0 > 0 && HomeMain2Manager.shared.pilotAppMain.results?.class_list_arr[row].week_best_list != nil{
                        cell.class_week_best_view.isHidden = false
                        scrollViewBestRank(cell: cell, row: row)
                        cell.class_best_scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    }else{
                        cell.class_week_best_view.isHidden = true
                    }
                }
                cell.layoutIfNeeded()
            }
            
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeClassTitleCell", for: indexPath) as! HomeClassTableViewCell
            if HomeMain2Manager.shared.pilotAppMain.results != nil{
                cell.classTitle.text = "클래스를 평가해주세요."
                cell.classTitle.font = cell.classTitle.font.withSize(18)
                cell.classTitleBtn.isHidden = true
            }
            cell.selectionStyle = .none
            return cell
        case 5:
            var cell = tableView.dequeueReusableCell(withIdentifier: "HomeClassReview2Cell", for: indexPath) as! HomeClassTableViewCell
            if HomeMain2Manager.shared.pilotAppMain.results != nil{
                if HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr[row].type ?? 0 == 2{
                    cell = tableView.dequeueReusableCell(withIdentifier: "HomeClassReview1Cell", for: indexPath) as! HomeClassTableViewCell
                }else{
                    cell.classRecommendBtn.tag = row
                }
                
                cell.classImg.sd_setImage(with: URL(string: "\(HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr[row].class_photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.className.text = "\(HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr[row].class_name ?? "")"
//                review_wait : 작성하기 , coach_wait : 작성완료 , coach_send : 답변도착
                cell.reviewWriteCompleteBtn.setTitle("리뷰쓰기", for: .normal)
                if HomeMain2Manager.shared.pilotAppMain.results?.class_review_arr[row].review_star_status ?? "" == "helpful"{
                    cell.classReviewStar1.image = UIImage(named: "like_btn_with_title")
                }else{
                    cell.classReviewStar1.image = UIImage(named: "dislike_btn_with_title")
                }
                
                cell.reviewWriteBtn.tag = row
                cell.classRePurchaseBtn.tag = row
                
            }
            
            cell.selectionStyle = .none
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeClassTitleCell", for: indexPath) as! HomeClassTableViewCell
            if HomeMain2Manager.shared.pilotAppMain.results != nil{
                cell.classTitle.text = "관심 클래스"
                cell.classTitle.font = cell.classTitle.font.withSize(18)
                cell.classTitleBtn.isHidden = true
            }
            cell.selectionStyle = .none
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeClassInterestCell", for: indexPath) as! HomeClassTableViewCell
            if HomeMain2Manager.shared.pilotAppMain.results != nil{
                cell.classImg.sd_setImage(with: URL(string: "\(HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[row].class_photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.className.text = "\(HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[row].class_short_name ?? "")"
                cell.classMember.text = "총 \(HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[row].curriculum_cnt ?? 0)강 주 \(HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[row].week_mission_cnt ?? 0)회 미션"
                cell.classFavoriteRecommendBtn.tag = row
                cell.classParticipateBtn.tag = HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[row].class_id ?? 0
                cell.classScrapBtn.tag = row
                if HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[row].favorites_status ?? "" == "Y"{
                    cell.classScrapBtn.setImage(UIImage(named:"search_scrap_icon_activeV2"), for: .normal)
                }else{
                    cell.classScrapBtn.setImage(UIImage(named:"search_scrap_icon_defaultV2"), for: .normal)
                }
                cell.classInBtn.tag = HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[row].class_id ?? 0
            }
            cell.selectionStyle = .none
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeClassEmptyCell", for: indexPath) as! HomeClassTableViewCell
            
            cell.selectionStyle = .none
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeClassInterestMoveCell", for: indexPath) as! HomeClassTableViewCell
            
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeClassInterestMoveCell", for: indexPath) as! HomeClassTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
