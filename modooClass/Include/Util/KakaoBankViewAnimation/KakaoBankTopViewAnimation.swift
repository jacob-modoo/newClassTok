//
//  kakaoBankTopViewAnimation.swift
//  NavigationCustomBar
//
//  Created by 조현민 on 21/10/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
import UIKit
@objc public protocol KakaoBankViewAnimation {
    func edit(made: Bool)
}

extension KakaoBankViewAnimation where Self: UIViewController {
    func edit(made: Bool) {
        
    }
}

open class KakaoBankViewAnimationController: UIViewController, UIScrollViewDelegate{
    @IBOutlet var titleView: UIView!
    @IBOutlet var titleViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet var topCalculateView: UIView!
    @IBOutlet var bottomCalculateView: UIView!
    @IBOutlet var bottomCalculateViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet var logo: UIImageView!
    @IBOutlet var logoConst: NSLayoutConstraint!
    
    @IBOutlet var buttonView: UIView!
    @IBOutlet var buttonViewTrailingConst: NSLayoutConstraint!
    
    @IBOutlet var scaleImg: UIImageView!
    @IBOutlet var scaleImgHeightConst: NSLayoutConstraint!
    @IBOutlet var scaleImgYConst: NSLayoutConstraint!
    
    
    @IBOutlet var userLabel: UILabel!
    
    var titleViewHeight:CGFloat = 0.0
    var topCalculateViewHeight:CGFloat = 0.0
    var bottomCalculateViewHeight:CGFloat = 0.0
    var scaleImgHeight:CGFloat = 0.0
    
    open override func viewDidLoad(){
        super.viewDidLoad()
        titleViewHeight = titleView.frame.height
        topCalculateViewHeight = topCalculateView.frame.height
        bottomCalculateViewHeight = bottomCalculateView.frame.height
        scaleImgHeight = scaleImg.frame.height
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y / titleViewHeight //default offset
        var titleViewOffsetHeight =  (titleViewHeight - topCalculateViewHeight) * offset
        let scaleImgOffsetHeight = scaleImgHeight - ((scaleImgHeight / 2) * offset)
        let scaleImgOffsetY = 0 - (22 * offset)
        let buttonViewOffsetTrailing = 16 + (42 * offset)
        
        if offset > 1 {
            offset = 1
            titleViewOffsetHeight =  titleView.frame.width * titleViewOffsetHeight
            titleViewHeightConst.constant = topCalculateViewHeight
            logoConst.constant = 0
            logo.alpha = 1
            userLabel.alpha = 1 - offset
            buttonViewTrailingConst.constant = 58
            scaleImgHeightConst.constant = 30
            scaleImgYConst.constant = -22
        }else{
            titleViewHeightConst.constant = titleViewHeight - titleViewOffsetHeight
            logoConst.constant = -90 + titleViewOffsetHeight
            logo.alpha = offset
            userLabel.alpha = 1 - offset
            scaleImgHeightConst.constant = scaleImgOffsetHeight
            scaleImgYConst.constant = scaleImgOffsetY
            buttonViewTrailingConst.constant = buttonViewOffsetTrailing
        }
    }
}

//class kakaoBankTopViewAniamtion : UIView{
//    var titleView:UIView = UIView.init(frame: CGRect.zero)
//    var topCalculateView:UIView = UIView.init(frame: CGRect.zero)
//    var bottomCalculateView:UIView = UIView.init(frame: CGRect.zero)
//    var buttonView:UIView = UIView.init(frame: CGRect.zero)
//
//    var titleViewHeight:CGFloat = 0.0
//    var topCalculateViewHeight:CGFloat = 0.0
//    var bottomCalculateViewHeight:CGFloat = 0.0
//    var scaleImgHeight:CGFloat = 0.0
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        translatesAutoresizingMaskIntoConstraints = false
//
//        //탑+바텀뷰를 가지고 있는 타이틀 뷰
//        addSubview(titleView)
//        titleView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        titleView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        titleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        titleView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//
//        topCalculateView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height/3)
//        bottomCalculateView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: (titleView.frame.height/3)*2)
//
//        //네비바처럼 사용하는 탑뷰
//        titleView.addSubview(topCalculateView)
//        topCalculateView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
//        topCalculateView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor).isActive = true
//        topCalculateView.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
//        topCalculateView.bottomAnchor.constraint(equalTo: bottomCalculateView.topAnchor).isActive = true
//
//        //줄이들고 늘어나는 바텀 뷰
//        titleView.addSubview(bottomCalculateView)
//        bottomCalculateView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
//        bottomCalculateView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor).isActive = true
//        bottomCalculateView.topAnchor.constraint(equalTo: topCalculateView.bottomAnchor).isActive = true
//        bottomCalculateView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
//        titleView.addSubview(buttonView)
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//}
