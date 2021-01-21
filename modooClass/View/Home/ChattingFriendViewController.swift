//
//  ChattingFriendViewController.swift
//  modooClass
//
//  Created by iOS|Dev on 2021/01/05.
//  Copyright © 2021 신민수. All rights reserved.
//

import Foundation
import UIKit

class ChattingFriendViewController: UIViewController {
    
    @IBOutlet weak var talbleView: UITableView!
    @IBOutlet weak var reply_image_add: UIButton!
    @IBOutlet weak var reply_emoticon: UIButton!
    @IBOutlet weak var reply_sendBtn: UIButton!
    @IBOutlet weak var reply_border_view: UIView!
    @IBOutlet weak var reply_textView: UITextView!
    @IBOutlet weak var profileTitle: UIFixedLabel!
    @IBOutlet weak var emoticonImg: UIImageView!
    @IBOutlet weak var emoticonView: UIView!
    
    
    let chattingStoryboard = UIStoryboard(name: "ChattingFriendViewController", bundle: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reply_border_view.layer.borderWidth = 1
        reply_border_view.layer.borderColor = UIColor(hexString: "#eeeeee").cgColor
        reply_border_view.layer.cornerRadius  = 15
        
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
    }
    
    
    @IBAction func moreBtnClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func addImageBtnClicked(_ sender: UIButton) {
    }
    
    @IBAction func emoticonAddBtnClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func replySendBtnClicked(_ sender: UIButton) {
    }
    
    @IBAction func emoticonExitBtnClicked(_ sender: UIButton) {
    }
    
    
    
}

extension ChattingFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingFriendVCCell", for: indexPath) as! ChattingFriendViewControllerCell
        
        return cell
    }
    
    
    
    
    
}
