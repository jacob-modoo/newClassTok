//
//  AlarmViewController.swift
//  modooClass
//
//  Created by 조현민 on 02/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import WebKit
import SafariServices
import AppsFlyerLib
import Firebase

/**
# AlarmViewController.swift 클래스 설명

## BaseViewController 상속 받음
- 알림 메인 화면을 보기 위한 뷰 컨트롤러
*/
class AlarmViewController: BaseViewController {

    /** **알림 리스트 */
    var alarmList:AlarmModel?
    /** **알림 리스트 배열 */
    var alarmArray:Array = Array<AlarmList>()
    /** **페이지 */
    var page = 1
    /** **새로고침 컨트롤 */
    var refreshControl = UIRefreshControl()
    
    let feedStoryboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
    let childWebViewStoryboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    
    /** **테이블뷰 */
    @IBOutlet weak var tableView: UITableView!
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        tableView.addSubview(refreshControl)
        alarmList = nil
        alarmArray.removeAll()
        page = 1
        self.app_alarm_list()
        NotificationCenter.default.addObserver(self, selector: #selector(self.alarmArrayAdd), name: NSNotification.Name(rawValue: "alarmArrayAddCheck"), object: nil )
        
    }
    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    /** **뷰가 사라지기 시작 할 때 타는 메소드 */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /** **뷰가 나타나고 타는 메소드 */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.logEvent("알림", parameters: [AnalyticsParameterScreenName : "AlarmViewController"])
//        navigationController?.interactivePopGestureRecognizer?.delegate = nil
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    /** **뷰가 사라지고 타는 메소드 */
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 스크롤이 멈췄을시 타는 함수
     
     - Parameters:
        - scrollView: 스크롤뷰 관련 된 처리 가능하도록 스크롤뷰 넘어옴
     
     - Throws: `Error` 스크롤이 이상한 값으로 넘어올 경우 `Error`
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            alarmList = nil
            alarmArray.removeAll()
            page = 1
            app_alarm_list()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.endOfWork()
            }
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 새로고침 컨트롤이 끝났을때 타는 함수
     
     - Throws: `Error` 새로고침이 끝나지 않는 경우 `Error`
     */
    func endOfWork() {
        refreshControl.endRefreshing()
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 알림 리스트 배열에 추가
     
     - Parameters:
        - notification: 오브젝트에 알림 리스트 배열 넘어옴
     
     - Throws: `Error` 값이 이상한 값으로 넘어올 경우 `Error`
     */
    @objc func alarmArrayAdd(notification:Notification){
        let temp = AlarmList.init()
        temp.appnotify_id = APPDELEGATE?.appnotify_id ?? 0
        temp.body = APPDELEGATE?.body ?? ""
        temp.push_type = APPDELEGATE?.push_type ?? 0
        temp.push_url = APPDELEGATE?.push_url ?? ""
        temp.friend_id = APPDELEGATE?.friend_id ?? 0
        temp.mcClass_id = APPDELEGATE?.mcClass_id ?? 0
        temp.mcCurriculum_id = APPDELEGATE?.mcCurriculum_id ?? 0
        temp.mcComment_id = APPDELEGATE?.mcComment_id ?? 0
        temp.read_status = APPDELEGATE?.read_status ?? "N"
        temp.photo = APPDELEGATE?.photo ?? ""
        temp.time_spilled = APPDELEGATE?.time_spilled ?? "0분전"
        temp.friend_name = APPDELEGATE?.friend_name ?? ""
        
        self.alarmArray.insert(temp, at: 0)
        self.tableView.reloadData()
    }
    
    /** **알림 버튼 클릭 > 각각의 연결 뷰로 이동 */
    @IBAction func alarmBtnClicked(_ sender: UIButton) {
        alarm_read(row:sender.tag)
    }
    
    /** **알림 읽기 버튼 클릭 > 전체 알림 읽음 처리 */
    @IBAction func alarmReadAllClicked(_ sender: UIBarButtonItem) {
        alarm_allRead()
    }
    
    @IBAction func backBtnClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func userBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        let newViewController = home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
        if UserManager.shared.userInfo.results?.user?.id == self.alarmArray[tag].friend_id ?? 0 {
            newViewController.isMyProfile = true
        }else{
            newViewController.isMyProfile = false
        }
        newViewController.user_id = self.alarmArray[tag].friend_id ?? 0
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}

extension AlarmViewController:UITableViewDelegate,UITableViewDataSource{
    
    /** **테이블 셀의 섹션당 로우 개수 함수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if alarmArray.count > 0{
            return alarmArray.count
        }else{
            return 1
        }
    }
    
    /** **테이블 셀의 로우 및 섹션 데이터 함수 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if alarmList != nil{
            if alarmArray.count > 0{
                let cell:AlarmTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as! AlarmTableViewCell
                
                if alarmArray[row].read_status ?? "N" == "Y"{
                    cell.backdView.backgroundColor = UIColor(hexString: "#FFFFFF")
                }else{
                    cell.backdView.backgroundColor = UIColor(hexString: "#F4F2FE")
                }
                cell.userPhoto.sd_setImage(with: URL(string: "\(alarmArray[row].photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                
                if alarmArray[row].icon_type ?? 0 == 1{
                    cell.rollGubun.image = UIImage(named: "reply_roll")
                }else if alarmArray[row].icon_type ?? 0 == 2{
                    cell.rollGubun.image = UIImage(named: "friend_roll")
                }else if alarmArray[row].icon_type ?? 0 == 3{
                    cell.rollGubun.image = UIImage(named: "notice_roll")
                }else{
                    cell.rollGubun.image = UIImage(named: "")
                }
                
                cell.userBtn.tag = row
                cell.title.text = alarmArray[row].body ?? ""
                if alarmArray[row].short_name ?? "" == ""{
                    cell.alarmTime.text = "\(alarmArray[row].time_spilled ?? "0분전")"
                }else{
                    cell.alarmTime.text = "\(alarmArray[row].short_name ?? "") • \(alarmArray[row].time_spilled ?? "0분전")"
                }
                cell.alarmBtn.tag = row
                cell.alarmBtn.isUserInteractionEnabled = true
                cell.userPhoto.stopShimmering()
                cell.title.stopShimmering()
                cell.alarmTime.stopShimmering()
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmEmptyCell", for: indexPath)
                cell.selectionStyle = .none
                return cell
            }
        }else{
            let cell:AlarmTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as! AlarmTableViewCell
            cell.alarmBtn.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            return cell
        }
    }
    
    /** **테이블 셀의 높이 함수 */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if alarmList != nil{
            if alarmArray.count > 0{
                return 82
            }else{
                if AppDelegate().deviceType() == 10{
                    return self.tableView.frame.height - 40
                }else{
                    return self.tableView.frame.height
                }
            }
        }else{
            return 82
        }
    }
    
    /** **테이블 셀의 섹션 개수 함수 */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if alarmArray.count - 1 == row {
            if alarmList?.results?.page ?? 0 < alarmList?.results?.total_page ?? 0 {
                self.page = self.page + 1
                app_alarm_list()
            }
        }
    }
}

extension AlarmViewController{
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 알림 리스트 배열 처리
     
    - Throws: `Error` 값의 타입이 제대로 넘어오지 않을 경우 `Error`
    */
    @objc func arrayComplete(completion:@escaping (Bool) -> () ) {
        DispatchQueue.main.async {
            for addArray in 0 ..< (self.alarmList?.results?.alarmList.count ?? 0)! {
                self.alarmArray.append((self.alarmList?.results?.alarmList[addArray])!)
            }
            completion(true)
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 알림 리스트 불러오는 함수
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func app_alarm_list(){
        AlarmApi.shared.alarmList(page:page,success: { [unowned self] result in
            if result.code! == "200"{
                self.alarmList = result
                self.arrayComplete { (status) in
                    if status {
                        self.endOfWork()
                        self.tableView.reloadData()
                    }
                }
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
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 >알림 읽음 처리
     
    - Parameters:
        - row: 배열 순서값
     
    - Throws: `Error` 값의 타입이 제대로 넘어오지 않을 경우 `Error`
    */
    func alarm_read(row:Int){
        let alarm_id = alarmArray[row].appnotify_id ?? 0
        AlarmApi.shared.alarmRead(id:alarm_id,success: { [unowned self] result in
            if result.code! == "200"{
                self.endOfWork()
                for i in 0..<self.alarmArray.count {
                    if self.alarmArray[i].appnotify_id == alarm_id {
                        self.alarmArray[i].read_status = "Y"
                        let indexPath = IndexPath(item: i, section: 0)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        let type = self.alarmArray[row].push_type ?? 100
                        print(type)
                        if type == 0{
                            let newViewController = self.childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                            if self.alarmArray[row].push_url ?? "" != "" {
                                newViewController.url = self.alarmArray[row].push_url ?? ""
                                self.navigationController?.pushViewController(newViewController, animated: true)
                            }
                        }else if type == 1{
//                            let newViewController = self.feedStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
                            if self.alarmArray[row].mcClass_id ?? 0 > 0{
                                self.navigationController?.popOrPushController(class_id: self.alarmArray[row].mcClass_id ?? 0)
//                                newViewController.class_id = self.alarmArray[row].mcClass_id ?? 0
//                                newViewController.pushGubun = 1
//                                self.navigationController?.pushViewController(newViewController, animated: true)
                            }
                            
                        }else if type == 2 || type == 3{//댓글상세
                            print("comment id : \(self.alarmArray[row].mcComment_id ?? 0)")
                            let newViewController = self.feedStoryboard.instantiateViewController(withIdentifier: "DetailReplyViewController") as! DetailReplyViewController
                            newViewController.comment_id = self.alarmArray[row].mcComment_id ?? 0
                            newViewController.class_id = self.alarmArray[row].mcClass_id ?? 0
                            newViewController.noticeCheck = true
                            if self.alarmArray[row].mcCurriculum_id ?? 0 == 0{
                                newViewController.commentType = "class"
                            }else{
                                newViewController.commentType = "curriculum"
                                newViewController.curriculum_id = self.alarmArray[row].mcCurriculum_id ?? 0
                            }
                            self.navigationController?.pushViewController(newViewController, animated: true)
                        }else if type == 5{//홈
                            self.navigationController?.popToRootViewController(animated: true)
                        }else if type == 7{//알림
//                            self.tableView.reloadData()
                        }else if type == 4 || type == 6{
                            print("Home2Webview")
                            let storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
                            let newViewController = storyboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
                            if self.alarmArray[row].friend_id ?? 0 > 0 {
                                if UserManager.shared.userInfo.results?.user?.id == self.alarmArray[row].friend_id ?? 0 {
                                    newViewController.isMyProfile = true
                                }else{
                                    newViewController.isMyProfile = false
                                }
                                newViewController.user_id = self.alarmArray[row].friend_id ?? 0
                                self.navigationController?.pushViewController(newViewController, animated: true)
                            }
                        }else if type == 8{
                            let chattingStoryboard: UIStoryboard = UIStoryboard(name: "ChattingWebView", bundle: nil)
                            let newViewController = chattingStoryboard.instantiateViewController(withIdentifier: "ChattingFriendWebViewViewController") as! ChattingFriendWebViewViewController
                            if self.alarmArray[row].push_url ?? "" != "" {
                                newViewController.url = self.alarmArray[row].push_url ?? ""
                                self.navigationController?.pushViewController(newViewController, animated: true)
                            }
                        }else{
                            let newViewController = self.childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                            if self.alarmArray[row].push_url ?? "" != "" {
                                newViewController.url = self.alarmArray[row].push_url ?? ""
                                self.navigationController?.pushViewController(newViewController, animated: true)
                            }
                        }
                    }
                }
            }else{
                Alert.With(self, title: "서버 오류 입니다.", btn1Title: "확인", btn1Handler: {

                })
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                
            })
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 >알림 전체 읽음 처리
     
    - Throws: `Error` 값의 타입이 제대로 넘어오지 않을 경우 `Error`
    */
    func alarm_allRead(){
        AlarmApi.shared.alarmReadAll(success: { [unowned self] result in
            if result.code! == "200"{
                self.endOfWork()
                for i in 0..<self.alarmArray.count {
                    self.alarmArray[i].read_status = "Y"
                    self.tableView.reloadData()
                }
            }else{
                Alert.With(self, title: "서버 오류 입니다.", btn1Title: "확인", btn1Handler: {
                    
                })
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                
            })
        }
    }
}
