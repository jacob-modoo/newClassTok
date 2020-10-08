//
//  HomeProfileViewController.swift
//  modooClass
//
//  Created by 조현민 on 2019/12/26.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import Firebase

class HomeProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var heightInset:CGFloat?
    var refreshControl = UIRefreshControl()
    var profileDetailList:ProfileModel?
    
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    let childWebViewStoryboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
        if HomeMain2Manager.shared.profileModel.results == nil{
            profileList()
        }
    }
    
    //이 뷰에서만 네비게이션 안보이게 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        Analytics.setScreenName("내정보", screenClass: "HomeProfileViewController")
    }
    /** **뷰가 사라지고 타는 메소드 */
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 스크롤이 멈췄을시 타는 함수
     
     - Parameters:
        - scrollView: 스크롤뷰 관련 된 처리 가능하도록 스크롤뷰 넘어옴
     
     - Throws: `Error` 스크롤이 이상한 값으로 넘어올 경우 `Error`
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            self.tableView.isUserInteractionEnabled = false
            DispatchQueue.main.async {
                if HomeMain2Manager.shared.profileModel.results?.class_member_list_arr.count ?? 0 > 0{
                    if HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr.count ?? 0 > 0{
                        let indexPath = IndexPath(row: 0, section: 2)
                        let cell = self.tableView.cellForRow(at: indexPath) as! HomeProfileTableViewCell
                        let collectionIndexPath = IndexPath(item: 0, section: 0)
                        cell.memberListCollectionView.scrollToItem(at: collectionIndexPath, at: .left, animated: false)
                    }
                }
                HomeMain2Manager.shared.profileModel = ProfileModel()
                self.profileList()
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
        self.tableView.isUserInteractionEnabled = true
    }
    
    func profileList(){
        ProfileApi.shared.profileList(success: { [unowned self] result in
            if result.code! == "200"{
                HomeMain2Manager.shared.profileModel = result
                self.endOfWork()
            }else{
                Alert.With(self, title: "서버 오류 입니다.", btn1Title: "확인", btn1Handler: {
                    self.endOfWork()
                })
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                self.endOfWork()
            })
        }
    }
    
    @IBAction func serviceNprivacyBtnClicked(_ sender: UIButton) {
        var url = ""
        if HomeMain2Manager.shared.profileModel.results != nil{
            if sender.tag == 0{
                url = HomeMain2Manager.shared.profileModel.results?.service_address ?? ""
            }else{
                url = HomeMain2Manager.shared.profileModel.results?.policy_address ?? ""
            }
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = url
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    /** **로그아웃 버튼 클릭 >로그인 화면으로 이동 */
    @IBAction func logoutBtnClicked(_ sender: UIButton) {
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
                    HomeMain2Manager.shared.pilotAppMain = PilotModel()
                    HomeMain2Manager.shared.pilotRecommendMain = PilotRecommendModel()
                    HomeMain2Manager.shared.profileModel = ProfileModel()
                    let nextView = self.loginStoryboard.instantiateViewController(withIdentifier: "LoginNavViewController")
                    nextView.modalPresentationStyle = .fullScreen
                    self.present(nextView, animated:false,completion: nil)
                }
            }else{
                Alert.With(self,title: "인터넷 연결을 확인해주세요.",btn1Title: "확인",btn1Handler: {})
            }
            
        })
        
    }
    
    @IBAction func contentBtnClicked(_ sender: UIButton) {
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        
        let tag = sender.tag
            if tag == 1{
                newViewController.url = "https://www.modooclass.net/class/activityguidance"
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else if tag == 2{
                newViewController.url = HomeMain2Manager.shared.profileModel.results?.payment_link ?? ""
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else if tag == 3{
                newViewController.url = HomeMain2Manager.shared.profileModel.results?.review_link ?? ""
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else if tag == 4{
                newViewController.url = HomeMain2Manager.shared.profileModel.results?.profile_edit_link ?? ""
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else if tag == 5{
                newViewController.url = HomeMain2Manager.shared.profileModel.results?.class_open_link ?? ""
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else{
                if tag <= (HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr.count ?? 0) + 5{
                newViewController.url = HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr[tag-6].link ?? ""
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else{
                if (tag - (HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr.count ?? 0)) == 6{
                    newViewController.url = HomeMain2Manager.shared.profileModel.results?.chat_link ?? ""
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }else if (tag - (HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr.count ?? 0)) == 7{
                    newViewController.url = HomeMain2Manager.shared.profileModel.results?.support_address ?? ""
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }else if (tag - (HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr.count ?? 0)) == 8{
                    
                }else if (tag - (HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr.count ?? 0)) == 10{
                    let url = HomeMain2Manager.shared.pilotAppMain.results?.app_notice_link ?? ""
                    newViewController.url = url
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }
            }
        }
    }
    
    @IBAction func tokenBtnClicked(_ sender: UIButton) {
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = HomeMain2Manager.shared.profileModel.results?.point_link ?? ""
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func withBtnClicked(_ sender: UIButton) {
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = HomeMain2Manager.shared.profileModel.results?.follower_address ?? ""
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func favoriteBtnClicked(_ sender: UIButton) {
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = HomeMain2Manager.shared.profileModel.results?.scrap_link ?? ""
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func switchBtnClicked(_ sender: UIButton) {
        alaramPost(sender: sender)
    }
    
    @IBAction func profileBtnClicked(_ sender: UIButton) {
        let newViewController = home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
        newViewController.user_id = sender.tag
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func pointShowBtnClicked(_ sender: UIButton) {
        let url = HomeMain2Manager.shared.profileModel.results?.level_history_address ?? ""
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = url
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func moveToLevelBtnClicked(_ sender: UIButton) {
        let url = HomeMain2Manager.shared.profileModel.results?.level_info?.level_information_page ?? ""
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = url
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    //    @IBAction func memberPageLeftBtnClicked(_ sender: UIButton) {
//        let indexPath = IndexPath(row: 0, section: 2)
//        let cell = tableView.cellForRow(at: indexPath) as! HomeProfileTableViewCell
//        var page = 0
//        if (HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr.count)!%3 > 0{
//            page = ((HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr.count)!/3) + 1
//        }else{
//            page = (HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr.count)!/3
//        }
//        if cell.pagecontroller.currentPage <= page{
//            if cell.pagecontroller.currentPage > 0{
//                cell.pagecontroller.currentPage = cell.pagecontroller.currentPage - 1
//                cell.memberListPageTitle.text = "\(cell.pagecontroller.currentPage + 1) / \(page)"
//                let collectionIndexPath = IndexPath(item: 0, section: ((cell.pagecontroller.currentPage)*3))
//                cell.memberListCollectionView.scrollToItem(at: collectionIndexPath, at: .left, animated: true)
//            }
//        }
//
//    }
//
//    @IBAction func memberPageRightBtnClicked(_ sender: UIButton) {
//        let indexPath = IndexPath(row: 0, section: 2)
//        let cell = tableView.cellForRow(at: indexPath) as! HomeProfileTableViewCell
//        var page = 0
//        if (HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr.count)!%3 > 0{
//            page = ((HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr.count)!/3) + 1
//        }else{
//            page = (HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr.count)!/3
//        }
//        if cell.pagecontroller.currentPage >= 0{
//            if cell.pagecontroller.currentPage < page{
//                cell.pagecontroller.currentPage = cell.pagecontroller.currentPage + 1
//                cell.memberListPageTitle.text = "\(cell.pagecontroller.currentPage + 1) / \(page)"
//                let collectionIndexPath = IndexPath(item: 0, section: ((cell.pagecontroller.currentPage)*3))
//                cell.memberListCollectionView.scrollToItem(at: collectionIndexPath, at: .left, animated: true)
//            }
//        }
//    }
    
    @IBAction func memberFriendAddBtnClicked(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 2)
        let cell = tableView.cellForRow(at: indexPath) as! HomeProfileTableViewCell
        
        let tag = sender.tag
        if cell.memberList_arr[tag].friend_status ?? "Y" == "Y"{
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            if cell.memberList_arr[tag].link ?? "" != "" {
                newViewController.url = cell.memberList_arr[tag].link ?? ""
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }else{
            friend_add(sender: sender)
        }
    }
    
    @IBAction func friendProfileBtnClicked(_ sender: UIButton) {
        let newViewController = home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
        newViewController.user_id = sender.tag
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    func friend_add(sender: UIButton){
        let indexPath = IndexPath(row: 0, section: 2)
        let cell = tableView.cellForRow(at: indexPath) as! HomeProfileTableViewCell
        let row = sender.tag
        let user_id = cell.memberList_arr[row].user_id ?? 0
        let friend_status = "N"
        FeedApi.shared.friend_add(user_id: user_id,friend_status:friend_status,success: { result in
            if result.code == "200"{
                sender.setImage(UIImage(named: "profile_chat_iconV2"), for: .normal)
                cell.memberList_arr[row].friend_status = "Y"
            }
        }) { error in
        }
    }
    
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 알림 스위치 값 변경 ( 푸쉬메세지 보내기 or 보내지 않기 )
     
    - Parameters:
        - sender: 버튼태그
     
    - Throws: `Error` 값의 타입이 제대로 넘어오지 않을 경우 `Error`
    */
    func alaramPost(sender: UIButton){
        let row = sender.tag
        var type = ""
        var flag = "N"
        var id = 0
        if row == 0{
            type = "app_notify"
            if HomeMain2Manager.shared.profileModel.results != nil{
                if HomeMain2Manager.shared.profileModel.results?.app_notify ?? "N" == "N"{
                    flag = "Y"
                }else{
                    flag = "N"
                }
            }
        }else if row == 1{
            type = "message_notify"
            if HomeMain2Manager.shared.profileModel.results != nil{
                if HomeMain2Manager.shared.profileModel.results?.message_notify ?? "N" == "N"{
                    flag = "Y"
                }else{
                    flag = "N"
                }
            }
        }else{
            type = "class"
            if HomeMain2Manager.shared.profileModel.results != nil{
                if HomeMain2Manager.shared.profileModel.results?.attendClassList_arr[row-2].flag ?? "N" == "N"{
                    flag = "Y"
                }else{
                    flag = "N"
                }
                id = HomeMain2Manager.shared.profileModel.results?.attendClassList_arr[row-2].id ?? 0
            }
        }
            
        ProfileApi.shared.alarmChange(type: type, id: id, flag: flag, success: { result in
            if result.code == "200"{
                if row == 0{
                    HomeMain2Manager.shared.profileModel.results?.app_notify = flag
                }else if row == 1{
                    HomeMain2Manager.shared.profileModel.results?.message_notify = flag
                }else{
                    HomeMain2Manager.shared.profileModel.results?.attendClassList_arr[row-2].flag = flag
                }
                if flag == "N"{
                    sender.setImage(UIImage(named: "switchOffV2"), for: .normal)
                }else{
                    sender.setImage(UIImage(named: "switchOnV2"), for: .normal)
                }
            }else{
                
            }
        }) { error in
            
        }
    }
    
}

extension HomeProfileViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if HomeMain2Manager.shared.profileModel.results != nil{
            switch section {
//            case 0,1,4,6,8,10,11:
            case 0,1,4,8,10,11:
                return 1
            case 2:
                if HomeMain2Manager.shared.profileModel.results != nil{
                    if HomeMain2Manager.shared.profileModel.results?.class_member_list_arr.count ?? 0 > 0{
                        if HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr.count ?? 0 > 0{
                            return 1
                        }else{
                            return 0
                        }
                    }else{
                        return 1
                    }
                }else{
                    return 0
                }
            case 3:
                return 4
            case 5:
                if HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr.count ?? 0 > 0{
                    return (HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr.count)! + 1
                }else{
                    return 1
                }
            case 6,7:
                return 0
//            case 7:
//                if HomeMain2Manager.shared.profileModel.results?.attendClassList_arr.count ?? 0 > 0{
//                    return (HomeMain2Manager.shared.profileModel.results?.attendClassList_arr.count)! + 2
//                }else{
//                    return 2
//                }
            case 9:
                return 4
            default:
                return 0
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileInfoCell", for: indexPath) as! HomeProfileTableViewCell
            //cell.levelProgressRightView.layer.cornerRadius = 4
            //cell.levelProgressLeftView.layer.cornerRadius = 4
            cell.levelProgressView.layer.sublayers![1].cornerRadius = 3
            cell.levelProgressView.subviews[1].clipsToBounds = true
            cell.levelBackground.layer.cornerRadius = 10
            cell.levelBodyView.layer.cornerRadius = 10
            
            let maxPoint = HomeMain2Manager.shared.profileModel.results?.level_info?.next_level_score ?? 0
            let currentPoint = HomeMain2Manager.shared.profileModel.results?.level_info?.level_score ?? 0
            cell.levelProgressView.progress = Float(currentPoint)/Float(maxPoint)
            if cell.levelProgressView.progress > 0 {
                cell.levelProgressLeftView.backgroundColor = UIColor(hexString: "#FF5A5F")
            }
            if cell.levelProgressView.progress == 1.0 {
                cell.levelProgressRightView.backgroundColor = UIColor(hexString: "#FF5A5F")
            }
            cell.levelMainLbl.text = HomeMain2Manager.shared.profileModel.results?.level_info?.level_name ?? ""
            let numberFormat = NumberFormatter()
            numberFormat.numberStyle = .decimal
            if currentPoint != 0 {
                cell.levelPointLbl.text = "\(numberFormat.string(from: NSNumber(value: currentPoint)) ?? "")점"
            } else {
                cell.levelPointLbl.isHidden = true
            }
            
            cell.levelProgressInfoLeftLbl.text = HomeMain2Manager.shared.profileModel.results?.level_info?.level_name ?? ""
            cell.levelPointInfoLbl.text = HomeMain2Manager.shared.profileModel.results?.level_info?.level_benefits ?? ""
            cell.levelProgressInfoRightLbl.text = HomeMain2Manager.shared.profileModel.results?.level_info?.next_level_name ?? ""
            cell.levelImg.sd_setImage(with: URL(string: "\(HomeMain2Manager.shared.profileModel.results?.level_info?.level_icon ?? "")"), placeholderImage: UIImage(named: "level_silver"))
            
            
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileTabCell", for: indexPath) as! HomeProfileTableViewCell
            cell.pointText.text = "\(HomeMain2Manager.shared.profileModel.results?.point ?? "0")"
            cell.withmeCnt.text = "\(HomeMain2Manager.shared.profileModel.results?.follower_count ?? 0)"
            cell.favoriteCnt.text = "\(HomeMain2Manager.shared.profileModel.results?.scrap_count ?? 0)"
            cell.selectionStyle = .none
            return cell
        case 2:
            if HomeMain2Manager.shared.profileModel.results?.class_member_list_arr.count ?? 0 > 0{
                if HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr.count ?? 0 > 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileMemberListCell", for: indexPath) as! HomeProfileTableViewCell
//                    if (HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr.count)!%3 > 0{
//                        cell.memberListPageTitle.text = "1 / \(((HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr.count)!/3)+1)"
//                    }else{
//                        cell.memberListPageTitle.text = "1 / \(((HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr.count)!/3))"
//                    }
//
                    cell.memberListTitle.text = "함께하는 멤버 : \(HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].class_short_name ?? "")"
                    cell.memberListChapter.text = "\(HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].class_group_no ?? 0)기"
                    cell.memberList_arr =  (HomeMain2Manager.shared.profileModel.results?.class_member_list_arr[0].memberList_arr)!
                    cell.callColection()
                    
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "height7cell", for: indexPath)
                    cell.selectionStyle = .none
                    return cell
                }
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "height7cell", for: indexPath)
                cell.selectionStyle = .none
                return cell
            }
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileContentCell", for: indexPath) as! HomeProfileTableViewCell
            cell.contentSubTitle.isHidden = false
            cell.arrowImgWidthConst.constant = 24
            if row == 0{
                cell.contentTitle.text = "장학제도 및 가이드"
                cell.contentSubTitle.isHidden = true
                cell.contentBtn.tag = 1
            }else if row == 1{
                cell.contentTitle.text = "결제내역"
                cell.contentSubTitle.text = "\(HomeMain2Manager.shared.profileModel.results?.payment_count ?? 0)건"
                cell.contentBtn.tag = 2
            }else if row == 2{
                cell.contentTitle.text = "리뷰관리"
                cell.contentSubTitle.text = "\(HomeMain2Manager.shared.profileModel.results?.review_count ?? 0)개"
                cell.contentBtn.tag = 3
            }else if row == 3{
                cell.contentTitle.text = "프로필관리"
                cell.contentSubTitle.isHidden = true
                cell.contentBtn.tag = 4
            }
            
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileTitleCell", for: indexPath) as! HomeProfileTableViewCell
            cell.titleSubject.text = "운영 중인 클래스"
            cell.selectionStyle = .none
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileContentCell", for: indexPath) as! HomeProfileTableViewCell
            cell.contentSubTitle.isHidden = true
            if row == 0{
                cell.contentTitle.text = "클래스 오픈 신청"
                cell.contentBtn.tag = 5
            }else{
                cell.contentTitle.text = "\(HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr[row - 1].class_name ?? "")"
                cell.contentBtn.tag = row + 5
            }
            cell.selectionStyle = .none
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileTitleCell", for: indexPath) as! HomeProfileTableViewCell
            cell.titleSubject.text = "알림 설정"
            cell.selectionStyle = .none
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileSwitchCell", for: indexPath) as! HomeProfileTableViewCell
            if row == 0{
                cell.switchTitle.text = "전체 알림 설정"
                if HomeMain2Manager.shared.profileModel.results?.app_notify ?? "N" == "Y"{
                    cell.switchBtn.setImage(UIImage(named: "switchOnV2"), for: .normal)
                }else{
                    cell.switchBtn.setImage(UIImage(named: "switchOffV2"), for: .normal)
                }
                cell.switchBtn.tag = row
            }else if row == 1{
                cell.switchTitle.text = "메세지 알림"
                if HomeMain2Manager.shared.profileModel.results?.message_notify ?? "N" == "Y"{
                    cell.switchBtn.setImage(UIImage(named: "switchOnV2"), for: .normal)
                }else{
                    cell.switchBtn.setImage(UIImage(named: "switchOffV2"), for: .normal)
                }
                cell.switchBtn.tag = row
            }else{
                cell.switchTitle.text = "\(HomeMain2Manager.shared.profileModel.results?.attendClassList_arr[row-2].class_name ?? "")"
                if HomeMain2Manager.shared.profileModel.results?.attendClassList_arr[row-2].flag ?? "N" == "Y"{
                    cell.switchBtn.setImage(UIImage(named: "switchOnV2"), for: .normal)
                }else{
                    cell.switchBtn.setImage(UIImage(named: "switchOffV2"), for: .normal)
                }
                cell.switchBtn.tag = row
            }
            cell.selectionStyle = .none
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileTitleCell", for: indexPath) as! HomeProfileTableViewCell
            cell.titleSubject.text = "고객 센터"
            cell.selectionStyle = .none
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileContentCell", for: indexPath) as! HomeProfileTableViewCell
            cell.contentSubTitle.isHidden = true
            cell.arrowImgWidthConst.constant = 24
            if row == 0{
                cell.contentTitle.text = "공지사항"
                cell.contentBtn.tag = (HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr.count ?? 0) + 10
            }else if row == 1{
                cell.contentTitle.text = "1:1 문의"
                cell.contentBtn.tag = (HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr.count ?? 0) + 6
            }else if row == 2{
                cell.contentTitle.text = "자주 묻는 질문"
                cell.contentBtn.tag = (HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr.count ?? 0) + 7
            }else if row == 3{
                cell.contentTitle.text = "앱버전 정보"
                cell.contentBtn.tag = (HomeMain2Manager.shared.profileModel.results?.profileManageClass_arr.count ?? 0) + 8
                cell.arrowImgWidthConst.constant = 0
                let infoDictionary = Bundle.main.infoDictionary
                let currentVersion = infoDictionary?["CFBundleShortVersionString"] as? String
                cell.contentSubTitle.isHidden = false
                cell.contentSubTitle.text = "\(currentVersion ?? "1.0.0")"
            }
            
            cell.selectionStyle = .none
            return cell
        case 10:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfilePrivacyCell", for: indexPath) as! HomeProfileTableViewCell
            cell.serviceBtn.tag = 0
            cell.policyBtn.tag = 1
            cell.selectionStyle = .none
            return cell
        case 11:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileLogoutCell", for: indexPath) as! HomeProfileTableViewCell
            
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProfileCell", for: indexPath) as! HomeProfileTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
