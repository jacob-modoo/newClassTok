//
//  ChattingViewController.swift
//  modooClass
//
//  Created by iOS|Dev on 2021/01/05.
//  Copyright © 2021 신민수. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup
import FirebaseDatabase

class ChattingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isFirstEntry:Bool?
    var chatList:ChatListModel?
    var chat_list_arr:Array = Array<Chat_list>()
    var page = 1
    var messageType = ""
    var emojiNumber = ""
    lazy var emoticonView = EmoticonView()
    var checkId = 0
    var firebaseRef : DatabaseReference = Database.database().reference()
    
    let user_id = UserManager.shared.userInfo.results?.user?.id ?? 0
    let chattingStoryboard = UIStoryboard(name: "Chatting", bundle: nil)
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        reloadView()
        self.listenerForChatList()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadView), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.listenerForChatList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.firebaseRef.child("chat_read").child("\(user_id)").removeAllObservers()
    }
    
    deinit {
        print("ChattingViewController deinit")
    }
    
    
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.firebaseRef.child("chat_read").child("\(user_id)").removeAllObservers()
    }
    
    
    @objc func reloadView() {
        ChattingListApi.shared.chatList(page: page) { [weak self] result in
            if result.code == "200" {
                self?.chatList = result

                self?.chat_list_arr.removeAll()

                for addArray in 0 ..< (self?.chatList?.results?.curr_total ?? 0)! {
                    if self?.chatList?.results?.list_arr[addArray].user_id.count ?? 0 > 1 {
                        self?.chat_list_arr.append((self?.chatList?.results?.list_arr[addArray])!)
                    }
                }

                DispatchQueue.main.async {
                    let indexSet = IndexSet.init(integer: 1)
                    self?.tableView.reloadSections(indexSet, with: .automatic)
                }
            }
        } fail: { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인") {
            }
        }
    }
    
    func listenerForChatList() {
        Indicator.showActivityIndicator(uiView: self.view)
        self.firebaseRef.child("chat_read").child("\(user_id)").observe(.value) { (snapshot) in

            let value = snapshot.value as? [String:Any]
            print("** snapshot value : \(value ?? [:])")
            
            self.isFirstEntry = true
            self.chatDetailList()

            DispatchQueue.main.async {
                for i in 0..<self.chat_list_arr.count {
                    if self.chat_list_arr[i].unread_count ?? 0 > 0 {
                        let indexPath = IndexPath(row: i, section: 1)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    
    func chatDetailList() {
        if self.isFirstEntry == true {
            self.page = 1
            self.chat_list_arr.removeAll()
        }
        
        ChattingListApi.shared.chatList(page: page) { [unowned self] result in
            if result.code == "200" {
                self.chatList = result
                
                for addArray in 0 ..< (self.chatList?.results?.curr_total ?? 0)! {
                    if self.chatList?.results?.list_arr[addArray].user_id.count ?? 0 > 1 {
                        self.chat_list_arr.append((self.chatList?.results?.list_arr[addArray])!)
                    }
                }

                DispatchQueue.main.async {
                    let indexSet = IndexSet.init(integer: 1)
                    self.tableView.reloadSections(indexSet, with: .automatic)
                }
                Indicator.hideActivityIndicator(uiView: self.view)
            }
        } fail: { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인") {
            }
            Indicator.hideActivityIndicator(uiView: self.view)
        }
    }
    
    func convertHtmlToString(cell: ChattingTableViewCell, row: Int) {
        let msg = chat_list_arr[row].last_message ?? ""
        do {
            let doc:Document = try SwiftSoup.parse(msg)
            let body = doc.body()
            let bodyElements = try body?.select("body").select("span")
            let emoji = try bodyElements?.attr("class")
            let image = try bodyElements?.attr("style")
            
            if image?.contains("background-image:url") == true {
                let imageUrl = msg.components(separatedBy: "('").last?.components(separatedBy: "')").first ?? ""
                cell.messagePhoto.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "home_default_photo"))
                cell.messageLbl.text = try doc.text()
                cell.messagePhotoWidth.constant = 28
                cell.msgTrailingCons.constant = 10
            } else {
                if emoji?.isEmpty == false {
                    if !((emoji?.contains("."))!) {
                        self.emojiNumber = "\(emoji ?? "").png"
                    } else {
                        self.emojiNumber = emoji ?? ""
                    }
                    for i in emoticonView.items {
                        if i == emojiNumber {
                            cell.messagePhoto.image = UIImage(named: i)
                        }
                    }
                    cell.messageLbl.text = try doc.text()
                    cell.messagePhotoWidth.constant = 28
                    cell.msgTrailingCons.constant = 10
                } else {
                    cell.messageLbl.text = try doc.text()
                    cell.messagePhotoWidth.constant = 0
                    cell.msgTrailingCons.constant = 0
                }
            }
        } catch Exception.Error(type: let type, Message: let message) {
            print(type)
            print(message)
        } catch {
            print("\(error)")
        }
        
    }
    
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if self.chat_list_arr.count > 0 {
                return self.chat_list_arr.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingListAdminCell", for: indexPath) as! ChattingTableViewCell
            cell.adminPhoto.image = UIImage(named: "app_Icon2")
            cell.adminMessage.text = "평일 오전 9시 00분 ~ 오후 5시 00분"
            cell.adminName.text = "문의사항이 있으시면, 터치해주세요."
            
            cell.selectionStyle = .none
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingListMessageCell", for: indexPath) as! ChattingTableViewCell
            
            self.convertHtmlToString(cell: cell, row: row)
            
            if user_id != chat_list_arr[row].user_id[0] {
                checkId = 0
            } else {
                checkId = 1
            }
            
            let url = URL(string: "\(chat_list_arr[row].photo[checkId] )")
            cell.userPhoto.sd_setImage(with: url, placeholderImage: UIImage(named: "reply_user_default"))
            cell.userName.text = "\(chat_list_arr[row].user_name[checkId] )"
            cell.timeLbl.text = "\(chat_list_arr[row].time ?? "")"
            
            if chat_list_arr[row].unread ?? 0 > 0 {
                cell.messageCount.isHidden = false
                cell.messageCount.setTitle("\(chat_list_arr[row].unread ?? 0)", for: .normal)
            } else {
                cell.messageCount.isHidden = true
            }
            
            if chat_list_arr[row].login[checkId] == true {
                cell.userOnlineBadge.isHidden = false
            } else {
                cell.userOnlineBadge.isHidden = true
            }
            
            
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingListAdminCell", for: indexPath) as! ChattingTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let newViewController = chattingStoryboard.instantiateViewController(withIdentifier: "ChattingFriendViewController") as! ChattingFriendViewController
        
        if indexPath.section == 0 {
            newViewController.chat_id = chatList?.results?.support_mcChat_id ?? 0
        } else if indexPath.section == 1 {
            let chatId = chat_list_arr[row].chatId ?? 0

            var id = 0
            if user_id != chat_list_arr[row].user_id[0] {
                id = 0
            } else {
                id = 1
            }
            let notMyId = chat_list_arr[row].user_id[id]
            
            newViewController.notMyId = notMyId
            newViewController.chat_id = chatId
        }
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row

        DispatchQueue.main.async {
            if section == 1 {
                if row == self.chat_list_arr.count-1 {
                    if self.page < self.chatList?.results?.page_total ?? 0 {
//                        Indicator.showActivityIndicator(uiView: self.view)
                        self.isFirstEntry = false
                        self.page = self.page + 1
                        self.chatDetailList()
                    }
                }
            }
        }
    }
}
