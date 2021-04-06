//
//  ChattingPageSideMenuView.swift
//  modooClass
//
//  Created by iOS|Dev on 2021/02/13.
//  Copyright © 2021 신민수. All rights reserved.
//

import UIKit

class ChattingPageSideMenuView: UIView {

    @IBOutlet weak var user1Lbl: UIFixedLabel!
    @IBOutlet weak var user1ImgView: UIImageView!
    
    @IBOutlet weak var user2Lbl: UIFixedLabel!
    @IBOutlet weak var user2ImgView: UIImageView!
    
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var chatExitBtn: UIButton!
    
    var profileBtnClick: (()->Void)?
    var switchBtnClick: (()->Void)?
    var leaveChatBtnClick: (()->Void)?
    var menuExitBtnClick: (()->Void)?
    
    
    init() {
        super.init(frame: .zero)

        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    
    
    func initialize() {
        
        let view = Bundle.main.loadNibNamed("ChattingPageSideMenuView", owner: self, options: nil)?.first as! UIView
//        let name = String(describing: type(of: self))
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: name, bundle: bundle)
//        nib.instantiate(withOwner: self, options: nil)

//        self.roundedView(usingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 12, height: 12))
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

        switchBtn.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        switchBtn.onTintColor = UIColor(hexString: "#FF5A5F")
    }
    
    @IBAction func prifileBtnClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sideMenuProfileTag"), object: sender.tag)
        profileBtnClick?()
    }
    
    @IBAction func switchBtnClicked(_ sender: UISwitch) {
        switchBtnClick?()
    }
    
    @IBAction func leaveChatBtnClicked(_ sender: UIButton) {
        leaveChatBtnClick?()
    }
    
    @IBAction func menuExitBtnClicked(_ sender: UIButton) {
        menuExitBtnClick?()
    }
    
}
