//
//  ChildDetailClassPopupVC.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/11/04.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

@IBDesignable class ChildDetailClassPopupView : UIView {
    
//    @IBOutlet var containerView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var dislikeBtn: UIButton!
    
    var popupLikeBtnClick : (() -> Void)?
    var popupDislikeBtnClick : (() -> Void)?
    var popupExitBtnClick : (() -> Void)?
    
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
        let view = Bundle.main.loadNibNamed("ChildDetailClassVCPopup", owner: self, options: nil)?.first as! UIView
//        let name = String(describing: type(of: self))
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: name, bundle: bundle)
//        nib.instantiate(withOwner: self, options: nil)

        self.roundedView(usingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 12, height: 12))
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])

    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hidePopupView))
//        view.addGestureRecognizer(swipeGesture)
//    }
    
    
    
    @IBAction func popupLikeBtnClicked(_ sender: UIButton) {
        print("popup like btn is clicked")
        popupLikeBtnClick?()
        
    }
    
    @IBAction func popupDislikeBtnClicked(_ sender: UIButton) {
        
        print("popup dislike btn is clicked")
        popupDislikeBtnClick?()
    }
    
    @IBAction func popupExitBtnClicked(_ sender: UIButton) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closePopupView"), object: nil)
        print("popup exit btn is clicked")
        popupExitBtnClick?()
    }
    
//    @objc func swipeGesureRec(sender : UISwipeGestureRecognizer) {
//        self.navigationController?.dismiss(animated: true, completion: nil)
//        print("swiped up")
//    }
    
}
