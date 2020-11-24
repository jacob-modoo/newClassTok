//
//  CustomPresentationViewController.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/11/22.
//  Copyright © 2020 신민수. All rights reserved.
//

import Foundation
import UIKit

class CustomPresentationViewController: UIPresentationController {
    
    var blurEffect = UIVisualEffectView()
    var swipeGesture = UISwipeGestureRecognizer()
    var tapGesture = UITapGestureRecognizer()
    
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let background = UIBlurEffect(style: .dark)
        
        blurEffect = UIVisualEffectView(effect: background)
        
        swipeGesture.direction = .up
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissViewController(_:)))
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController(_:)))
        blurEffect.addGestureRecognizer(tapGesture)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height/2), size: CGSize(width: self.containerView!.frame.width, height: 200))
        
    }
    
    override func presentationTransitionWillBegin() {
        self.blurEffect.alpha = 0
        self.containerView?.addSubview(blurEffect)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.blurEffect.alpha = 0.5
        }, completion: { (completion) in
            print("completed transitioning")
        })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.blurEffect.alpha = 0
            
        }, completion: { (completion) in
            self.blurEffect.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.roundedView(usingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 12, height: 12))
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffect.frame = containerView!.bounds
    }
    
    @objc func dismissViewController(_ swipeGesture: UISwipeGestureRecognizer){
//        dismiss the view controller
        self.presentedViewController.navigationController?.dismissViewControllerToTop(viewController: presentedViewController)
    }
    
}

