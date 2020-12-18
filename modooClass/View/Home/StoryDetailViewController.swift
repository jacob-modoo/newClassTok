//
//  StroyDetailViewController.swift
//  modooClass
//
//  Created by 조현민 on 2020/02/17.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
//import BMPlayer
import AVFoundation
import Photos
import CropViewController
import AVKit
import MediaPlayer
import Firebase

class StoryDetailViewController: UIViewController {

    
    @IBOutlet weak var vmHeightConst: NSLayoutConstraint!
    @IBOutlet weak var vmAspectConst: NSLayoutConstraint!
    @IBOutlet weak var ytHeightConst: NSLayoutConstraint!
    @IBOutlet weak var ytAspectConst: NSLayoutConstraint!
    @IBOutlet weak var replyTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ytView: WKYTPlayerView!
    @IBOutlet weak var vmView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var user_photo: UIImageView!
    @IBOutlet weak var viewTitle: UIFixedLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var replySendView: UIView!
    @IBOutlet weak var replyBorderView: UIView!
    @IBOutlet weak var replyTextViewLbl: UIFixedLabel!
    @IBOutlet weak var replyTextView: UIFixedTextView!
    @IBOutlet weak var emoticonViewEnterBtn: UIButton!
    @IBOutlet weak var replySendBtn: UIButton!
    @IBOutlet weak var emoticonSelectView: UIView!
    @IBOutlet weak var emoticonImg: UIImageView!
    @IBOutlet weak var moreBtn: UIButton!
    
    lazy var emoticonView: EmoticonView = {
        let tv = EmoticonView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private var playerVars = [
        "autoplay": 1,
        "playsinline": 1,
        "autohide":1,
        "controls": 1,
        "showinfo": 1,
        "fs": 1,
        "rel": 0,
        "loop": 0,
        "enablejsapi": 1,
        "disablekv":1,
        "iv_load_policy":3,
        "modestbranding": 0,
    ]
    var refreshControl = UIRefreshControl()
    
    let randomColor = ["#DED8D2", "#E6D8DB"]
    
    var emoticonNumber:Int = 0
    var keyboardShow = false
    var keyBoardSize:CGRect?
    var customView: UIView!
    private let imageView = UIImageView()
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var youtube_url = ""
    var youtube_load = false
    var feedId = "S182711"//"M186759"//"Q185271"//"R5363"//"M182754"//"R5363" //"S182711"  "Q185271"
    var list:SquareDetailModel?
    var videoPlayer:AVPlayer!
    let playerController = AVPlayerViewController()
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    var firstExec:Bool = true
    var photoSize:CGFloat = 100
    var photoSizeImage:UIImageView = UIImageView.init(frame: .zero)
    var page = 1
    var tagForLikeBtn = 0
    var user_id = UserManager.shared.userInfo.results?.user?.id ?? 0
    var active_comment_list:Array = Array<Active_comment>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.logEvent("피드", parameters: [AnalyticsParameterScreenName : "StoryDetailViewController"])
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.storyDetailReplyUpdate), name: NSNotification.Name(rawValue: "storyDetailReplyUpdate"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateStoryDetailLikeCount), name: NSNotification.Name(rawValue: "updateStoryDetailLikeCount"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.chattingCheck), name: NSNotification.Name(rawValue: "feedDetailValueSend"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.feedDetailFriend), name: NSNotification.Name(rawValue: "feedDetailFriend"), object: nil )
        
        FeedApi.shared.appMainPilotV2(success: { result in
            if result.code == "200" {
                HomeMain2Manager.shared.pilotAppMain = result
            } else {
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
            })
        }
        
        ProfileApi.shared.profileV2ActiveList(user_id: self.user_id,page:self.page, success: { [unowned self] result in
            if result.code == "200"{
//                self.profileModel = result
                for addArray in 0 ..< (result.results?.active_comment_list.count)! {
                    self.active_comment_list.append((result.results?.active_comment_list[addArray])!)
                }
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
            })
        }
        
        replyBorderView.layer.borderWidth = 1
        replyBorderView.layer.borderColor = UIColor(hexString: "#eeeeee").cgColor
        replyBorderView.layer.cornerRadius = 15
        replyTextView.layer.cornerRadius = 15
        replyTextView.autocorrectionType = .no
        
        replySendView.layer.shadowColor = UIColor(hexString: "#757575").cgColor
        replySendView.layer.shadowOffset = CGSize(width: 0.0, height: -6.0)
        replySendView.layer.shadowOpacity = 0.05
        replySendView.layer.shadowRadius = 4
        replySendView.layer.masksToBounds = false
        
        ytView.delegate = self
        
        emoticonView.WithEmoticon { [unowned self] eNumber in
            self.emoticonSelectView.isHidden = false
            self.emoticonImg.image = UIImage(named: "emti\(eNumber+1)")
            self.emoticonNumber = eNumber+1
            self.image = nil
        }
        
        self.addChild(playerController)
        self.vmView.addSubview(playerController.view)
        playerController.view.snp.makeConstraints{ (make) in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        self.vmView.frame = self.view.frame
        
        tableView.estimatedRowHeight = 44
        squareDetail()
        
    }
    
     @objc func feedDetailFriend(notification:Notification){
        if let temp = notification.object {
            let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
            if UserManager.shared.userInfo.results?.user?.id == temp as? Int {
                newViewController.isMyProfile = true
            }else{
                newViewController.isMyProfile = false
            }
            newViewController.user_id = temp as! Int
            self.ytView.pauseVideo()
            self.playerController.player?.pause()
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @objc func chattingCheck(notification:Notification){
        guard let chattingUrl = notification.userInfo?["chattingUrl"] as? String else { return }
        let newViewController = UIStoryboard(name: "ChattingWebView", bundle: nil).instantiateViewController(withIdentifier: "ChattingFriendWebViewViewController") as! ChattingFriendWebViewViewController
        newViewController.url = chattingUrl
        newViewController.tokenCheck = true
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        print("StroyDetailViewController deinit")
    }
    
    @objc func storyDetailReplyUpdate(notification:Notification){
        guard let replyArray = notification.userInfo?["replyArray"] as? Array<SquareReply_list> else { return }
        guard let replyCount = notification.userInfo?["replyCount"] as? Int else { return }
        self.list?.results?.comment_reply?.list_arr.removeAll()
        self.list?.results?.comment_reply?.list_arr = replyArray
        self.list?.results?.reply_cnt = replyCount
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /**
     - will update the count of likes in comment section in tableView
     */
    @objc func updateStoryDetailLikeCount(notification: Notification) {
        if (notification.userInfo as NSDictionary?) != nil {
            let sender = notification.userInfo?["btnTag"] as! UIButton
            let likeGubun = notification.userInfo?["likeGubun"] as! Int
            sender.tag = self.tagForLikeBtn
            if likeGubun != 1 {               // if we don't use this we will call only API "delete" type not "post"
                sender.tag += 1
            }
            replyLikeHave(sender: sender)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            self.tableView.isUserInteractionEnabled = false
            DispatchQueue.main.async {
                self.squareDetail()
            }
        }
    }
    
    func endOfWork() {
        refreshControl.endRefreshing()
        self.tableView.isUserInteractionEnabled = true
    }
    
    /** **이미지 클릭 버튼 > 이미지를 크기 보게  */
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        if imageView.image != nil{
            Alert.WithImageView(self, image: imageView.image!, btn1Title: "", btn1Handler: {
                
            })
        }
    }
    
    @IBAction func emptyViewBtnClicked(_ sender: UIButton) {
        let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "StoryReplyDetailViewController") as! StoryReplyDetailViewController
        newViewController.feedId = self.feedId
        newViewController.replyCount = self.list?.results?.comment_reply?.reply_total ?? 0
        newViewController.keyboardShow = false
        self.navigationController?.pushViewController(newViewController, animated: true)
        
        DispatchQueue.main.async {
            if self.keyboardShow == true {
                self.view.endEditing(true)
                self.textViewTab()
            }
        }
    }
    
    /** **this button will delete the feed*/
    @IBAction func moreBtnClicked(_ sender: UIButton) {
        let content_id = self.list?.results?.content_id ?? 0
        Alert.With(self, title: "알림", content: "게시물을 삭제하시겠어요?", btn1Title: "취소", btn1Handler: {
        }, btn2Title: "확인", btn2Handler: {
            FeedApi.shared.feed_delete(id: content_id, success: { [unowned self] result in
                if result.code == "200"{
                    if self.active_comment_list.count != 0 {
                        for i in 0..<self.active_comment_list.count {
                            if content_id == self.active_comment_list[i].id ?? 0 {
                                self.active_comment_list.remove(at: i)
                                break
                            }
                        }
                    }
                }
            }) { (error) in
                Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                self.endOfWork()
                })
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateProfileActiveList"), object: nil)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func returnBackBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /** **이모티콘 선택 이미지 클릭 > 이모티콘뷰 보이기  */
    @IBAction func replyEmoticonBtnClicked(_ sender: UIButton) {
        replyTextView.becomeFirstResponder()
        DispatchQueue.main.async {
            if self.customView == nil {
                self.customView = UIView.init(frame: CGRect.init(x: 0, y: (self.keyBoardSize?.origin.y)!, width: self.view.frame.width, height: self.keyBoardSize!.height))
                self.customView.addSubview(self.emoticonView)
                self.emoticonView.snp.makeConstraints { (make) in
                    make.bottom.top.leading.trailing.equalToSuperview()
                }
                let tapOut: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.textViewTab))
                self.replyTextView.addGestureRecognizer(tapOut)
                UIApplication.shared.windows.last?.addSubview(self.customView)
            }else {
                self.customView.removeFromSuperview()
                self.customView = nil
            }
        }
    }
    
    /** **이모티콘뷰 나가기 버튼 클릭 > 이모티콘뷰 닫기  */
    @IBAction func emoticonViewExitBtnClicked(_ sender: UIButton) {
        emoticonSelectView.isHidden = true
        emoticonImg.image = nil
        self.image = nil
    }
    
    @IBAction func classAttendBtnClicked(_ sender: UIButton) {
        self.navigationController?.popOrPushController(class_id: self.list?.results?.mcClass_id ?? 0)
    }
    
    @IBAction func replyLikeCountBtnClicked(_ sender: UIButton) {
        squareMainHaveSave(sender: sender)
    }
    
    @IBAction func replyCountBtnClicked(_ sender: UIButton) {
        let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "StoryReplyDetailViewController") as! StoryReplyDetailViewController
        newViewController.feedId = self.feedId
        newViewController.replyCount = self.list?.results?.comment_reply?.reply_total ?? 0
        self.navigationController?.pushViewController(newViewController, animated: true)
        
        DispatchQueue.main.async {
            if self.keyboardShow == true {
                self.view.endEditing(true)
                self.textViewTab()
            }
        }
    }
    
    @IBAction func activeLikeBtnClicked(_ sender: UIButton) {
        squareSubHaveSave(sender: sender)
    }
    
    @IBAction func likeListBtnClicked(_ sender: UIButton) {
        //좋아요 리스트 고고
        let nextView = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "ReplyLikeViewController") as! ReplyLikeViewController
        nextView.modalPresentationStyle = .overFullScreen
//        nextView.comment_id = Int((self.list?.results!.id)!) ?? 0//sender.tag
        nextView.comment_str_id = self.feedId
        nextView.viewCheck = "feedDetail"
        self.present(nextView, animated:true,completion: nil)
    }
    
    @IBAction func activeProfileBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
            if UserManager.shared.userInfo.results?.user?.id == self.list?.results?.user_info?.user_id ?? 0 {
                newViewController.isMyProfile = true
            }else{
                newViewController.isMyProfile = false
            }
            newViewController.user_id = self.list?.results?.user_info?.user_id ?? 0
            self.ytView.pauseVideo()
            self.playerController.player?.pause()
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func replySendBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.replyTextView.text?.isBlank == false || self.emoticonImg.image != nil{
            replySend(sender:sender)
        }else{
            Alert.With(self, title: "댓글을 입력해주세요", btn1Title: "확인", btn1Handler: {
                self.replyTextView.becomeFirstResponder()
            })
        }
    }
    
    @IBAction func activeWithoutChatBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 1{
            friend_add(sender: sender)
        }else{
            let newViewController = UIStoryboard(name: "ChattingWebView", bundle: nil).instantiateViewController(withIdentifier: "ChattingFriendWebViewViewController") as! ChattingFriendWebViewViewController
            
            newViewController.url = "https://www.modooclass.net/class/chat/\(self.list?.results?.user_info?.user_id ?? 0)"
            newViewController.tokenCheck = true
            self.ytView.pauseVideo()
            self.playerController.player?.pause()
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func imagePickerBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        imagePicked()
    }
    
    @IBAction func replyMoreBtnClicked(_ sender: UIButton) {
        let comment_id = self.list?.results?.comment_reply?.list_arr[sender.tag].comment_id ?? ""
        Alert.With(self, btn1Title: "삭제", btn1Handler: {
            DispatchQueue.main.async {
                FeedApi.shared.squareReplyDelete(articleId: comment_id, success: { [unowned self] result in
                    if result.code == "200"{
                        for addArray in 0 ..< (self.list?.results?.comment_reply?.list_arr.count ?? 0)! {
                            if comment_id == "\(self.list?.results?.comment_reply?.list_arr[addArray].comment_id ?? "")"{
                                self.list?.results?.comment_reply?.list_arr.remove(at: addArray)
                                DispatchQueue.main.async {
                                    self.tableView.reloadSections([4,5,6], with: .automatic)
                                }
                                break
                            }
                        }
                    }
                }) { error in
                    
                }
            }
        })
    }
    
    @IBAction func activeMoveBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        self.feedId = self.list?.results?.user_info?.active_list_arr[tag].click_event ?? ""
        let sameVC = home2WebViewStoryboard.instantiateViewController(withIdentifier: "StoryDetailViewController") as! StoryDetailViewController
        sameVC.feedId = self.feedId
        self.navigationController?.pushViewController(sameVC, animated: true)
    }
    
    @IBAction func likeCountBtnClicked(_ sender: UIButton) {
//        let row = sender.tag / 10000
//        let likeValue = list?.results?.comment_reply?.list_arr[row].like_me ?? ""
//        let comment_id = list?.results?.comment_reply?.list_arr[row].comment_id ?? ""
//
//        if likeValue == "N" {
             replyLikeHave(sender: sender)
//        } else {
//            let nextView = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "ReplyLikeViewController") as! ReplyLikeViewController
//            nextView.modalPresentationStyle = .overFullScreen
//            nextView.comment_str_id = comment_id
//            self.tagForLikeBtn = sender.tag
//            nextView.viewCheck = "feedDetailMain"
//            self.present(nextView, animated:true,completion: nil)
//        }
    }
    
    @IBAction func friendProfileBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
            let friend_id = self.list?.results?.comment_reply?.list_arr[sender.tag].user_id ?? 0
            if UserManager.shared.userInfo.results?.user?.id == friend_id {
                newViewController.isMyProfile = true
            }else{
                newViewController.isMyProfile = false
            }
            newViewController.user_id = friend_id
            self.ytView.pauseVideo()
            self.playerController.player?.pause()
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    func replySend(sender:UIButton){
//        https://api2.enfit.net/api/v3/squareComment/M184695
        sender.isUserInteractionEnabled = false
        let content = self.replyTextView.text
        Indicator.showActivityIndicator(uiView: self.view)
        FeedApi.shared.squareReplySave(articleId: self.feedId, content: content!, emoticon: self.emoticonNumber, photo: self.image, success: { [unowned self] result in
            if result.code == "200"{
                let temp = SquareReply_list.init()
                
                temp.id = result.results?.id
                temp.user_name = result.results?.user_name ?? ""
                temp.user_photo = result.results?.user_photo ?? ""
                temp.content = result.results?.content ?? ""
                temp.emoticon = result.results?.emoticon ?? 0
                temp.job_name = result.results?.job_name ?? ""
                temp.like_cnt = result.results?.like_cnt ?? 0
                temp.like_me = result.results?.like_me ?? ""
                temp.photo_url = result.results?.photo_url ?? ""
                temp.created_at = result.results?.created_at ?? ""
                temp.comment_id = result.results?.comment_id ?? ""
                temp.coach_yn = result.results?.coach_yn ?? ""
                temp.friend_yn = result.results?.friend_yn ?? ""
                temp.time_spilled = result.results?.time_spilled ?? "1초전"
                self.list?.results?.comment_reply?.list_arr.insert(temp, at: 0)
                
                self.list?.results?.comment_reply?.reply_total = (self.list?.results?.comment_reply?.reply_total ?? 0) + 1
                self.list?.results?.reply_cnt = (self.list?.results?.reply_cnt ?? 0) + 1
                
                self.emoticonSelectView.isHidden = true
                self.emoticonImg.image = nil
                self.replyTextViewLbl.isHidden = false
                self.replyTextView.text = ""
                self.textViewTab()
                self.emoticonNumber = 0
                DispatchQueue.main.async {
                    self.tableView.reloadSections([4,5,6], with: .automatic)
                }
            }
            
            Indicator.hideActivityIndicator(uiView: self.view)
            sender.isUserInteractionEnabled = true
            
        }) { error in
            Indicator.hideActivityIndicator(uiView: self.view)
            sender.isUserInteractionEnabled = true
        }
    }
    
    func squareMainHaveSave(sender:UIButton){
        var type = ""
        
        if self.list?.results?.like_yn ?? "" == "N"{
            type = "post"
            sender.setImage(UIImage(named: "profile_likeBtn_active"), for: .normal)
            sender.setTitle("  도움돼요 \((self.list?.results?.like_cnt ?? 0) + 1)  ", for: .normal)
        }else{
            type = "delete"
            sender.setImage(UIImage(named: "profile_main_likeBtn"), for: .normal)
            sender.setTitle("  도움돼요 \((self.list?.results?.like_cnt ?? 0) - 1)  ", for: .normal)
        }
        
        ProfileApi.shared.profileV2CommentLike(comment_id: self.feedId, type: type, success: { [unowned self] result in
            if result.code == "200"{
                if self.list?.results?.like_yn ?? "" == "N"{
                    sender.setImage(UIImage(named: "profile_likeBtn_active"), for: .normal)
                    self.list?.results?.like_yn = "Y"
                    self.list?.results?.like_cnt = (self.list?.results?.like_cnt ?? 0) + 1
                }else{
                    sender.setImage(UIImage(named: "profile_main_likeBtn"), for: .normal)
                    self.list?.results?.like_yn = "N"
                    self.list?.results?.like_cnt = (self.list?.results?.like_cnt ?? 0) - 1
                }
            }
        }) { error in
            if self.list?.results?.like_yn ?? "" == "N"{
                sender.setImage(UIImage(named: "profile_main_likeBtn"), for: .normal)
                sender.setTitle("  도움돼요 \((self.list?.results?.like_cnt ?? 0) - 1)  ", for: .normal)
            }else{
                sender.setImage(UIImage(named: "profile_likeBtn_active"), for: .normal)
                sender.setTitle("  도움돼요 \((self.list?.results?.like_cnt ?? 0) + 1)  ", for: .normal)
            }
        }
    }
    
    func squareSubHaveSave(sender:UIButton){
        var type = ""
        let tag = sender.tag
        
        if self.list?.results?.user_info?.active_list_arr[tag].mcLike_status ?? "" == "N"{
            type = "post"
            sender.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
        }else{
            type = "delete"
            sender.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
        }
        
        ProfileApi.shared.profileV2CommentLike(comment_id: self.list?.results?.user_info?.active_list_arr[tag].click_event ?? "", type: type, success: { [unowned self] result in
            if result.code == "200"{
                if type == "delete"{
                    sender.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    self.list?.results?.user_info?.active_list_arr[tag].like_cnt = (self.list?.results?.user_info?.active_list_arr[tag].like_cnt ?? 0) - 1
                    self.list?.results?.user_info?.active_list_arr[tag].mcLike_status = "N"
                }else{
                    sender.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    self.list?.results?.user_info?.active_list_arr[tag].like_cnt = (self.list?.results?.user_info?.active_list_arr[tag].like_cnt ?? 0) + 1
                    self.list?.results?.user_info?.active_list_arr[tag].mcLike_status = "Y"
                }
                
                let indexPath = IndexPath(row: tag/3, section: 8)
                if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                    if visibleIndexPaths != NSNotFound {
                        let indexPath = IndexPath(row: tag/3, section: 8)
                        let cell = self.tableView.cellForRow(at: indexPath) as! StoryDetailTableViewCell
                        
                        if tag%3 == 0{
                            cell.photoLikeCount1.text = "도움돼요 \(self.list?.results?.user_info?.active_list_arr[tag].like_cnt ?? 0)"
                        }else if tag%3 == 1{
                            cell.photoLikeCount2.text = "도움돼요 \(self.list?.results?.user_info?.active_list_arr[tag].like_cnt ?? 0)"
                        }else{
                            cell.photoLikeCount3.text = "도움돼요 \(self.list?.results?.user_info?.active_list_arr[tag].like_cnt ?? 0)"
                        }
                    }
                }
                
            }
        }) { error in
            
        }
    }
    
    /** **텍스트뷰 클릭 > 이모티콘뷰 숨기기 */
    @objc func textViewTab(){
        if self.customView != nil {
            self.customView.removeFromSuperview()
            self.customView = nil
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 키보드가 보일때 함수
     
     - Parameters:
        - notification: 키보드가 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func keyboardWillShow(notification: Notification) {
        if keyboardShow == false {
            print("이거 혹시 두번타니?")
            if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.keyBoardSize = kbSize
                UIView.animate(withDuration: 0.5, animations: {
                    if #available(iOS 11.0, *) {
                        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
                        self.view.frame.size.height = self.view.frame.size.height - kbSize.height
                    }
                    self.view.layoutIfNeeded()
                    self.keyboardShow = true
                }) { success in
                    
                }
            }
            
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 키보드가 보이지 않을때 함수
     
     - Parameters:
        - notification: 키보드가 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func keyboardWillHide(notification: Notification) {
        if keyboardShow == true {
            if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.keyBoardSize = nil
                if self.customView != nil {
                    self.customView.removeFromSuperview()
                    self.customView = nil
//                    if APPDELEGATE?.topMostViewController()?.isKind(of: DetailReplyViewController.self) == true{
                        self.replyTextView.gestureRecognizers?.removeLast()
//                    }
                }
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    if #available(iOS 11.0, *) {
                        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
                        self.view.frame.size.height = self.view.frame.size.height + kbSize.height
                    }
                    self.view.layoutIfNeeded()
                    self.keyboardShow = false
                }) { success in
                    
                }
            }
        }
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardShow == true {
                if kbSize.size.height < self.keyBoardSize?.height ?? 0{
                    self.view.frame.size.height = self.view.frame.size.height + ((self.keyBoardSize?.height ?? 0) - kbSize.size.height)
                }else{
                    self.view.frame.size.height = self.view.frame.size.height + ((self.keyBoardSize?.height ?? 0) - kbSize.size.height)
                }
                self.keyBoardSize = kbSize
            }
        }
    }
    
    func replyLikeHave(sender:UIButton){
        sender.isUserInteractionEnabled = false
        let row = sender.tag / 10000
        let likeGubun = sender.tag % 10000
        //let likeGubun = self.list?.results?.comment_reply?.list_arr[row].like_me ?? ""
        let comment_id = self.list?.results?.comment_reply?.list_arr[row].comment_id ?? ""
        var type = ""
        if likeGubun == 1{
            type = "delete"
        }else{
            type = "post"
        }

        ProfileApi.shared.profileV2CommentLike(comment_id: comment_id, type: type, success: { [unowned self] result in
            if result.code == "200"{
                let indexPath = IndexPath(row: row, section: 4)
                let cell = self.tableView.cellForRow(at: indexPath) as! StoryDetailTableViewCell
                if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                    if visibleIndexPaths != NSNotFound {
                        if self.list?.results?.comment_reply?.list_arr[row].like_cnt ?? 0 > 0 {
                            cell.likeCountBtn.setTitle(" \(self.list?.results?.comment_reply?.list_arr[row].like_cnt ?? 0)", for: .normal)
                        }
                    }
                }
                
                if likeGubun == 1{
                    cell.likeCountBtn.tag = row*10000 + 2
                    self.list?.results?.comment_reply?.list_arr[row].like_cnt = (self.list?.results?.comment_reply?.list_arr[row].like_cnt ?? 0)-1
                    self.list?.results?.comment_reply?.list_arr[row].like_me = "N"
                    cell.likeCountBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                    cell.likeCountBtn.setImage(UIImage(named: "comment_likeBtn_default"), for: .normal)
                    cell.likeCountBtn.setTitle(" \(self.list?.results?.comment_reply?.list_arr[row].like_cnt ?? 0)", for: .normal)
                }else{
                    cell.likeCountBtn.tag = row*10000 + 1
                    self.list?.results?.comment_reply?.list_arr[row].like_me = "Y"
                    self.list?.results?.comment_reply?.list_arr[row].like_cnt = (self.list?.results?.comment_reply?.list_arr[row].like_cnt ?? 0)+1
                    cell.likeCountBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                    cell.likeCountBtn.setImage(UIImage(named: "comment_likeBtn_active"), for: .normal)
                    cell.likeCountBtn.setTitle(" \(self.list?.results?.comment_reply?.list_arr[row].like_cnt ?? 0)", for: .normal)
                }
                
                sender.isUserInteractionEnabled = true
                
            }else{
                sender.isUserInteractionEnabled = true
            }
        }) { error in
            sender.isUserInteractionEnabled = true
        }
    }
    
    func friend_add(sender: UIButton){
        let user_id = self.list?.results?.user_info?.user_id ?? 0
        let friend_status = self.list?.results?.user_info?.friend_status ?? "N"
        FeedApi.shared.friend_add(user_id: user_id,friend_status:friend_status,success: { [unowned self] result in
            if result.code == "200"{
                sender.setImage(UIImage(named: "messageImgV2"), for: .normal)
                self.list?.results?.user_info?.friend_status = "Y"
                sender.tag = 2
            }
        }) { error in
            
        }
    }
    
    func squareDetail(){
        self.ytView.isHidden = true
        self.vmView.isHidden = true
        
        FeedApi.shared.appSquareDetail(feedId: self.feedId,success: { [unowned self] result in
            Indicator.hideActivityIndicator(uiView: self.view)
            if result.code == "200"{
                self.list = result
                DispatchQueue.main.async {
                    self.ytAspectConst.priority = .defaultHigh
                    self.ytHeightConst.priority = .defaultLow
                    self.vmAspectConst.priority = .defaultHigh
                    self.vmHeightConst.priority = .defaultLow
                    
                    if self.list?.results?.play_file_app ?? "" != ""{
                        self.ytView.isHidden = true
                        self.vmView.isHidden = false
                        let url = URL(fileURLWithPath: "\(self.list?.results?.play_file_app ?? "")")
                        let player = AVPlayer(url: url)
                        self.playerController.player = player
    //                    player.play()
                        
                    }else{
                        if self.list?.results?.youtube_file ?? "" != ""{
    //                        Indicator.showActivityIndicator(uiView: self.view)
                            self.ytView.isHidden = false
                            self.vmView.isHidden = true
                            self.youtube_url = self.list?.results?.youtube_file ?? ""
                            self.videoLoad()
                        }else{
                            self.ytAspectConst.priority = .defaultLow
                            self.ytHeightConst.priority = .defaultHigh
                            self.vmAspectConst.priority = .defaultLow
                            self.vmHeightConst.priority = .defaultHigh
                            self.ytHeightConst.constant = 0
                            self.vmHeightConst.constant = 0
                            self.ytView.pauseVideo()
                            self.playerController.player?.pause()
                        }
                    }
                    self.view.layoutIfNeeded()
                    
                    for addArray in 0 ..< (self.list?.results?.user_info?.active_list_arr.count ?? 0)! {
                        if self.list?.results?.id ?? "" == "\(self.list?.results?.user_info?.active_list_arr[addArray].id ?? 0)"{
                            self.list?.results?.user_info?.active_list_arr.remove(at: addArray)
                            break
                        }
                    }
                
                    self.user_photo.sd_setImage(with: URL(string: "\(self.list?.results?.user_info?.user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                    let message = "\(self.list?.results?.user_info?.user_name ?? "")의 \(self.list?.results?.type ?? "")"
                    let attributedString = NSMutableAttributedString(string: message)

                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#484848"), range: (message as NSString).range(of:"의 \(self.list?.results?.type ?? "")"))
                    attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!, range: (message as NSString).range(of:"의 \(self.list?.results?.type ?? "")"))

                    self.viewTitle.attributedText = attributedString
                    
                    var cellFrame = self.view.frame.size
                    cellFrame.height =  cellFrame.height - 15
                    cellFrame.width =  cellFrame.width - 15
                    if self.list?.results?.photo_arr.count ?? 0 > 0{
                        self.photoSizeImage.sd_setImage(with: URL(string: "\(self.list?.results?.photo_arr[0].photo_url ?? "")"), placeholderImage: UIImage(named: "curriculumV2_default"), options: [], completed: { (theImage, error, cache, url) in
                            self.photoSize = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
                            UIView.animate(withDuration: 0.0, animations: {
                                
                                if self.firstExec == true{
                                    self.firstExec = false
                                }else{
                                    self.scrollToFirstRow()
                                }
                            }, completion: { _ in
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            })
                        })
                    }else{
                        UIView.animate(withDuration: 0.0, animations: {
                            
                            if self.firstExec == true{
                                self.firstExec = false
                            }else{
                                self.scrollToFirstRow()
                            }
                        }, completion: { _ in
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        })
                    }
                }
                
            }
            self.endOfWork()
        }) { error in
            self.endOfWork()
            Indicator.hideActivityIndicator(uiView: self.view)
        }
    }
    
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: NSNotFound, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
    }
    
    func gridView1(cell:StoryDetailTableViewCell , row:Int){
        let checkRow = (row*3)
        if self.list?.results?.user_info?.active_list_arr[checkRow].youtu_address ?? "" != ""{
            cell.photoView1.isHidden = false
            cell.noPhotoView1.isHidden = true
            cell.photoBackImage1.sd_setImage(with: URL(string: "http://img.youtube.com/vi/\((self.list?.results?.user_info?.active_list_arr[checkRow].youtu_address ?? "").replace(target: "https://youtu.be/", withString: "").replace(target: "https://www.youtube.com/watch?v=", withString: ""))/0.jpg"), placeholderImage: UIImage(named: "home_default_photo"))
            cell.photoLikeCount1.text = "👍 \(self.list?.results?.user_info?.active_list_arr[checkRow].like_cnt ?? 0)"
            cell.photoPlayImg1.isHidden = false

            cell.photoBtn1.tag = checkRow
//            if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.list?.results?.user_info?.active_list_arr[checkRow].user_id ?? 0{
                cell.photoLikeBtn1.isHidden = true
//            }else{
//                cell.photoLikeBtn1.isHidden = false
//            }
            if self.list?.results?.user_info?.active_list_arr[checkRow].mcLike_status ?? "N" == "N"{
                cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                cell.photoLikeBtn1.tag = checkRow
            }else{
                cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                cell.photoLikeBtn1.tag = checkRow
            }
        }else{
            cell.photoPlayImg1.isHidden = true
            if self.list?.results?.user_info?.active_list_arr[checkRow].photo_url ?? "" != "" {
                cell.photoView1.isHidden = false
                cell.noPhotoView1.isHidden = true
                cell.photoBackImage1.sd_setImage(with: URL(string: "\(self.list?.results?.user_info?.active_list_arr[checkRow].photo_url ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))

                cell.photoLikeCount1.text = "👍 \(self.list?.results?.user_info?.active_list_arr[checkRow].like_cnt ?? 0)"

                cell.photoBtn1.tag = checkRow
                if self.list?.results?.user_info?.active_list_arr[checkRow].mcLike_status ?? "N" == "N"{
                    cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.photoLikeBtn1.tag = checkRow
                }else{
                    cell.photoLikeBtn1.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.photoLikeBtn1.tag = checkRow
                }
//                if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.list?.results?.user_info?.active_list_arr[checkRow].user_id ?? 0{
                    cell.photoLikeBtn1.isHidden = true
//                }else{
//                    cell.photoLikeBtn1.isHidden = false
//                }
            }else{
                cell.photoView1.isHidden = true
                cell.noPhotoView1.isHidden = false
                cell.noPhotoProfileText1.text = "\(self.list?.results?.user_info?.active_list_arr[checkRow].content ?? "")"
                cell.noPhotoLikeCount1.text = "👍 \(self.list?.results?.user_info?.active_list_arr[checkRow].like_cnt ?? 0)"
                cell.noPhotoUserImg1.sd_setImage(with: URL(string: "\(self.list?.results?.user_info?.active_list_arr[checkRow].user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                
                let randomIndex = Int(arc4random_uniform(UInt32(randomColor.count)))
                cell.noPhotoView1.backgroundColor = UIColor(hexString: randomColor[randomIndex])

                cell.noPhotoBtn1.tag = checkRow
                
//                if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.list?.results?.user_info?.active_list_arr[checkRow].user_id ?? 0{
                    cell.noPhotoLikeBtn1.isHidden = true
//                }else{
//                    cell.noPhotoLikeBtn1.isHidden = false
//                }
                if self.list?.results?.user_info?.active_list_arr[checkRow].mcLike_status ?? "N" == "N"{
                    cell.noPhotoLikeBtn1.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.noPhotoLikeBtn1.tag = checkRow
                }else{
                    cell.noPhotoLikeBtn1.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.noPhotoLikeBtn1.tag = checkRow
                }
            }
        }

    }
    
    func gridView2(cell:StoryDetailTableViewCell , row:Int){
        let checkRow = (row*3)+1
        if self.list?.results?.user_info?.active_list_arr[checkRow].youtu_address ?? "" != ""{
            cell.photoView2.isHidden = false
            cell.noPhotoView2.isHidden = true
            cell.photoBackImage2.sd_setImage(with: URL(string: "http://img.youtube.com/vi/\((self.list?.results?.user_info?.active_list_arr[checkRow].youtu_address ?? "").replace(target: "https://youtu.be/", withString: "").replace(target: "https://www.youtube.com/watch?v=", withString: ""))/0.jpg"), placeholderImage: UIImage(named: "home_default_photo"))
            cell.photoLikeCount2.text = "👍 \(self.list?.results?.user_info?.active_list_arr[checkRow].like_cnt ?? 0)"
            cell.photoPlayImg2.isHidden = false
            cell.photoBtn2.tag = checkRow
//            if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.list?.results?.user_info?.active_list_arr[checkRow].user_id ?? 0{
                cell.photoLikeBtn2.isHidden = true
//            }else{
//                cell.photoLikeBtn2.isHidden = false
//            }
            if self.list?.results?.user_info?.active_list_arr[checkRow].mcLike_status ?? "N" == "N"{
                cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                cell.photoLikeBtn2.tag = checkRow
            }else{
                cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                cell.photoLikeBtn2.tag = checkRow
            }
        }else{
            cell.photoPlayImg2.isHidden = true
            if self.list?.results?.user_info?.active_list_arr[checkRow].photo_url ?? "" != "" {
                cell.photoView2.isHidden = false
                cell.noPhotoView2.isHidden = true
                cell.photoBackImage2.sd_setImage(with: URL(string: "\(self.list?.results?.user_info?.active_list_arr[checkRow].photo_url ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))

                cell.photoLikeCount2.text = "👍 \(self.list?.results?.user_info?.active_list_arr[checkRow].like_cnt ?? 0)"
                cell.photoBtn2.tag = checkRow
                if self.list?.results?.user_info?.active_list_arr[checkRow].mcLike_status ?? "N" == "N"{
                    cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.photoLikeBtn2.tag = checkRow
                }else{
                    cell.photoLikeBtn2.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.photoLikeBtn2.tag = checkRow
                }
                
//                if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.list?.results?.user_info?.active_list_arr[checkRow].user_id ?? 0{
                    cell.photoLikeBtn2.isHidden = true
//                }else{
//                    cell.photoLikeBtn2.isHidden = false
//                }
            }else{
                cell.photoView2.isHidden = true
                cell.noPhotoView2.isHidden = false
                cell.noPhotoProfileText2.text = "\(self.list?.results?.user_info?.active_list_arr[checkRow].content ?? "")"
                cell.noPhotoLikeCount2.text = "👍 \(self.list?.results?.user_info?.active_list_arr[checkRow].like_cnt ?? 0)"
                cell.noPhotoUserImg2.sd_setImage(with: URL(string: "\(self.list?.results?.user_info?.active_list_arr[checkRow].user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                let randomIndex = Int(arc4random_uniform(UInt32(randomColor.count)))
                cell.noPhotoView1.backgroundColor = UIColor(hexString: randomColor[randomIndex])
                cell.noPhotoBtn2.tag = checkRow
                if self.list?.results?.user_info?.active_list_arr[checkRow].mcLike_status ?? "N" == "N"{
                    cell.noPhotoLikeBtn2.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.noPhotoLikeBtn2.tag = checkRow
                }else{
                    cell.noPhotoLikeBtn2.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.noPhotoLikeBtn2.tag = checkRow
                }
//                if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.list?.results?.user_info?.active_list_arr[checkRow].user_id ?? 0{
                    cell.noPhotoLikeBtn2.isHidden = true
//                }else{
//                    cell.noPhotoLikeBtn2.isHidden = false
//                }
            }
        }
    }
    
    func gridView3(cell:StoryDetailTableViewCell , row:Int){
        let checkRow = (row*3)+2
        if self.list?.results?.user_info?.active_list_arr[checkRow].youtu_address ?? "" != ""{
            cell.photoView3.isHidden = false
            cell.noPhotoView3.isHidden = true
            
            cell.photoBackImage3.sd_setImage(with: URL(string: "http://img.youtube.com/vi/\((self.list?.results?.user_info?.active_list_arr[checkRow].youtu_address ?? "").replace(target: "https://youtu.be/", withString: "").replace(target: "https://www.youtube.com/watch?v=", withString: ""))/0.jpg"), placeholderImage: UIImage(named: "home_default_photo"))
            cell.photoLikeCount3.text = "👍 \(self.list?.results?.user_info?.active_list_arr[checkRow].like_cnt ?? 0)"
            cell.photoPlayImg3.isHidden = false
            cell.photoBtn3.tag = checkRow
            if self.list?.results?.user_info?.active_list_arr[checkRow].mcLike_status ?? "N" == "N"{
                cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                cell.photoLikeBtn3.tag = checkRow
            }else{
                cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                cell.photoLikeBtn3.tag = checkRow
            }
//            if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.list?.results?.user_info?.active_list_arr[checkRow].user_id ?? 0{
                cell.photoLikeBtn3.isHidden = true
//            }else{
//                cell.photoLikeBtn3.isHidden = false
//            }
        }else{
            cell.photoPlayImg3.isHidden = true
            if self.list?.results?.user_info?.active_list_arr[checkRow].photo_url ?? "" != "" {
                cell.photoView3.isHidden = false
                cell.noPhotoView3.isHidden = true
                cell.photoBackImage3.sd_setImage(with: URL(string: "\(self.list?.results?.user_info?.active_list_arr[checkRow].photo_url ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))

                cell.photoLikeCount3.text = "👍 \(self.list?.results?.user_info?.active_list_arr[checkRow].like_cnt ?? 0)"
                cell.photoBtn3.tag = checkRow
                if self.list?.results?.user_info?.active_list_arr[checkRow].mcLike_status ?? "N" == "N"{
                    cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.photoLikeBtn3.tag = checkRow
                }else{
                    cell.photoLikeBtn3.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.photoLikeBtn3.tag = checkRow
                }
//                if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.list?.results?.user_info?.active_list_arr[checkRow].user_id ?? 0{
                    cell.photoLikeBtn3.isHidden = true
//                }else{
//                    cell.photoLikeBtn3.isHidden = false
//                }
            }else{
                cell.photoView3.isHidden = true
                cell.noPhotoView3.isHidden = false
                cell.noPhotoProfileText3.text = "\(self.list?.results?.user_info?.active_list_arr[checkRow].content ?? "")"
                cell.noPhotoLikeCount3.text = "👍 \(self.list?.results?.user_info?.active_list_arr[checkRow].like_cnt ?? 0)"
                cell.noPhotoUserImg3.sd_setImage(with: URL(string: "\(self.list?.results?.user_info?.active_list_arr[checkRow].user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                let randomIndex = Int(arc4random_uniform(UInt32(randomColor.count)))
                cell.noPhotoView1.backgroundColor = UIColor(hexString: randomColor[randomIndex])
//                if UserManager.shared.userInfo.results?.user?.id ?? 0 == self.list?.results?.user_info?.active_list_arr[checkRow].user_id ?? 0{
                    cell.noPhotoLikeBtn3.isHidden = true
//                }else{
//                    cell.noPhotoLikeBtn3.isHidden = false
//                }
                cell.noPhotoBtn3.tag = checkRow
                if self.list?.results?.user_info?.active_list_arr[checkRow].mcLike_status ?? "N" == "N"{
                    cell.noPhotoLikeBtn3.setImage(UIImage(named: "profileV2_heart_default"), for: .normal)
                    cell.noPhotoLikeBtn3.tag = checkRow
                }else{
                    cell.noPhotoLikeBtn3.setImage(UIImage(named: "profileV2_heart_active"), for: .normal)
                    cell.noPhotoLikeBtn3.tag = checkRow
                }
            }
        }
    }
    
    func replyWriteCheck(){
        Alert.WithReply(self, btn1Title: "삭제", btn1Handler: {
            self.replyTextView.text = nil
            self.emoticonImg.image = nil
            self.image = nil
            if self.customView != nil{
                self.customView.removeFromSuperview()
                self.customView = nil
            }
        }, btn2Title: "이어서 작성", btn2Handler: {
            if self.emoticonImg.image != nil {
                self.emoticonSelectView.isHidden = false
            }
            self.replyTextView.becomeFirstResponder()
        })
    }
    
    func getAspectRatioAccordingToiPhones(cellImageFrame:CGSize,downloadedImage: UIImage)->CGFloat {
        let widthOffset = downloadedImage.size.width - cellImageFrame.width
        let widthOffsetPercentage = (widthOffset*100)/downloadedImage.size.width
        let heightOffset = (widthOffsetPercentage * downloadedImage.size.height)/100
        let effectiveHeight = downloadedImage.size.height - heightOffset
        return(effectiveHeight)
    }
}

extension StoryDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.list != nil{
            if section == 4{
                if self.list?.results?.comment_reply?.list_arr.count ?? 0 > 7{
                    return 7
                }else if self.list?.results?.comment_reply?.list_arr.count ?? 0 == 0{
                    return 0
                }else{
                    return self.list?.results?.comment_reply?.list_arr.count ?? 0
                }
            }else if section == 5{
                if self.list?.results?.comment_reply?.list_arr.count ?? 0 > 7 || self.list?.results?.comment_reply?.list_arr.count ?? 0 == 0{
                    return 1
                }else{
                    return 0
                }
            }else if section == 8{
                
                if (self.list?.results?.user_info?.active_list_arr.count ?? 0) > 0{
                    if (self.list?.results?.user_info?.active_list_arr.count ?? 0) % 3 == 0{
                        return (self.list?.results?.user_info?.active_list_arr.count ?? 0)/3
                    }else{
                        return (self.list?.results?.user_info?.active_list_arr.count ?? 0)/3 + 1
                    }
                }else{
                    return 0
                }
            }else{
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
            if self.list?.results?.play_file_app ?? "" != "" || self.list?.results?.youtube_file ?? "" != ""{
                let cell:StoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailClassInfoTableViewCell", for: indexPath) as! StoryDetailTableViewCell
                cell.classPriceImg.sd_setImage(with: URL(string: "\(self.list?.results?.class_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                cell.classPriceName.text = "\(self.list?.results?.class_name ?? "")"
                if self.list?.results?.mcClass_id ?? 0 == 0 {
                    cell.classLinkView.isHidden = true
                    cell.contentIfNeeded.isHidden = false
                    cell.contentIfNeeded.text = "\(self.list?.results?.content ?? "")"
                }else{
                    cell.classLinkView.isHidden = false
                    cell.contentIfNeeded.isHidden = true
                }
                
                if self.list?.results?.class_signup_data ?? 0 > 20{
                    cell.classSalePrice.text = "\(convertCurrency(money: (NSNumber(value: self.list?.results?.class_signup_data ?? 0)), style : NumberFormatter.Style.decimal))명이 \(self.list?.results?.coach_name ?? "")팔로잉."
                }else{
                    cell.classSalePrice.text = "\(self.list?.results?.coach_name ?? "")님의 클래스 오픈을 축하해주세요 ✨"
                }
                cell.selectionStyle = .none
                return cell
            }else{
                if self.list?.results?.photo_arr.count ?? 0 > 0{
                    let cell:StoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailClassInfoITableViewCell", for: indexPath) as! StoryDetailTableViewCell
                    var cellFrame = cell.frame.size
                    cellFrame.height =  cellFrame.height - 15
                    cellFrame.width =  cellFrame.width - 15
                    if self.list?.results?.type ?? "" == "미션"{
                        cell.missionCompleteImg.isHidden = false
                    }else{
                        cell.missionCompleteImg.isHidden = true
                    }
                    if self.list?.results?.mcClass_id ?? 0 == 0 {
                        cell.classLinkView.isHidden = true
                        cell.contentIfNeeded.isHidden = false
                        cell.contentIfNeeded.text = "\(self.list?.results?.content ?? "")"
                    }else{
                        cell.classLinkView.isHidden = false
                        cell.contentIfNeeded.isHidden = true
                    }
                    
                    cell.classPriceImg.sd_setImage(with: URL(string: "\(self.list?.results?.class_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                    cell.classPriceName.text = "\(self.list?.results?.class_name ?? "")"
                    if self.list?.results?.class_signup_data ?? 0 > 20{
                        cell.classSalePrice.text = "\(convertCurrency(money: (NSNumber(value: self.list?.results?.class_signup_data ?? 0)), style : NumberFormatter.Style.decimal))명이 \(self.list?.results?.coach_name ?? "")팔로잉."
                    }else{
                        cell.classSalePrice.text = "\(self.list?.results?.coach_name ?? "")님의 클래스 오픈을 축하해주세요 ✨"
                    }
                    
                    cell.replyPhotoImgHeightConst.constant = self.photoSize
                    cell.replyPhotoImg.sd_setImage(with: URL(string: "\(self.list?.results?.photo_arr[0].photo_url ?? "")"), placeholderImage: UIImage(named: "curriculumV2_default"))
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell:StoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailClassInfoQTableViewCell", for: indexPath) as! StoryDetailTableViewCell
                    cell.replyUserPhoto.sd_setImage(with: URL(string: "\(self.list?.results?.user_info?.user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                    cell.replyUserName.text = self.list?.results?.user_info?.user_name ?? ""
                    cell.classPriceImg.sd_setImage(with: URL(string: "\(self.list?.results?.class_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                    cell.classPriceName.text = "\(self.list?.results?.class_name ?? "")"
                    
                    if self.list?.results?.mcClass_id ?? 0 == 0 {
                        cell.classLinkView.isHidden = true
                        cell.contentIfNeeded.isHidden = false
                        cell.contentIfNeeded.text = "\(self.list?.results?.content ?? "")"
                    }else{
                        cell.classLinkView.isHidden = false
                        cell.contentIfNeeded.isHidden = true
                    }
                    
                    if self.list?.results?.class_signup_data ?? 0 > 20{
                        cell.classSalePrice.text = "\(convertCurrency(money: (NSNumber(value: self.list?.results?.class_signup_data ?? 0)), style : NumberFormatter.Style.decimal))명이 \(self.list?.results?.coach_name ?? "")팔로잉."
                    }else{
                        cell.classSalePrice.text = "\(self.list?.results?.coach_name ?? "")님의 클래스 오픈을 축하해주세요 ✨"
                    }
                    cell.selectionStyle = .none
                    return cell
                }
            }
            
        case 1:
            var cell:StoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailContentTableViewCell", for: indexPath) as! StoryDetailTableViewCell
            if self.list?.results?.type ?? "" == "리뷰"{
                if self.list?.results?.content_reply ?? "" == ""{
                    cell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailReviewTableViewCell", for: indexPath) as! StoryDetailTableViewCell
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailReview2TableViewCell", for: indexPath) as! StoryDetailTableViewCell
                    cell.coachImg.sd_setImage(with: URL(string: "\(self.list?.results?.coach_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                    cell.coachNick.text = "\(self.list?.results?.coach_name ?? "")"
                    cell.coachReviewContent.text = "\(self.list?.results?.content_reply ?? "")"
                }
                cell.reviewClassName.text = "\(self.list?.results?.class_name ?? "")"
                if self.list?.results?.star == 1 || self.list?.results?.star == 2 {
                    cell.userReviewStar1.image = UIImage(named: "review_not_recommended")
                }else {
                    cell.userReviewStar1.image = UIImage(named: "review_recom_short")
                }
            }
            /** this statement will correct the written tag in 스토리 작성 page*/
            if self.list?.results?.mcClass_id ?? 0 == 0 {
                if self.list?.results?.tag_data ?? "" != "" {
                    if self.list?.results?.tag_data?.first != "#" {
                        self.list?.results?.tag_data = "#\(self.list?.results?.tag_data ?? "")"
                    }
//                    cell.userReviewContent.text = "\(self.list?.results?.tag_data?.replace(target: "#", withString: " #") ?? "")"
                    cell.userReviewContent.text = "\(self.list?.results?.tag_data ?? "")"
                    cell.userReviewContent.textColor = UIColor(hexString: "#FF5A5F")
                    if self.list?.results?.tag_data?.first == " " {
                        cell.userReviewContent.text.removeFirst()
                    }
                    
                }
            }else{
                cell.userReviewContent.text = "\(self.list?.results?.content ?? "")"
                cell.userReviewContent.textColor = UIColor(hexString: "#484848")
            }
            /** hiding deleting btn (moreBtn) for other users*/
            if self.user_id == self.list?.results?.user_info?.user_id ?? 0 {
                self.moreBtn.isHidden = false
            }else{
                self.moreBtn.isHidden = true
            }
            
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell:StoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailInterestTableViewCell", for: indexPath) as! StoryDetailTableViewCell
            cell.interest_arr = (self.list?.results?.interest_arr)!
            cell.interestCollectionView.reloadData()
            DispatchQueue.main.async {
                cell.interestCollectionViewHeightConst.constant = cell.interestCollectionView.contentSize.height
            }
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell:StoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailLikeInfoTableViewCell", for: indexPath) as! StoryDetailTableViewCell
            if self.list?.results?.like_yn ?? "N" == "N"{
                cell.replyLikeCountBtn.setImage(UIImage(named: "profile_main_likeBtn"), for: .normal)
            }else{
                cell.replyLikeCountBtn.setImage(UIImage(named: "profile_likeBtn_active"), for: .normal)
            }
            cell.replyLikeCountBtn.setTitle("  도움돼요 \(self.list?.results?.like_cnt ?? 0)  ", for: .normal)
            cell.replyCountBtn.setTitle("  댓글 \(self.list?.results?.reply_cnt ?? 0)  ", for: .normal)
            cell.selectionStyle = .none
            return cell
        case 4:
            var cell:StoryDetailTableViewCell =  tableView.dequeueReusableCell(withIdentifier:  "StoryDetail1TableViewCell") as! StoryDetailTableViewCell
            if self.list?.results?.comment_reply?.list_arr.count ?? 0 > 0{
                if (self.list?.results?.comment_reply?.list_arr.count ?? 0)-1 >= row{
                    if self.list?.results?.comment_reply?.list_arr[row].photo_url ?? "" == "" && self.list?.results?.comment_reply?.list_arr[row].emoticon ?? 0 == 0{
                        cell = tableView.dequeueReusableCell(withIdentifier: "StoryDetail1TableViewCell", for: indexPath) as! StoryDetailTableViewCell
                    }else{
                        if self.list?.results?.comment_reply?.list_arr[row].content ?? "" != "" {
                            cell = tableView.dequeueReusableCell(withIdentifier: "StoryDetail2TableViewCell", for: indexPath) as! StoryDetailTableViewCell
                        }else{
                            cell = tableView.dequeueReusableCell(withIdentifier: "StoryDetail3TableViewCell", for: indexPath) as! StoryDetailTableViewCell
                        }
                        if self.list?.results?.comment_reply?.list_arr[row].emoticon ?? 0 == 0{
                            cell.replyPhoto.sd_setImage(with: URL(string: "\(self.list?.results?.comment_reply?.list_arr[row].photo_url ?? "")"), placeholderImage: UIImage(named: "user_default"))
                            cell.replyPhotoHightConst.constant = 160
                            cell.replyPhotoWidthConst.constant = 160
                        }else{
                            cell.replyPhoto.image = UIImage(named: "emti\(self.list?.results?.comment_reply?.list_arr[row].emoticon ?? 0)")
                            cell.replyPhotoHightConst.constant = 80
                            cell.replyPhotoWidthConst.constant = 80
                        }
                        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                        cell.replyPhoto.addGestureRecognizer(pictureTap)
                        
                    }
                    
                    cell.userName.text = self.list?.results?.comment_reply?.list_arr[row].user_name
                    cell.reply_userPhoto.sd_setImage(with: URL(string: "\(self.list?.results?.comment_reply?.list_arr[row].user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                    cell.replyTime.text = self.list?.results?.comment_reply?.list_arr[row].time_spilled ?? "0분전"
                    
                    if self.list?.results?.comment_reply?.list_arr[row].like_me ?? "" == "Y" {
//                        cell.likeBtn.setTitleColor(UIColor(named: "MainPoint_mainColor"), for: .normal)
//                        cell.likeBtn.tag = row*10000 + 1
                        cell.likeCountBtn.tag = row*10000 + 1
                        cell.likeCountBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                        cell.likeCountBtn.setImage(UIImage(named: "comment_likeBtn_active"), for: .normal)
                        cell.likeCountBtn.setTitle(" \(self.list?.results?.comment_reply?.list_arr[row].like_cnt ?? 0)", for: .normal)
                    }else{
//                        cell.likeBtn.setTitleColor(UIColor(named: "FontColor_mainColor"), for: .normal)
//                        cell.likeBtn.tag = row*10000 + 2
                        cell.likeCountBtn.tag = row*10000 + 2
                        cell.likeCountBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                        cell.likeCountBtn.setImage(UIImage(named: "comment_likeBtn_default"), for: .normal)
                        cell.likeCountBtn.setTitle(" \(self.list?.results?.comment_reply?.list_arr[row].like_cnt ?? 0)", for: .normal)
                    }
                    
                    if self.list?.results?.comment_reply?.list_arr[row].user_id == UserManager.shared.userInfo.results?.user?.id {
                        cell.moreBtn.tag = row
                        cell.moreBtn.isHidden = false
                    }else{
                        cell.moreBtn.isHidden = true
                    }
                    
//                    if self.list?.results?.comment_reply?.list_arr[row].like_cnt ?? 0 > 0 {
//                        cell.likeCountBtn.setTitle("\(self.list?.results?.comment_reply?.list_arr[row].like_cnt ?? 0)", for: .normal)
//                    }
                    
                    if self.list?.results?.comment_reply?.list_arr[row].content ?? "" != "" {
                        cell.replyContentTextView.text = self.list?.results?.comment_reply?.list_arr[row].content ?? ""
                        cell.replyContentTextView.textContainer.lineBreakMode = .byTruncatingTail
                    }else{ }
                    
//                    if self.list?.results?.comment_reply?.list_arr[row].coach_yn ?? "N" == "Y"{
//                        cell.coachStar.isHidden = false
//                    }else{
//                        cell.coachStar.isHidden = true
//                    }
                    
                    cell.replyContentView.layer.cornerRadius = 12
                    cell.likeCountBtn.layer.shadowOpacity = 0.1
                    cell.likeCountBtn.layer.shadowRadius = 3
                    cell.likeCountBtn.layer.shadowOffset = CGSize(width: 0,height: 2)
                    
                    cell.friendProfileBtn.tag = row//replyArray[row].user_id ?? 0
                    cell.friendProfile2Btn.tag = row//replyArray[row].user_id ?? 0
                    //cell.likeCountBtn.tag = self.list?.results?.comment_reply?.list_arr[row].id ?? 0
                }
            }
            
            cell.selectionStyle = .none
            return cell
        case 5:
            var cell:StoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailEmptyTableViewCell", for: indexPath) as! StoryDetailTableViewCell
            if self.list?.results?.comment_reply?.list_arr.count ?? 0 > 7{
                cell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailOverTableViewCell", for: indexPath) as! StoryDetailTableViewCell
                cell.replyDetailMoveBtn.setTitle("\((self.list?.results?.comment_reply?.reply_total ?? 0)-7)개의 댓글 더보기", for: .normal)
                
            }
            cell.selectionStyle = .none
            return cell
        case 6:
            let cell:StoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailLikeInfo2TableViewCell", for: indexPath) as! StoryDetailTableViewCell
            cell.infoLikeCnt.text = "\(self.list?.results?.like_cnt ?? 0)"
            cell.infoReplyCnt.text = "\(self.list?.results?.reply_cnt ?? 0)"
            cell.infoWriteDate.text = "\(self.list?.results?.time_spilled ?? "")"
            cell.selectionStyle = .none
            return cell
        case 7:
            let cell:StoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailActiveTitleTableViewCell", for: indexPath) as! StoryDetailTableViewCell
            cell.classCoachImg.sd_setImage(with: URL(string: "\(self.list?.results?.user_info?.user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
            cell.classCoachName.text = "\(self.list?.results?.user_info?.user_name ?? "")"
            
            if self.list?.results?.user_info?.user_id ?? 0 != UserManager.shared.userInfo.results?.user?.id ?? 0 {
                if self.list?.results?.user_info?.friend_status ?? "Y" == "Y"{
                    cell.classCoachWithBtn.setImage(UIImage(named: "messageImgV2"), for: .normal)
                    cell.classCoachWithBtn.tag = 2
                }else{
                    cell.classCoachWithBtn.setImage(UIImage(named: "follow_profile"), for: .normal)
                    cell.classCoachWithBtn.tag = 1
                }
                cell.classCoachProfileBtn.tag = self.list?.results?.user_info?.user_id ?? 0
                
                if self.list?.results?.user_info?.gender ?? "M" == "M"{
                    cell.genderBadge.image = UIImage(named: "manBadge")
                }else if self.list?.results?.user_info?.gender ?? "M" == "F"{
                    cell.genderBadge.image = UIImage(named: "womanBadge")
                }else{
                    cell.genderBadge.isHidden = true
                }
            } else {
                cell.classCoachWithBtn.isHidden = true
            }
            
            cell.classWithoutCnt.text = "팔로워 \(convertCurrency(money: (NSNumber(value: self.list?.results?.user_info?.mcFriend_cnt ?? 0)), style : .decimal))명"
            cell.selectionStyle = .none
            return cell
        case 8:
            let cell:StoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoryDetailActiveTableViewCell", for: indexPath) as! StoryDetailTableViewCell
            if (self.list?.results?.user_info?.active_list_arr.count ?? 0) > (row*3)+2{
                gridView1(cell: cell, row: row)
                gridView2(cell: cell, row: row)
                gridView3(cell: cell, row: row)
            }else{
                if (self.list?.results?.user_info?.active_list_arr.count ?? 0) % 3 == 2{
                    cell.photoView3.isHidden = true
                    cell.noPhotoView3.isHidden = true
                    gridView1(cell: cell, row: row)
                    gridView2(cell: cell, row: row)
                }else if (self.list?.results?.user_info?.active_list_arr.count ?? 0) % 3 == 1{
                    gridView1(cell: cell, row: row)
                    cell.photoView2.isHidden = true
                    cell.noPhotoView2.isHidden = true
                    cell.photoView3.isHidden = true
                    cell.noPhotoView3.isHidden = true
                }
            }
            
            cell.selectionStyle = .none
            return cell
        default:
            let cell:StoryDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StoryDetail1TableViewCell", for: indexPath) as! StoryDetailTableViewCell
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 8{
            let heightforCell3 = ((self.view.frame.width)/3)
            return heightforCell3
        }else{
            return UITableView.automaticDimension
        }
    }
    
    /** **테이블 셀의 선택시 함수 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            
        }
    }
}

extension StoryDetailViewController:UITextViewDelegate{
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 텍스트뷰가 변경될때 타는 함수
     
     - Parameters:
        - textView: 텍스트뷰 값이 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    func textViewDidChange(_ textView: UITextView) {
        if self.replyTextView.contentSize.height >= 45 {
            self.replyTextView.isScrollEnabled = true
            self.replyTextViewHeight.constant = 45
        }else{
            self.replyTextView.isScrollEnabled = false
            let sizeToFitIn = CGSize(width: self.replyTextView.bounds.size.width, height: CGFloat(MAXFLOAT))
            let newSize = self.replyTextView.sizeThatFits(sizeToFitIn)
            self.replyTextViewHeight.constant = newSize.height
        }
        
        if self.replyTextView.text == "" {
            replyTextViewLbl.isHidden = false
        }else{
            replyTextViewLbl.isHidden = true
        }
        
        if(textView.text == UIPasteboard.general.string){
            let newTextViewHeight = ceil(textView.sizeThatFits(textView.frame.size).height)
            if newTextViewHeight > 45 {
                self.replyTextView.isScrollEnabled = true
                self.replyTextViewHeight.constant = 45
            }else{
                self.replyTextViewHeight.constant = newTextViewHeight
            }
        }
    }
    
}

extension StoryDetailViewController:CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 이미지 선택을 위한 알림창 띄움 앨범 or 카메라
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    func imagePicked(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "사진첩", style: .default) { (action) in
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .overFullScreen
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let profileAction = UIAlertAction(title: "카메라", style: .default) { (action) in
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.modalPresentationStyle = .overFullScreen
            //            imagePicker.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
            imagePicker.preferredContentSize = CGSize(width: 320, height: 568)
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        alertController.addAction(profileAction)
        alertController.addAction(defaultAction)
        alertController.modalPresentationStyle = .overFullScreen
        
        //        let presentationController = alertController.popoverPresentationController
        //        presentationController?.barButtonItem = (sender as! UIBarButtonItem)
        present(alertController, animated: true, completion: nil)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 이미지를 선택하는 함수
     
     - Parameters:
        - picker: imageViewController
        - info: 이미지 Data
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
        
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        //cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        //cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        //cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        //cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        
        //cropController.rotateButtonsHidden = true
        //cropController.rotateClockwiseButtonHidden = true
        
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        self.image = image
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            if picker.sourceType == .camera {
                picker.dismiss(animated: true, completion: {
                    if #available(iOS 13.0, *) {
                        cropController.modalPresentationStyle = .fullScreen
                    }
                    self.present(cropController, animated: true, completion: nil)
                })
            } else {
                picker.pushViewController(cropController, animated: true)
            }
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                if #available(iOS 13.0, *) {
                    cropController.modalPresentationStyle = .fullScreen
                }
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 이미지를 사각형으로 자르는 함수
     
     - Parameters:
        - cropViewController: imageViewController
        - image: 이미지 Data
        - cropRect: 자른 이미지 사각형 크기
        - angle: 자른 이미지 각도
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 이미지를 원형으로 자르는 함수
     
     - Parameters:
        - cropViewController: imageViewController
        - image: 이미지 Data
        - cropRect: 자른 이미지 사각형 크기
        - angle: 자른 이미지 각도
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 형태를 변형한 이미지를 보여주고 이미지뷰에 넣는 함수
     
     - Parameters:
        - cropViewController: imageViewController
        - image: 이미지 Data
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        
        if cropViewController.croppingStyle != .circular {
            imageView.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                   toView: imageView,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.layoutImageView() },
                                                   completion: { self.imageView.isHidden = false })
        }else {
            self.imageView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
        
        imageView.image = image
        self.emoticonSelectView.isHidden = false
        self.emoticonImg.image = ImageScale().scaleImage(image: image)
        self.image = ImageScale().scaleImage(image: image)
        self.emoticonNumber = 0
        let time = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.replyTextView.becomeFirstResponder()
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 이미지뷰를 선택시 앨범 or 카메라 선택하게 하는 탭 함수
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    @objc public func didTapImageView() {
        // When tapping the image view, restore the image to the previous cropping state
        let cropViewController = CropViewController(croppingStyle: self.croppingStyle, image: self.image!)
        cropViewController.delegate = self
        let viewFrame = view.convert(imageView.frame, to: navigationController!.view)
        
        cropViewController.modalPresentationStyle = .overFullScreen
        cropViewController.presentAnimatedFrom(self, fromImage: self.imageView.image, fromView: nil, fromFrame: viewFrame, angle: self.croppedAngle, toImageFrame: self.croppedRect, setup: { self.imageView.isHidden = true }, completion: nil)
    }
    
    /** **뷰가 불려오고난뒤 레이아웃의 뷰들 */
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    /** ** 이미지뷰의 크기 조절  함수 */
    public func layoutImageView() {
        guard imageView.image != nil else { return }

        let padding: CGFloat = 20.0

        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))

        var imageFrame = CGRect.zero
        imageFrame.size = imageView.image!.size;

        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imageView.frame = imageFrame
        }
        else {
            self.imageView.frame = imageFrame;
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
    
}

extension StoryDetailViewController:WKYTPlayerViewDelegate {
    func playerView(_ playerView: WKYTPlayerView, didPlayTime playTime: Float) {
    }
    
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        //        0 - 재생 안됨   1 - 재생 종료   2 - 재생 시작     3 - 일시중지    4 - 버퍼링
//        var play_state = ""
//        var play_time = 0
        switch state.rawValue {
        case 0:
            self.ytView.playVideo()
        case 1:
//            play_state = "end"
            break
        case 2:
//            Indicator.hideActivityIndicator(uiView: self.view)
//            play_state = "start"
            break
        case 3:
//            play_state = "pause"
            break
        default:
            break
        }
        
    }
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
//        playerView.playVideo()
    }
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo quality: WKYTPlaybackQuality) {
    }
    
    func playerView(_ playerView: WKYTPlayerView, receivedError error: WKYTPlayerError) {
    }
    
    func videoLoad(){
        let videoId = self.youtube_url.replace(target: "https://youtu.be/", withString: "").replace(target: "https://www.youtube.com/watch?v=", withString: "")
        self.ytView.load(withVideoId: videoId, playerVars: self.playerVars)
        
    }
    
}
