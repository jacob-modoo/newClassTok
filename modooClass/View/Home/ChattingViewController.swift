//
//  ChattingViewController.swift
//  modooClass
//
//  Created by iOS|Dev on 2021/01/05.
//  Copyright © 2021 신민수. All rights reserved.
//

import Foundation
import UIKit

class ChattingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var chatList:ChatListModel?
    var chat_list_arr:Array? = Array<Chat_list>()
    var page = 1
    
    
    
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
                print("** caht list data: \(self.chatList?.results?.list_arr.count ?? 99)")
                for addArray in 0 ..< (self.chatList?.results?.list_arr.count ?? 0)! {
                    self.chat_list_arr?.append((self.chatList?.results?.list_arr[addArray])!)
                }
                self.tableView.reloadData()
            }
        } fail: { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인") {
        
            }
        }
    }
    
    func chatDetailList(page:Int) {
        ChattingListApi.shared.chatList(page: page) { [unowned self] result in
            if result.code == "200" {
                self.chatList =  result
                for addArray in 0 ..< (self.chatList?.results?.list_arr.count ?? 0)! {
                    self.chat_list_arr?.append((self.chatList?.results?.list_arr[addArray])!)
                }
                self.tableView.reloadData()
                Indicator.hideActivityIndicator(uiView: self.view)
            }
        } fail: { error in
            Indicator.hideActivityIndicator(uiView: self.view)
        }
    }
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if chatList != nil {
        print("** chat list is : \(self.chatList?.results?.list_arr.count ?? 9)")
            if section == 0 {
                return 1
            } else {
                return self.chatList?.results?.list_arr.count ?? 0
            }
//        } else {
//            print("** chat list is nil")
//            return 0
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            print("** section 0")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingListAdminCell", for: indexPath) as! ChattingTableViewCell
            cell.adminPhoto.image = UIImage(named: "app_Icon2")
            cell.adminMessage.text = "평일 오잔 8시 00분 ~ 오후 5시 00분"
            cell.adminName.text = "문의사항 있으시면 대화 남겨주세요."
            
            cell.selectionStyle = .none
            return cell
        case 1:
            print("** section 1")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingListMessageCell", for: indexPath) as! ChattingTableViewCell
            let url = URL(string: "\(chat_list_arr?[row].photo?[1] ?? "no value")")
            print("** photo url : \(String(describing: url))")
            cell.userPhoto.sd_setImage(with: url, placeholderImage: UIImage(named: "reply_user_default"))
            cell.userName.text = "\(chatList?.results?.list_arr[row].user_name?[1] ?? "")"
            
            cell.messageLbl.attributedText = "\(chatList?.results?.list_arr[row].last_message ?? "")".convertToAttributedFromHTML()
            cell.timeLbl.text = "\(chatList?.results?.list_arr[row].time ?? "")"
            
            cell.selectionStyle = .none
            return cell
        default:
            print("** default section")
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
//        bosganda keyingi pagega idong!
        print("the row is clicked!")
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let section = indexPath.section
////        let row = indexPath.row
//
//        DispatchQueue.main.async {
//            if section == 1 {
//                if self.chatList?.results?.list_arr.count ?? 0 < self.chatList?.results?.total ?? 0 {
////                    Indicator.showActivityIndicator(uiView: self.view)
////                    self.page += 1
////                    self.chatDetailList(page: self.page)
//                }
//            }
//        }
//    }
}
