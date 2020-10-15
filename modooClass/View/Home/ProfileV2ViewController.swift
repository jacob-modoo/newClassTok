//
//  ProfileV2ViewController.swift
//  modooClass
//
//  Created by 조현민 on 2020/01/06.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit
import Firebase

class ProfileV2ViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    /** **친구 소개 숨김 유무 */
    var pageOpen:Bool = false
    /** **친구 소개 텍스트뷰 */
    var missionTextView:UITextView?
    /** **프로필 리스트 */
    var profileModel:ProfileV2Model?
    
    /** **새로고침 컨트롤 */
    var refreshControl = UIRefreshControl()
    var user_id = UserManager.shared.userInfo.results?.user?.id ?? 0 //44120
    var isReachingEnd = false
    let childWebViewStoryboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    let chattingStoryboard: UIStoryboard = UIStoryboard(name: "ChattingWebView", bundle: nil)
    
    var page = 1
    var activeTotalPage = 1
    var textLineCount = 0
    var active_comment_list:Array = Array<Active_comment>()
    
    let storyColor = ["#CDDEF2", "#B2C1D2", "#D9DFEE", "#DFDFDF"]
    let missionColor = ["#E6D8DB", "#D4DCD9"]
    let questionColor = ["#DED8D2", "#E6E4D7", "#E2E8D7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ProfileList()
        tableView.addSubview(refreshControl)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadActiveList), name: NSNotification.Name(rawValue: "updateProfileActiveList"), object: nil)
        if HomeMain2Manager.shared.pilotAppMain.results?.user_id ?? 0 == self.user_id {
            self.backBtn.isHidden = true
        }else{
            self.backBtn.isHidden = false
        }
    }
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        Analytics.setScreenName("프로필", screenClass: "ProfileV2ViewController")
    }

    /** **뷰가 사라지고 타는 메소드 */
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
        active_comment_list.removeAll()
    }
    
    @objc func reloadActiveList() {
        active_comment_list.removeAll()
        self.page = 1
        self.ProfileList()
        print("post received!!!")
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 스크롤이 멈췄을시 타는 함수
     
     - Parameters:
        - scrollView: 스크롤뷰 관련 된 처리 가능하도록 스크롤뷰 넘어옴
     
     - Throws: `Error` 스크롤이 이상한 값으로 넘어올 경우 `Error`
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            reloadActiveList()
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
    **파라미터가 없고 반환값이 없는 메소드 > 프로필 리스트 불러오는 함수
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func ProfileList(){
        ProfileApi.shared.profileV2List(user_id: self.user_id, success: { [unowned self] result in
            if result.code == "200"{
                self.profileModel = result
                let width: CGFloat = 200.0
                self.missionTextView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
                let setHeightUsingCSS = "<html><head><style type=\"text/css\"> img{ max-height: 100%; max-width: \(self.view.frame.width - 32); !important; width: auto; height: auto;} </style> </head><body> \(self.profileModel?.results?.user_info?.profile_comment ?? "") </body></html>"
                print(setHeightUsingCSS)
                self.missionTextView!.attributedText = setHeightUsingCSS.html2AttributedString
                self.missionTextView!.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
                
                self.missionTextView!.translatesAutoresizingMaskIntoConstraints = true
                self.missionTextView!.sizeToFit()
                self.missionTextView!.isScrollEnabled = false
                self.missionTextView!.isEditable = false
                self.missionTextView!.isSelectable = false
                
                let textSize = CGSize(width: self.missionTextView!.frame.size.width, height: CGFloat(Float.infinity));
                let rHeight = Float(self.missionTextView!.sizeThatFits(textSize).height)
                var lineCount:Float = 0
                let charSize = Float(self.missionTextView!.font!.lineHeight)
                lineCount = floor(rHeight / charSize)
                self.textLineCount = Int(lineCount)
                
                self.activeList()
            }else{
                print("여기??")
                Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                    self.endOfWork()
                })
            }
        }) { error in
            print("아님 여기???")
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                self.endOfWork()
            })
        }
    }
    
    func activeList(){
        ProfileApi.shared.profileV2ActiveList(user_id: self.user_id,page:self.page, success: { [unowned self] result in
            if result.code == "200"{
//                self.profileModel = result
                self.activeTotalPage = result.results?.active_comment_total_page ?? 0
                for addArray in 0 ..< (result.results?.active_comment_list.count)! {
                    self.active_comment_list.append((result.results?.active_comment_list[addArray])!)
                }
                
                DispatchQueue.main.async {
                    self.endOfWork()
                    self.tableView.reloadData()
                }
            }
        }) { error in
            
        }
    }
    
    func addActiveList(){
        ProfileApi.shared.profileV2ActiveList(user_id: self.user_id,page:self.page, success: { [unowned self] result in
            if result.code == "200"{
                for addArray in 0 ..< (result.results?.active_comment_list.count)! {
                    self.active_comment_list.append((result.results?.active_comment_list[addArray])!)
                }
                DispatchQueue.main.async {
                    self.endOfWork()
                    self.tableView.reloadData()
                }
            }
        }) { error in
            
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 >친구 추가 or 삭제 함수
     
     - Parameters:
        - sender: 버튼 태그
     
    - Throws: `Error` 값의 타입이 제대로 넘어오지 않을 경우 `Error`
    */
    func friend_add(sender: UIButton){
        let user_id = sender.tag
        let friend_status = profileModel?.results?.user_info?.friend_status ?? "N"
        
        
        if friend_status == "Y"{
            self.profileModel?.results?.user_info?.friend_status = "N"
        }else{
            self.profileModel?.results?.user_info?.friend_status = "Y"
        }
        
        FeedApi.shared.friend_add(user_id: user_id,friend_status:friend_status,success: { [unowned self] result in
            if result.code == "200"{
                let indexPath = IndexPath(row: 0, section: 6)
                if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                    if visibleIndexPaths != NSNotFound {
                        let indexPath = IndexPath(row: 0, section: 6)
                        let cell = self.tableView.cellForRow(at: indexPath) as! ProfileV2TableViewCell//ProfileFriendViewCell
                        if self.profileModel?.results?.user_info?.friend_status ?? "Y" == "Y"{
                            cell.friendAddBtn.backgroundColor = UIColor(hexString: "#F7F7F9")
                            cell.friendAddBtn.layer.borderWidth = 1
                            cell.friendAddBtn.layer.borderColor = UIColor(hexString: "#B4B4B4").cgColor
                            cell.friendAddBtn.setImage(UIImage(named:"profile_friend_delete"), for: .normal)
                            cell.friendAddBtn.setTitle("", for: .normal)
                            cell.friendAddBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        }else{
                            cell.friendAddBtn.backgroundColor = UIColor(hexString: "#FF5A5F")
                            cell.friendAddBtn.layer.borderWidth = 0
                            cell.friendAddBtn.setImage(UIImage(named:"withoutIcon"), for: .normal)
                            cell.friendAddBtn.setTitle("팔로우", for: .normal)
                            cell.friendAddBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                        }
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 1.5, animations: {
                                if self.profileModel?.results?.user_info?.friend_status ?? "Y" == "Y"{
                                    cell.messageBtnWidthConst.constant = 260
                                    cell.messageBtnLeadingConst.constant = 16
                                    cell.messageBtn.isHidden = false
                                    
                                }else{
                                    cell.messageBtnWidthConst.constant = 0
                                    cell.messageBtnLeadingConst.constant = 0
                                    cell.messageBtn.isHidden = true
                                }
                            }, completion: { (success: Bool) -> () in
                                
                            })
                        }
                    }
                }
            }else{
                Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                    self.endOfWork()
                })
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                self.endOfWork()
            })
        }
    }
    
    /** **친구 소개 열기버튼 클릭 > 소개 테이블셀 리로드 */
    @IBAction func pageOpenNCloseBtnClicked(_ sender: UIButton) {
        pageOpen = !pageOpen
        if pageOpen == false {
            sender.setTitle("더보기", for: .normal)
            sender.setImage(UIImage(named: "main_arrow_bottom"), for: .normal)
        }else{
            sender.setTitle("접기", for: .normal)
            sender.setImage(UIImage(named: "main_arrow_top"), for: .normal)
        }
        let indexSet = IndexSet.init(integer: 2)
        self.tableView.reloadSections(indexSet, with: .automatic)
    }
    
    @IBAction func activeMoveBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        DispatchQueue.main.async {
//            let storyboard = UIStoryboard.init(name: "Home2WebView", bundle: nil)
//            let newViewController = storyboard.instantiateViewController(withIdentifier: "StoryDetailViewController") as! StoryDetailViewController
//            newViewController.feedId = self.active_comment_list[tag].comment_id ?? ""
//            self.navigationController?.pushViewController(newViewController, animated: true)
            
            self.navigationController?.storyPopOrPushController(feedId: "\(self.active_comment_list[tag].comment_id ?? "")")
        }
    }
    
    @IBAction func profileLikeBtnClicked(_ sender: UIButton) {
        let row = sender.tag/10000
        let like_yn = sender.tag%10000
        var type = ""
        
        if like_yn == 1{
            type = ""
        }else{
            type = "delete"
        }
        if active_comment_list[row].comment_id ?? "" != ""{ //1 : no , 2 : yes
            ProfileApi.shared.profileV2CommentLike(comment_id: active_comment_list[row].comment_id ?? "", type: type, success: { [unowned self] result in
                if result.code == "200"{
                    if type == "delete"{
                        sender.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                        sender.tag = (row*10000) + 1
                        self.active_comment_list[row].like_cnt = (self.active_comment_list[row].like_cnt ?? 0) - 1
                    }else{
                        sender.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                        sender.tag = (row*10000) + 2
                        self.active_comment_list[row].like_cnt = (self.active_comment_list[row].like_cnt ?? 0) + 1
                    }
                    
                    let indexPath = IndexPath(row: row/3, section: 10)
                    if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                        if visibleIndexPaths != NSNotFound {
                            let indexPath = IndexPath(row: row/3, section: 10)
                            let cell = self.tableView.cellForRow(at: indexPath) as! ProfileV2TableViewCell
                            
                            if row%3 == 0{
                                cell.photoLikeCount1.text = "좋아요 \(self.active_comment_list[row].like_cnt ?? 0)"
                            }else if row%3 == 1{
                                cell.photoLikeCount2.text = "좋아요 \(self.active_comment_list[row].like_cnt ?? 0)"
                            }else{
                                cell.photoLikeCount3.text = "좋아요 \(self.active_comment_list[row].like_cnt ?? 0)"
                            }
                        }
                    }
                    
                }
            }) { error in
            }
        }
    }
    
    @IBAction func informationUpdateBtnClicked(_ sender: UIButton) {
        if self.profileModel?.results?.user_info?.user_id ?? 0 == UserManager.shared.userInfo.results?.user?.id ?? 0{
            if self.profileModel?.results?.profile_edit_address ?? "" != ""{
                let newViewController = home2WebViewStoryboard.instantiateViewController(withIdentifier: "HomeProfileViewController") as! HomeProfileViewController
//                newViewController.url = self.profileModel?.results?.profile_edit_address ?? ""
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
    }
    
    @IBAction func friendAddBtnClicked(_ sender: UIButton) {
        friend_add(sender: sender)
    }
    
    @IBAction func messageBtnClicked(_ sender: UIButton) {
        if self.profileModel?.results?.chat_address ?? "" != ""{
            let newViewController = chattingStoryboard.instantiateViewController(withIdentifier: "ChattingFriendWebViewViewController") as! ChattingFriendWebViewViewController
                newViewController.url = self.profileModel?.results?.chat_address ?? ""
                self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func friendBtnClicked(_ sender: UIButton) {
        if self.profileModel?.results?.friend_address ?? "" != ""{
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = self.profileModel?.results?.friend_address ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func reviewBtnClicked(_ sender: UIButton) {
        print(profileModel?.results?.user_info?.level_info?.level_name ?? "")
        
        if self.profileModel?.results?.review_address ?? "" != ""{
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = self.profileModel?.results?.review_address ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func scrapBtnClicked(_ sender: UIButton) {
        if self.profileModel?.results?.scrap_address ?? "" != ""{
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = self.profileModel?.results?.scrap_address ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func managerBtnClicked(_ sender: UIButton) {
        
        if self.profileModel?.results?.manage_class_list[sender.tag].click_event ?? "" != ""{
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = self.profileModel?.results?.manage_class_list[sender.tag].click_event ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        Alert.WithImageView(self, image: imageView.image!, btn1Title: "", btn1Handler: {
            
        })
    }
}

extension ProfileV2ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func underline() -> NSAttributedString{
        let str = "내 정보"
        let attributedString = NSMutableAttributedString(string: str)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AppleSDGothicNeo-Regular", size: 12.5)!, range: (str as NSString).range(of:str))
//        attributedString.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: (str as NSString).range(of:str))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#b4b4b4") , range: (str as NSString).range(of:str))
//        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: (str as NSString).range(of:str))
        return attributedString
    }
    
    func infoViewSortJob(cell:ProfileV2TableViewCell){
        if profileModel?.results?.user_info?.job_name ?? "" != ""{
            cell.job.text = "  \(profileModel?.results?.user_info?.job_name ?? "")  "
        }else{
            cell.job.text = ""
        }
    }
    
    func infoViewSortAge(cell:ProfileV2TableViewCell){
        if profileModel?.results?.user_info?.birthday_year ?? 0 != 0 {
            cell.age.text = "\(profileModel?.results?.user_info?.level_info?.level_name ?? "") | \(profileModel?.results?.user_info?.birthday_year ?? 0)세  "
        }else{
            cell.age.text = ""
        }
        
    }
    
    func infoViewLevel(cell: ProfileV2TableViewCell) {
        if profileModel?.results?.user_info?.level_info?.level_name ?? "" != "" {
            cell.levelLbl.text = "   \(profileModel?.results?.user_info?.level_info?.level_name ?? "")   "
        } else {
            cell.levelLbl.text = ""
        }
    }
    
    func infoViewSortGender(cell:ProfileV2TableViewCell){
        if profileModel?.results?.user_info?.gender ?? "" == "F"{
            cell.genderText.text = "  여자"
            cell.genderImg.image = UIImage(named:"womanBadge")
        }else if profileModel?.results?.user_info?.gender ?? "" == "M"{
            cell.genderText.text = "  남자"
            cell.genderImg.image = UIImage(named:"manBadge")
        }else{
            cell.genderText.isHidden = true
            cell.genderImg.isHidden = true
        }
    }
    
    func gridView1(cell:ProfileV2TableViewCell , row:Int){
        let checkRow = (row*3)
        if active_comment_list[checkRow].youtu_address ?? "" != ""{
            cell.photoView1.isHidden = false
            cell.noPhotoView1.isHidden = true
            cell.photoBackImage1.sd_setImage(with: URL(string: "\(active_comment_list[checkRow].youtu_image_address ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
            cell.photoLikeCount1.text = "좋아요 \(active_comment_list[checkRow].like_cnt ?? 0)"
            cell.photoPlayImg1.isHidden = false

            cell.photoBtn1.tag = checkRow
            if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.user_id{
                cell.photoLikeBtn1.isHidden = true
            }else{
                cell.photoLikeBtn1.isHidden = false
            }
            if active_comment_list[checkRow].like_status ?? "N" == "N"{
                cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                cell.photoLikeBtn1.tag = (checkRow * 10000) + 1
            }else{
                cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                cell.photoLikeBtn1.tag = (checkRow * 10000) + 2
            }
        }else{
            cell.photoPlayImg1.isHidden = true
            if active_comment_list[checkRow].photo_url ?? "" != "" {
                cell.photoView1.isHidden = false
                cell.noPhotoView1.isHidden = true
                cell.photoBackImage1.sd_setImage(with: URL(string: "\(active_comment_list[checkRow].photo_url ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))

                cell.photoLikeCount1.text = "좋아요 \(active_comment_list[checkRow].like_cnt ?? 0)"

                cell.photoBtn1.tag = checkRow
                if active_comment_list[checkRow].like_status ?? "N" == "N"{
                    cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.photoLikeBtn1.tag = (checkRow * 10000) + 1
                }else{
                    cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.photoLikeBtn1.tag = (checkRow * 10000) + 2
                }
                if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.user_id{
                    cell.photoLikeBtn1.isHidden = true
                }else{
                    cell.photoLikeBtn1.isHidden = false
                }
            }else{
                cell.photoView1.isHidden = true
                cell.noPhotoView1.isHidden = false
                cell.noPhotoProfileText1.text = "\(active_comment_list[checkRow].class_name ?? "")"
                cell.noPhotoLikeCount1.text = "좋아요 \(active_comment_list[checkRow].like_cnt ?? 0)"
                cell.noPhotoUserImg1.sd_setImage(with: URL(string: "\(active_comment_list[checkRow].user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                if active_comment_list[checkRow].type ?? "" == "story"{
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView1.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                }else if active_comment_list[checkRow].type ?? "" == "mission"{
                    let randomIndex = Int(arc4random_uniform(UInt32(missionColor.count)))
                    cell.noPhotoView1.backgroundColor = UIColor(hexString: missionColor[randomIndex])
                }else if active_comment_list[checkRow].type ?? "" == "question"{
                    let randomIndex = Int(arc4random_uniform(UInt32(questionColor.count)))
                    cell.noPhotoView1.backgroundColor = UIColor(hexString: questionColor[randomIndex])
                }else{

                }

                cell.noPhotoBtn1.tag = checkRow
                
                if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.user_id{
                    cell.noPhotoLikeBtn1.isHidden = true
                }else{
                    cell.noPhotoLikeBtn1.isHidden = false
                }
                if active_comment_list[checkRow].like_status ?? "N" == "N"{
                    cell.noPhotoLikeBtn1.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.noPhotoLikeBtn1.tag = (checkRow * 10000) + 1
                }else{
                    cell.noPhotoLikeBtn1.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.noPhotoLikeBtn1.tag = (checkRow * 10000) + 2
                }
            }
        }

    }
    
    func gridView2(cell:ProfileV2TableViewCell , row:Int){
        let checkRow = (row*3)+1
        if active_comment_list[checkRow].youtu_address ?? "" != ""{
            cell.photoView2.isHidden = false
            cell.noPhotoView2.isHidden = true
            cell.photoBackImage2.sd_setImage(with: URL(string: "\(active_comment_list[checkRow].youtu_image_address ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
            cell.photoLikeCount2.text = "좋아요 \(active_comment_list[checkRow].like_cnt ?? 0)"
            cell.photoPlayImg2.isHidden = false
            cell.photoBtn2.tag = checkRow
            if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.user_id{
                cell.photoLikeBtn2.isHidden = true
            }else{
                cell.photoLikeBtn2.isHidden = false
            }
            if active_comment_list[checkRow].like_status ?? "N" == "N"{
                cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                cell.photoLikeBtn2.tag = (checkRow * 10000) + 1
            }else{
                cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                cell.photoLikeBtn2.tag = (checkRow * 10000) + 2
            }
        }else{
            cell.photoPlayImg2.isHidden = true
            if active_comment_list[checkRow].photo_url ?? "" != "" {
                cell.photoView2.isHidden = false
                cell.noPhotoView2.isHidden = true
                cell.photoBackImage2.sd_setImage(with: URL(string: "\(active_comment_list[checkRow].photo_url ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))

                cell.photoLikeCount2.text = "좋아요 \(active_comment_list[checkRow].like_cnt ?? 0)"
                cell.photoBtn2.tag = checkRow
                if active_comment_list[checkRow].like_status ?? "N" == "N"{
                    cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.photoLikeBtn2.tag = (checkRow * 10000) + 1
                }else{
                    cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.photoLikeBtn2.tag = (checkRow * 10000) + 2
                }
                
                if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.user_id{
                    cell.photoLikeBtn2.isHidden = true
                }else{
                    cell.photoLikeBtn2.isHidden = false
                }
            }else{
                cell.photoView2.isHidden = true
                cell.noPhotoView2.isHidden = false
                cell.noPhotoProfileText2.text = "\(active_comment_list[checkRow].class_name ?? "")"
                cell.noPhotoLikeCount2.text = "좋아요 \(active_comment_list[checkRow].like_cnt ?? 0)"
                cell.noPhotoUserImg2.sd_setImage(with: URL(string: "\(active_comment_list[checkRow].user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                if active_comment_list[checkRow].type ?? "" == "story"{
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView2.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                }else if active_comment_list[checkRow].type ?? "" == "mission"{
                    let randomIndex = Int(arc4random_uniform(UInt32(missionColor.count)))
                    cell.noPhotoView2.backgroundColor = UIColor(hexString: missionColor[randomIndex])
                }else if active_comment_list[checkRow].type ?? "" == "question"{
                    let randomIndex = Int(arc4random_uniform(UInt32(questionColor.count)))
                    cell.noPhotoView2.backgroundColor = UIColor(hexString: questionColor[randomIndex])
                }else{

                }
                cell.noPhotoBtn2.tag = checkRow
                if active_comment_list[checkRow].like_status ?? "N" == "N"{
                    cell.noPhotoLikeBtn2.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.noPhotoLikeBtn2.tag = (checkRow * 10000) + 1
                }else{
                    cell.noPhotoLikeBtn2.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.noPhotoLikeBtn2.tag = (checkRow * 10000) + 2
                }
                if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.user_id{
                    cell.noPhotoLikeBtn2.isHidden = true
                }else{
                    cell.noPhotoLikeBtn2.isHidden = false
                }
            }
        }
    }
    
    func gridView3(cell:ProfileV2TableViewCell , row:Int){
        let checkRow = (row*3)+2
        if active_comment_list[checkRow].youtu_address ?? "" != ""{
            cell.photoView3.isHidden = false
            cell.noPhotoView3.isHidden = true
            cell.photoBackImage3.sd_setImage(with: URL(string: "\(active_comment_list[checkRow].youtu_image_address ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
            cell.photoLikeCount3.text = "좋아요 \(active_comment_list[checkRow].like_cnt ?? 0)"
            cell.photoPlayImg3.isHidden = false
            cell.photoBtn3.tag = checkRow
            if active_comment_list[checkRow].like_status ?? "N" == "N"{
                cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                cell.photoLikeBtn3.tag = (checkRow * 10000) + 1
            }else{
                cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                cell.photoLikeBtn3.tag = (checkRow * 10000) + 2
            }
            if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.user_id{
                cell.photoLikeBtn3.isHidden = true
            }else{
                cell.photoLikeBtn3.isHidden = false
            }
        }else{
            cell.photoPlayImg3.isHidden = true
            if active_comment_list[checkRow].photo_url ?? "" != "" {
                cell.photoView3.isHidden = false
                cell.noPhotoView3.isHidden = true
                cell.photoBackImage3.sd_setImage(with: URL(string: "\(active_comment_list[checkRow].photo_url ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))

                cell.photoLikeCount3.text = "좋아요 \(active_comment_list[checkRow].like_cnt ?? 0)"
                cell.photoBtn3.tag = checkRow
                if active_comment_list[checkRow].like_status ?? "N" == "N"{
                    cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.photoLikeBtn3.tag = (checkRow * 10000) + 1
                }else{
                    cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.photoLikeBtn3.tag = (checkRow * 10000) + 2
                }
                if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.user_id{
                    cell.photoLikeBtn3.isHidden = true
                }else{
                    cell.photoLikeBtn3.isHidden = false
                }
            }else{
                cell.photoView3.isHidden = true
                cell.noPhotoView3.isHidden = false
                cell.noPhotoProfileText3.text = "\(active_comment_list[checkRow].class_name ?? "")"
                cell.noPhotoLikeCount3.text = "좋아요 \(active_comment_list[checkRow].like_cnt ?? 0)"
                cell.noPhotoUserImg3.sd_setImage(with: URL(string: "\(active_comment_list[checkRow].user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                if active_comment_list[checkRow].type ?? "" == "story"{
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView3.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                }else if active_comment_list[checkRow].type ?? "" == "mission"{
                    let randomIndex = Int(arc4random_uniform(UInt32(missionColor.count)))
                    cell.noPhotoView3.backgroundColor = UIColor(hexString: missionColor[randomIndex])
                }else if active_comment_list[checkRow].type ?? "" == "question"{
                    let randomIndex = Int(arc4random_uniform(UInt32(questionColor.count)))
                    cell.noPhotoView3.backgroundColor = UIColor(hexString: questionColor[randomIndex])
                }else{

                }
                if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.user_id{
                    cell.noPhotoLikeBtn3.isHidden = true
                }else{
                    cell.noPhotoLikeBtn3.isHidden = false
                }
                cell.noPhotoBtn3.tag = checkRow
                if active_comment_list[checkRow].like_status ?? "N" == "N"{
                    cell.noPhotoLikeBtn3.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.noPhotoLikeBtn3.tag = (checkRow * 10000) + 1
                }else{
                    cell.noPhotoLikeBtn3.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.noPhotoLikeBtn3.tag = (checkRow * 10000) + 2
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.profileModel != nil{
            switch section {
            case 0:
//                if self.profileModel?.results?.user_info?.photo_list.count ?? 0 > 0{
//                    return 1
//                }else{
//                    return 0
//                }
                return 1
            case 2:
                if (self.profileModel?.results?.user_info?.interest_list_list.count ?? 0) > 0{
                    return 1
                }else{
                    return 0
                }
            case 4:
                if self.profileModel?.results?.user_info?.profile_comment ?? "" != ""{
                    return 1
                }else{
                    return 0
                }
            case 5:
                if self.profileModel?.results?.user_info?.profile_comment ?? "" != ""{
                    if textLineCount > 3{
                        return 1
                    }else{
                        return 0
                    }
                }else{
                    return 0
                }
                
            case 6: // 프렌드
                if self.profileModel?.results?.user_info?.user_id ?? 0 != UserManager.shared.userInfo.results?.user?.id ?? 0{
                    if self.profileModel?.results?.user_info?.user_id ?? 0 != 0{
                        return 1
                    }else{
                        return 0
                    }
                }else{
                    return 0
                }
            case 7: // 운영중인 클래스 추후에 다시 오픈
//                if self.profileModel?.results?.manage_class_list.count ?? 0 > 0{
//                    return 1
//                }else{
//                    return 0
//                }
                return 0
            case 8:
                return 0
//                if self.profileModel?.results?.manage_class_list.count ?? 0 > 0{
//                    if (self.profileModel?.results?.manage_class_list.count ?? 0) % 2 == 0{
//                        return (self.profileModel?.results?.manage_class_list.count ?? 0)/2
//                    }else{
//                        return (self.profileModel?.results?.manage_class_list.count ?? 0)/2 + 1
//                    }
//                }else{
//                    return 0
//                }
            case 9:
                return 1
            case 10:
                if (self.active_comment_list.count) > 0{
                    if self.active_comment_list.count % 3 == 0{
                        return self.active_comment_list.count/3
                    }else{
                        return self.active_comment_list.count/3 + 1
                    }
                }else{
                    return 0
                }
            default:
                return 1
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
            let cell:ProfileV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfilePhotoTableViewCell", for: indexPath) as! ProfileV2TableViewCell
            
            if self.profileModel != nil{
                cell.collectionTag = 0
                cell.userImg.sd_setImage(with: URL(string: "\(self.profileModel?.results?.user_info?.user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                cell.iconImg.sd_setImage(with: URL(string: "\(self.profileModel?.results?.user_info?.level_info?.level_icon ?? "")"))
                cell.userBackgroundImg.sd_setImage(with: URL(string: "\(self.profileModel?.results?.user_info?.level_info?.level_icon ?? "")"))
                let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                cell.userImg.addGestureRecognizer(pictureTap)
                cell.user_id = self.profileModel?.results?.user_info?.user_id ?? 0
                cell.user_info = self.profileModel?.results?.user_info
//                cell.imageCollectionView.reloadData()
            cell.callColection()
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell:ProfileV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTitleTableViewCell", for: indexPath) as! ProfileV2TableViewCell
            if self.profileModel != nil{
                cell.nickName.text = "\(profileModel?.results?.user_info?.user_name ?? "")"
//                cell.levelLbl.text = "   \(profileModel?.results?.user_info?.level_info?.level_name ?? "")   "
                
                var index = 0
                var ageCheck = false
                var genderCheck = false
                if profileModel?.results?.user_info?.birthday_year ?? 0 != 0 {
                    index = index + 1
                    ageCheck = true
                }
                if profileModel?.results?.user_info?.job_name ?? "" != ""{
                    index = index + 1
                }
                if profileModel?.results?.user_info?.gender ?? "" != ""{
                    index = index + 1
                    genderCheck = true
                }
                if self.profileModel?.results?.user_info?.user_id ?? 0 != UserManager.shared.userInfo.results?.user?.id ?? 0{
                    cell.user_photo_btn.isHidden = true
                }else{
                    cell.user_photo_btn.isHidden = false
                }
                
                cell.age.text = ""
                cell.job.text = ""
                cell.genderText.text = ""
                cell.genderImg.image = UIImage(named: "manBadge")
                cell.user_photo_btn.setAttributedTitle(underline(), for: .normal)
                if index == 0{
                    cell.age_job_view.isHidden = true
                    cell.job_gender_view.isHidden = true
                    cell.job.isHidden = true
                    cell.age.isHidden = true
                    cell.genderImg.isHidden = true
                    cell.genderText.isHidden = true
                    if user_id == UserManager.shared.userInfo.results?.user?.id ?? 0{
                        cell.profile_emptyBtn.isHidden = false
                    }else{
                        cell.profile_emptyBtn.isHidden = true
                    }
                }else if index == 1{
                    cell.age_job_view.isHidden = true
                    cell.job_gender_view.isHidden = true
                    if genderCheck == true{
                        infoViewSortGender(cell: cell)
                    }else{
                        if ageCheck == true{
                            infoViewSortAge(cell: cell)
                        }else{
                            infoViewSortJob(cell: cell)
                        }
                    }
                }else if index == 2{
                    cell.age_job_view.isHidden = false
                    cell.job_gender_view.isHidden = true
                    if genderCheck == true{
                        if ageCheck == true{
                            infoViewSortAge(cell: cell)
                        }else{
                            infoViewSortJob(cell: cell)
                        }
                        infoViewSortGender(cell: cell)
                    }else{
                        infoViewSortJob(cell: cell)
                        infoViewSortAge(cell: cell)
                    }
                }else if index == 3{
                    infoViewSortJob(cell: cell)
                    infoViewSortAge(cell: cell)
                    infoViewSortGender(cell: cell)
                }
            }
            
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell:ProfileV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileInterestTableViewCell", for: indexPath) as! ProfileV2TableViewCell
            if self.profileModel != nil{
                cell.collectionTag = 1
                cell.user_id = self.profileModel?.results?.user_info?.user_id ?? 0
                cell.interest_list_list = (self.profileModel?.results?.user_info?.interest_list_list)!
                cell.callColection()
                DispatchQueue.main.async {
                    cell.interestCollectionViewHeightConst.constant = cell.interestCollectionView.contentSize.height
                }
            }
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell:ProfileV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2WithoutCell", for: indexPath) as! ProfileV2TableViewCell
            if self.profileModel != nil{
                let str = "\(profileModel?.results?.user_info?.together_cnt ?? 0) 명이 팔로워"
                let attributedString = NSMutableAttributedString(string: str)
                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!, range: (str as NSString).range(of:"\(profileModel?.results?.user_info?.together_cnt ?? 0)"))
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: (str as NSString).range(of:"\(profileModel?.results?.user_info?.together_cnt ?? 0)"))
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#484848") , range: (str as NSString).range(of:"\(profileModel?.results?.user_info?.together_cnt ?? 0)"))
    
                cell.withoutText.attributedText = attributedString
            }
            
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell:ProfileV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2CoachIntroCell", for: indexPath) as! ProfileV2TableViewCell
            if self.profileModel != nil{
                cell.addTextView.addSubview(self.missionTextView!)
                self.missionTextView!.snp.makeConstraints { (make) in
                    make.left.right.equalTo(cell.addTextView)
                }
            }
            cell.selectionStyle = .none
            return cell
        case 5:
            let cell:ProfileV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2CoachMoreCell", for: indexPath) as! ProfileV2TableViewCell
            if pageOpen == false {
                cell.introBtn.setTitle("더보기", for: .normal)
                cell.introBtn.setImage(UIImage(named: "main_arrow_bottom"), for: .normal)
            }else{
                cell.introBtn.setTitle("접기", for: .normal)
                cell.introBtn.setImage(UIImage(named: "main_arrow_top"), for: .normal)
            }
            cell.selectionStyle = .none
            return cell
        
        case 6:
            let cell:ProfileV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileFriendViewCell", for: indexPath) as! ProfileV2TableViewCell
            if self.profileModel != nil{
                cell.friendAddBtn.tag = self.profileModel?.results?.user_info?.user_id ?? 0
                if self.profileModel?.results?.user_info?.friend_status ?? "Y" == "Y"{
                    cell.messageBtnWidthConst.constant = 260
                    cell.messageBtnLeadingConst.constant = 16
                    cell.messageBtn.isHidden = false
                    cell.friendAddBtn.backgroundColor = UIColor(hexString: "#F7F7F9")
                    cell.friendAddBtn.layer.borderWidth = 1
                    cell.friendAddBtn.layer.borderColor = UIColor(hexString: "#B4B4B4").cgColor
                    cell.friendAddBtn.setImage(UIImage(named:"profile_friend_delete"), for: .normal)
                    cell.friendAddBtn.setTitle("", for: .normal)
                    cell.friendAddBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }else{
                    cell.messageBtnWidthConst.constant = 0
                    cell.messageBtnLeadingConst.constant = 0
                    cell.messageBtn.isHidden = true
                    cell.friendAddBtn.backgroundColor = UIColor(hexString: "#FF5A5F")
                    cell.friendAddBtn.layer.borderWidth = 0
                    cell.friendAddBtn.setImage(UIImage(named:""), for: .normal)
                    cell.friendAddBtn.setTitle("팔로우", for: .normal)
                    cell.friendAddBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                }
            }
            cell.selectionStyle = .none
            return cell
        case 7:
            let cell:ProfileV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2ManagerTitleCell", for: indexPath) as! ProfileV2TableViewCell
            cell.managerTitle.text = "운영중인 클래스 \(self.profileModel?.results?.manage_class_total ?? 0)"
            cell.selectionStyle = .none
            return cell
        case 8:
            let cell:ProfileV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2ManagerContentCell", for: indexPath) as! ProfileV2TableViewCell
            
            if (self.profileModel?.results?.manage_class_list.count ?? 0) > (row*2)+1{
                cell.managerImg1.sd_setImage(with: URL(string: "\(self.profileModel?.results?.manage_class_list[row*2].photo_url ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.managerImg2.sd_setImage(with: URL(string: "\(self.profileModel?.results?.manage_class_list[(row*2)+1].photo_url ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.managerTitle1.text = "\(self.profileModel?.results?.manage_class_list[row*2].class_name ?? "")"
                cell.managerTitle2.text = "\(self.profileModel?.results?.manage_class_list[(row*2)+1].class_name ?? "")"
                cell.managerBtn1.tag = row*2
                cell.managerBtn2.tag = (row*2)+1
                cell.managerViewBottomConst.constant = 16
                cell.managerView1.isHidden = false
                cell.managerView2.isHidden = false
            }else{
                if (self.profileModel?.results?.manage_class_list.count ?? 0) % 2 == 1{
                    cell.managerImg1.sd_setImage(with: URL(string: "\(self.profileModel?.results?.manage_class_list[row*2].photo_url ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                    cell.managerTitle1.text = "\(self.profileModel?.results?.manage_class_list[row*2].class_name ?? "")"
                    cell.managerBtn1.tag = row*2
                    cell.managerView1.isHidden = false
                    cell.managerView2.isHidden = true
                }
                
            }
            var managerCount = 0
            
            if (self.profileModel?.results?.manage_class_list.count ?? 0) % 2 == 1{
                managerCount = ((self.profileModel?.results?.manage_class_list.count ?? 0)/2) + 1
            }else{
                managerCount = ((self.profileModel?.results?.manage_class_list.count ?? 0)/2)
            }
            print("row : \(row) , managerCount : \(managerCount)")
            if row == managerCount-1{
                cell.managerViewBottomConst.constant = 32
            }else{
                cell.managerViewBottomConst.constant = 0
            }
            
            cell.selectionStyle = .none
            return cell
        case 9:
            let cell:ProfileV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileActiveMenuTableViewCell", for: indexPath) as! ProfileV2TableViewCell
            if self.profileModel != nil{
                cell.activeTitle.text = "활동 \(self.profileModel?.results?.active_comment_total ?? 0)"
                cell.reviewTitle.text = "리뷰 \(self.profileModel?.results?.class_review_total ?? 0)"
                cell.scrapTitle.text = "즐겨찾기 \(self.profileModel?.results?.scrap_list_total ?? 0)"
            }
            cell.selectionStyle = .none
            return cell
        case 10:
            let cell:ProfileV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileActiveTableViewCell", for: indexPath) as! ProfileV2TableViewCell
            if self.profileModel != nil{
                if active_comment_list.count > (row*3)+2{
                    gridView1(cell: cell, row: row)
                    gridView2(cell: cell, row: row)
                    gridView3(cell: cell, row: row)
                }else{
                    if active_comment_list.count % 3 == 2{
                        print("\(active_comment_list.count % 3)")
                        cell.photoView3.isHidden = true
                        cell.noPhotoView3.isHidden = true
                        gridView1(cell: cell, row: row)
                        gridView2(cell: cell, row: row)
                    }else if active_comment_list.count % 3 == 1{
                        print("\(active_comment_list.count % 3)")
                        gridView1(cell: cell, row: row)
                        cell.photoView2.isHidden = true
                        cell.noPhotoView2.isHidden = true
                        cell.photoView3.isHidden = true
                        cell.noPhotoView3.isHidden = true
                    }
                }

            }
            cell.selectionStyle = .none
            return cell
        
        default:
            let cell:ProfileV2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileFriendViewCell", for: indexPath) as! ProfileV2TableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        var managerCount = 0
        var heightforCell2 = 0
        let heightCheck = ((self.view.frame.width)/10)*4
        
        if section == 8{
            if (self.profileModel?.results?.manage_class_list.count ?? 0) % 2 == 1{
                managerCount = ((self.profileModel?.results?.manage_class_list.count ?? 0)/2) + 1
            }else{
                managerCount = ((self.profileModel?.results?.manage_class_list.count ?? 0)/2)
            }
            if row == managerCount-1{
                heightforCell2 = Int(heightCheck + 42)
            }else{
                heightforCell2 = Int(heightCheck + 16)
            }
        }
        
        let heightforCell3 = ((self.view.frame.width)/3)
        switch section {
//        case 0:
//            return (self.view.frame.width/3)*2
        case 4:
            if pageOpen == true{
                return (missionTextView?.contentSize.height)! + 44
            }else{
                return 50
            }
        case 8:
            
            return CGFloat(heightforCell2)
        case 10:
            return heightforCell3
        default:
            return UITableView.automaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section == 10{
            if self.active_comment_list.count > 0{
                if ((self.active_comment_list.count/3) - 2) == row{
                    if self.activeTotalPage > self.page{
                        self.page = self.page + 1
                        self.addActiveList()
                    }
                }
            }
        }
    }
    
}
