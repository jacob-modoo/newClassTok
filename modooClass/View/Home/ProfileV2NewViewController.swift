//
//  ProfileV2NewViewController.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/11/11.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit
import Firebase

class ProfileV2NewViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePageTitleView: UIView!
    @IBOutlet weak var profilePageTitleViewHeight: NSLayoutConstraint!
    
    var refreshControl = UIRefreshControl()
    var profileNewModel:ProfileNewModel?
    var class_list_arr:Array? = Array<Class_New_List>()
    var comment_list_arr:Array = Array<Activity_List>()
    var chatRoom:ChatRoomPModel?
    var pageOpen:Bool = false
    var activeTotalPage = 1
    var textLineCount = 0
    var page = 1
    var missionTextView:UITextView?
    var socialNetwork:Bool?
    var user_id = UserManager.shared.userInfo.results?.user?.id ?? 0
    var isMyProfile:Bool = false
    private var expandableText:NSRange?
    let childWebViewStoryboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    let chattingStoryboard: UIStoryboard = UIStoryboard(name: "Chatting", bundle: nil)
    let feedStoryboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
    
    let storyColor = ["#CDDEF2", "#B2C1D2", "#D9DFEE", "#DFDFDF"]
    let missionColor = ["#E6D8DB", "#D4DCD9"]
    let questionColor = ["#DED8D2", "#E6E4D7", "#E2E8D7"]
    lazy var emoticonView = EmoticonView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = false
        Indicator.showActivityIndicator(uiView: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.view.isUserInteractionEnabled = true
            Indicator.hideActivityIndicator(uiView: self.view)
        }
        self.profileNewList()
        tableView.addSubview(refreshControl)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToClassDetail), name: NSNotification.Name(rawValue: "goToClassDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadActiveList), name: NSNotification.Name(rawValue: "updateProfileActiveList"), object: nil)
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
        Analytics.logEvent("프로필", parameters: [AnalyticsParameterScreenName : "ProfileV2NewViewController"])
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
        comment_list_arr.removeAll()
        class_list_arr = nil
    }
    
    @IBAction func profileBtnClicked(_ sender: UIButton) {
        let newViewController = home2WebViewStoryboard.instantiateViewController(withIdentifier: "HomeProfileViewController") as! HomeProfileViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
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
    
    @IBAction func sendMsgBtnClicked(_ sender: UIButton) {
        let chat_user_id = self.profileNewModel?.results?.user_id ?? 0
        ChattingListApi.shared.getChatroomId(chatRoomId: "\(chat_user_id)") { result in
            if result.code == "200" {
                self.chatRoom = result
                let chatId = self.chatRoom?.results?.mcChat_id ?? 0
                let newViewController = self.chattingStoryboard.instantiateViewController(withIdentifier: "ChattingFriendViewController") as! ChattingFriendViewController
                newViewController.chat_id = chatId
                print("** chat  id : \(chatId)")
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        } fail: { error in
            print("error in calling getChatroomID api")
        }
    }
    
    @IBAction func addFriendBtnClicked(_ sender: UIButton) {
        if profileNewModel?.results?.mode ?? "" != "myprofile" {
            if profileNewModel?.results?.friend_yn ?? "N" != "Y" {
                friend_add(sender: sender)
            } else {
                Alert.WithUnfriend(self, btn1Title: "팔로우 취소", btn1Handler: {
                    print("** sender tag \(sender.tag)")
                    self.friend_add(sender: sender)
                }, btn2Title: "취소") {
                    
                }
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
            newViewController.url = self.profileNewModel?.results?.class_studio_link ?? ""
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func classEnterBtnClicked(_ sender: UIButton) {
        let pageArr = ["HomeIntroWebViewController":0,
                       "HomeClassViewController":1,
                       "HomeFeedWebViewController":2,
                       "ProfileV2NewViewController":3]
        var pageNumber = pageArr["HomeClassViewController"]
        if self.profileNewModel?.results?.class_yn ?? "N" == "N" {
            pageNumber = pageArr["HomeIntroWebViewController"]
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "moveToPage"), object: pageNumber)
        }
    }
    
    @IBAction func readMoreBtnClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            let indexPath = NSIndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        }
        if sender.tag == 0 {
            sender.tag = 1
        } else {
            sender.tag = 0
        }
        self.tableView.reloadData()
    }
    
    @IBAction func activeMoveBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        let feedId = self.comment_list_arr[tag].id ?? ""
        let sameVC = home2WebViewStoryboard.instantiateViewController(withIdentifier: "StoryDetailViewController") as! StoryDetailViewController
        sameVC.feedId = feedId
        self.navigationController?.pushViewController(sameVC, animated: true)
//        self.navigationController?.storyPopOrPushController(feedId: "\(self.comment_list_arr[tag].id ?? "")")
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
            let class_id = notification.userInfo?["id"] as! Int
            let tag = notification.userInfo?["tag"] as! Int
            let class_status = notification.userInfo?["status"] as! Int
            if class_status < 6 {
                let newViewConroller = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                newViewConroller.url = HomeMain2Manager.shared.pilotAppMain.results?.management_class_arr[tag].manager_link ?? ""
                self.navigationController?.pushViewController(newViewConroller, animated: true)
            } else {
                self.navigationController?.popOrPushController(class_id: class_id)
            }
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
        ProfileApi.shared.profileV3List(user_id: self.user_id, page: self.page) { [weak self] result in
            if result.code == "200"{
                self?.profileNewModel = result
                self?.activeTotalPage = result.results?.total_page ?? 0
                
                for addArray in 0..<(result.results?.class_list_arr.count ?? 0) {
                    self?.class_list_arr?.append((result.results?.class_list_arr[addArray])!)
                }
                
                for addArray in 0..<(result.results?.comment_list_arr.count)! {
                    self?.comment_list_arr.append((result.results?.comment_list_arr[addArray])!)
                }
                DispatchQueue.main.async {
                    self?.endOfWork()
                    self?.tableView.reloadData()
                }
                
                if self?.profileNewModel?.results?.mode ?? "" != "myprofile" {
                    self?.profilePageTitleView.isHidden = false
                    self?.profilePageTitleViewHeight.constant = 44
                } else {
                    if self?.isMyProfile == true {
                        self?.profilePageTitleView.isHidden = false
                        self?.profilePageTitleViewHeight.constant = 44
                    } else {
                        self?.profilePageTitleView.isHidden = true
                        self?.profilePageTitleViewHeight.constant = 0
                    }
                }
//                self.activeList()
//                self.activeNewList()
                
            } else {
                print("여기??")
                Alert.With(self!, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                    self?.endOfWork()
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
        ProfileApi.shared.profileV3List(user_id: self.user_id, page: self.page) { [weak self] result in
            if result.code == "200" {
                self?.activeTotalPage = result.results?.total_page ?? 0
                for addArray in 0..<(result.results?.comment_list_arr.count)! {
                    self?.comment_list_arr.append((result.results?.comment_list_arr[addArray])!)
                }
                DispatchQueue.main.async {
                    self?.endOfWork()
                    self?.tableView.reloadData()
                }
            }
        } fail: { eroor in
        
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
                        let cell = self.tableView.cellForRow(at: indexPath) as! ProfileV2NewTableViewCell //ProfileV2FriendOfferCell
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.3) {
                                if self.profileNewModel?.results?.friend_yn ?? "Y" == "Y"{
                                    cell.msgSendBtnWidth.constant = (self.view.frame.width/2)-22
                                    cell.addFriendBtnTrailing.constant = 12
                                    cell.msgSendBtn.isHidden = false
                                }else{
                                    cell.msgSendBtnWidth.constant = 0
                                    cell.addFriendBtnTrailing.constant = 0
                                    cell.msgSendBtn.isHidden = true
                                }
                            }
                            self.tableView.reloadSections([3], with: .automatic)
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
    
    func getHeightFromText(txtLbl: UILabel, strText : String!) -> CGFloat {
        let textLbl : UILabel! = UILabel(frame: CGRect(x: txtLbl.frame.origin.x, y: txtLbl.frame.origin.y, width: txtLbl.frame.size.width, height: 0)) //UITextView(frame: CGRect(x: txtView.frame.origin.x, y: 0,
//        width: txtView.frame.size.width,
//        height: 0))
        textLbl.text = strText
//        textLbl.font = UIFont(name: "Fira Sans", size:  16.0)
        textLbl.sizeToFit()

        var txt_frame : CGRect! = CGRect()
        txt_frame = textLbl.frame

        var size : CGSize! = CGSize()
        size = txt_frame.size

        size.height = txt_frame.size.height

        return size.height
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
        if comment_list_arr[checkRow].play_status ?? "" == "Y"{
            cell.photoGradientViewHeight1.constant = cell.photoView1.frame.height
            cell.photoView1.isHidden = false
            cell.noPhotoView1.isHidden = true
            cell.photoBackImage1.sd_setImage(with: URL(string: "\(comment_list_arr[checkRow].photo_data ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
            cell.photoLikeCount1.text = "👍 \(comment_list_arr[checkRow].like_cnt ?? 0)"
            cell.photoPlayImg1.isHidden = false
            cell.photoBtn1.tag = checkRow
            if comment_list_arr[checkRow].new_flag ?? "N" == "N"{
                cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                cell.photoLikeBtn1.tag = (checkRow * 10000) + 1
            }else{
                cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                cell.photoLikeBtn1.tag = (checkRow * 10000) + 2
            }
        }else{
            cell.photoPlayImg1.isHidden = true
            cell.photoGradientViewHeight1.constant = cell.photoView1.frame.height/2
            if comment_list_arr[checkRow].photo_data ?? "" != "" {
                cell.photoView1.isHidden = false
                cell.noPhotoView1.isHidden = true
                cell.photoBackImage1.sd_setImage(with: URL(string: "\(comment_list_arr[checkRow].photo_data ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))

//                if comment_list_arr[checkRow].like_cnt ?? 0 > 0 {
//                    cell.photoLikeCount1.isHidden = false
                    cell.photoLikeCount1.text = "👍 \(comment_list_arr[checkRow].like_cnt ?? 0)"
//                } else {
//                    cell.photoLikeCount1.isHidden = true
//                }
                

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
                    cell.noPhotoEmoticon1.image = UIImage(named: "emti\(self.comment_list_arr[checkRow].emoticon ?? 0)")
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
        }
    }
    
    func gridView2(cell:ProfileV2NewTableViewCell , row:Int){
        let checkRow = (row*3)+1
        if comment_list_arr[checkRow].play_status ?? "" == "Y"{
            cell.photoGradientViewHeight2.constant = cell.photoView2.frame.height
            cell.photoView2.isHidden = false
            cell.noPhotoView2.isHidden = true
            cell.photoBackImage2.sd_setImage(with: URL(string: "\(comment_list_arr[checkRow].photo_data ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
            cell.photoLikeCount2.text = "👍 \(comment_list_arr[checkRow].like_cnt ?? 0)"
            cell.photoPlayImg2.isHidden = false
            cell.photoBtn2.tag = checkRow
            if comment_list_arr[checkRow].new_flag ?? "N" == "N"{
                cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                cell.photoLikeBtn2.tag = (checkRow * 10000) + 1
            }else{
                cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                cell.photoLikeBtn2.tag = (checkRow * 10000) + 2
            }
        }else{
            cell.photoPlayImg2.isHidden = true
            cell.photoGradientViewHeight2.constant = cell.photoView2.frame.height/2
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
                    cell.noPhotoEmoticon2.image = UIImage(named: "emti\(self.comment_list_arr[checkRow].emoticon ?? 0)")
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
        }
    }
    
    func gridView3(cell:ProfileV2NewTableViewCell , row:Int){
        let checkRow = (row*3)+2
        if comment_list_arr[checkRow].play_status ?? "" == "Y"{
            cell.photoGradientViewHeight3.constant = cell.photoView3.frame.height
            
            cell.photoView3.isHidden = false
            cell.noPhotoView3.isHidden = true
            cell.photoBackImage3.sd_setImage(with: URL(string: "\(comment_list_arr[checkRow].photo_data ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
            cell.photoLikeCount3.text = "👍 \(comment_list_arr[checkRow].like_cnt ?? 0)"
            cell.photoPlayImg3.isHidden = false
            cell.photoBtn3.tag = checkRow
            if comment_list_arr[checkRow].new_flag ?? "N" == "N"{
                cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                cell.photoLikeBtn3.tag = (checkRow * 10000) + 1
            }else{
                cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                cell.photoLikeBtn3.tag = (checkRow * 10000) + 2
            }
        }else{
            cell.photoPlayImg3.isHidden = true
            cell.photoGradientViewHeight3.constant = cell.photoView3.frame.height/2
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
                    cell.noPhotoEmoticon3.image = UIImage(named: "emti\(self.comment_list_arr[checkRow].emoticon ?? 0)")
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
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.profileNewModel != nil {
            switch section {
            case 0,3,8,9:
                return 1
            case 1:
                if self.profileNewModel?.results?.user_comment ?? "" != "" {
                    return 1
                } else {
                    return 0
                }
            case 2:
                if (self.profileNewModel?.results?.sns_youtube ?? "") == "" &&
                    (self.profileNewModel?.results?.sns_facebook ?? "") == "" &&
                    (self.profileNewModel?.results?.sns_instagram ?? "") == "" &&
                    (self.profileNewModel?.results?.sns_homepage ?? "") == "" {
                    return 0
                } else {
                    return 1
                }
            case 4,5:
                if self.profileNewModel?.results?.mode ?? "" != "myprofile" {
                    if self.profileNewModel?.results?.class_list_arr.count ?? 0 > 0 {
                        return 1
                    } else {
                        return 0
                    }
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
                
//                let mutableString:String = self.profileNewModel?.results?.user_comment ?? ""
//                let trimmedString = (mutableString as NSString).replacingCharacters(in: NSRange(location: cell.introTextLbl.visibleTextLength, length: 3), with: "..." )
//                cell.introTextLbl.text = trimmedString.html2String
                let user_comment = self.profileNewModel?.results?.user_comment ?? ""
                print("visible text length \(user_comment.count)")
                if (self.profileNewModel?.results?.user_comment ?? "").count < 100 {
                    cell.readMoreBtnHeight.constant = 0
                    cell.readMoreBtn.isHidden = true
                    cell.introTextLbl.text = user_comment.html2String
                } else {
                    cell.readMoreBtnHeight.constant = 24
                    cell.readMoreBtn.isHidden = false
                    if cell.readMoreBtn.tag == 0 {
                        cell.introTextLbl.numberOfLines = 2
//                        cell.introTextLbl.sizeToFit()
                        cell.introTextLbl.text = user_comment.html2String
//                        cell.introTextLbl.addTrailing(with: "...")
                        cell.readMoreBtn.setTitle("더보기", for: .normal)
                        cell.readMoreBtn.underlineText()
                    } else {
                        cell.introTextLbl.text = user_comment.html2String
                        cell.introTextLbl.numberOfLines = 0
                        cell.introTextLbl.sizeToFit()
                        cell.readMoreBtn.setTitle("닫기", for: .normal)
                        cell.readMoreBtn.underlineText()
                    }
                }
                
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2SocialNetworkCell", for: indexPath) as! ProfileV2NewTableViewCell
            
            if profileNewModel?.results?.sns_instagram ?? "" != "" {
                cell.instagramViewWidth.constant = 30
                cell.instaToFbConstraint.constant = 12
            } else {
                cell.instagramViewWidth.constant = 0
                cell.instaToFbConstraint.constant = 0
            }
            
            if profileNewModel?.results?.sns_facebook ?? "" != "" {
                cell.fbViewWidth.constant = 30
                cell.fbToYtConstraint.constant = 12
            } else {
                cell.fbViewWidth.constant = 0
                cell.fbToYtConstraint.constant = 0
            }
            
            if profileNewModel?.results?.sns_youtube ?? "" != "" {
                cell.ytViewWidth.constant = 30
                cell.ytToHmConstraint.constant = 12
            } else {
                cell.ytViewWidth.constant = 0
                cell.ytToHmConstraint.constant = 0
            }
            
            if profileNewModel?.results?.sns_homepage ?? "" != "" {
                cell.hmViewWidth.constant = 30
            } else {
                cell.hmViewWidth.constant = 0
            }
            
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell:ProfileV2NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileV2FriendOfferCell", for: indexPath) as! ProfileV2NewTableViewCell
            if self.profileNewModel != nil {
                cell.addFriendBtn.tag = self.profileNewModel?.results?.user_id ?? 0
                if profileNewModel?.results?.mode ?? "" != "myprofile" {
                    if profileNewModel?.results?.friend_yn ?? "N" != "Y" {
                        cell.addFriendBtn.backgroundColor = UIColor(hexString: "#FF5A5F")
                        cell.addFriendBtn.setTitleColor(.white, for: .normal)
                        cell.addFriendBtnTrailing.constant = 0
                        cell.addFriendBtn.setTitle("팔로우", for: .normal)
                        cell.addFriendBtn.borderWidth = 0
                        cell.addFriendBtn.imageView?.isHidden = true
                        cell.msgSendBtnWidth.constant = 0
                        cell.msgSendBtn.isHidden = true
                    } else {
                        cell.addFriendBtn.backgroundColor = .white
                        cell.addFriendBtn.setTitle("팔로잉", for: .normal)
                        cell.addFriendBtn.setImage(UIImage(named: "arrow_bottom_small"), for: .normal)
                        cell.addFriendBtnTrailing.constant = 12
                        cell.addFriendBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                        cell.addFriendBtn.borderWidth = 1
                        cell.addFriendBtn.borderColor = UIColor(hexString: "#B4B4B4")
                        cell.msgSendBtnWidth.constant = (self.view.frame.width/2)-22
                        cell.msgSendBtn.isHidden = false
                    }
                } else {
                    cell.msgSendBtnWidth.constant = 0
                    cell.addFriendBtnTrailing.constant = 0
                    cell.msgSendBtn.isHidden = true
                    cell.addFriendBtn.imageView?.isHidden = true
                    cell.addFriendBtn.backgroundColor = .white
                    cell.addFriendBtn.setTitle("프로필 편집", for: .normal)
                    cell.addFriendBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                    cell.addFriendBtn.borderWidth = 1
                    cell.addFriendBtn.borderColor = UIColor(hexString: "#B4B4B4")
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
                cell.commenCountLbl.isHidden = true
                if self.profileNewModel?.results?.class_list_arr.count ?? 0 > 0 &&
                    self.profileNewModel?.results?.mode ?? "" == "myprofile" {
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
                if self.class_list_arr?.count ?? 0 > 0 {
                    for i in 0..<(self.class_list_arr?.count ?? 0) {
                        cell.class_list_arr.append((self.class_list_arr?[i])!)
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
                cell.profileTableViewTitleLbl.text = "스토리"
                cell.coachStudioBtn.isHidden = true
                if self.profileNewModel?.results?.total ?? 0 > 0 {
                    cell.commenCountLbl.text = "\(self.profileNewModel?.results?.total ?? 0)개"
                } else {
                    cell.commenCountLbl.isHidden = true
                }
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
