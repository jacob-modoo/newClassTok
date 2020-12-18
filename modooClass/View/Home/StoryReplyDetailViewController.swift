//
//  StoryReplyDetailViewController.swift
//  modooClass
//
//  Created by 조현민 on 2020/02/20.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit
import ReverseExtension
import AVFoundation
import Photos
import CropViewController

class StoryReplyDetailViewController: UIViewController {

    @IBOutlet weak var replyTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var replySendView: UIView!
    @IBOutlet weak var replyBorderView: UIView!
    @IBOutlet weak var replyTextViewLbl: UIFixedLabel!
    @IBOutlet weak var replyTextView: UIFixedTextView!
    @IBOutlet weak var emoticonViewEnterBtn: UIButton!
    @IBOutlet weak var replySendBtn: UIButton!
    @IBOutlet weak var emoticonSelectView: UIView!
    @IBOutlet weak var emoticonImg: UIImageView!
    @IBOutlet weak var replyEmptyView: GradientView!
    
    var feedId = ""
    var page = 1
    var emoticonNumber:Int = 0
    var keyboardShow:Bool?
    var keyBoardSize:CGRect?
    var customView: UIView!
    private let imageView = UIImageView()
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var replyCount = 0
    var list:SquareReplyCommentListModel?
    var listArr:Array = Array<SquareReply_list>()
    var tagForLikeBtn = 0
    lazy var emoticonView: EmoticonView = {
        let tv = EmoticonView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismiss = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.tableView.addGestureRecognizer(dismiss)
        
        tableView.estimatedRowHeight = 56
        tableView.rowHeight = UITableView.automaticDimension
        squareCommentList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateStoryReplyLikeCount), name: NSNotification.Name(rawValue: "updateStoryReplyLikeCount"), object: nil )
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
        
        emoticonView.WithEmoticon { [unowned self] eNumber in
            self.emoticonSelectView.isHidden = false
            self.emoticonImg.image = UIImage(named: "emti\(eNumber+1)")
            self.emoticonNumber = eNumber+1
            self.image = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if keyboardShow == false {
            self.replyTextView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.listArr.reverse()
        let userInfo = ["replyArray" : self.listArr ,"replyCount": self.list?.results?.reply_total ?? 0] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "storyDetailReplyUpdate"), object: nil,userInfo: userInfo)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        print("tableView is tapped!")
    }
    
    func squareCommentList(){
        FeedApi.shared.squareCommentList(articleId: self.feedId, page: self.page,success: { [unowned self] result in
            self.list = result
            if result.code == "200"{
                self.replyCount = self.list?.results?.reply_total ?? 0
                if self.replyCount > 15{
                    self.tableView.re.dataSource = self
                    self.tableView.re.delegate = self
                    self.tableView.re.scrollViewDidReachTop = { [unowned self] scrollView in
                        print("scrollViewDidReachTop \(self.feedId)")
                    }
                    self.tableView.re.scrollViewDidReachBottom = { [unowned self] scrollView in
                        print("scrollViewDidReachBottom \(self.feedId)")
                    }
                }else{
                    self.tableView.dataSource = self
                    self.tableView.delegate = self
                }
                
                
                
                self.list?.results?.list_arr.reverse()
                for addArray in 0 ..< (self.list?.results?.list_arr.count ?? 0) {
                    self.listArr.append((self.list?.results?.list_arr[addArray])!)
                }
                if self.listArr.count > 0{
                    self.replyEmptyView.isHidden = true
                }else{
                    self.replyEmptyView.isHidden = false
                }
                self.tableView.reloadData()
                if self.replyCount < 15 && self.replyCount > 0 {
                    self.scrollToFirsLastRow()
                }
            }
        }) { error in
            
        }
    }
    
    func scrollToFirsLastRow() {
        let indexPath = NSIndexPath(row: self.listArr.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
    }
    
    func squareAddCommentList(){
        FeedApi.shared.squareCommentList(articleId: self.feedId, page: self.page,success: { [unowned self] result in
            self.list = result
            if result.code == "200"{
                self.list?.results?.list_arr.reverse()
                self.listArr.reverse()
                for addArray in 0 ..< (self.list?.results?.list_arr.count ?? 0) {
                    self.listArr.append((self.list?.results?.list_arr[addArray])!)
                }
                self.listArr.reverse()
                
                if self.listArr.count > 0{
                    self.replyEmptyView.isHidden = true
                }else{
                    self.replyEmptyView.isHidden = false
                }
                self.tableView.reloadData()
            }
        }) { error in
            
        }
    }
    
    func replyWriteCheck(){
        Alert.WithReply(self, btn1Title: "삭제", btn1Handler: {
            self.emoticonImg.image = nil
            self.image = nil
            self.replyTextViewHeight.constant = 33
            if self.customView != nil{
                self.customView?.removeFromSuperview()
                self.customView = nil
            }
            self.replyTextViewLbl.isHidden = false
            let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#484848")];
            let attributedString = NSAttributedString(string: self.replyTextView.text, attributes: attributedStringColor)
            self.replyTextView.attributedText = attributedString
            self.replyTextView.text = ""
        }, btn2Title: "이어서 작성", btn2Handler: {
            if self.emoticonImg.image != nil {
                self.emoticonSelectView.isHidden = false
            }
            self.replyTextView.becomeFirstResponder()
        })
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
                self.listArr.reverse()
                self.listArr.insert(temp, at: 0)
                self.listArr.reverse()
                self.list?.results?.reply_total = (self.list?.results?.reply_total ?? 0) + 1
                
                self.emoticonSelectView.isHidden = true
                self.emoticonImg.image = nil
                self.replyTextViewLbl.isHidden = false
                self.replyTextView.text = ""
                if self.customView != nil{
                    self.customView?.removeFromSuperview()
                    self.customView = nil
                }
                self.emoticonNumber = 0
                UIView.animate(withDuration: 0.0, animations: {
                    self.tableView.setContentOffset(.zero, animated: true)
                    if self.listArr.count > 0{
                        self.replyEmptyView.isHidden = true
                    }else{
                        self.replyEmptyView.isHidden = false
                    }
                }, completion: { _ in
                    self.tableView.reloadData()
                })
            }
            
            Indicator.hideActivityIndicator(uiView: self.view)
            sender.isUserInteractionEnabled = true
            
        }) { error in
            Indicator.hideActivityIndicator(uiView: self.view)
            sender.isUserInteractionEnabled = true
        }
    }
    
    func replyLikeHave(sender:UIButton){
        sender.isUserInteractionEnabled = false
        let row = sender.tag / 10000
        let likeGubun = self.listArr[row].like_me ?? ""
        let comment_id = self.listArr[row].comment_id ?? ""
        
        var type = ""
        if likeGubun == "Y"{
            type = "delete"
            
        }else{
            type = "post"
            
        }

        ProfileApi.shared.profileV2CommentLike(comment_id: comment_id, type: type, success: { [unowned self] result in
            if result.code == "200" {
            
                let indexPath = IndexPath(row: (self.listArr.count-1) - row, section: 0)
                
                if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                    if visibleIndexPaths != NSNotFound {
                        var indexPath = IndexPath(row: (self.listArr.count-1) - row, section: 0)
                        if self.replyCount > 15{
                            indexPath = IndexPath(row: (self.listArr.count-1) - row, section: 0)
                        }else{
                            indexPath = IndexPath(row: row, section: 0)
                        }
                        let cell = self.tableView.cellForRow(at: indexPath) as! StoryDetailTableViewCell
                        
                        if likeGubun == "Y"{
                            cell.likeCountBtn.tag = row*10000 + 2
                            self.listArr[row].like_me = "N"
                            self.listArr[row].like_cnt = (self.listArr[row].like_cnt ?? 0)-1
                            cell.likeCountBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                            cell.likeCountBtn.setImage(UIImage(named: "comment_likeBtn_default"), for: .normal)
                            cell.likeCountBtn.setTitle(" \(self.listArr[row].like_cnt ?? 0)", for: .normal)
                        }else{
                            cell.likeCountBtn.tag = row*10000 + 1
                            self.listArr[row].like_me = "Y"
                            self.listArr[row].like_cnt = (self.listArr[row].like_cnt ?? 0)+1
                            cell.likeCountBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                            cell.likeCountBtn.setImage(UIImage(named: "comment_likeBtn_active"), for: .normal)
                            cell.likeCountBtn.setTitle(" \(self.listArr[row].like_cnt ?? 0)", for: .normal)
                        }
                     
//                        if self.listArr[row].like_cnt ?? 0 > 0 {
//                            cell.likeCountBtn.setTitle(" \(self.listArr[row].like_cnt ?? 0)", for: .normal)
//                        }
                    }
                    sender.isUserInteractionEnabled = true
                }
                sender.isUserInteractionEnabled = true
                
            }else{
                sender.isUserInteractionEnabled = true
            }
        }) { error in
            sender.isUserInteractionEnabled = true
        }
    }
    
    /** **이미지 클릭 버튼 > 이미지를 크기 보게  */
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        if imageView.image != nil{
            Alert.WithImageView(self, image: imageView.image!, btn1Title: "", btn1Handler: {
                
            })
        }
    }
    
    @IBAction func friendProfileBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
            newViewController.user_id = self.listArr[sender.tag].user_id ?? 0 //[sender.tag].user_id ?? 0
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func replyMoreBtnClicked(_ sender: UIButton) {
        print("** comment_id : \(sender.tag)")
        print("** feedID : \(self.listArr[sender.tag].comment_id ?? "")")
        let comment_id = self.listArr[sender.tag].comment_id ?? ""
        Alert.With(self, btn1Title: "삭제", btn1Handler: {
            DispatchQueue.main.async {
                FeedApi.shared.squareReplyDelete(articleId: comment_id,success: { [unowned self] result in
                    if result.code == "200"{
                        for addArray in 0 ..< (self.listArr.count) {
                            if comment_id == "\(self.listArr[addArray].comment_id ?? "")"{
                                self.listArr.remove(at: addArray)
                                if self.listArr.count > 0{
                                    self.replyEmptyView.isHidden = true
                                }else{
                                    self.replyEmptyView.isHidden = false
                                }
                                self.tableView.reloadData()
                                break
                            }
                        }
                    }
                }) { error in

                }
            }
        })
    }
    
    @IBAction func likeCountBtnClicked(_ sender: UIButton) {
//        let row = sender.tag / 10000
//        let likeValue = self.listArr[row].like_me ?? ""
//        let comment_id = self.listArr[row].comment_id ?? ""
//        if likeValue == "N" {
             replyLikeHave(sender: sender)
//        } else {
//            let nextView = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "ReplyLikeViewController") as! ReplyLikeViewController
//            nextView.modalPresentationStyle = .overFullScreen
//            nextView.comment_str_id = comment_id
//            self.tagForLikeBtn = sender.tag
//            nextView.viewCheck = "feedDetailSub"
//            self.present(nextView, animated:true,completion: nil)
//        }
    }
    
    @IBAction func returnBackBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imagePickerBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        imagePicked()
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
    
    /** **이모티콘뷰 나가기 버튼 클릭 > 이모티콘뷰 닫기  */
    @IBAction func emoticonViewExitBtnClicked(_ sender: UIButton) {
        emoticonSelectView.isHidden = true
        emoticonImg.image = nil
        self.image = nil
    }
    
    /**
     - will update the count of likes in comment section in tableView
     */
    @objc func updateStoryReplyLikeCount(notification: Notification) {
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
        if keyboardShow ?? false == false {
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
    
}

extension StoryReplyDetailViewController: UITableViewDataSource ,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cell:StoryDetailTableViewCell =  tableView.dequeueReusableCell(withIdentifier:  "StoryDetail1TableViewCell") as! StoryDetailTableViewCell
        if self.listArr[row].photo_url ?? "" == "" && self.listArr[row].emoticon ?? 0 == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "StoryDetail1TableViewCell", for: indexPath) as! StoryDetailTableViewCell
        }else{
            if self.listArr[row].content ?? "" != "" {
                cell = tableView.dequeueReusableCell(withIdentifier: "StoryDetail2TableViewCell", for: indexPath) as! StoryDetailTableViewCell
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "StoryDetail3TableViewCell", for: indexPath) as! StoryDetailTableViewCell
            }
            if self.listArr[row].emoticon ?? 0 == 0{
                cell.replyPhoto.sd_setImage(with: URL(string: "\(self.listArr[row].photo_url ?? "")"), placeholderImage: UIImage(named: "user_default"))
                cell.replyPhotoHightConst.constant = 160
                cell.replyPhotoWidthConst.constant = 160
            }else{
                cell.replyPhoto.image = UIImage(named: "emti\(self.listArr[row].emoticon ?? 0)")
                cell.replyPhotoHightConst.constant = 80
                cell.replyPhotoWidthConst.constant = 80
            }
            let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            cell.replyPhoto.addGestureRecognizer(pictureTap)
        }

        cell.userName.text = self.listArr[row].user_name
        cell.reply_userPhoto.sd_setImage(with: URL(string: "\(self.listArr[row].user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
        cell.replyTime.text = self.listArr[row].time_spilled ?? "0분전"

        if self.listArr[row].like_me ?? "" == "Y" {
//            cell.likeBtn.setTitleColor(UIColor(named: "MainPoint_mainColor"), for: .normal)
//            cell.likeBtn.tag = row*10000 + 1
            cell.likeCountBtn.tag = row*10000 + 1
            cell.likeCountBtn.setImage(UIImage(named: "comment_likeBtn_active"), for: .normal)
            cell.likeCountBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
            cell.likeCountBtn.setTitle(" \(self.listArr[row].like_cnt ?? 0)", for: .normal)
        }else{
//            cell.likeBtn.setTitleColor(UIColor(named: "FontColor_mainColor"), for: .normal)
//            cell.likeBtn.tag = row*10000 + 2
            cell.likeCountBtn.tag = row*10000 + 2
            cell.likeCountBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
            cell.likeCountBtn.setImage(UIImage(named: "comment_likeBtn_default"), for: .normal)
            cell.likeCountBtn.setTitle(" \(self.listArr[row].like_cnt ?? 0)", for: .normal)
        }

        if self.listArr[row].user_id == UserManager.shared.userInfo.results?.user?.id {
            cell.moreBtn.tag = row//self.listArr[row].id ?? 0
            cell.moreBtn.isHidden = false
        }else{
            cell.moreBtn.isHidden = true
        }

//        if self.listArr[row].like_cnt ?? 0 > 0 {
//
//            cell.likeCountBtn.setTitle("\(self.listArr[row].like_cnt ?? 0)", for: .normal)
//        }

        if self.listArr[row].content ?? "" != "" {
            cell.replyContentTextView.text = self.listArr[row].content ?? ""
            cell.replyContentTextView.textContainer.lineBreakMode = .byTruncatingTail
        }else{ }

        if self.listArr[row].coach_yn ?? "N" == "Y"{
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

        cell.setEditing(false, animated: false)
        cell.selectionStyle = .none
        return cell
    }
    
    /** **테이블 셀이 보이기 시작할때 타는 함수 */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        print(row)
        if self.listArr.count - 2 < self.list?.results?.reply_total ?? 0{
            if self.page <= self.list?.results?.total_page ?? 0{
                self.page = self.page + 1
                squareAddCommentList()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//       print("scrollView.contentOffset.y =", scrollView.contentOffset.y)
    }
}

extension StoryReplyDetailViewController:UITextViewDelegate{
    
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

extension StoryReplyDetailViewController:CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
