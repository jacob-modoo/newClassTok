//
//  AlertManager.swift
//  modooClass
//
//  Created by 조현민 on 08/03/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
class Alert: NSObject {
    static let storyboard = UIStoryboard.init(name: "Alert", bundle: nil)
    
    override init() {
        super.init()
    }
    
    static func WithToolTip(_ viewController:UIViewController) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithToolTipView.rawValue) as! AlertViewController
        
        alert.alertType = .WithToolTipView
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    
    static func WithToolTipInfo(_ viewController:UIViewController) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithToolTipInfoView.rawValue) as! AlertViewController
        
        alert.alertType = .WithToolTipInfoView
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    
    // Alert With Title
    // AlertT
    static func With(_ viewController:UIViewController , title:String) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithTitle.rawValue) as! AlertViewController
        alert.alertTitle = title
        
        alert.alertType = .WithTitle
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    // Alert With Title, Content
    // AlertTC
    static func With(_ viewController:UIViewController , title:String, content:String) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithTitleContent.rawValue) as! AlertViewController
        alert.alertTitle = title
        alert.alertContent = content
        
        alert.alertType = .WithTitleContent
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    // Alert With Title, Btn1
    // AlertTB1
    static func With(_ viewController:UIViewController , title:String, btn1Title:String, btn1Handler: @escaping () -> Void) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithTitleBtn1.rawValue) as! AlertViewController
        alert.alertTitle = title
        alert.btn1Title = btn1Title
        alert.btn1Click = btn1Handler
        
        alert.alertType = .WithTitleBtn1
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    // Alert With Title, Content, Btn1
    // AlertTCB1
    static func With(_ viewController:UIViewController , title:String, content:String, btn1Title:String, btn1Handler: @escaping () -> Void) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithTitleContentBtn1.rawValue) as! AlertViewController
        alert.alertTitle = title
        alert.alertContent = content
        alert.btn1Title = btn1Title
        alert.btn1Click = btn1Handler
        
        alert.alertType = .WithTitleContentBtn1
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    // Alert With Title, Content, Btn1, Btn2
    
    // Alert With Title, Content, Btn1, Image1
    static func With(_ viewController:UIViewController , title:String, content:String,imageType:String, btn1Title:String, btn1Handler: @escaping () -> Void) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithBtn1Image.rawValue) as! AlertViewController
        alert.alertTitle = title
        alert.alertContent = content
        alert.btn1Title = btn1Title
        alert.btn1Click = btn1Handler
        alert.imageType = imageType
        
        alert.alertType = .WithBtn1Image
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    // Alert With Title, Content, Btn1, Image1
    
    
    // AlertTCB1B2
    static func With(_ viewController:UIViewController , title:String, content:String, btn1Title:String, btn1Handler: @escaping () -> Void, btn2Title:String, btn2Handler: @escaping () -> Void) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithTitleContentBtn1Btn2.rawValue) as! AlertViewController
        alert.alertTitle = title
        alert.alertContent = content
        alert.btn1Title = btn1Title
        alert.btn2Title = btn2Title
        alert.btn1Click = btn1Handler
        alert.btn2Click = btn2Handler
        
        alert.alertType = .WithTitleContentBtn1Btn2
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    // Alert With Title, Content, Cancel, submit, TextField
    
    // Alert With Title, Content, Cancel, submit, TextField
    
    static func With(_ viewController:UIViewController,btn1Title:String, btn1Handler: @escaping () -> Void, btn2Title:String, btn2Handler: @escaping () -> Void) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithBtn1Btn2.rawValue) as! AlertViewController
        
        alert.alertType = .WithBtn1Btn2
        
        alert.btn1Title = btn1Title
        alert.btn2Title = btn2Title
        alert.btn1Click = btn1Handler
        alert.btn2Click = btn2Handler
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    
    static func WithReview(_ viewController:UIViewController,btn1Title:String, btn1Handler: @escaping () -> Void, btn2Title:String, btn2Handler: @escaping () -> Void) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithReview.rawValue) as! AlertViewController
        
        alert.alertType = .WithReview
        
        alert.btn1Title = btn1Title
        alert.btn2Title = btn2Title
        alert.btn1Click = btn1Handler
        alert.btn2Click = btn2Handler
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    
    static func With(_ viewController:UIViewController,btn1Title:String, btn1Handler: @escaping () -> Void) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithBtn1.rawValue) as! AlertViewController
        
        alert.alertType = .WithBtn1
        
        alert.btn1Title = btn1Title
        alert.btn1Click = btn1Handler
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    
    static func With(_ viewController:UIViewController,btn1Title:String, btn1Handler: @escaping () -> Void, btn2Title:String, btn2Handler: @escaping () -> Void ,btn3Title:String, btn3Handler: @escaping () -> Void) {
        
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithBtn1Btn2Btn3.rawValue) as! AlertViewController
        
        alert.alertType = .WithBtn1Btn2Btn3
        
        alert.btn1Title = btn1Title
        alert.btn2Title = btn2Title
        alert.btn3Title = btn3Title
        alert.btn1Click = btn1Handler
        alert.btn2Click = btn2Handler
        alert.btn3Click = btn3Handler
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    
    static func WithReply(_ viewController:UIViewController,btn1Title:String, btn1Handler: @escaping () -> Void, btn2Title:String, btn2Handler: @escaping () -> Void) {
        
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithReply.rawValue) as! AlertViewController
        
        alert.alertType = .WithReply
        
        alert.btn1Title = btn1Title
        alert.btn2Title = btn2Title
        alert.btn1Click = btn1Handler
        alert.btn2Click = btn2Handler
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    
    static func WithImageView(_ viewController:UIViewController , image:UIImage, btn1Title:String, btn1Handler: @escaping () -> Void) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithImageView.rawValue) as! AlertViewController
        alert.btn1Title = btn1Title
        alert.btn1Click = btn1Handler
        alert.missionImage = image
        alert.alertType = .WithImageView
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    
    static func WithInfoWriteStart(_ viewController:UIViewController,btn1Title:String, btn1Handler: @escaping () -> Void) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithInfoWirteStart.rawValue) as! AlertViewController
        
        alert.alertType = .WithInfoWirteStart
        
        alert.btn1Title = btn1Title
        alert.btn1Click = btn1Handler
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    
    static func WithInterestCheck(_ viewController:UIViewController,btn1Title:String, btn1Handler: @escaping () -> Void) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithInterestCheck.rawValue) as! AlertViewController
        
        alert.alertType = .WithInterestCheck
        
        alert.btn1Title = btn1Title
        alert.btn1Click = btn1Handler
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    
    static func UpdateAlert(_ viewController:UIViewController,updateBtnTitle:String, btn1Handler: @escaping () -> Void, updateBtnCancleTitle:String, btn2Handler: @escaping () -> Void ) {
        
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithUpdate.rawValue) as! AlertViewController
        
        alert.alertType = .WithUpdate
        
        alert.updateBtnTitle = updateBtnTitle
        alert.updateBtnCancleTitle = updateBtnCancleTitle
        alert.updateBtnClicked = btn1Handler
        alert.updateBtnCancle = btn2Handler
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    
    static func UpdateMustAlert(_ viewController:UIViewController,updateBtnTitle:String, btn1Handler: @escaping () -> Void, updateBtnCancleTitle:String, btn2Handler: @escaping () -> Void ) {
        
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithUpdateMust.rawValue) as! AlertViewController
        
        alert.alertType = .WithUpdateMust
        alert.updateMustBtnTitle = updateBtnTitle
        alert.updateMustBtnCancleTitle = updateBtnCancleTitle
        alert.updateMustBtnClicked = btn1Handler
        alert.updateMustBtnCancle = btn2Handler
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
    
    static func WithUnfriend(_ viewController:UIViewController, btn1Title:String, btn1Handler: @escaping () -> Void, btn2Title:String, btn2Handler: @escaping () -> Void) {
        let alert:AlertViewController = storyboard.instantiateViewController(withIdentifier: AlertType.WithUnfriend.rawValue) as! AlertViewController
        
        alert.alertType = .WithUnfriend
        alert.btn1Title = btn1Title
        alert.btn2Title = btn2Title
        alert.btn1Click = btn1Handler
        alert.btn2Click = btn2Handler
        
        alert.modalPresentationStyle = .overFullScreen
        
        viewController.present(alert, animated: false, completion: nil)
    }
}
