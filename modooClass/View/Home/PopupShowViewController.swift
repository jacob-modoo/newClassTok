//
//  PopupShowViewController.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/05/22.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

class PopupShowViewController: UIViewController {

    @IBOutlet weak var popupImg: UIImageView!
    @IBOutlet weak var linkBtn: UIFixedButton!
    @IBOutlet weak var openLaterBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    
    var openLater = false
    
    let homeViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    let childWebViewStoryboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popupImg.sd_setImage(with: URL(string: "\(UserManager.shared.userInfo.results?.event_image ?? "")"))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
         navigationController?.setNavigationBarHidden(true, animated: animated)
       }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
      
    }
  
    deinit {
        
    }
    
    @IBAction func linkBtnClicked(_ sender: UIButton) {
        let url = UserManager.shared.userInfo.results?.event_link ?? ""
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = url
        
        self.navigationController?.pushViewController(newViewController, animated: true)
    
    }
   
    @IBAction func openLaterBtnClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
   
    }
  
    @IBAction func closeBtnClicked(_ sender: UIButton) {

        self.dismiss(animated: true, completion: nil)
    }
  
}
