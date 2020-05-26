//
//  NetworkOut.swift
//  modooClass
//
//  Created by 조현민 on 01/07/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

class NetworkOutView: UIView {
    
    private let xibName = "NetworkOut"
    var submitClick: ((Int) -> Void)?
    var backClick: ((Int) -> Void)?
    @IBOutlet var networkRefreshBtn: UIButton!
    @IBOutlet var networkView: UIView!
    @IBOutlet var backBtn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    deinit {
        print("networkView deinit")
    }
    
    static func initWithNib(frame:CGRect) -> NetworkOutView{
        let xibName = "NetworkOut"
        let view:NetworkOutView = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! NetworkOutView
        view.frame = frame
        view.isHidden = true
        return view
    }
    @IBAction func networkRefreshBtnClicked(_ sender: Any) {
        if self.submitClick != nil {
            self.submitClick!(1)
        }
        self.dismissNetworkView()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        if self.backClick != nil {
            self.backClick!(1)
        }
        self.dismissNetworkView()
    }
    
    
    func dismissNetworkView() {
        UIView.animate(withDuration: 0.3, animations: {
//            self.networkView.frame.origin.y += self.networkView.frame.height
        }) { success in
            self.isHidden = true
        }
    }
    func showNetworkView() {
        self.isHidden = false
        if APPDELEGATE?.topMostViewController()?.isKind(of: HomeMainViewController.self) == true {
            backBtn.isHidden = true
        }
        UIView.animate(withDuration: 0.3, animations: {
//            self.networkView.frame.origin.y -= self.networkView.frame.height
        }) { success in
            
        }
    }
    
    func submitBtnClicked(btn1Handler: @escaping (Int) -> Void) {
        self.submitClick = btn1Handler
    }
    
    func backBtnClicked(btn1Handler: @escaping (Int) -> Void) {
        self.backClick = btn1Handler
    }
    
}
