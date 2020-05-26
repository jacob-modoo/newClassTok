//
//  DetailReplyViewController.swift
//  modooClass
//
//  Created by 조현민 on 07/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CropViewController
import youtube_ios_player_helper
import AVKit
import MediaPlayer


/**
# DetailReplyViewController.swift 클래스 설명
 
 ## UIViewController 상속 받음
 - 클래스 참여 화면에 자식 뷰 컨트롤러
 */
class DetailReplyViewController: UIViewController {

    /** **댓글 나타내는 뷰 */
    @IBOutlet weak var replySendView: UIView!
    /** **댓글 텍스트 뷰 */
    @IBOutlet weak var replyTextView: UITextView!
    /** **댓글 PlaceHolder 라벨 */
    @IBOutlet var replyTextViewLbl: UILabel!
    /** **댓글 보내는 버튼 */
    @IBOutlet weak var replySendBtn: UIButton!
    /** **테이블뷰 */
    @IBOutlet weak var tableView: UITableView!
    /** **댓글 보더 뷰 */
    @IBOutlet weak var replyBorderView: UIView!
    /** **이모티콘뷰 나가기 버튼 */
    @IBOutlet weak var emoticonViewExitBtn: UIButton!
    /** **이모티콘 선택 버튼 */
    @IBOutlet weak var emoticonViewEnterBtn: UIButton!
    /** **이모티콘 선택할수 있는 뷰 */
    @IBOutlet weak var emoticonSelectView: UIView!
    /** **이모티콘 선택된 이미지뷰 */
    @IBOutlet weak var emoticonImg: UIImageView!
    /** **댓글 텍스트뷰 높이 */
    @IBOutlet weak var replyTextViewHeight: NSLayoutConstraint!
    /** **클래스 아이디 */
    var class_id = 0
    /** **커리큘럼 아이디 */
    var curriculum_id = 0
    /** **댓글 아이디 */
    var comment_id = 0
    /** **페이지 */
    var page = 1
    /** **이모티콘 숫자 */
    var emoticonNumber:Int = 0
    /** **댓글 타입 */
    var commentType = "class"
    /** **키보드 숨김 유무 */
    var keyboardShow = false
    /** **미션인지 체크 유무 */
    var missionCheck:Bool = false
    /** **공지사항인지 체크 유무 */
    var noticeCheck:Bool = false
    /** **키보드 사이즈 */
    var keyBoardSize:CGRect?
    /** **키보드위에 올리는 뷰 */
    var customView: UIView!
    private let imageView = UIImageView()
    /** **미션 이미지 */
    private var image: UIImage?
    /** **사진 크롭 스타일 */
    private var croppingStyle = CropViewCroppingStyle.default
    /** **크롭 사이즈 */
    private var croppedRect = CGRect.zero
    /** **크롭 각도 */
    private var croppedAngle = 0
    /** **댓글 리스트 */
    var list:FeedAppClassCommentDetailReplyModel?
    /** **댓글 리스트 페이징 배열 */
    var replyArray:Array = Array<AppClassCommentList>()
    /** **이모티콘 확장 뷰 */
    lazy var emoticonView: EmoticonView = {
        let tv = EmoticonView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let feedStoryboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
//    let profileStoryboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    let chattingStoryboard: UIStoryboard = UIStoryboard(name: "ChattingWebView", bundle: nil)
    let childWebViewStoryboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    
    @IBOutlet weak var youtubeView: YTPlayerView!
    var youtube_url = ""
    var youtube_load = false
    
    
    @IBOutlet weak var yotubeViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var youtubeViewAspect: NSLayoutConstraint!
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
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.chattingCheck), name: NSNotification.Name(rawValue: "replyDetailValueSend"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.classDetailFriend), name: NSNotification.Name(rawValue: "replyDetailFriend"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
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
        
        detailReplyData(comment_id: comment_id, page: page)
        
        youtubeView.delegate = self
        
        let dismiss = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        dismiss.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(dismiss)
        
        emoticonView.WithEmoticon { [unowned self] eNumber in
            self.emoticonSelectView.isHidden = false
            self.emoticonImg.image = UIImage(named: "emti\(eNumber+1)")
            self.emoticonNumber = eNumber+1
            self.image = nil
        }
        
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
        commentDataUpdated()
    }
    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    /** **이미지 클릭 버튼 > 이미지를 크기 보게  */
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        if imageView.image != nil{
            Alert.WithImageView(self, image: imageView.image!, btn1Title: "", btn1Handler: {
                
            })
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 앱이 백그라운드로 넘어갈 시에 타는 함수
     
     - Parameters:
        - notification: 백그라운드 변수
     
     - Throws: `Error` 앱이 죽을경우 `Error`
     */
    @objc func applicationDidEnterBackground(_ notification: Notification?) {
        self.deinitNowPlayingInfo()
    }
    
    /** **will hide the keyboard when view is tapped */
    @objc func hideKeyboard() {
        view.endEditing(true)
        print("view is tapped!")
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 앱이 백그라운드에서 포그라운드로 넘어올 시에 타는 함수
     
     - Parameters:
        - notification: 백그라운드 변수
     
     - Throws: `Error` 앱이 죽을경우 `Error`
     */
    @objc func applicationWillEnterForeground(_ notification: Notification?) {
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
    
    @IBAction func listFriendProfileBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
            newViewController.user_id = self.list?.results?.user_id ?? 0
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    /** **친구 프로필 버튼 클릭 > 친구프로필 뷰로 이동 ( ProfileFriendViewController  )  */
    @IBAction func friendProfileBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
            newViewController.user_id = self.replyArray[sender.tag].user_id ?? 0
            self.navigationController?.pushViewController(newViewController, animated: true)
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
    
    /** **뒤로 돌아가기 버튼 클릭 > 전 화면 뷰로 이동 */
    @IBAction func returnBackBtnClicked(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            commentDataUpdated()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func commentDataUpdated() {
        
        if missionCheck == false{
            if noticeCheck == false{
                if commentType == "class"{
                    let userInfo = [ "comment_id" : self.comment_id ,"replyCount": replyArray.count , "commentLikeCount":list?.results?.like ?? 0 , "preHave":list?.results?.like_me ?? "N"] as [String : Any]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classParamChange"), object: nil,userInfo: userInfo)
                }else{
                    let userInfo = [ "comment_id" : self.comment_id ,"replyCount": replyArray.count , "commentLikeCount":list?.results?.like ?? 0,"preHave":list?.results?.like_me ?? "N"] as [String : Any]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumParamChange"), object: nil,userInfo: userInfo)
                }
            }else{
                let userInfo = [ "comment_id" : self.comment_id ,"replyCount": replyArray.count , "commentLikeCount":list?.results?.like ?? 0,"preHave":list?.results?.like_me ?? "N"] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "noticeParamChange"), object: nil,userInfo: userInfo)
            }
        }else{
            let userInfo = [ "comment_id" : self.comment_id , "commentLikeCount":list?.results?.like ?? 0,"preHave":list?.results?.like_me ?? "N"] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "missionParamChange"), object: nil,userInfo: userInfo)
        }
        
    }
    
    /** **자신이 쓴 댓글 더보기 버튼 클릭 > 댓글 삭제할지 알림  */
    @IBAction func moreBtnMainClicked(_ sender: UIButton) {
        Alert.With(self, btn1Title: "삭제", btn1Handler: {
            DispatchQueue.main.async {
                self.replyDelete(comment_id: sender.tag,type:"main")
            }
        })
    }
    
    /** **자신이 쓴 댓글 더보기 버튼 클릭 > 댓글 삭제할지 알림  */
    @IBAction func moreBtnClicked(_ sender: UIButton) {
        Alert.With(self, btn1Title: "삭제", btn1Handler: {
            DispatchQueue.main.async {
                self.replyDelete(comment_id: sender.tag,type:"reply")
            }
        })
    }
    
    /** **좋아요 버튼 클릭 > 메인댓글 좋아요  */
    @IBAction func firstLikeBtnClicked(_ sender: UIButton) {
        haveFirstSave(sender: sender)
    }
    
    /** **좋아요 버튼 클릭 > 서브댓글 좋아요  */
    @IBAction func secondLikeBtnClicked(_ sender: UIButton) {
        haveSecondSave(sender: sender)
    }
    
    /** **이모티콘뷰 나가기 버튼 클릭 > 이모티콘뷰 닫기  */
    @IBAction func emoticonViewExitBtnClicked(_ sender: UIButton) {
        emoticonSelectView.isHidden = true
        emoticonImg.image = nil
        self.image = nil
    }
    
    /** **댓글 저장 버튼 클릭 > 댓글 저장 함수  */
    @IBAction func replySendBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.replyTextView.text?.isBlank == false || self.emoticonImg.image != nil{
            if self.commentType == "class"{
                replySend(commentType: "class",sender:sender)
            }else{
                replySend(commentType: "curriculum",sender:sender)
            }
        }else{
            Alert.With(self, title: "댓글을 입력해주세요", btn1Title: "확인", btn1Handler: {
                self.replyTextView.becomeFirstResponder()
            })
        }
    }
    
    @IBAction func firstLikeCountBtnClicked(_ sender: UIButton) {
        let likeValue = list?.results?.like_me ?? ""
        
        if likeValue == "N"  {
            self.haveFirstSave(sender: sender)
        } else {
            
            let nextView = feedStoryboard.instantiateViewController(withIdentifier: "ReplyLikeViewController") as! ReplyLikeViewController
            nextView.modalPresentationStyle = .overFullScreen
            nextView.comment_id = comment_id
            nextView.viewCheck = "replyDetail"
            self.present(nextView, animated:true,completion: nil)
        }
    }
    
    
    @IBAction func secondLikeCountBtnClicked(_ sender: UIButton) {
        let row = sender.tag / 10000
        let likeValue = replyArray[row].like_me ?? ""
        let comment_id = replyArray[row].id ?? 0
        if likeValue == "N"  {
            self.haveSecondSave(sender: sender)
        } else {
            
            let nextView = feedStoryboard.instantiateViewController(withIdentifier: "ReplyLikeViewController") as! ReplyLikeViewController
            nextView.modalPresentationStyle = .overFullScreen
            nextView.comment_id = comment_id
            nextView.viewCheck = "replyDetail"
            self.present(nextView, animated:true,completion: nil)
        }
    }
    
    /** **이미지 버튼 클릭 > 앨범, 카메라 이동 */
    @IBAction func imagePickerBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        imagePicked()
    }
    
    /** **뷰 버튼 클릭 > 텍스트뷰 포커스  */
    @IBAction func keyboardFocusBtnClicked(_ sender: UIButton) {
        replyTextView.becomeFirstResponder()
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
    
    @objc func classDetailFriend(notification:Notification){
        if let temp = notification.object {
//            let newViewController = self.profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//            newViewController.user_id = temp as! Int
//            self.navigationController?.pushViewController(newViewController, animated: true)
//            let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
//            newViewController.url = temp as! String
//            self.navigationController?.pushViewController(newViewController, animated: true)
            let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
            newViewController.user_id = temp as! Int
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @objc func chattingCheck(notification:Notification){
        guard let chattingUrl = notification.userInfo?["chattingUrl"] as? String else { return }
        let newViewController = chattingStoryboard.instantiateViewController(withIdentifier: "ChattingFriendWebViewViewController") as! ChattingFriendWebViewViewController
        newViewController.url = chattingUrl
        newViewController.tokenCheck = true
        self.navigationController?.pushViewController(newViewController, animated: true)
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
//                        let window = UIApplication.shared.keyWindow
//                        let bottomPadding = window?.safeAreaInsets.bottom
//                        self.tableView.contentInset = UIEdgeInsets.init(top: kbSize.height, left: 0, bottom: 0, right: 0)
//                        self.view.frame.origin.y = self.view.frame.origin.y - kbSize.height + bottomPadding!
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
//                        let window = UIApplication.shared.keyWindow
//                        let bottomPadding = window?.safeAreaInsets.bottom
//                        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
//                        self.view.frame.origin.y = self.view.frame.origin.y + kbSize.height - bottomPadding!
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
    
}


extension DetailReplyViewController:UITableViewDelegate,UITableViewDataSource{
    
    /** **테이블 셀의 섹션당 로우 개수 함수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if list != nil{
            if section == 0 {
                return 1
            }else{
                return replyArray.count
            }
        }else{
            return 0
        }
    }
    
    /** **테이블 셀의 로우 및 섹션 데이터 함수 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0{
            
            var cell:DetailReplyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailReplyFirst1TableViewCell") as! DetailReplyTableViewCell
            
            if list != nil{
                if list?.results?.photo ?? "" == "" && list?.results?.emoticon ?? 0 == 0{
                    cell = tableView.dequeueReusableCell(withIdentifier: "DetailReplyFirst1TableViewCell", for: indexPath) as! DetailReplyTableViewCell
                }else{
                    if list?.results?.content ?? "" != "" {
                        cell = tableView.dequeueReusableCell(withIdentifier: "DetailReplyFirst2TableViewCell", for: indexPath) as! DetailReplyTableViewCell
                    }else{
                        cell = tableView.dequeueReusableCell(withIdentifier: "DetailReplyFirst3TableViewCell", for: indexPath) as! DetailReplyTableViewCell
                    }
                    
                    if list?.results?.emoticon ?? 0 == 0{
                        cell.replyPhoto.sd_setImage(with: URL(string: "\(list?.results?.photo ?? "")"), placeholderImage: UIImage(named: "user_default"))
                        cell.replyPhotoHightConst.constant = 160
                        cell.replyPhotoWidthConst.constant = 160
                    }else{
                        cell.replyPhoto.image = UIImage(named: "emti\(list?.results?.emoticon ?? 0)")
                        cell.replyPhotoHightConst.constant = 80
                        cell.replyPhotoWidthConst.constant = 80

                    }
                    let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                    cell.replyPhoto.addGestureRecognizer(pictureTap)
                    
                }
                
                if list?.results?.content ?? "" != "" {
                    cell.replyContentTextView.text = list?.results?.content ?? ""
                    cell.replyContentTextView.textContainer.lineBreakMode = .byTruncatingTail
//                    let attributedString  = NSMutableAttributedString(string: "Your string" , attributes: attributes)
//                    cell.replyContentTextView.attributedText = (list?.results?.content ?? "").html2AttributedString
                    cell.replyContentTextView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14.5)
//                    cell.replyContentTextView.text = list?.results?.content ?? ""
                }else{ }
                
                cell.replyContentView.layer.cornerRadius = 12
                cell.likeCountBtn.layer.shadowOpacity = 0.1
                cell.likeCountBtn.layer.shadowRadius = 3
                cell.likeCountBtn.layer.shadowOffset = CGSize(width: 0,height: 2)
                
                cell.userName.text = list?.results?.user_name ?? ""
                cell.reply_userPhoto.sd_setImage(with: URL(string: "\(list?.results?.user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
               
                if list?.results?.like_me ?? "" == "Y" {
                    cell.likeBtn.setTitleColor(UIColor(named: "MainPoint_mainColor"), for: .normal)
                    cell.likeBtn.tag = (list?.results!.id)!*10000 + 1
                    cell.likeCountBtn.tag = (list?.results!.id)!*10000 + 1
                    cell.likeCountBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                    cell.likeCountBtn.setImage(UIImage(named: "heart_red"), for: .normal)
                    cell.likeCountBtn.setTitle(" \(list?.results?.like ?? 0)", for: .normal)
                }else{
                    cell.likeBtn.setTitleColor(UIColor(named: "FontColor_mainColor"), for: .normal)
                    cell.likeBtn.tag = (list?.results!.id)!*10000 + 2
                    cell.likeCountBtn.tag = (list?.results!.id)!*10000 + 2
                    cell.likeCountBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                    cell.likeCountBtn.setImage(UIImage(named: "heart_grey"), for: .normal)
                    cell.likeCountBtn.setTitle(" \(list?.results?.like ?? 0)", for: .normal)
                }
                if list?.results?.type ?? "" != "공지사항"{
                    cell.noticeLbl.text = ""
                }else{
                    cell.noticeLbl.text = "•공지사항"
                }
                
                if list?.results?.user_id ?? 0 == UserManager.shared.userInfo.results?.user?.id {
                    cell.moreBtn.tag = list?.results?.id ?? 0
                    cell.moreBtn.isHidden = false
                }else{
                    cell.moreBtn.isHidden = true
                }
                
//                if list?.results?.like ?? 0 > 0 {
//                    cell.likeCountBtn.setTitle(" \(list?.results?.like ?? 0)", for: .normal)
//                }
                cell.replyTime.text = list?.results?.time_spilled ?? "0분전"
                
                // Todo://
//                if list?.results?.roll != "M"{
//                    cell.rollGubunImg.isHidden = false
//                }else{
//                    cell.rollGubunImg.isHidden = true
//                }
                
                if list?.results?.friend_status ?? "Y" != "Y"{
                    if list?.results?.user_id ?? 0 == UserManager.shared.userInfo.results?.user?.id ?? 0 {
                        cell.rollGubunImg.isHidden = true
                    }else{
                        cell.rollGubunImg.isHidden = false
                    }
                }else{
                    cell.rollGubunImg.isHidden = true
                }
                if list?.results?.coach_yn ?? "N" == "Y"{ 
                    cell.coachStar.isHidden = false
                }else{
                    cell.coachStar.isHidden = true
                }
                cell.likeCountBtn.tag = list?.results?.id ?? 0
                
            }
            cell.selectionStyle = .none
            return cell
        }else{
            var cell:DetailReplyTableViewCell =  tableView.dequeueReusableCell(withIdentifier:  "DetailReplySecond1TableViewCell") as! DetailReplyTableViewCell
            if list != nil{
                if replyArray[row].photo ?? "" == "" && replyArray[row].emoticon ?? 0 == 0{
                    cell = tableView.dequeueReusableCell(withIdentifier: "DetailReplySecond1TableViewCell", for: indexPath) as! DetailReplyTableViewCell
                }else{
                    if replyArray[row].content ?? "" != "" {
                        cell = tableView.dequeueReusableCell(withIdentifier: "DetailReplySecond2TableViewCell", for: indexPath) as! DetailReplyTableViewCell
                    }else{
                        cell = tableView.dequeueReusableCell(withIdentifier: "DetailReplySecond3TableViewCell", for: indexPath) as! DetailReplyTableViewCell
                    }
                    if replyArray[row].emoticon ?? 0 == 0{
                        cell.replyPhoto.sd_setImage(with: URL(string: "\(replyArray[row].photo ?? "")"), placeholderImage: UIImage(named: "user_default"))
                        cell.replyPhotoHightConst.constant = 160
                        cell.replyPhotoWidthConst.constant = 160
                    }else{
                        cell.replyPhoto.image = UIImage(named: "emti\(replyArray[row].emoticon ?? 0)")
                        cell.replyPhotoHightConst.constant = 80
                        cell.replyPhotoWidthConst.constant = 80
                    }
                    let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                    cell.replyPhoto.addGestureRecognizer(pictureTap)
                }
                
                cell.userName.text = replyArray[row].user_name
                cell.reply_userPhoto.sd_setImage(with: URL(string: "\(replyArray[row].user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                cell.replyTime.text = replyArray[row].time_spilled ?? "0분전"
                
                if replyArray[row].like_me ?? "" == "Y" {
                    cell.likeBtn.setTitleColor(UIColor(named: "MainPoint_mainColor"), for: .normal)
                    cell.likeBtn.tag = row*10000 + 1
                    cell.likeCountBtn.tag = row*10000 + 1
                    cell.likeCountBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                    cell.likeCountBtn.setImage(UIImage(named: "heart_red"), for: .normal)
                    cell.likeCountBtn.setTitle(" \(self.replyArray[row].like ?? 0)", for: .normal)
                }else{
                    cell.likeBtn.setTitleColor(UIColor(named: "FontColor_mainColor"), for: .normal)
                    cell.likeBtn.tag = row*10000 + 2
                    cell.likeCountBtn.tag = row*10000 + 2
                    cell.likeCountBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                    cell.likeCountBtn.setImage(UIImage(named: "heart_grey"), for: .normal)
                    cell.likeCountBtn.setTitle(" \(self.replyArray[row].like ?? 0)", for: .normal)
                }
                
                if replyArray[row].user_id == UserManager.shared.userInfo.results?.user?.id {
                    cell.moreBtn.tag = replyArray[row].id ?? 0
                    cell.moreBtn.isHidden = false
                }else{
                    cell.moreBtn.isHidden = true
                }
                
//                if replyArray[row].like ?? 0 > 0 {
//                   cell.likeCountBtn.setTitle(" \(replyArray[row].like ?? 0)", for: .normal)
//                }
                if replyArray[row].content ?? "" != "" {
                    cell.replyContentTextView.text = replyArray[row].content ?? ""
                    cell.replyContentTextView.textContainer.lineBreakMode = .byTruncatingTail
//                    cell.replyContentTextView.attributedText = (replyArray[row].content ?? "").html2AttributedString
//                    cell.replyContentTextView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
                }else{ }
                
                if replyArray[row].friend_status ?? "Y" != "Y"{
                    if replyArray[row].user_id ?? 0 == UserManager.shared.userInfo.results?.user?.id ?? 0 {
                        cell.rollGubunImg.isHidden = true
                    }else{
                        cell.rollGubunImg.isHidden = false
                    }
                }else{
                    cell.rollGubunImg.isHidden = true
                }
                if replyArray[row].coach_yn ?? "N" == "Y"{
                    cell.coachStar.isHidden = false
                }else{
                    cell.coachStar.isHidden = true
                }
                
                cell.replyContentView.layer.cornerRadius = 12
                cell.likeCountBtn.layer.shadowOpacity = 0.1
                cell.likeCountBtn.layer.shadowRadius = 3
                cell.likeCountBtn.layer.shadowOffset = CGSize(width: 0,height: 2)
                
                cell.friendProfileBtn.tag = row//replyArray[row].user_id ?? 0
                cell.friendProfile2Btn.tag = row//replyArray[row].user_id ?? 0
                //cell.likeCountBtn.tag = replyArray[row].id ?? 0
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier:  "DetailReplySecond1TableViewCell", for: indexPath) as! DetailReplyTableViewCell
            }
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    /** **테이블 셀의 섹션 개수 함수 */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /** **테이블 셀의 높이 함수 */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
    
    /** **테이블 셀이 보이기 시작할때 타는 함수 */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section == 1{
            if row == (replyArray.count)-2{
                if replyArray.count < list?.results?.reply?.total ?? 0 {
                    self.page = self.page + 1
                    self.detailReplyData(comment_id: comment_id, page: self.page)
                }
            }
        }
    }
}

extension DetailReplyViewController {
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 강의의 댓글에 댓글 리스트를 가져오기 위한 함수
     
     - Parameters:
        - comment_id: 댓글 아이디
        - page: 페이지번호
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func detailReplyData(comment_id:Int,page:Int){
        FeedApi.shared.replyDetail(comment_id: comment_id, page: page,success: { result in
            if result.code == "200"{
                self.list = result
                for addArray in 0 ..< (self.list?.results?.reply?.appClassCommentList.count)! {
                    self.replyArray.append((self.list?.results?.reply?.appClassCommentList[addArray])!)
                }
                if self.list?.results?.play_file ?? "" != "" {
                    self.youtube_url = self.list?.results?.play_file ?? ""
                }else{
                    if self.list?.results?.youtu_address ?? "" != "" {
                        self.youtube_url = self.list?.results?.youtu_address ?? ""
                    }else{
                        self.youtube_url = ""
                    }
                }
                DispatchQueue.main.async {
                    if self.youtube_load == false{
                        self.videoLoad()
                        self.youtube_load = true
                    }else{
                        self.youtube_load = true
                    }
                    self.tableView.reloadData()
                }
            }
        }) { error in
            
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 강의의 댓글에 좋아요 혹은 취소를 위한 함수
     
     - Parameters:
        - sender: 버튼 태그
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func haveFirstSave(sender:UIButton){
        let likeGubun = sender.tag % 10000 // 1 : Y delete  2 : N post
        let row = sender.tag / 10000
        

        var type = ""
        
        if likeGubun == 1{
            type = "delete"
        }else{
            type = "post"
        }
        FeedApi.shared.replyCommentLike(comment_id: comment_id, method_type: type,success: { result in
            let selectedIndexPath = IndexPath(item: 0, section: 0)
            let cell = self.tableView.cellForRow(at: selectedIndexPath) as! DetailReplyTableViewCell
            if result.code == "200"{
                if likeGubun == 1{
                    cell.likeBtn.setTitleColor(UIColor(named: "FontColor_mainColor"), for: .normal)
                    cell.likeBtn.tag = row*10000 + 2
                    cell.likeCountBtn.tag = row*10000 + 2
                    self.list?.results?.like_me = "N"
                    self.list?.results?.like = (self.list?.results?.like ?? 0)-1
                    cell.likeCountBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                    cell.likeCountBtn.setImage(UIImage(named: "heart_grey"), for: .normal)
                    cell.likeCountBtn.setTitle(" \(self.list?.results?.like ?? 0)", for: .normal)
                    
                }else{
                    cell.likeBtn.setTitleColor(UIColor(named: "MainPoint_mainColor"), for: .normal)
                    cell.likeBtn.tag = row*10000 + 1
                    cell.likeCountBtn.tag = row*10000 + 1
                    self.list?.results?.like_me = "Y"
                    self.list?.results?.like = (self.list?.results?.like ?? 0)+1
                    cell.likeCountBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                    cell.likeCountBtn.setImage(UIImage(named: "heart_red"), for: .normal)
                    cell.likeCountBtn.setTitle(" \(self.list?.results?.like ?? 0)", for: .normal)
                }
                self.list?.results?.like = result.results?.like ?? 0
  //              let selectedIndexPath = IndexPath(item:0 , section: 0)
    //            self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                //sender.isUserInteractionEnabled = true
            }
        }) { error in

        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 강의의 댓글의 댓글에 좋아요 혹은 취소를 위한 함수
     
     - Parameters:
        - sender: 버튼 태그
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func haveSecondSave(sender:UIButton){
        sender.isUserInteractionEnabled = false
        let row = sender.tag / 10000
        let likeGubun = sender.tag % 10000 // 1 : Y delete  2 : N post
        let comment_id = replyArray[row].id ?? 0
        
        var type = ""
        if likeGubun == 1{
            type = "delete"
        }else{
            type = "post"
        }

        FeedApi.shared.replyCommentLike(comment_id: comment_id, method_type: type,success: { result in
           let selectedIndexPath = IndexPath(item:row , section: 1)
            let cell = self.tableView.cellForRow(at: selectedIndexPath) as! DetailReplyTableViewCell
            if result.code == "200"{
                if likeGubun == 1{
                    cell.likeBtn.setTitleColor(UIColor(named: "FontColor_mainColor"), for: .normal)
                    cell.likeBtn.tag = row*10000 + 2
                    self.replyArray[row].like_me = "N"
                    self.replyArray[row].like = (self.replyArray[row].like ?? 0)-1
                    cell.likeCountBtn.tag = row*10000 + 2
                    cell.likeCountBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                    cell.likeCountBtn.setImage(UIImage(named: "heart_grey"), for: .normal)
                    cell.likeCountBtn.setTitle(" \(self.replyArray[row].like ?? 0)", for: .normal)
                }else{
                    cell.likeBtn.setTitleColor(UIColor(named: "MainPoint_mainColor"), for: .normal)
                    cell.likeBtn.tag = row*10000 + 1
                    self.replyArray[row].like_me = "Y"
                    self.replyArray[row].like = (self.replyArray[row].like ?? 0)+1
                    cell.likeCountBtn.tag = row*10000 + 1
                    cell.likeCountBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                    cell.likeCountBtn.setImage(UIImage(named: "heart_red"), for: .normal)
                    cell.likeCountBtn.setTitle(" \(self.replyArray[row].like ?? 0)", for: .normal)
                }

                self.replyArray[row].like = result.results?.like ?? 0
                DispatchQueue.main.async {
                    
                    self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    sender.isUserInteractionEnabled = true
                }
                
            }else{
                sender.isUserInteractionEnabled = true
            }
        }) { error in
            sender.isUserInteractionEnabled = true
        }
    }
 
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 강의의 댓글에 댓글을 남기기 위한 함수
     
     - Parameters:
        - commentType: 강의 댓글 타입
        - sender: 버튼 태그
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func replySend(commentType:String,sender:UIButton){
        sender.isUserInteractionEnabled = false
        let replyText = self.replyTextView.text
        self.emoticonSelectView.isHidden = true
        self.emoticonImg.image = nil
        self.replyTextView.text = nil
        if self.customView != nil{
            self.customView.removeFromSuperview()
            self.customView = nil
        }
        Indicator.showActivityIndicator(uiView: self.view)
        FeedApi.shared.replySave(class_id: self.class_id, curriculum: self.curriculum_id, mcComment_id: self.comment_id, content: replyText!, commentType: commentType, commentChild: true,emoticon:self.emoticonNumber, photo: self.image,success: { result in
            
            if result.code == "200"{
                let temp = AppClassCommentList.init()
                temp.id = result.results?.id
                temp.type = result.results?.type
                temp.user_id = result.results?.user_id
                temp.user_photo = result.results?.user_photo
                temp.user_name = result.results?.user_name
                temp.time_spilled = result.results?.time_spilled
                temp.content = result.results?.content
                temp.reply_count = result.results?.reply_count
                temp.like = result.results?.like
                temp.like_me = result.results?.like_me
                temp.photo = result.results?.photo
                temp.roll = result.results?.roll
                temp.like_user = result.results?.like_user
                temp.emoticon = result.results?.emoticon

                self.replyArray.insert(temp, at: 0)
                self.emoticonNumber = 0
                self.list?.results?.reply_count = (self.list?.results?.reply_count ?? 0) + 1
                self.tableView.reloadSections([0,1], with: .automatic)
                sender.isUserInteractionEnabled = true
                Indicator.hideActivityIndicator(uiView: self.view)
            }else{
                Indicator.hideActivityIndicator(uiView: self.view)
            }
        }) { error in
            Indicator.hideActivityIndicator(uiView: self.view)
            sender.isUserInteractionEnabled = true
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 강의의 댓글을 삭제하기 위한 함수
     
     - Parameters:
        - comment_id: 강의 댓글 아이디
        - type: 댓글 타입
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func replyDelete(comment_id:Int,type:String){
        FeedApi.shared.replyDelete(comment_id: comment_id,success: { result in
            if result.code == "200"{
                var row = 0
                let userInfo = [ "comment_id" : self.comment_id]
                if type == "main"{
                    if self.missionCheck == true{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "missionReplyDelete"), object: nil,userInfo: userInfo)
                    }else{
                        if self.noticeCheck == true{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "noticeReplyDelete"), object: nil,userInfo: userInfo)
                        }else{
                            if self.commentType == "class"{
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classReplyDelete"), object: nil,userInfo: userInfo)
                            }else{
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumReplyDelete"), object: nil,userInfo: userInfo)
                            }
                        }
                    }
                    self.navigationController?.popViewController(animated: true)
                }else{
                    for i in 0..<self.replyArray.count{
                        if self.replyArray[i].id == result.results{
                            row = i
                        }else{}
                    }
                    self.replyArray.remove(at: row)
                    var indexSet = IndexSet.init(integer: 1)
                    self.tableView.reloadSections(indexSet, with: .automatic)
                    
                    self.list?.results?.reply_count = (self.list?.results?.reply_count ?? 0) - 1
                    indexSet = IndexSet.init(integer: 0)
                    self.tableView.reloadSections(indexSet, with: .automatic)
                }
            }
        }) { error in
            
        }
    }
}

extension DetailReplyViewController:UITextViewDelegate{
    
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

extension DetailReplyViewController:CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension DetailReplyViewController:YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
    }
    
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        //        0 - 재생 안됨   1 - 재생 종료   2 - 재생 시작     3 - 일시중지    4 - 버퍼링
//        var play_state = ""
//        var play_time = 0
        switch state.rawValue {
        case 0:
            self.youtubeView.playVideo()
        case 1:
//            play_state = "end"
            break
        case 2:
//            play_state = "start"
            break
        case 3:
//            play_state = "pause"
            break
        default:
            break
        }
        
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
    }
    
    func videoLoad(){
        let videoId = self.youtube_url.replace(target: "https://youtu.be/", withString: "").replace(target: "https://www.youtube.com/watch?v=", withString: "")
        if self.youtube_url != "" {
            self.youtubeViewAspect.isActive = true
            self.yotubeViewHeightConst.isActive = false
            self.youtubeView.load(withVideoId: videoId, playerVars: self.playerVars)
        }else{
            self.youtubeViewAspect.isActive = false
            self.yotubeViewHeightConst.isActive = true
            self.yotubeViewHeightConst.constant = 0
        }
        
    }
    
}
