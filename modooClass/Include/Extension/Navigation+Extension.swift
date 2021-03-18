//
//  File.swift
//  modooClass
//
//  Created by 조현민 on 17/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation



extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
    
    func popToViewBottomController(ofClass: AnyClass, animated: Bool = false) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromBottom
            self.navigationController?.view.layer.add(transition, forKey: nil)
            popToViewController(vc, animated: animated)
        }
    }
    
    func pushToViewBottomController(vc: UIViewController, animated: Bool = false) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController?.view.layer.add(transition, forKey: nil)
        pushViewController(vc, animated: animated)
    }
    
    func pushViewControllerFromTop(viewController vc: UIViewController) {
        vc.view.alpha = 0
//        vc.isModalInPresentation = true
        self.present(vc, animated: false) { () -> Void in
            vc.view.frame = CGRect(x: 0, y: -vc.view.frame.height, width: vc.view.frame.width, height: vc.view.frame.height)
            vc.view.alpha = 1
            UIView.animate(withDuration: 1, animations: { () -> Void in
                vc.view.frame = CGRect(x: 0, y: 0, width: vc.view.frame.width, height: vc.view.frame.height)
            }, completion: nil)
        }
    }

    func dismissViewControllerToTop(viewController: UIViewController) {
        print("navigation function")
        let vc = viewController
        UIView.animate(withDuration: 1, animations: { () -> Void in
            vc.view.frame = CGRect(x: 0, y: -vc.view.frame.height, width: vc.view.frame.width, height: vc.view.frame.height)
            print("animation")
        }, completion: { complete -> Void in
            if complete {
                print("completion")
                viewController.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func popOrPushController(class_id:Int){
        var popVC:FeedDetailViewController!
        for vc in self.viewControllers {
            if vc.isKind(of: FeedDetailViewController.self) {
                popVC = (vc as! FeedDetailViewController)
            }else{

            }
        }
        if popVC != nil {
            popVC.class_id = class_id
            popToViewController(popVC, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: "")
        }else {
            let storyboard = UIStoryboard.init(name: "Feed", bundle: nil)
            popVC = (storyboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController)
            popVC.class_id = class_id
            popVC.pushGubun = 1
            pushViewController(popVC, animated: true)
        }
    }
    
    func storyPopOrPushController(feedId:String){
        var popVC:StoryDetailViewController!
        for vc in self.viewControllers {
            if vc.isKind(of: StoryDetailViewController.self) {
                popVC = (vc as! StoryDetailViewController)
            }else{

            }
        }
        if popVC != nil {
            popVC.feedId = feedId
            popToViewController(popVC, animated: true)
//            popVC.feedDetailUpdatePost()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "feedDetailUpdatePost"), object: nil)
        }else {
            let storyboard = UIStoryboard.init(name: "Home2WebView", bundle: nil)
            popVC = (storyboard.instantiateViewController(withIdentifier: "StoryDetailViewController") as! StoryDetailViewController)
            popVC.feedId = feedId
            pushViewController(popVC, animated: true)
        }
    }
    
    func removePreviousController(total: Int){
        let totalViewControllers = self.viewControllers.count
        self.viewControllers.removeSubrange(totalViewControllers-total..<totalViewControllers - 1)
    }
}
