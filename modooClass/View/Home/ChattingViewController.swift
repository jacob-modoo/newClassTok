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

class ChattingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var chatList:ChatListModel?
    var chat_list_arr:Array = Array<Chat_list>()
    var page = 1
    var messageType = ""
    var emojiNumber = ""
    lazy var emoticonView = EmoticonView()
    var checkId = 0
    
    let user_id = UserManager.shared.userInfo.results?.user?.id ?? 0
    let chattingStoryboard = UIStoryboard(name: "Chatting", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(refreshControl!)
        reloadView()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        print("ChattingViewController deinit")
    }
    
    
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func reloadView() {
        ChattingListApi.shared.chatList(page: page) { result in
            if result.code == "200" {
                self.chatList = result
                self.chatDetailList()
                self.tableView.reloadData()
            }
        } fail: { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인") {
            }
        }
    }
    
    func chatDetailList() {
        ChattingListApi.shared.chatList(page: page) { [unowned self] result in
            if result.code == "200" {
//                self.chatList =  result
                for addArray in 0 ..< (self.chatList?.results?.curr_total ?? 0)! {
                    if chatList?.results?.list_arr[addArray].user_id.count ?? 0 > 1 {
                        self.chat_list_arr.append((self.chatList?.results?.list_arr[addArray])!)
                    }
                }
                
                self.tableView.reloadData()
                Indicator.hideActivityIndicator(uiView: self.view)
            }
        } fail: { error in
            Indicator.hideActivityIndicator(uiView: self.view)
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인") {
            }
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
                cell.messagePhoto.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "reply_user_default"))
                cell.messageLbl.text = try doc.text()
                cell.messagePhotoWidth.constant = 28
                cell.msgTrailingCons.constant = 10
            } else {
                if emoji?.isEmpty == false {
                    self.emojiNumber = "\(emoji ?? "").png"
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
        if chat_list_arr.count > 0 {
            if section == 0 {
                return 1
            } else {
                return self.chat_list_arr.count
            }
        } else {
            if section == 0 {
                return 1
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
            cell.adminMessage.text = "평일 오잔 8시 00분 ~ 오후 5시 00분"
            cell.adminName.text = "문의사항 있으시면 대화 남겨주세요."
            
            cell.selectionStyle = .none
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingListMessageCell", for: indexPath) as! ChattingTableViewCell
            
            convertHtmlToString(cell: cell, row: row)
            
            if user_id != chat_list_arr[row].user_id[0] {
                checkId = 0
            } else {
                checkId = 1
            }
            
            let url = URL(string: "\(chat_list_arr[row].photo[checkId] )")
            cell.userPhoto.sd_setImage(with: url, placeholderImage: UIImage(named: "reply_user_default"))
            cell.userName.text = "\(chat_list_arr[row].user_name[checkId] )"
            cell.timeLbl.text = "\(chat_list_arr[row].time ?? "")"
            
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
        newViewController.chat_id = chat_list_arr[row].chatId ?? 0
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row

        DispatchQueue.main.async {
            if section == 1 {
                if row == self.chat_list_arr.count-1 {
                    if self.page < self.chatList?.results?.page_total ?? 0 {
                        Indicator.showActivityIndicator(uiView: self.view)
                        self.page = self.page + 1
                        self.chatDetailList()
                    }
                }
            }
        }
    }
}
