//
//  ChattingFriendViewController.swift
//  modooClass
//
//  Created by iOS|Dev on 2021/01/05.
//  Copyright © 2021 신민수. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import CropViewController

class ChattingFriendViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reply_image_add: UIButton!
    @IBOutlet weak var reply_emoticon: UIButton!
    @IBOutlet weak var reply_sendBtn: UIButton!
    @IBOutlet weak var reply_border_view: UIView!
    @IBOutlet weak var reply_textView: UITextView!
    @IBOutlet weak var profileTitle: UIFixedLabel!
    @IBOutlet weak var emoticonImg: UIImageView!
    @IBOutlet weak var emoticonSelectView: UIView!
    @IBOutlet weak var replyTextViewLbl: UIFixedLabel!
    @IBOutlet weak var replyTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var sideMenuView: ChattingPageSideMenuView!
    @IBOutlet weak var sideMenuViewWidth: NSLayoutConstraint!
    
    var chat_id = 0
    var page = 1
    var user_id = UserManager.shared.userInfo.results?.user?.id ?? 0
    var myId = 0
    var customView:UIView!
    var emoticonNumber:Int = 0
    var keyboardShow = false
    var keyBoardSize:CGRect?
    var chatRoom:ChatRoomModel?
    var chatRoomList:Array = Array<ChatRoomList>()
    var chatHistory:ChatHistoryModel?
    var chat_history_arr:Array = Array<ChatHistoryList>()
    var emojiNumber = ""
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    private let imageView = UIImageView()
    
    lazy var emoticonView: EmoticonView = {
        let tv = EmoticonView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let chattingStoryboard = UIStoryboard(name: "Chatting", bundle: nil)
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadChatHistory()
        reply_border_view.layer.borderWidth = 1
        reply_border_view.layer.borderColor = UIColor(hexString: "#eeeeee").cgColor
        reply_border_view.layer.cornerRadius  = 15
        
        emoticonView.WithEmoticon { [unowned self] eNumber in
            self.emoticonSelectView.isHidden = false
            self.emoticonImg.image = UIImage(named: "emti\(eNumber+1)")
            self.emoticonNumber = eNumber+1
            self.image = nil
        }
        
        
//        self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.sideMenuProfileTag(_ :)), name: NSNotification.Name(rawValue: "sideMenuProfileTag"), object: nil)
//        replySendView.layer.shadowColor = UIColor(hexString: "#757575").cgColor
//        replySendView.layer.shadowOffset = CGSize(width: 0.0, height: -6.0)
//        replySendView.layer.shadowOpacity = 0.05
//        replySendView.layer.shadowRadius = 4
//        replySendView.layer.masksToBounds = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        print("ChattingFriendViewController deinit")
    }
    
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func moreBtnClicked(_ sender: UIButton) {
        print("** more btn is clicked")
        self.sideMenuOpen()
    }
    
    
    @IBAction func addImageBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        imagePicked()
    }
    
    @IBAction func profileBtnClicked(_ sender: UIButton) {
//        go to friend's profile
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.reply_textView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
            if UserManager.shared.userInfo.results?.user?.id == sender.tag{
                newViewController.isMyProfile = true
            }else{
                newViewController.isMyProfile = false
            }
            newViewController.user_id = self.chat_history_arr[sender.tag].user_id ?? 0
            newViewController.isMyProfile = true
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        
    }
    
    @IBAction func emoticonAddBtnClicked(_ sender: UIButton) {
        reply_textView.becomeFirstResponder()
        DispatchQueue.main.async {
            if self.customView == nil {
                self.customView = UIView.init(frame: CGRect.init(x: 0, y: (self.keyBoardSize?.origin.y)!, width: self.view.frame.width, height: self.keyBoardSize!.height))
                self.customView.addSubview(self.emoticonView)
                self.emoticonView.snp.makeConstraints { (make) in
                    make.bottom.top.leading.trailing.equalToSuperview()
                }
                let tapOut: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.textViewTab))
                self.reply_textView.addGestureRecognizer(tapOut)
                UIApplication.shared.windows.last?.addSubview(self.customView)
            }else {
                self.customView.removeFromSuperview()
                self.customView = nil
            }
        }
    }
    
    
    @IBAction func replySendBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.reply_textView.text?.isBlank == false || self.emoticonImg.image != nil{
            messageReplySend()
        }else{
            Alert.With(self, title: "댓글을 입력해주세요", btn1Title: "확인", btn1Handler: {
                self.reply_textView.becomeFirstResponder()
            })
        }
    }
    
    @IBAction func emoticonExitBtnClicked(_ sender: UIButton) {
        emoticonSelectView.isHidden = true
        emoticonImg.image = nil
        self.image = nil
    }
    
    @objc func sideMenuProfileTag(_ notification : Notification) {
        if let tag = notification.object as? Int {
            let chatUserId = self.chatRoom?.results?.list_arr[tag].user_id ?? 0
            let newViewController = home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
//            if chatUserId == self.user_id {
                newViewController.isMyProfile = true
//            } else {
//                newViewController.isMyProfile = false
//            }
            newViewController.user_id = chatUserId
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    func sideMenuOpen() {
        print("popup view is showing!!!")
        if keyboardShow == true {
            self.view.endEditing(true)
        }
        
        self.sideMenuView.leaveChatBtnClick = {
            print("** leaveChatBtnClicked")
        }
        
        self.sideMenuView.menuExitBtnClick = {
            print("** menuExitBtnClicked")
            self.hidePopupView()
        }
        
        self.sideMenuView.profileBtnClick = {
            print("** profileBtnClicked")
            
            //var userId = chatRoom?.results?.list_arr[sender.tag].user_id ?? 0
        }
        
        self.sideMenuView.switchBtnClick = {
            print("** switchBtnClicked")
        }
        
//        self.sideMenuView.roundedView(usingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 12, height: 12))
//        self.sideMenuView.likeBtn.setImage(UIImage(named: "class_new_likeDefault"), for: .normal)
//        self.sideMenuView.dislikeBtn.setImage(UIImage(named: "class_new_dislikeBtn"), for: .normal)
        self.sideMenuView.user1ImgView.sd_setImage(with: URL(string: "\(chatRoom?.results?.list_arr[0].photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
        self.sideMenuView.user2ImgView.sd_setImage(with: URL(string: "\(chatRoom?.results?.list_arr[1].photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
        
        self.sideMenuView.user1Lbl.text = "\(chatRoom?.results?.list_arr[0].user_name ?? "")"
        self.sideMenuView.user2Lbl.text = "\(chatRoom?.results?.list_arr[1].user_name ?? "")"
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_ :)))
        swipeGesture.direction = .right
        transparentView.addGestureRecognizer(swipeGesture)
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.view.bringSubviewToFront(transparentView)
        self.view.bringSubviewToFront(sideMenuView)
//        self.view.insertSubview(videoPlayerView, aboveSubview: childView)
        self.sideMenuView.frame = CGRect(x: self.view.frame.width, y: 0, width: 0, height: self.view.frame.height)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.sideMenuView.transform = self.sideMenuView.transform.translatedBy(x: 0, y: 0)
//            self.sideMenuViewWidth.constant = self.view.frame.width*0.6
//            self.sideMenuView.frame = CGRect(x: self.view.frame.width*0.3, y: 0, width: self.view.frame.width*0.6, height: self.view.frame.height)
            self.transparentView.alpha = 0.6
        } completion: { _ in
//            self.isShowPopup = false
        }
    }
    
    func hidePopupView() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.sideMenuView.transform = CGAffineTransform.identity
            self.transparentView.alpha = 0
        } completion: { _ in
            self.view.sendSubviewToBack(self.sideMenuView)
            self.view.sendSubviewToBack(self.transparentView)
        }

    }
    
    @objc func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        print("swiped up")
        if sender.state == .ended {
            self.hidePopupView()
        }
    }
    
    func sizeOfImageAt(url: URL) -> CGSize? {
        // with CGImageSource we avoid loading the whole image into memory
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }

        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
            return nil
        }

        if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
            let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
            return CGSize(width: width, height: height)
        } else {
            return nil
        }
    }
    
    func reloadChatHistory() {
        ChattingListApi.shared.chatHistory(chat_room_id: chat_id, page: page) { [unowned self] result in
            if result.code == "200" {
                self.chatHistory = result
                
                self.chatHistory?.results?.list_arr.reverse()
                for addArray in 0..<(self.chatHistory?.results?.list_arr.count ?? 0)! {
                    self.chat_history_arr.append((self.chatHistory?.results?.list_arr[addArray])!)
                }
//                DispatchQueue.main.async {
//                    let indexPath = IndexPath(row: chat_history_arr.count-1, section: 0)
//                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                }
                chatRoomDetail()
                print("** chat room list count : \(chat_history_arr[0].id ?? 0 )")
                self.tableView.reloadData()
                scrollToFirsLastRow()
                Indicator.hideActivityIndicator(uiView: self.view)
            }
        } fail: { error in
            Indicator.hideActivityIndicator(uiView: self.view)
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인") {
            }
        }
    }
    
    func chatRoomDetail() {
        ChattingListApi.shared.chatRoom(chatRoomId: chat_id) { [unowned self] result in
            if result.code == "200" {
                self.chatRoom = result
                
                
                for addArray in 0..<(self.chatRoom?.results?.list_arr.count ?? 0) {
                    self.chatRoomList.append((chatRoom?.results?.list_arr[addArray])!)
                }
                
                if user_id == chatRoomList[0].user_id ?? 0 {
                    myId = 1
                } else {
                    myId = 0
                }
                self.profileTitle.text = "\(chatRoomList[myId].user_name ?? "")님과 1:1 대화"
                self.tableView.reloadData()
            }
        } fail: { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인") {
            }
        }
    }
    
    func chatDetailMessages() {
        ChattingListApi.shared.chatHistory(chat_room_id: chat_id, page: page) { [unowned self] result in
            if result.code == "200" {
                self.chatHistory = result
                
//                self.chatHistory?.results?.list_arr.reverse()
                self.chat_history_arr.reverse()
                for addArray in 0..<(self.chatHistory?.results?.list_arr.count ?? 0)! {
                    self.chat_history_arr.append((self.chatHistory?.results?.list_arr[addArray])!)
                }
                self.chat_history_arr.reverse()
                
//                DispatchQueue.main.async {
//                    let indexPath = IndexPath(row: chat_history_arr.count-1, section: 0)
//                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                }
                print("** chat room list count : \(chat_history_arr[0].id ?? 0 )")
                self.tableView.reloadData()
                scrollToFirsLastRow()
                Indicator.hideActivityIndicator(uiView: self.view)
            }
        } fail: { error in
            Indicator.hideActivityIndicator(uiView: self.view)
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인") {
            }
        }

    }
    
    func scrollToFirsLastRow() {
        let indexPath = NSIndexPath(row: self.chat_history_arr.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
    }
    
    func messageReplySend() {
//        https://api2.enfit.net/api/v3/chat/{chat_room_id}
//        sender.isUserInteractionEnabled = false
        let content = self.reply_textView.text
        let user_name = UserManager.shared.userInfo.results?.user?.nickname ?? ""
        Indicator.showActivityIndicator(uiView: self.view)
        ChattingListApi.shared.chatReplySave(tempIdx: randomTempIdx(), sender: self.user_id, sender_name: user_name, message: content ?? "", emoticon: "emti\(emoticonNumber)", image: self.image, read: 1, chat_room_id: self.chat_id) { [unowned self] result in
            if result.code == "200" {
                let temp = ChatHistoryList.init()
                temp.idx = result.results?.idx
                temp.sender = result.results?.sender
                temp.sender_name = result.results?.sender_name
                temp.emoticon = result.results?.emoticon
                temp.image = result.results?.image
//                temp.created_at = result.results?.created_at
//                temp.updated_at = result.results?.updated_at
                temp.unread_count = result.results?.unread_count
//                temp.friend_status = result.results?.friend_status
                temp.message = result.results?.message
                temp.time = result.results?.time
                temp.date = result.results?.date
                self.emoticonSelectView.isHidden = true
                self.emoticonImg.image = nil
                self.replyTextViewLbl.isHidden = false
                
                let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#484848")];
                let attributedString = NSAttributedString(string: self.reply_textView.text, attributes: attributedStringColor)
                self.reply_textView.attributedText = attributedString
                self.reply_textView.text = ""
                if self.customView != nil{
                    self.customView?.removeFromSuperview()
                    self.customView = nil
                }
                
                self.chat_history_arr.reverse()
                self.chat_history_arr.insert(temp, at: 0)
                self.chat_history_arr.reverse()
                
                self.chatHistory?.results?.total = (self.chatHistory?.results?.total ?? 0) + 1
                
                self.emoticonNumber = 0
//                sender.isUserInteractionEnabled = true
                DispatchQueue.main.async {
                    self.tableView.reloadSections([0], with: .automatic)
                    Indicator.hideActivityIndicator(uiView: self.view)
                }
                
            } else {
                Indicator.hideActivityIndicator(uiView: self.view)
            }
        } fail: { error in
            Indicator.hideActivityIndicator(uiView: self.view)
//            sender.isUserInteractionEnabled = true
        }

        
        
    }
    
//    func paramForMsgReplySave() -> Dictionary<String, Any> {
//
//
//    }
    
    func randomTempIdx() -> Int {
        let date = Date()
        var calendar = Calendar.current
        
        if let timezone = TimeZone(identifier: "EST") {
            calendar.timeZone = timezone
        }
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let randomInt = Int.random(in: 1...10)*(99999 - 11111 + 1) + 11111
        let tempId = hour+minute+randomInt
        print("** hour : \(hour)")
        print("** minute : \(minute)")
        return tempId
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
            let attributedString = NSAttributedString(string: self.reply_textView.text, attributes: attributedStringColor)
            self.reply_textView.attributedText = attributedString
            self.reply_textView.text = ""
        }, btn2Title: "이어서 작성", btn2Handler: {
            if self.emoticonImg.image != nil {
                self.emoticonSelectView.isHidden = false
            }
            self.reply_textView.becomeFirstResponder()
        })
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
                        self.reply_textView.gestureRecognizers?.removeLast()
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
    
    func retrieveMessages() {
        let messageDB = Database.database().reference().child("message")
        
        messageDB.observe(.childAdded) { (snapshot) in
//            let snapshotValue = snapshot.value as! Dictionary<String, String>
//            let sender = snapshotValue["Sender"]
//            let text = snapshotValue["MessageBody"]
        }
    }
    
}

extension ChattingFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chatHistory != nil {
            switch section {
            case 0:
                if chat_history_arr.count > 0 {
                    return chat_history_arr.count
                } else {
                    return 0
                }
            case 1:
                if chat_history_arr.count > 0 {
                    return 0
                } else {
                    return 1
                }
            default:
                return 1
            }
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if chat_history_arr.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        let title = "time arr"
//
//        return "\(title)"
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomEmptyCell", for: indexPath) as! ChattingRoomTableViewCell
        
        switch section {
        case 0:
            if chat_history_arr.count > 0 {
                
//                let isSame = (chat_history_arr[row].date ?? "").compare(chat_history_arr[row+1].date ?? "") == ComparisonResult.orderedSame
//
//                if isSame == false {
//                    cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomMsgDateCell", for: indexPath) as! ChattingRoomTableViewCell
//
//                    cell.msgDateLbl.text = chat_history_arr[row].date ?? ""
//                    print("** is false ")
//                }
//
//                print("** isSame : \(isSame)")
                
                
                if chat_history_arr[row].sender ?? 0 != self.user_id {
    //                received msg
                    if chat_history_arr[row].image ?? "" != "" {
                        cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomReceivedImgCell", for: indexPath) as! ChattingRoomTableViewCell
                        
                        guard let userPhotoUrl = URL(string: "\(chat_history_arr[row].photo ?? "")") else {
                            return cell
                        }
                        cell.userImgView.sd_setImage(with: userPhotoUrl, placeholderImage: UIImage(named: "reply_user_default"))
                        cell.userNameLbl.text = "\(chat_history_arr[row].user_name ?? "")"
                        
                        guard let imgUrl = URL(string: "\(chat_history_arr[row].image ?? "")") else {
                            return cell
                        }
//                        let ratio = (sizeOfImageAt(url: imgUrl)?.width ?? 0)/(sizeOfImageAt(url: imgUrl)?.height ?? 0)
//                        let imgHeight = (sizeOfImageAt(url: imgUrl)?.width ?? 0)/ratio
//                        let imgWidth = (sizeOfImageAt(url: imgUrl)?.height ?? 0)/ratio
                        
                        cell.msgReceivedImgWidth.constant = 160  //imgWidth
                        cell.msgReceivedImgHeight.constant = 160  //imgHeight
                        cell.msgReceivedImg.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "home_default_photo"))
                        
                        cell.msgReceivedTimeLbl.text = "\(chat_history_arr[row].time ?? "")"
                        cell.profileBtn.tag = row
                        
                    } else {
                        if chat_history_arr[row].emoticon ?? "" != "" && chat_history_arr[row].message ?? "" != "" {
                            cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomReceivedImgTxtCell", for: indexPath) as! ChattingRoomTableViewCell
                            let userPhotoUrl = URL(string: chat_history_arr[row].photo ?? "")
                            cell.userImgView.sd_setImage(with: userPhotoUrl, placeholderImage: UIImage(named: "reply_user_default"))
                            cell.userNameLbl.text = chat_history_arr[row].user_name ?? ""
                            
                            cell.msgReceivedImgHeight.constant = 120
                            cell.msgReceivedImgWidth.constant = 120
                            self.emojiNumber = "\(chat_history_arr[row].emoticon ?? "").png"
                            for emoji in emoticonView.items {
                                if emoji == emojiNumber {
                                    cell.msgReceivedImg.image = UIImage(named: emoji)
                                }
                            }
                            cell.profileBtn.tag = row
                            cell.msgReceivedTextView.text = "\(chat_history_arr[row].message ?? "")"
                            cell.msgReceivedTimeLbl.text = "\(chat_history_arr[row].time ?? "")"
                            
                        } else if chat_history_arr[row].emoticon ?? "" != "" && chat_history_arr[row].message ?? "" == "" {
                            cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomReceivedImgCell", for: indexPath) as! ChattingRoomTableViewCell
                            
                            let userPhotoUrl = URL(string: chat_history_arr[row].photo ?? "")
                            cell.userImgView.sd_setImage(with: userPhotoUrl, placeholderImage: UIImage(named: "reply_user_default"))
                            cell.userNameLbl.text = chat_history_arr[row].user_name ?? ""
                            cell.msgReceivedImgHeight.constant = 120
                            cell.msgReceivedImgWidth.constant = 120
                            self.emojiNumber = "\(chat_history_arr[row].emoticon ?? "").png"
                            for emoji in emoticonView.items {
                                if emoji == emojiNumber {
                                    cell.msgReceivedImg.image = UIImage(named: emoji)
                                }
                            }
                            cell.msgReceivedTimeLbl.text = "\(chat_history_arr[row].time ?? "")"
                            
                        } else {
                            cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomReceivedTextCell", for: indexPath) as! ChattingRoomTableViewCell
                            let userPhotoUrl = URL(string: chat_history_arr[row].photo ?? "")
                            cell.userImgView.sd_setImage(with: userPhotoUrl, placeholderImage: UIImage(named: "reply_user_default"))
                            cell.userNameLbl.text = "\(chat_history_arr[row].user_name ?? "")"
                            cell.msgReceivedTextView.text = "\(chat_history_arr[row].message ?? "")"
                            cell.msgReceivedTimeLbl.text = "\(chat_history_arr[row].time ?? "")"
                        }
                    }
                    cell.profileBtn.tag = row
                } else {
    //                sent msg
                    if chat_history_arr[row].image ?? "" != "" {
                        cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomSentImgCell", for: indexPath) as! ChattingRoomTableViewCell
                        
                        guard let imgUrl = URL(string: "\(chat_history_arr[row].image ?? "")") else {
                            return cell
                        }
//                        let ratio = (sizeOfImageAt(url: imgUrl)?.width ?? 0)/(sizeOfImageAt(url: imgUrl)?.height ?? 0)
//                        let imgHeight = (sizeOfImageAt(url: imgUrl)?.width ?? 0)/ratio
//                        let imgWidth = (sizeOfImageAt(url: imgUrl)?.height ?? 0)/ratio
                        
                        cell.msgSentImgHeight.constant = 160 //imgHeight
                        cell.msgSentImgWidth.constant = 160  //imgWidth
                        
                        cell.msgSentImgView.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "home_default_photo"))
                        cell.msgSentTimeLbl.text = "\(chat_history_arr[row].time ?? "")"
                        if chat_history_arr[row].unread_count ?? 0 > 0 {
                            cell.msgSentReadLbl.text = "\(chat_history_arr[row].unread_count ?? 0)"
                        } else {
                            cell.msgSentReadLbl.text = ""
                        }
                    } else {
                        if chat_history_arr[row].emoticon ?? "" != "" && chat_history_arr[row].message ?? "" != "" {
                            cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomSentImgTxtCell", for: indexPath) as! ChattingRoomTableViewCell
                            cell.msgSentImgHeight.constant = 120
                            cell.msgSentImgWidth.constant = 120
                            
                            self.emojiNumber = "\(chat_history_arr[row].emoticon ?? "").png"
                            for emoji in emoticonView.items {
                                if emoji == emojiNumber {
                                    cell.msgSentImgView.image = UIImage(named: emoji)
                                }
                            }
                            
                            if chat_history_arr[row].unread_count ?? 0 > 0 {
                                cell.msgSentReadLbl.text = "\(chat_history_arr[row].unread_count ?? 0)"
                            } else {
                                cell.msgSentReadLbl.text = ""
                            }
                            cell.msgSentTxtLbl.text = "\(chat_history_arr[row].message ?? "")"
                            cell.msgSentTimeLbl.text = "\(chat_history_arr[row].time ?? "")"
                            
                        } else if chat_history_arr[row].emoticon ?? "" != "" && chat_history_arr[row].message ?? "" == "" {
                            cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomSentImgCell", for: indexPath) as! ChattingRoomTableViewCell
                            cell.msgSentImgHeight.constant = 120
                            cell.msgSentImgWidth.constant = 120
                            
                            self.emojiNumber = "\(chat_history_arr[row].emoticon ?? "").png"
                            for emoji in emoticonView.items {
                                if emoji == emojiNumber {
                                    cell.msgSentImgView.image = UIImage(named: emoji)
                                }
                            }
                            if chat_history_arr[row].unread_count ?? 0 > 0 {
                                cell.msgSentReadLbl.text = "\(chat_history_arr[row].unread_count ?? 0)"
                            } else {
                                cell.msgSentReadLbl.text = ""
                            }
                            cell.msgSentTimeLbl.text = "\(chat_history_arr[row].time ?? "")"
                        } else {
                            cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomSentTextCell", for: indexPath) as! ChattingRoomTableViewCell
                            if chat_history_arr[row].unread_count ?? 0 > 0 {
                                cell.msgSentReadLbl.text = "\(chat_history_arr[row].unread_count ?? 0)"
                            } else {
                                cell.msgSentReadLbl.text = ""
                            }
                            cell.msgSentTxtLbl.text = "\(chat_history_arr[row].message ?? "")"
                            cell.msgSentTimeLbl.text = "\(chat_history_arr[row].time ?? "")"
                        }
                    }
                }
            }
//            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.selectionStyle = .none
            return cell
        case 1:
            if user_id == chatRoom?.results?.list_arr[0].user_id ?? 0 {
                myId = 1
            } else {
                myId = 0
            }
            cell.emptyChatLbl.text = "\(chatRoom?.results?.list_arr[myId].user_name ?? "")님과 즐거운 시간되세요"
//            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.selectionStyle = .none
            return cell
        default:
//            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        DispatchQueue.main.async {
            if section == 0 {
                if row == self.chat_history_arr.count-1 {
                    if self.page < self.chatHistory?.results?.page_total ?? 0 {
                        Indicator.showActivityIndicator(uiView: self.view)
                        self.page += 1
                        self.chatDetailMessages()
                    }
                }
            }
        }
    }
}


extension ChattingFriendViewController: CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        
//        if cropViewController.croppingStyle != .circular {
//            imageView.isHidden = true
//
//            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
//                                                   toView: imageView,
//                                                   toFrame: CGRect.zero,
//                                                   setup: { self.layoutImageView() },
//                                                   completion: { self.imageView.isHidden = false })
//        }else {
//            self.imageView.isHidden = false
//            cropViewController.dismiss(animated: true, completion: nil)
//        }
        print("** selected image")
        self.image = image
//        self.emoticonSelectView.isHidden = false
//        self.emoticonImg.image = ImageScale().scaleImage(image: image)
//        self.image = ImageScale().scaleImage(image: image)
//        self.emoticonNumber = 0
//        let time = DispatchTime.now() + .seconds(1)
//        DispatchQueue.main.asyncAfter(deadline: time) {
//            self.reply_textView.becomeFirstResponder()
//        }
        
        cropViewController.dismiss(animated: true) {
//            self.messageReplySend()
//            ChattingListApi.shared.chatImage2URL(image: image) { (result) in
//                if result.code == "200" {
//                    print("** successfull : \(result.results?.photo_url ?? "")")
//                    
//                }
//            } fail: { (error) in
//                print("\(String(describing: error))")
//            }

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


extension ChattingFriendViewController: UITextViewDelegate {
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 텍스트뷰가 변경될때 타는 함수
     
     - Parameters:
        - textView: 텍스트뷰 값이 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    func textViewDidChange(_ textView: UITextView) {
        if self.reply_textView.contentSize.height >= 45 {
            self.reply_textView.isScrollEnabled = true
            self.replyTextViewHeight.constant = 45
        }else{
            self.reply_textView.isScrollEnabled = false
            let sizeToFitIn = CGSize(width: self.reply_textView.bounds.size.width, height: CGFloat(MAXFLOAT))
            let newSize = self.reply_textView.sizeThatFits(sizeToFitIn)
            self.replyTextViewHeight.constant = newSize.height
        }
        
        if self.reply_textView.text == "" {
            replyTextViewLbl.isHidden = false
        }else{
            replyTextViewLbl.isHidden = true
        }
        
        if(textView.text == UIPasteboard.general.string){
            let newTextViewHeight = ceil(textView.sizeThatFits(textView.frame.size).height)
            if newTextViewHeight > 45 {
                self.reply_textView.isScrollEnabled = true
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
        if self.reply_textView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            
        }
    }
}
