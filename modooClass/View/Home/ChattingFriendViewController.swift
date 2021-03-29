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
    @IBOutlet weak var replySendView: GradientView!
    
    var setDateArr:Array = [Int]()
    var firstReload:Bool?
    var senderId = 0
    var isSender:Bool?
    var chat_read_log = "entry"
    var chat_id = 0
    var page = 1
    var user_id = UserManager.shared.userInfo.results?.user?.id ?? 0
    var notMyId = 0
    var imageURL = ""
    var customView:UIView!
    var emoticonNumber:Int = 0
    var keyboardShow = false
    var keyBoardSize:CGRect?
    var chatRoom:ChatRoomModel?
    var chatRoomList:Array = Array<ChatRoomList>()
    var chatHistory:ChatHistoryModel?
    var chat_history_arr:Array = Array<ChatHistoryList>()
    var emojiNumber = ""
    var ref:DatabaseReference = Database.database().reference()
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    private let imageView = UIImageView()
    
    let dateFormatter = DateFormatter()
    
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
        
        emoticonView.WithEmoticon { [unowned self] eNumber in
            self.emoticonSelectView.isHidden = false
            self.emoticonImg.image = UIImage(named: "emti\(eNumber+1)")
            self.emoticonNumber = eNumber+1
            self.image = nil
        }
        
        reply_textView.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.sideMenuProfileTag(_ :)), name: NSNotification.Name(rawValue: "sideMenuProfileTag"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openLinkUrl), name: NSNotification.Name(rawValue: "openLinkUrl"), object: nil)
       
        reply_border_view.layer.borderWidth = 1
        reply_border_view.layer.borderColor = UIColor(hexString: "#eeeeee").cgColor
        reply_border_view.layer.cornerRadius = 15
        reply_textView.layer.cornerRadius = 15
        reply_textView.autocorrectionType = .no

        replySendView.layer.shadowColor = UIColor(hexString: "#757575").cgColor
        replySendView.layer.shadowOffset = CGSize(width: 0.0, height: -6.0)
        replySendView.layer.shadowOpacity = 0.05
        replySendView.layer.shadowRadius = 4
        replySendView.layer.masksToBounds = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listensUserLog()
        self.firstReload = true
        self.listenerForMessages()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("** ChattingViewController disappeared")
        
        self.ref.child("chat_read_log").child("\(self.notMyId)").child("\(self.chat_id)").removeAllObservers()
        self.ref.child("chat").child("\(self.chat_id)").child("\(self.user_id)").removeAllObservers()
    }
    
    deinit {
        print("ChattingFriendViewController deinit")
    }
    
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func moreBtnClicked(_ sender: UIButton) {
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
//        self.view.endEditing(true)
        if self.reply_textView.text?.isBlank == false || self.emoticonImg.image != nil{
            self.messageReplySend()
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
    
    func sideMenuOpen() {
        print("popup view is showing!!!")
        if keyboardShow == true {
            self.view.endEditing(true)
        }
        
        self.sideMenuView.leaveChatBtnClick = {
            
            ChattingListApi.shared.chat_leave(chatId: self.chat_id) { result in
                if result.code == "200" {
                    print("** leaveChatBtnClicked")
                    self.hidePopupView()
                    self.navigationController?.popViewController(animated: true)
                }
            } fail: { (error) in
            }

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
    
    func reloadChatHistory() {
        ChattingListApi.shared.chatHistory(chat_room_id: chat_id, page: page) { [unowned self] result in
            if result.code == "200" {
                
                self.chatHistory = result
                
                for addArray in 0..<(self.chatHistory?.results?.list_arr.count ?? 0)! {
                    self.chat_history_arr.append((self.chatHistory?.results?.list_arr[addArray])!)
                }
                
                if self.chatHistory?.results?.total ?? 0 > 1 {
                    self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
                }
                
                chatRoomDetail()
                setCellDate()
                DispatchQueue.main.async {
                    let indexSet = IndexSet.init(integer: 0)
                    self.tableView.reloadSections(indexSet, with: .automatic)
                }
            }
                
                
//                Indicator.hideActivityIndicator(uiView: self.view)
            
        } fail: { error in
//            Indicator.hideActivityIndicator(uiView: self.view)
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인") {
            }
        }
    }
    
    func chatRoomDetail() {
        ChattingListApi.shared.chatRoom(chatRoomId: chat_id) { [weak self] result in
            if result.code == "200" {
                self?.chatRoom = result
                
                for addArray in 0..<(self?.chatRoom?.results?.list_arr.count ?? 0) {
                    self?.chatRoomList.append((self?.chatRoom?.results?.list_arr[addArray])!)
                }
                
                var checkId = 0
                if self?.user_id == self?.chatRoomList[0].user_id ?? 0 {
                    checkId = 1
                } else {
                    checkId = 0
                }
                self?.profileTitle.text = "\(self?.chatRoomList[checkId].user_name ?? "")님과 1:1 대화"
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
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
                
                for addArray in 0..<(self.chatHistory?.results?.list_arr.count ?? 0)! {
                    self.chat_history_arr.append((self.chatHistory?.results?.list_arr[addArray])!)
                }
                
                if self.chatHistory?.results?.total ?? 0 > 1 {
                    self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
                }
                
//                setCellDate()
                
                DispatchQueue.main.async {
                    let indexSet = IndexSet.init(integer: 0)
                    self.tableView.reloadSections(indexSet, with: .none)
                }
                
                Indicator.hideActivityIndicator(uiView: self.view)
            }
        } fail: { error in
            Indicator.hideActivityIndicator(uiView: self.view)
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인") {
            }
        }

    }
    
    func listensUserLog() {
        self.ref.child("chat_read_log").child("\(self.notMyId)").child("\(self.chat_id)").observe(.value, with: { (snapshot) in

            if let value = snapshot.value as? [String:Any] {
                guard let idx = value["mcChatLog_id"] as? Int else {return}
                
                for i in 0..<self.chat_history_arr.count {


//                            if self.chat_history_arr[i].unread_count ?? 0 > 0 {
//                                self.chat_history_arr[i].unread_count = 0
//                            print("** api  successed to be called")
//                                let indexPath = IndexPath(row: i, section: 0)
//                                self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                            }


//                    if self.user_id != self.chat_history_arr[i].user_id {
                        if idx >= self.chat_history_arr[i].idx ?? 0 {
                            self.chat_history_arr[i].unread_count = 0
                            let indexPath = IndexPath(row: i, section: 0)
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
//                            else {
//                                self.chat_history_arr[i].unread_count = 1
//                                print("** row \(i) updating to 1")
//                                let indexPath = IndexPath(row: i, section: 0)
//                                self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                            }
//                    }
                }
                
                for i in 0..<(self.chat_history_arr.count) {
                    if self.chat_history_arr[i].unread_count ?? 0 > 1 {
                        self.chat_history_arr[i].unread_count = 1
                        let indexPath = IndexPath(row: i, section: 0)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        })
    }
    
    func listenerForMessages() {
        self.ref.child("chat").child("\(self.chat_id)").child("\(self.user_id)").observe(.value, with: { (snapshot) in
                
            guard let value = convertToDictionary(text: snapshot.value as? String ?? "") else {
                return
            }
            
            let newData = ChatFirebaseDB(dic: value)
            let sender_id = Int(newData.sender ?? "") ?? 0
            
//                self.isOnline =  true
//            self.chatReadApiCalled(chatId: self.chat_id)
        
        
            if sender_id != self.user_id {

//                    let temp = ChatHistoryList.init()
//                    temp.idx = newData.idx
//                    temp.sender = Int(newData.sender ?? "") ?? 0
//                    temp.sender_name = newData.sender_name
//                    temp.emoticon = newData.emoticon
//                    temp.user_only = newData.user_only
//                    temp.image = newData.image
//                    temp.photo = newData.photo
//                    temp.unread_count = newData.unread_count
//                    temp.message = newData.message
//                    temp.time = newData.time
//                    temp.date = newData.date
//
                
//                    self.chat_history_arr[0].unread_count = newData.unread_count
//                    print("** unread_count : \(self.chat_history_arr[0].unread_count ?? 0)")
//                self.chat_history_arr.append(temp)
//                    if self.isOnline == true {
                    
//                    }

                
//                for i in 0..<(self.chat_history_arr.count) {
//                    if self.chat_history_arr[i].unread_count ?? 0 > 1 {
//                        self.chat_history_arr[i].unread_count = 1
//                        print("** the row \(i) updated to 1")
//
////
//                        let indexPath = IndexPath(row: i, section: 0)
//                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                    }
//                }
//                self.listensUserLog()
//
                self.chatReadApiCalled(chatId: self.chat_id)
                
                print("** listener is listening : \(value)")
                if self.firstReload == false {
                    self.page = 1
                    self.chat_history_arr.removeAll()
                    self.chatDetailMessages()
                }
                
                
//
                
                self.firstReload = false
                    
                
//                    DispatchQueue.main.async {
//                        let indexSet = IndexSet.init(integer: 0)
//                        self.tableView.reloadSections(indexSet, with: .automatic)
//                    }
                
            }
          
        })
        
    }
    
    func messageReplySend() {
//        https://api2.enfit.net/api/v3/chat/{chat_room_id}
        let content = self.reply_textView.text
        let user_name = UserManager.shared.userInfo.results?.user?.nickname ?? ""
//        Indicator.showActivityIndicator(uiView: self.view)
        var emojiString = ""
        if emoticonNumber > 0 {
            emojiString = "emti\(emoticonNumber).png"
        }
        
        ChattingListApi.shared.chatReplySave(tempIdx: randomTempIdx(), sender: self.user_id, sender_name: user_name, message: content ?? "", emoticon: emojiString, image: imageURL, read: 0, chat_room_id: self.chat_id) { [unowned self] result in
            if result.code == "200" {
                let temp = ChatHistoryList.init()
                temp.idx = result.results?.idx
                temp.sender = result.results?.sender
                temp.sender_name = result.results?.sender_name
                temp.emoticon = result.results?.emoticon
                temp.image = result.results?.image
                temp.photo = result.results?.photo
                temp.unread_count = result.results?.unread_count
                temp.message = result.results?.message
                temp.time = result.results?.time
                temp.date = result.results?.date

//                self.chat_history_arr.append(temp)
//                self.chat_history_arr.reverse()
                self.chat_history_arr.insert(temp, at: 0)
//                self.chat_history_arr.reverse()

                self.chatHistory?.results?.total = (self.chatHistory?.results?.total ?? 0) + 1
                self.imageURL = ""
                
                self.senderId = result.results?.sender ?? 0


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
                
                self.emoticonNumber = 0
                
                DispatchQueue.main.async {
                    let indexSet = IndexSet.init(integer: 0)
                    self.tableView.reloadSections(indexSet, with: .automatic)
//                    Indicator.hideActivityIndicator(uiView: self.view)
                }
                
                self.chatReadApiCalled(chatId: self.chat_id)
                
            } else {
//                Indicator.hideActivityIndicator(uiView: self.view)
            }
        } fail: { error in
//            Indicator.hideActivityIndicator(uiView: self.view)
        }

        
        
    }
    
    func chatReadApiCalled(chatId: Int) {
        ChattingListApi.shared.chatRead(chatId: chatId) { result in
            if result.code == "200" {
//                    for i in 0..<self.chat_history_arr.count {
//                        if self.chat_history_arr[i].unread_count ?? 0 > 0 {
//                            self.chat_history_arr[i].unread_count = 0
                        print("** api  successed to be called")
//                            let indexPath = IndexPath(row: i, section: 0)
//                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                        }
//                    }
            }
        } fail: { error in
            print("\(error.debugDescription)")
        }
    }
    
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
    
}

@objc extension ChattingFriendViewController {
    
    /** **텍스트뷰 클릭 > 이모티콘뷰 숨기기 */
    func textViewTab(){
        if self.customView != nil {
            self.customView.removeFromSuperview()
            self.customView = nil
        }
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let image = sender.view as? UIImageView else {return}
        Alert.WithImageView(self, image: image.image!, btn1Title: "") {
            print("** image tapped")
        }
    }
    
    func sideMenuProfileTag(_ notification : Notification) {
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
    
    func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            self.hidePopupView()
        }
    }
    
    func setCellDate() {
        
        dateFormatter.dateFormat = "yyyy.MM.dd"

        for i in 0..<self.chat_history_arr.count-1 {
            let pastDate = dateFormatter.date(from: self.chat_history_arr[i+1].date ?? "")
            let currentDate = dateFormatter.date(from: self.chat_history_arr[i].date ?? "")

            let compare = Calendar.current.compare(currentDate!, to: pastDate!, toGranularity: .day)
            if compare == .orderedDescending {
                self.setDateArr.append(i)
//
                print("** pastDate : \(self.setDateArr)\n** currentDate : \(String(describing: currentDate))")
            }
        }
    }
    
    func openLinkUrl(_ notification: Notification) {
        let url = notification.object as! String
        let session = UserDefaultSetting.getUserDefaultsString(forKey: sessionToken) as! String
        var urlToken = ""
        if url.contains("materials/") {
            urlToken = "\(url)?token=\(session)"
        } else {
            urlToken = "\(url)"
        }

        print("** url token \(urlToken)")
        let newVC = UIStoryboard(name: "ChildWebView", bundle: nil).instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newVC.url = urlToken
        navigationController?.pushViewController(newVC, animated: true)
//        UIApplication.shared.openURL(URL(string: urlToken)!)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 키보드가 보일때 함수
     
     - Parameters:
        - notification: 키보드가 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    func keyboardWillShow(notification: Notification) {
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
    func keyboardWillHide(notification: Notification) {
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
    
    func keyboardWillChange(notification: Notification) {
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

extension ChattingFriendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            if chatHistory?.results?.total ?? 0 > 0 {
                return 0
            } else {
                return 1
            }
        case 0:
            if chatHistory?.results?.total ?? 0 > 0 {
                return chat_history_arr.count  //+self.setDateArr.count
            } else {
                return 0
            }
        default:
            return 1
        }
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if chat_history_arr.count > 0 {
//            return 2
//        } else {
//            return 2
//        }
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
//
//        return "section \(section)"
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        
        switch section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomEmptyCell", for: indexPath) as! ChattingRoomTableViewCell
            print("** empty cell")
            var checkId = 0
            if user_id == chatRoom?.results?.list_arr[0].user_id ?? 0 {
                checkId = 1
            } else {
                checkId = 0
            }
            cell.emptyChatLbl.text = "\(chatRoom?.results?.list_arr[checkId].user_name ?? "")님과 즐거운 시간되세요"
            if self.chatHistory?.results?.total ?? 0 > 1 {
                cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            }
            cell.selectionStyle = .none
            return cell
            
        case 0:
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomEmptyCell", for: indexPath) as! ChattingRoomTableViewCell
            if chat_history_arr.count > 0 {
                var row2 = 0
                for i in 0..<chat_history_arr.count {
                    row2 = i
                }
                
                if chat_history_arr[row].sender ?? 0 != 0 && chat_history_arr[row].sender ?? 0 != self.user_id {
                    self.isSender = false
                } else {
                    self.isSender = true
                }
                
                if self.isSender == false {
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
//                        let imgHeight = (sizeOfImageAt(url: imgUrl)?.width ?? 0) //  /ratio
//                        let imgWidth = (sizeOfImageAt(url: imgUrl)?.height ?? 0) // /ratio
//
//
//                        var newHeight = 0 as CGFloat
//                        var newWidth = 0 as CGFloat
//                        if imgWidth > 960 {
//                            let ratio = imgWidth/960
//                            newHeight = imgHeight/ratio
//                            newWidth = 960
//                        }
                        
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                        cell.msgReceivedImg.addGestureRecognizer(tapGesture)
                        
                        if row < chat_history_arr.count-1 {
                            let pastDate = dateFormatter.date(from: self.chat_history_arr[row+1].date ?? "")
                            let currentDate = dateFormatter.date(from: self.chat_history_arr[row].date ?? "")

                            let compare = Calendar.current.compare(currentDate!, to: pastDate!, toGranularity: .day)
                            if compare == .orderedDescending {
                                cell.dateDifferenceLbl.text = "\(chat_history_arr[row].date ?? "")"
                                cell.dateDifferenceViewHeight.constant = 28
                                cell.userImgTopConstraint.constant = 45
                            } else {
                                cell.dateDifferenceLbl.text = ""
                                cell.dateDifferenceViewHeight.constant = 0
                                cell.userImgTopConstraint.constant = 12
                            }
                        }
                        
                        cell.msgReceivedImgWidth.constant = 160 //newWidth  //imgWidth
                        cell.msgReceivedImgHeight.constant = 160 //newHeight  //imgHeight
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
                            self.emojiNumber = "\(chat_history_arr[row].emoticon ?? "")"
                            if !self.emojiNumber.contains(".") {
                                self.emojiNumber = "\(emojiNumber).png"
                            }
                            for emoji in emoticonView.items {
                                if emoji == emojiNumber {
                                    cell.msgReceivedImg.image = UIImage(named: emoji)
                                }
                            }
                            
                            if row < chat_history_arr.count-1 {
                                let pastDate = dateFormatter.date(from: self.chat_history_arr[row+1].date ?? "")
                                let currentDate = dateFormatter.date(from: self.chat_history_arr[row].date ?? "")

                                let compare = Calendar.current.compare(currentDate!, to: pastDate!, toGranularity: .day)
                                if compare == .orderedDescending {
                                    cell.dateDifferenceLbl.text = "\(chat_history_arr[row].date ?? "")"
                                    cell.dateDifferenceViewHeight.constant = 28
                                    cell.userImgTopConstraint.constant = 45
                                } else {
                                    cell.dateDifferenceLbl.text = ""
                                    cell.dateDifferenceViewHeight.constant = 0
                                    cell.userImgTopConstraint.constant = 12
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
                            self.emojiNumber = "\(chat_history_arr[row].emoticon ?? "")"
                            if !self.emojiNumber.contains(".") {
                                self.emojiNumber = "\(emojiNumber).png"
                            }
                            for emoji in emoticonView.items {
                                if emoji == emojiNumber {
                                    cell.msgReceivedImg.image = UIImage(named: emoji)
                                }
                            }
                            
                            if row < chat_history_arr.count-1 {
                                let pastDate = dateFormatter.date(from: self.chat_history_arr[row+1].date ?? "")
                                let currentDate = dateFormatter.date(from: self.chat_history_arr[row].date ?? "")

                                let compare = Calendar.current.compare(currentDate!, to: pastDate!, toGranularity: .day)
                                if compare == .orderedDescending {
                                    cell.dateDifferenceLbl.text = "\(chat_history_arr[row].date ?? "")"
                                    cell.dateDifferenceViewHeight.constant = 28
                                    cell.userImgTopConstraint.constant = 45
                                } else {
                                    cell.dateDifferenceLbl.text = ""
                                    cell.dateDifferenceViewHeight.constant = 0
                                    cell.userImgTopConstraint.constant = 12
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
                            
//                            for i in 0..<(chatHistory?.results?.total ?? 0) {
//
//                            }
                            if row < chat_history_arr.count-1 {
                                let pastDate = dateFormatter.date(from: self.chat_history_arr[row+1].date ?? "")
                                let currentDate = dateFormatter.date(from: self.chat_history_arr[row].date ?? "")

                                let compare = Calendar.current.compare(currentDate!, to: pastDate!, toGranularity: .day)
                                if compare == .orderedDescending {
                                    cell.dateDifferenceLbl.text = "\(chat_history_arr[row].date ?? "")"
                                    cell.dateDifferenceViewHeight.constant = 28
                                    cell.userImgTopConstraint.constant = 45
                                } else {
                                    cell.dateDifferenceLbl.text = ""
                                    cell.dateDifferenceViewHeight.constant = 0
                                    cell.userImgTopConstraint.constant = 12
                                }
                            }
                                
//                            }
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
                        
                        
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                        cell.msgSentImgView.addGestureRecognizer(tapGesture)
                        
                        cell.msgSentImgHeight.constant = 160 //imgHeight
                        cell.msgSentImgWidth.constant = 160  //imgWidth
                        
                        if row < chat_history_arr.count-1 {
                            let pastDate = dateFormatter.date(from: self.chat_history_arr[row+1].date ?? "")
                            let currentDate = dateFormatter.date(from: self.chat_history_arr[row].date ?? "")

                            let compare = Calendar.current.compare(currentDate!, to: pastDate!, toGranularity: .day)
                            if compare == .orderedDescending {
                                cell.dateDifferenceLbl.text = "\(chat_history_arr[row].date ?? "")"
                                cell.dateDifferenceViewHeight.constant = 28
                            } else {
                                cell.dateDifferenceLbl.text = ""
                                cell.dateDifferenceViewHeight.constant = 0
                            }
                        }
                        
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
                            
                            self.emojiNumber = "\(chat_history_arr[row].emoticon ?? "")"
                            if !self.emojiNumber.contains(".") {
                                self.emojiNumber = "\(emojiNumber).png"
                            }
                            for emoji in emoticonView.items {
                                if emoji == emojiNumber {
                                    cell.msgSentImgView.image = UIImage(named: emoji)
                                }
                            }
                            
                            if row < chat_history_arr.count-1 {
                                let pastDate = dateFormatter.date(from: self.chat_history_arr[row+1].date ?? "")
                                let currentDate = dateFormatter.date(from: self.chat_history_arr[row].date ?? "")

                                let compare = Calendar.current.compare(currentDate!, to: pastDate!, toGranularity: .day)
                                if compare == .orderedDescending {
                                    cell.dateDifferenceLbl.text = "\(chat_history_arr[row].date ?? "")"
                                    cell.dateDifferenceViewHeight.constant = 28
                                } else {
                                    cell.dateDifferenceLbl.text = ""
                                    cell.dateDifferenceViewHeight.constant = 0
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
                            
                            self.emojiNumber = "\(chat_history_arr[row].emoticon ?? "")"
                            if !self.emojiNumber.contains(".") {
                                self.emojiNumber = "\(emojiNumber).png"
                            }
                            for emoji in emoticonView.items {
                                if emoji == emojiNumber {
                                    cell.msgSentImgView.image = UIImage(named: emoji)
                                }
                            }
                            
                            if row < chat_history_arr.count-1 {
                                let pastDate = dateFormatter.date(from: self.chat_history_arr[row+1].date ?? "")
                                let currentDate = dateFormatter.date(from: self.chat_history_arr[row].date ?? "")

                                let compare = Calendar.current.compare(currentDate!, to: pastDate!, toGranularity: .day)
                                if compare == .orderedDescending {
                                    cell.dateDifferenceLbl.text = "\(chat_history_arr[row].date ?? "")"
                                    cell.dateDifferenceViewHeight.constant = 28
                                } else {
                                    cell.dateDifferenceLbl.text = ""
                                    cell.dateDifferenceViewHeight.constant = 0
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
                            
                            if row < chat_history_arr.count-1 {
                                let pastDate = dateFormatter.date(from: self.chat_history_arr[row+1].date ?? "")
                                let currentDate = dateFormatter.date(from: self.chat_history_arr[row].date ?? "")

                                let compare = Calendar.current.compare(currentDate!, to: pastDate!, toGranularity: .day)
                                if compare == .orderedDescending {
                                    cell.dateDifferenceLbl.text = "\(chat_history_arr[row].date ?? "")"
                                    cell.dateDifferenceViewHeight.constant = 28
                                } else {
                                    cell.dateDifferenceLbl.text = ""
                                    cell.dateDifferenceViewHeight.constant = 0
                                }
                            }
                        }
                    }
                }
            }
            if self.chatHistory?.results?.total ?? 0 > 1 {
                cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            }
            
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomEmptyCell", for: indexPath) as! ChattingRoomTableViewCell
            if self.chatHistory?.results?.total ?? 0 > 1 {
                cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        DispatchQueue.main.async {
            if section == 0 {
                if self.page < self.chatHistory?.results?.page_total ?? 0 {
                    if row == self.chat_history_arr.count-1 {
                        Indicator.showActivityIndicator(uiView: self.view)
                        self.page += 1
                        self.chatDetailMessages()
                    }
                }
            }
        }
    }
    
    /** **테이블 셀의 선택시 함수 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
//        if self.reply_textView.text.isEmpty != true || self.emoticonImg.image != nil{
//            replyWriteCheck()
//        }else{
//
//        }
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
            ChattingListApi.shared.chatImage2URL(image: image) { (result) in
                if result.code == "200" {
                    self.imageURL = result.results?.photo_url ?? ""
                    self.messageReplySend()
                }
            } fail: { (error) in
                print("\(String(describing: error))")
            }
            
            
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
}
