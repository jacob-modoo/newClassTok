//
//  ProfileV2NewViewController.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/11/11.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit
import Firebase
import ReadMoreTextView

class ProfileV2NewViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePageTitleView: UIView!
    @IBOutlet weak var profilePageTitleViewHeight: NSLayoutConstraint!
    
    var refreshControl = UIRefreshControl()
    var page = 1
    var profileModel:ProfileV2Model?
    var profileNewModel:ProfileNewModel?
    var pageOpen:Bool = false
    var activeTotalPage = 1
    var textLineCount = 0
    var active_comment_list:Array = Array<Active_comment>()
    var comment_list_arr:Array = Array<Comment_List>()
    var missionTextView:UITextView?
    var socialNetwork:Bool?
    var user_id = UserManager.shared.userInfo.results?.user?.id ?? 0
    var isMyProfile:Bool = false
    private var expandableText:NSRange?
    let childWebViewStoryboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    let chattingStoryboard: UIStoryboard = UIStoryboard(name: "ChattingWebView", bundle: nil)
    let feedStoryboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
    
    let storyColor = ["#CDDEF2", "#B2C1D2", "#D9DFEE", "#DFDFDF"]
    let missionColor = ["#E6D8DB", "#D4DCD9"]
    let questionColor = ["#DED8D2", "#E6E4D7", "#E2E8D7"]
    lazy var emoticonView = EmoticonView()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
        self.profileNewList()
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToClassDetail), name: NSNotification.Name(rawValue: "goToClassDetail"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.setScreenName("프로필", screenClass: "ProfileV2NewViewController")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
        comment_list_arr.removeAll()
    }
    
    @IBAction func profileBtnClicked(_ sender: UIButton) {
        let newViewController = home2WebViewStoryboard.instantiateViewController(withIdentifier: "HomeProfileViewController") as! HomeProfileViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func profilePhotoBtnClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func snsLinkBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 0 {
            if self.profileNewModel?.results?.sns_instagram ?? "" != "" {
                if let url = URL(string: "\(self.profileNewModel?.results?.sns_instagram ?? "")") {
                    UIApplication.shared.open(url)
                } else {
                    showToast2(message: "잘못된 링크이거나 접근할 수 없습니다.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
                }
            } else {
                showToast2(message: "링크가 존재하지 않습니다.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
            }
        } else if tag == 1 {
            if self.profileNewModel?.results?.sns_facebook ?? "" != "" {
                if let url = URL(string: "\(self.profileNewModel?.results?.sns_facebook ?? "")") {
                    UIApplication.shared.open(url)
                } else {
                    showToast2(message: "잘못된 링크이거나 접근할 수 없습니다.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
                }
            } else {
                showToast2(message: "링크가 존재하지 않습니다.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
            }
        } else if tag == 2 {
            if self.profileNewModel?.results?.sns_youtube ?? "" != "" {
                if let url = URL(string: "\(self.profileNewModel?.results?.sns_youtube ?? "")") {
                    UIApplication.shared.open(url)
                } else {
                    showToast2(message: "잘못된 링크이거나 접근할 수 없습니다.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
                }
            } else {
                showToast2(message: "링크가 존재하지 않습니다.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
            }
        } else {
            if self.profileNewModel?.results?.sns_homepage ?? "" != "" {
                if let url = URL(string: "\(self.profileNewModel?.results?.sns_homepage ?? "")") {
                    UIApplication.shared.open(url)
                } else {
                    showToast2(message: "잘못된 링크이거나 접근할 수 없습니다.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
                }
            } else {
                showToast2(message: "링크가 존재하지 않습니다.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
            }
        }
    }
    
    @IBAction func unFriendBtn(_ sender: UIButton) {
        Alert.WithUnfriend(self, btn1Title: "팔로우 취소", btn1Handler: {
            self.friend_add(sender: sender)
        }, btn2Title: "취소") {
//            will just dismiss the alert
        }
    }
    
    @IBAction func addFriendBtnClicked(_ sender: UIButton) {
        if profileNewModel?.results?.mode ?? "" != "myprofile" {
            if profileNewModel?.results?.friend_yn ?? "N" != "Y" {
                friend_add(sender: sender)
            } else {
                let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                newViewController.url = self.profileNewModel?.results?.chat_link ?? ""
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        } else {
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = self.profileNewModel?.results?.profile_link ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func coachStudioBtnClicked(_ sender: UIButton) {
        if self.profileNewModel?.results?.class_studio_link ?? "" != ""{
            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
            newViewController.url = self.profileNewModel?.results?.class_link ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func classEnterBtnClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveToClassPage"), object: nil)
        }
    }
    
    @IBAction func activeMoveBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        self.navigationController?.storyPopOrPushController(feedId: "\(self.comment_list_arr[tag].id ?? "")")
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
        if comment_list_arr[row].id ?? "" != ""{ //1 : no , 2 : yes
            ProfileApi.shared.profileV2CommentLike(comment_id: comment_list_arr[row].id ?? "", type: type, success: { [unowned self] result in
                if result.code == "200"{
                    if type == "delete"{
                        sender.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                        sender.tag = (row*10000) + 1
                        self.comment_list_arr[row].like_cnt = (self.comment_list_arr[row].like_cnt ?? 0) - 1
                    }else{
                        sender.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                        sender.tag = (row*10000) + 2
                        self.comment_list_arr[row].like_cnt = (self.comment_list_arr[row].like_cnt ?? 0) + 1
                    }
                    
                    let indexPath = IndexPath(row: row/3, section: 11)
                    if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                        if visibleIndexPaths != NSNotFound {
                            let indexPath = IndexPath(row: row/3, section: 11)
                            let cell = self.tableView.cellForRow(at: indexPath) as! ProfileV2TableViewCell
                            
                            if row%3 == 0{
                                cell.photoLikeCount1.text = "👍 \(self.comment_list_arr[row].like_cnt ?? 0)"
                            }else if row%3 == 1{
                                cell.photoLikeCount2.text = "👍 \(self.comment_list_arr[row].like_cnt ?? 0)"
                            }else{
                                cell.photoLikeCount3.text = "👍 \(self.comment_list_arr[row].like_cnt ?? 0)"
                            }
                        }
                    }
                    
                }
            }) { error in
            }
        }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        print("uigesture-recognizer")
        let imageView = sender.view as! UIImageView
        Alert.WithImageView(self, image: imageView.image!, btn1Title: "", btn1Handler: {
            
        })
    }
    
    @objc func reloadActiveList() {
        comment_list_arr.removeAll()
        self.page = 1
        self.profileNewList()
    }
    
    @objc func goToClassDetail(_ notification:Notification){
        if notification.userInfo as NSDictionary? != nil {
            let class_id = notification.userInfo?["class_id"] as! Int
            self.navigationController?.popOrPushController(class_id: class_id)
        }
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
    func profileNewList(){
        ProfileApi.shared.profileV3List(user_id: self.user_id, page: self.page) { [unowned self] result in
            if result.code == "200"{
                self.profileNewModel = result
                print("the status of api data : ", self.profileNewModel?.results?.mode ?? "data not arrived yet")
                if self.profileNewModel?.results?.mode ?? "" != "myprofile" {
                    self.profilePageTitleView.isHidden = false
                    self.profilePageTitleViewHeight.constant = 44
                } else {
                    if isMyProfile == true {
                        self.profilePageTitleView.isHidden = false
                        self.profilePageTitleViewHeight.constant = 44
                    } else {
                        self.profilePageTitleView.isHidden = true
                        self.profilePageTitleViewHeight.constant = 0
                    }
                }
//                self.activeList()
                self.activeNewList()
                
                
            } else {
                print("여기??")
                Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                    self.endOfWork()
                })
            }
        } fail: { error in
            print("아님 여기???")
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                self.endOfWork()
            })
        }
    }
    
    func activeNewList() {
        ProfileApi.shared.profileV3List(user_id: self.user_id, page: self.page) { [unowned self] result in
            if result.code == "200" {
                self.activeTotalPage = result.results?.total_page ?? 0
                for addArray in 0..<(result.results?.comment_list_arr.count)! {
                    self.comment_list_arr.append((result.results?.comment_list_arr[addArray])!)
                }
                DispatchQueue.main.async {
                    self.endOfWork()
                    self.tableView.reloadData()
                }
            }
        } fail: { eroor in
            print(eroor ?? "error in calling *profileV3List* api")
        }

    }
    
    func ProfileList(){
        ProfileApi.shared.profileV2List(user_id: self.user_id, success: { [unowned self] result in
            if result.code == "200"{
                self.profileModel = result
                let width: CGFloat = 200.0
                self.missionTextView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
                let setHeightUsingCSS = "<html><head><style type=\"text/css\"> img{ max-height: 100%; max-width: \(self.view.frame.width - 32); !important; width: auto; height: auto;} </style> </head><body> \(self.profileModel?.results?.user_info?.profile_comment ?? "") </body></html>"
                print("height set by CSS : \(setHeightUsingCSS)")
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
        let friend_status = profileNewModel?.results?.friend_yn ?? "N"
        
        if friend_status == "Y"{
            self.profileNewModel?.results?.friend_yn = "N"
        }else{
            self.profileNewModel?.results?.friend_yn = "Y"
        }
        
        FeedApi.shared.friend_add(user_id: user_id,friend_status:friend_status,success: { [unowned self] result in
            if result.code == "200"{
                let indexPath = IndexPath(row: 0, section: 3)
                if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                    if visibleIndexPaths != NSNotFound {
                        let indexPath = IndexPath(row: 0, section: 3)
                        let cell = self.tableView.cellForRow(at: indexPath) as! ProfileV2NewTableViewCell//ProfileV2FriendOfferCell
                        if self.profileNewModel?.results?.friend_yn ?? "Y" == "Y"{
                            cell.profileMainBtn.borderWidth = 1
                            cell.profileMainBtn.borderColor = UIColor(hexString: "#FF5A5F")
                            cell.profileMainBtn.backgroundColor = .white
                            cell.profileMainBtn.setTitle("메세지", for: .normal)
                            cell.profileMainBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                        }else{
                            cell.profileMainBtn.backgroundColor = UIColor(hexString: "#FF5A5F")
                            cell.profileMainBtn.setTitle("팔로우", for: .normal)
                            cell.profileMainBtn.setTitleColor(.white, for: .normal)
                        }
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.5) {
                                if self.profileNewModel?.results?.friend_yn ?? "Y" == "Y"{
                                    cell.profileMsgBtnWidth.constant = (self.view.frame.width/2)-22
                                    cell.profileMsgBtnLeadConstraint.constant = 12
                                    cell.profileFollowingBtn.isHidden = false
                                }else{
                                    cell.profileMsgBtnWidth.constant = 0
                                    cell.profileMsgBtnLeadConstraint.constant = 0
                                    cell.profileFollowingBtn.isHidden = true
                                }
                            }
                        }
                    }
                }
            } else {
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
    
    func boldText(fullText:String, fullTextSize: CGFloat, boldText:String, boldTextSize: CGFloat) -> NSAttributedString {

        let string = fullText as NSString

        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fullTextSize)])

        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: boldTextSize)]

        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: boldText))
        
        return attributedString
    }
}

extension ProfileV2NewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func gridView1(cell:ProfileV2NewTableViewCell , row:Int){
        let checkRow = (row*3)
//        if active_comment_list[checkRow].youtu_address ?? "" != ""{
//            cell.photoView1.isHidden = false
//            cell.noPhotoView1.isHidden = true
//            cell.photoBackImage1.sd_setImage(with: URL(string: "\(active_comment_list[checkRow].youtu_image_address ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
//            cell.photoLikeCount1.text = "👍 \(active_comment_list[checkRow].like_cnt ?? 0)"
//            cell.photoPlayImg1.isHidden = false
//
//            cell.photoBtn1.tag = checkRow
//            if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.user_id{
//                cell.photoLikeBtn1.isHidden = true
//            }else{
//                cell.photoLikeBtn1.isHidden = false
//            }
//            if active_comment_list[checkRow].like_status ?? "N" == "N"{
//                cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
//                cell.photoLikeBtn1.tag = (checkRow * 10000) + 1
//            }else{
//                cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
//                cell.photoLikeBtn1.tag = (checkRow * 10000) + 2
//            }
//        }else{
            cell.photoPlayImg1.isHidden = true
            if comment_list_arr[checkRow].photo_data ?? "" != "" {
                cell.photoView1.isHidden = false
                cell.noPhotoView1.isHidden = true
                cell.photoBackImage1.sd_setImage(with: URL(string: "\(comment_list_arr[checkRow].photo_data ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))

                if comment_list_arr[checkRow].like_cnt ?? 0 > 0 {
                    cell.photoLikeCount1.isHidden = false
                    cell.photoLikeCount1.text = "👍 \(comment_list_arr[checkRow].like_cnt ?? 0)"
                } else {
                    cell.photoLikeCount1.isHidden = true
                }
                

                cell.photoBtn1.tag = checkRow
                if comment_list_arr[checkRow].new_flag ?? "N" == "N"{
                    cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.photoLikeBtn1.tag = (checkRow * 10000) + 1
                }else{
                    cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.photoLikeBtn1.tag = (checkRow * 10000) + 2
                }
                
            }else{
                cell.photoView1.isHidden = true
                cell.noPhotoView1.isHidden = false
                if comment_list_arr[checkRow].class_id != 0 {
                    cell.noPhotoUserImg1.sd_setImage(with: URL(string: "\(comment_list_arr[checkRow].class_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                } else {
                    cell.noPhotoUserImg1.sd_setImage(with: URL(string: "\(self.profileNewModel?.results?.user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                }
                cell.noPhotoProfileText1.text = "\(comment_list_arr[checkRow].content ?? "")"
                cell.noPhotoLikeCount1.text = "👍 \(comment_list_arr[checkRow].like_cnt ?? 0)"
                
                let feedType = comment_list_arr[checkRow].id ?? ""
                
                if feedType.contains("S") {
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView1.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                } else if feedType.contains("M") {
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView1.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                } else if feedType.contains("R") {
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView1.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                } else if feedType.contains("Q") {
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView1.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                }
                
                if self.comment_list_arr[checkRow].emoticon ?? 0 > 0 {
                    cell.noPhotoEmoticon1.isHidden = false
                    cell.noPhotoUserImg1.isHidden = true
                    cell.noPhotoEmoticon1.image = UIImage(named: "\(self.emoticonView.items[self.comment_list_arr[checkRow].emoticon!])")
                } else {
                    cell.noPhotoEmoticon1.isHidden = true
                    cell.noPhotoUserImg1.isHidden = false
                }
                
                cell.noPhotoBtn1.tag = checkRow
                
                if comment_list_arr[checkRow].new_flag ?? "N" == "N"{
                    cell.noPhotoLikeBtn1.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.noPhotoLikeBtn1.tag = (checkRow * 10000) + 1
                }else{
                    cell.noPhotoLikeBtn1.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.noPhotoLikeBtn1.tag = (checkRow * 10000) + 2
                }
            }
//        }
    }
    
    func gridView2(cell:ProfileV2NewTableViewCell , row:Int){
        let checkRow = (row*3)+1
//        if active_comment_list[checkRow].youtu_address ?? "" != ""{
//            cell.photoView2.isHidden = false
//            cell.noPhotoView2.isHidden = true
//            cell.photoBackImage2.sd_setImage(with: URL(string: "\(active_comment_list[checkRow].youtu_image_address ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
//            cell.photoLikeCount2.text = "👍 \(active_comment_list[checkRow].like_cnt ?? 0)"
//            cell.photoPlayImg2.isHidden = false
//            cell.photoBtn2.tag = checkRow
//            if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.user_id{
//                cell.photoLikeBtn2.isHidden = true
//            }else{
//                cell.photoLikeBtn2.isHidden = false
//            }
//            if active_comment_list[checkRow].like_status ?? "N" == "N"{
//                cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
//                cell.photoLikeBtn2.tag = (checkRow * 10000) + 1
//            }else{
//                cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
//                cell.photoLikeBtn2.tag = (checkRow * 10000) + 2
//            }
//        }else{
            cell.photoPlayImg2.isHidden = true
            if comment_list_arr[checkRow].photo_data ?? "" != "" {
                cell.photoView2.isHidden = false
                cell.noPhotoView2.isHidden = true
                cell.photoBackImage2.sd_setImage(with: URL(string: "\(comment_list_arr[checkRow].photo_data ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))

                cell.photoLikeCount2.text = "👍 \(comment_list_arr[checkRow].like_cnt ?? 0)"
                cell.photoBtn2.tag = checkRow
                if comment_list_arr[checkRow].new_flag ?? "N" == "N"{
                    cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.photoLikeBtn2.tag = (checkRow * 10000) + 1
                }else{
                    cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.photoLikeBtn2.tag = (checkRow * 10000) + 2
                }
                
            }else{
                cell.photoView2.isHidden = true
                cell.noPhotoView2.isHidden = false
                if comment_list_arr[checkRow].class_id != 0 {
                    cell.noPhotoUserImg2.sd_setImage(with: URL(string: "\(comment_list_arr[checkRow].class_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                } else {
                    cell.noPhotoUserImg2.sd_setImage(with: URL(string: "\(self.profileNewModel?.results?.user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                }
                cell.noPhotoProfileText2.text = "\(comment_list_arr[checkRow].content ?? "")"
                cell.noPhotoLikeCount2.text = "👍 \(comment_list_arr[checkRow].like_cnt ?? 0)"
                
                let feedType = comment_list_arr[checkRow].id ?? ""
                
                if feedType.contains("S") {
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView2.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                } else if feedType.contains("M") {
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView2.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                } else if feedType.contains("R") {
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView2.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                } else if feedType.contains("Q") {
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView2.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                }
                
                if self.comment_list_arr[checkRow].emoticon ?? 0 > 0 {
                    cell.noPhotoEmoticon2.isHidden = false
                    cell.noPhotoUserImg2.isHidden = true
                    cell.noPhotoEmoticon2.image = UIImage(named: "\(self.emoticonView.items[self.comment_list_arr[checkRow].emoticon!])")
                } else {
                    cell.noPhotoEmoticon2.isHidden = true
                    cell.noPhotoUserImg2.isHidden = false
                }
                
                cell.noPhotoBtn2.tag = checkRow
                if comment_list_arr[checkRow].new_flag ?? "N" == "N"{
                    cell.noPhotoLikeBtn2.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.noPhotoLikeBtn2.tag = (checkRow * 10000) + 1
                }else{
                    cell.noPhotoLikeBtn2.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.noPhotoLikeBtn2.tag = (checkRow * 10000) + 2
                }
            }
//        }
    }
    
    func gridView3(cell:ProfileV2NewTableViewCell , row:Int){
        let checkRow = (row*3)+2
//        if active_comment_list[checkRow].youtu_address ?? "" != ""{
//            cell.photoView3.isHidden = false
//            cell.noPhotoView3.isHidden = true
//            cell.photoBackImage3.sd_setImage(with: URL(string: "\(active_comment_list[checkRow].youtu_image_address ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
//            cell.photoLikeCount3.text = "👍 \(active_comment_list[checkRow].like_cnt ?? 0)"
//            cell.photoPlayImg3.isHidden = false
//            cell.photoBtn3.tag = checkRow
//            if active_comment_list[checkRow].like_status ?? "N" == "N"{
//                cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
//                cell.photoLikeBtn3.tag = (checkRow * 10000) + 1
//            }else{
//                cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
//                cell.photoLikeBtn3.tag = (checkRow * 10000) + 2
//            }
//            if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.user_id{
//                cell.photoLikeBtn3.isHidden = true
//            }else{
//                cell.photoLikeBtn3.isHidden = false
//            }
//        }else{
            cell.photoPlayImg3.isHidden = true
            if comment_list_arr[checkRow].photo_data ?? "" != "" {
                cell.photoView3.isHidden = false
                cell.noPhotoView3.isHidden = true
                cell.photoBackImage3.sd_setImage(with: URL(string: "\(comment_list_arr[checkRow].photo_data ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))

                cell.photoLikeCount3.text = "👍 \(comment_list_arr[checkRow].like_cnt ?? 0)"
                cell.photoBtn3.tag = checkRow
                if comment_list_arr[checkRow].new_flag ?? "N" == "N"{
                    cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.photoLikeBtn3.tag = (checkRow * 10000) + 1
                }else{
                    cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.photoLikeBtn3.tag = (checkRow * 10000) + 2
                }
                
            }else{
                cell.photoView3.isHidden = true
                cell.noPhotoView3.isHidden = false
                if comment_list_arr[checkRow].class_id != 0 {
                    cell.noPhotoUserImg3.sd_setImage(with: URL(string: "\(comment_list_arr[checkRow].class_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                } else {
                    cell.noPhotoUserImg3.sd_setImage(with: URL(string: "\(self.profileNewModel?.results?.user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                }
                cell.noPhotoProfileText3.text = "\(comment_list_arr[checkRow].content ?? "")"
                cell.noPhotoLikeCount3.text = "👍 \(comment_list_arr[checkRow].like_cnt ?? 0)"
                
                let feedType = comment_list_arr[checkRow].id ?? ""
                
                if feedType.contains("S") {
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView3.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                } else if feedType.contains("M") {
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView3.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                } else if feedType.contains("R") {
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView3.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                } else if feedType.contains("Q") {
                    let randomIndex = Int(arc4random_uniform(UInt32(storyColor.count)))
                    cell.noPhotoView3.backgroundColor = UIColor(hexString: storyColor[randomIndex])
                }
                
                if self.comment_list_arr[checkRow].emoticon ?? 0 > 0 {
                    cell.noPhotoEmoticon3.isHidden = false
                    cell.noPhotoUserImg3.isHidden = true
                    cell.noPhotoEmoticon3.image = UIImage(named: "\(self.emoticonView.items[self.comment_list_arr[checkRow].emoticon!])")
                } else {
                    cell.noPhotoEmoticon3.isHidden = true
                    cell.noPhotoUserImg3.isHidden = false
                }
                
                cell.noPhotoBtn3.tag = checkRow
                if comment_list_arr[checkRow].new_flag ?? "N" == "N"{
                    cell.noPhotoLikeBtn3.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.noPhotoLikeBtn3.tag = (checkRow * 10000) + 1
                }else{
                    cell.noPhotoLikeBtn3.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.noPhotoLikeBtn3.tag = (checkRow * 10000) + 2
                }
            }
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.profileNewModel != nil {
            switch section {
            case 0,2,3,8,9:
                return 1
            case 1:
                if self.profileNewModel?.results?.user_comment ?? "" != "" {
                    return 1
                } else {
                    return 0
                }
            case 4,5:
                if self.profileNewModel?.results?.mode ?? "" != "myprofile" {
                    return 0
                } else {
                    return 1
                }
            case 6:
                if self.profileNewModel?.results?.mode ?? "" == "myprofile" {
                    if self.profileNewModel?.results?.class_list_arr.count ?? 0 > 0 {
                        return 0
                    } else {
                        return 1
                    }
                } else {
                    return 0
                }
            case 7:
                if self.profileNewModel?.results?.class_list_arr.count ?? 0 > 0 {
                    return 1
                } else {
                    return 0
                }
            case 10:
                if self.comment_list_arr.count > 0 {
                    return 0
                } else {
                    return 1
                }
            case 11:
                if (self.comment_list_arr.count) > 0{
                    if self.comment_list_arr.count % 3 == 0{
                        return self.comment_list_arr.count/3
                    }else{
                        return self.comment_list_arr.count/3 + 1
                    }
                }else{
                    return 0
                }
            default:
                return 1
            }
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2UserProfileCell", for: indexPath) as! ProfileV2NewTableViewCell
            if self.profileNewModel != nil {
                cell.userLevelLbl.text = profileNewModel?.results?.level_name ?? ""
                cell.userNickname.text = profileNewModel?.results?.user_name ?? ""
                let url = URL(string: self.profileNewModel?.results?.level_icon ?? "")
                cell.userBackgroundImg.sd_setImage(with: url)
                cell.profileIconImg.sd_setImage(with: url)
                
                cell.profilePhoto.sd_setImage(with: URL(string: self.profileNewModel?.results?.user_photo ?? ""), placeholderImage: UIImage(named: "reply_user_default"))
                let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                cell.profilePhoto.addGestureRecognizer(pictureTap)
                let bold_text = "\(convertCurrency(money: NSNumber(value: self.profileNewModel?.results?.helpful_cnt ?? 0), style: .decimal))"
                let full_text = "👍\(bold_text) 건의 도움이 되었어요."
                cell.helpfulCountLbl.attributedText = boldText(fullText: full_text, fullTextSize: 14, boldText: bold_text, boldTextSize: 15)
                if self.profileNewModel?.results?.mode ?? "" != "myprofile" {
                    cell.profileBtn.isHidden = true
                } else {
                    cell.profileBtn.isHidden = false
                }
                
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2IntroCell", for: indexPath) as! ProfileV2NewTableViewCell
            if self.profileNewModel != nil {
                cell.myIntroTextView.text = self.profileNewModel?.results?.user_comment ?? ""
                cell.myIntroTextView.shouldTrim = true
                cell.myIntroTextView.maximumNumberOfLines = 1
                cell.myIntroTextView.attributedReadMoreText = NSAttributedString(string: "... 더보기")
                cell.myIntroTextView.attributedReadLessText = NSAttributedString(string: "닫기")
//                cell.introTextLbl.text = self.profileNewModel?.results?.user_comment ?? ""
//                if cell.introTextLbl.isTruncatedText {
//                    self.expandableText = cell.introTextLbl.setExpandActionIfPossible("... 더보기", textColor: UIColor(hexString: "#B4B4B4"))
//                }
//                @IBAction func didTapLabel(_ sender: UITapGestureRecognizer) {
//                        guard let expandRange = expandableText else {
//                            return
//                        }
//                        let tapLocation = sender.location(in: label)
//                        if label.didTapInRange(tapLocation, targetRange: expandRange) {
//                            label.numberOfLines = 0
//                            label.text = loremIpsumString
//                        }
//                        else {
//                            resultLabel.text = "You tapped the area outside More."
//                        }
//                    }
                
                self.tableView.layoutIfNeeded()
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2SocialNetworkCell", for: indexPath) as! ProfileV2NewTableViewCell

            cell.selectionStyle = .none
            return cell
        case 3:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2FriendOfferCell", for: indexPath) as! ProfileV2NewTableViewCell
            if self.profileNewModel != nil {
                cell.profileMainBtn.tag = self.profileNewModel?.results?.user_id ?? 0
                if profileNewModel?.results?.mode ?? "" != "myprofile" {
                    if profileNewModel?.results?.friend_yn ?? "N" != "Y" {
                        cell.profileMainBtn.backgroundColor = UIColor(hexString: "#FF5A5F")
                        cell.profileMainBtn.setTitle("팔로우", for: .normal)
                        cell.profileMainBtn.setTitleColor(.white, for: .normal)
                        cell.profileMsgBtnWidth.constant = 0
                        cell.profileMsgBtnLeadConstraint.constant = 0
                        cell.profileFollowingBtn.isHidden = true
                    } else {
                        cell.profileMainBtn.setTitle("메세지", for: .normal)
                        cell.profileMainBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                        cell.profileMainBtn.backgroundColor = .white
                        cell.profileMsgBtnWidth.constant = (self.view.frame.width/2)-22
                        cell.profileMsgBtnLeadConstraint.constant = 12
                        cell.profileFollowingBtn.isHidden = false
                    }
                } else {
                    cell.profileMsgBtnWidth.constant = 0
                    cell.profileMsgBtnLeadConstraint.constant = 0
                    cell.profileFollowingBtn.isHidden = true
                    
                    cell.profileMainBtn.backgroundColor = .white
                    cell.profileMainBtn.setTitle("프로필 편집", for: .normal)
                    cell.profileMainBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                    cell.profileMainBtn.borderWidth = 1
                    cell.profileMainBtn.borderColor = UIColor(hexString: "#B4B4B4")
                }
            }
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2LineCell", for: indexPath) as! ProfileV2NewTableViewCell
            
            cell.selectionStyle = .none
            return cell
        case 5:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2TableTitleCell", for: indexPath) as! ProfileV2NewTableViewCell
            if self.profileNewModel != nil {
                cell.profileTableViewTitleLbl.text = "지식공유"
                if self.profileNewModel?.results?.class_list_arr.count ?? 0 > 0 {
                    cell.coachStudioBtn.isHidden = false
                } else {
                    cell.coachStudioBtn.isHidden = true
                }
            }
            cell.selectionStyle = .none
            return cell
        case 6:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2ShareContentCell", for: indexPath) as! ProfileV2NewTableViewCell
            if self.profileNewModel != nil {
                
            }
            cell.selectionStyle = .none
            return cell
        case 7:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2CollectionViewCell", for: indexPath) as! ProfileV2NewTableViewCell
            if self.profileNewModel != nil {
                if self.profileNewModel?.results?.class_list_arr.count ?? 0 > 0 {
                    for i in 0..<(self.profileNewModel?.results?.class_list_arr.count ?? 0) {
                        cell.class_list_arr.append((self.profileNewModel?.results?.class_list_arr[i])!)
                    }
                }
            }
            cell.selectionStyle = .none
            return cell
        case 8:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2LineCell", for: indexPath) as! ProfileV2NewTableViewCell
            cell.selectionStyle = .none
            return cell
        case 9:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2TableTitleCell", for: indexPath) as! ProfileV2NewTableViewCell
            if self.profileNewModel != nil {
                cell.profileTableViewTitleLbl.text = "일상공유"
                cell.coachStudioBtn.isHidden = true
            }
            cell.selectionStyle = .none
            return cell
        case 10:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2EmptyActivityCell", for: indexPath) as! ProfileV2NewTableViewCell
            if self.profileNewModel != nil {
                cell.profileEmptyViewWidth.constant = self.view.frame.width-100
                if self.profileNewModel?.results?.mode ?? "" == "myprofile" {
                    cell.feedbackNoHaveLbl.isHidden = true
                    cell.profileNoStoryLblView.isHidden = false
                } else {
                    cell.feedbackNoHaveLbl.isHidden = false
                    cell.profileNoStoryLblView.isHidden = true
                }
            }
            cell.selectionStyle = .none
            return cell
        case 11:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2ActiveTableViewCell", for: indexPath) as! ProfileV2NewTableViewCell
            if self.profileNewModel != nil {
                if comment_list_arr.count > (row*3)+2 {
                    gridView1(cell: cell, row: row)
                    gridView2(cell: cell, row: row)
                    gridView3(cell: cell, row: row)
                } else {
                    if comment_list_arr.count % 3 == 2 {
                        cell.photoView3.isHidden = true
                        cell.noPhotoView3.isHidden = true
                        gridView1(cell: cell, row: row)
                        gridView2(cell: cell, row: row)
                    } else if comment_list_arr.count % 3 == 1 {
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
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2FriendOfferCell", for: indexPath) as! ProfileV2NewTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 11 {
            return self.view.frame.width/3
        }
        
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section == 11 {
            if self.comment_list_arr.count > 0 {
                if (self.comment_list_arr.count/3) - 2 == row {
                    if self.activeTotalPage > self.page {
                        self.page += 1
                        self.activeNewList()
                    }
                }
            }
        }
    }
    
}
