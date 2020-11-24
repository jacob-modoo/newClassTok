//
//  ChildDetailClassPopupVC.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/11/19.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

class ChildDetailClassPopupVC: UIViewController {
    
    @IBOutlet weak var dislikeBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CHildDetailClassPopupVC showed")
//        self.view.roundedView(usingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 12, height: 12))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    deinit {
        print("ChildDetailClassPopupVC dismiss")
    }
    
    
    @IBAction func exitBtnClicked(_ sender: UIButton) {
        let navigation = UINavigationController()
        navigation.dismissViewControllerToTop(viewController: self)
        print("exit button pressed")
    }
    
    @IBAction func dislikeBtnClicked(_ sender: UIButton) {
        print("dislike button pressed")
    }
    
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        print("like button pressed")
    }
    
    
}
