//
//  AlertViewController.swift
//  modooClass
//
//  Created by 조현민 on 08/03/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

enum AlertType:String {
    case WithTitleContentBtn1Btn2 = "Alert01"
    case WithTitle = "Alert02"
    case WithTitleContent = "Alert03"
    case WithTitleBtn1 = "Alert04"
    case WithTitleContentBtn1 = "Alert05"
    case WithBtn1Btn2 = "Alert06"
    case WithBtn1Btn2Btn3 = "Alert07"
    case WithUpdate = "Alert08"
    case WithUpdateMust = "Alert09"
    case WithBtn1 = "Alert10"
    case WithBtn1Image = "Alert11"
    case WithReview = "Alert12"
    case WithReply = "Alert13"
    case WithImageView = "Alert14"
    case WithToolTipView = "Alert15"
    case WithToolTipInfoView = "Alert16"
    case WithInfoWirteStart = "Alert17"
    case WithInterestCheck = "Alert18"
    case WithUnfriend = "AlertUnfriend"
}

class AlertViewController: UIViewController {
    
    var alertType:AlertType = .WithTitle
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet var Image1: UIImageView!
    
    @IBOutlet var missionScrollView: UIScrollView!
    @IBOutlet var missionImg: UIImageView!
    
    @IBOutlet weak var updateImg: UIImageView!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var updateCancleBtn: UIButton!
    @IBOutlet weak var updateMustBtn: UIButton!
    @IBOutlet weak var updateMustCancleBtn: UIButton!
    
    @IBOutlet weak var dissmissBtn: UIButton!
    
    var alertTitle = String()
    var alertContent = String()
    var imageType = String()
    var btn1Title = String()
    var btn2Title = String()
    var btn3Title = String()
    
    var btn1Click: (() -> Void)?
    var btn2Click: (() -> Void)?
    var btn3Click: (() -> Void)?
    
    var missionImage = UIImage()
    
    var updateBtnTitle = String()
    var updateBtnCancleTitle = String()
    var updateBtnClicked: (() -> Void)?
    var updateBtnCancle: (() -> Void)?
    
    var updateMustBtnTitle = String()
    var updateMustBtnCancleTitle = String()
    var updateMustBtnClicked: (() -> Void)?
    var updateMustBtnCancle: (() -> Void)?
    
    let dismissTime:TimeInterval = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.alertType {
        case .WithTitle:
            self.setTitle()
            break
        case .WithTitleContent:
            self.setTitleContent()
            break
        case .WithTitleBtn1:
            self.setTitleBtn1()
            break
        case .WithTitleContentBtn1:
            self.setTitleContentBtn1()
            break
        case .WithTitleContentBtn1Btn2:
            self.setTitleContentBtn1Btn2()
            break
        case .WithBtn1Btn2:
            self.setBtnBtn2()
            break
        case .WithBtn1Btn2Btn3:
            self.setBtnBtn2Btn3()
            break
        case .WithUpdate:
            self.setUpdate()
            break
        case .WithUpdateMust:
            self.setUpdateMust()
            break
        case .WithBtn1:
            self.setBtn1()
            break
        case .WithBtn1Image:
            self.setBtn1Image()
            break
        case .WithReview:
            self.setBtnBtn2()
            break
        case .WithReply:
            self.setBtnBtn2()
            break
        case .WithImageView:
            self.imageViewBtn()
            break
        case .WithToolTipView:
            self.toolTipExitBtn()
            break
        case .WithToolTipInfoView:
            self.toolTipInfoExitBtn()
            break
        case .WithInfoWirteStart:
            self.infoWriteStart()
            break
        case .WithInterestCheck:
            self.interestCheck()
            break
        case .WithUnfriend:
            self.setBtnBtn2()
        }
        view.layoutIfNeeded()
    }
    
    func infoWriteStart(){
        
    }
    
    func interestCheck(){
        
    }
    
    func setBtn1(){
        self.btn1.setTitle(btn1Title, for: .normal)
    }
    
    func setBtn1Image(){
        self.titleLbl.text = alertTitle
        self.contentLbl.text = alertContent
        self.btn1.setTitle(btn1Title, for: .normal)
        if self.imageType == "stamp"{
            self.Image1.image = UIImage(named: "stamp_alert")
        }else{
            self.Image1.image = UIImage(named: "stamp_alert")
        }
    }
    
    func toolTipExitBtn(){
        
    }
    
    func toolTipInfoExitBtn(){
        
    }
    
    // Alert With Title
    func setTitle() {
        self.titleLbl.text = alertTitle
        
        Timer.scheduledTimer(timeInterval: self.dismissTime, target: self,   selector: (#selector(self.viewDismiss)), userInfo: nil, repeats: false)
    }
    // Alert With Title, Content
    func setTitleContent() {
        self.titleLbl.text = alertTitle
        self.contentLbl.text = alertContent
        
        Timer.scheduledTimer(timeInterval: self.dismissTime, target: self,   selector: (#selector(self.viewDismiss)), userInfo: nil, repeats: false)
    }
    // Alert With Title, Btn1
    func setTitleBtn1() {
        self.titleLbl.text = alertTitle
        self.btn1.setTitle(btn1Title, for: .normal)
    }
    // Alert With Title, Content, Btn1
    func setTitleContentBtn1() {
        self.titleLbl.text = alertTitle
        self.contentLbl.text = alertContent
        self.btn1.setTitle(btn1Title, for: .normal)
    }
    // Alert With Title, Content, Btn1, Btn2
    func setTitleContentBtn1Btn2() {
        self.titleLbl.text = alertTitle
        self.contentLbl.text = alertContent
        self.btn1.setTitle(btn1Title, for: .normal)
        self.btn2.setTitle(btn2Title, for: .normal)
    }
    
    func setBtnBtn2(){
        self.btn1.setTitle(btn1Title, for: .normal)
        self.btn2.setTitle(btn2Title, for: .normal)
    }
    
    func setBtnBtn2Btn3(){
        self.btn1.setTitle(btn1Title, for: .normal)
        self.btn2.setTitle(btn2Title, for: .normal)
        self.btn3.setTitle(btn3Title, for: .normal)
    }
    
    func imageViewBtn(){
        self.missionImg.image = missionImage
        self.btn1.setTitle(btn1Title, for: .normal)
    }
    
    func setUpdate(){
        self.updateBtn.setTitle(updateBtnTitle, for: .normal)
        self.updateCancleBtn.setTitle(updateBtnCancleTitle, for: .normal)
        self.updateImg.layer.cornerRadius = 10
        self.updateImg.layer.masksToBounds = true
    }
    
    func setUpdateMust(){
        self.updateMustBtn.setTitle(updateMustBtnTitle, for: .normal)
        self.updateMustCancleBtn.setTitle(updateMustBtnCancleTitle, for: .normal)
        self.updateImg.layer.cornerRadius = 10
        self.updateImg.layer.masksToBounds = true
    }
    
    @objc func viewDismiss() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btn1Clicked(_ sender: Any) {
        if self.btn1Click != nil {
            self.btn1Click!()
        }
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btn2Clicked(_ sender: Any) {
        if self.btn2Click != nil {
            self.btn2Click!()
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btn3Clicked(_ sender: Any) {
        if self.btn3Click != nil {
            self.btn3Click!()
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func dissmissBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func updateBtnClicked(_ sender: UIButton) {
        if self.updateBtnClicked != nil {
            self.updateBtnClicked!()
        }
    }
    
    @IBAction func updateBtnCancle(_ sender: UIButton) {
        if self.updateBtnCancle != nil {
            self.updateBtnCancle!()
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func updateMustBtnClicked(_ sender: UIButton) {
        if self.updateMustBtnClicked != nil {
            self.updateMustBtnClicked!()
        }
    }
    @IBAction func updateMustCancle(_ sender: UIButton) {
        if self.updateMustBtnCancle != nil {
            self.updateMustBtnCancle!()
        }
    }
}


extension AlertViewController:UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.missionImg
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let subView = scrollView.subviews[0] // get the image view
        let offsetX = max((scrollView.bounds.size.width-scrollView.contentSize.width)*0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height-scrollView.contentSize.height)*0.5, 0.0)
        // adjust the center of image view
        subView.center = CGPoint(x: scrollView.contentSize.width*0.5+offsetX, y: scrollView.contentSize.height*0.5+offsetY)
    }
}
