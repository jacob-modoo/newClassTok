//
//  Toast.swift
//  modooClass
//
//  Created by 조현민 on 13/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class Toast {
    
    static func showFriend(message: String , controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor(hexString: "#4D4B57")
        toastContainer.alpha = 0.8
        toastContainer.layer.cornerRadius = 5
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        let attributedString = NSMutableAttributedString(string: message)
        print("message : ",message)

        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#FFB5B7"), range: (message as NSString).range(of:"함께해요"))

        toastLabel.attributedText = attributedString

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 16)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -16)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -16)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 16)
        toastContainer.addConstraints([a1, a2, a3, a4])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 16)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -16)
//        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)

        let xConstraint = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: controller.view, attribute: .centerX, multiplier: 1, constant: 0)
        let superBottom = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -30)
            controller.view.addConstraints([c1, c2, xConstraint,superBottom])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 0.8
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }

    static func show(message: String ,point:Int , controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor(hexString: "#4D4B57")
        toastContainer.alpha = 0.8
        toastContainer.layer.cornerRadius = 5
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)! //.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        let attributedString = NSMutableAttributedString(string: message)
        print("message : ",message)

        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#14d2b8"), range: (message as NSString).range(of:"\(point)원"))

        toastLabel.attributedText = attributedString

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 16)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -16)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -16)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 16)
        toastContainer.addConstraints([a1, a2, a3, a4])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 16)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -16)
//        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)

        let xConstraint = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: controller.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: toastContainer, attribute: .centerY, relatedBy: .equal, toItem: controller.view, attribute: .centerY, multiplier: 1, constant: 0)
        controller.view.addConstraints([c1, c2, xConstraint,yConstraint])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 0.8
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }

    static func showNotification(message: String , controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor(hexString: "#4D4B57")
        toastContainer.alpha = 0.8
        toastContainer.layer.cornerRadius = 5
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)! //.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        let attributedString = NSMutableAttributedString(string: message)

//        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#7461f2"), range: (message as NSString).range(of:"\(point)원"))

        toastLabel.attributedText = attributedString

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 16)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -16)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -16)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 16)
        toastContainer.addConstraints([a1, a2, a3, a4])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 16)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -16)
        //        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)

        let xConstraint = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: controller.view, attribute: .centerX, multiplier: 1, constant: 0)
        var yConstraint = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: controller.view, attribute: .top, multiplier: 1, constant: 0)
        if AppDelegate().deviceType() == 10 {
            if deviceOrient == "Portrait"{
                yConstraint = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: controller.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
            }else{
                yConstraint = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: controller.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
            }

        }else{
            if deviceOrient == "Portrait"{
                yConstraint = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: controller.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
            }else{
                yConstraint = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: controller.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
            }

        }

        controller.view.addConstraints([c1, c2, xConstraint,yConstraint])
//        controller.view.addConstraints([c1, c2, c3,xConstraint,heightConstraint])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 0.8
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
    static func showFavorite(message: String , controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor(hexString: "#FFE3E4")
        toastContainer.alpha = 0.9
        toastContainer.layer.cornerRadius = 5
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor(hexString: "#FF5A5F")
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        let attributedString = NSMutableAttributedString(string: message)
        print("message : ",message)

//        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#FFB5B7"), range: (message as NSString).range(of:"함께해요"))

        toastLabel.attributedText = attributedString

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 16)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -16)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -24)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 24)
        toastContainer.addConstraints([a1, a2, a3, a4])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 16)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -16)
//        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)

        let xConstraint = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: controller.view, attribute: .centerX, multiplier: 1, constant: 0)
        let superBottom = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -50)
            controller.view.addConstraints([c1, c2, xConstraint,superBottom])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 0.9
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }

    static func showButtonNotification(message: String , chat_id:Int , controller: UIViewController) {

        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor(hexString: "#4D4B57")
        toastContainer.alpha = 0.8
        toastContainer.layer.cornerRadius = 5
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        let attributedString = NSMutableAttributedString(string: message)

        let toastButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        toastButton.setTitleColor(UIColor(hexString: "#14d2b8"), for: .normal)
        toastButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        toastButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        toastButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        toastButton.setTitle("확인", for: .normal)
//        toastButton.addTarget(self, action: Selector(("buttonTapped:")), for: .touchUpInside)//.touchUpInside)//#selector(buttonTapped(sender:)), for: .touchUpInside) Selector(("buttonTapped:"))
//        toastButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
//        toastButton.addTarget(self, action:#selector(buttonTapped), for: UIControl.Event.touchUpInside)//.touchUpInside)
        toastButton.addTarget(self, action: #selector(Toast.buttonTapped(sender:)), for: .touchUpInside)
//        toastButton.addAction(for: .touchUpInside, { [unowned self] in
//
//        })
        toastButton.accessibilityHint = "\(chat_id)"

        toastLabel.attributedText = attributedString

        toastContainer.addSubview(toastLabel)
        toastContainer.addSubview(toastButton)
        controller.view.addSubview(toastContainer)

        toastButton.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 16)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastButton, attribute: .leading, multiplier: 1, constant: -16)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -16)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 16)

        let b1 = NSLayoutConstraint(item: toastButton, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -16)
        let b2 = NSLayoutConstraint(item: toastButton, attribute: .centerY, relatedBy: .equal, toItem: toastContainer, attribute: .centerY, multiplier: 1, constant: 0)
//        let b3 = NSLayoutConstraint(item: toastButton, attribute: .leading, relatedBy: .equal, toItem: toastLabel, attribute: .trailing, multiplier: 1, constant: 0)
        let b3 = NSLayoutConstraint(item: toastButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 30)


        toastContainer.addConstraints([a1, a2, a3, a4, b1, b2 ,b3])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 16)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -16)

        let xConstraint = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: controller.view, attribute: .centerX, multiplier: 1, constant: 0)
        var yConstraint = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: controller.view, attribute: .top, multiplier: 1, constant: 0)
        if AppDelegate().deviceType() == 10 {
            if deviceOrient == "Portrait"{
                yConstraint = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: controller.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
            }else{
                yConstraint = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: controller.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
            }

        }else{
            if deviceOrient == "Portrait"{
                yConstraint = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: controller.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
            }else{
                yConstraint = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: controller.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
            }

        }

        controller.view.addConstraints([c1, c2, xConstraint,yConstraint])
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 0.8
        }, completion: { _ in
            
        })
        
        let time = DispatchTime.now() + .seconds(6)
        DispatchQueue.main.asyncAfter(deadline: time) {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        }
    }

    @objc static func buttonTapped(sender: UIButton){
        if APPDELEGATE?.topMostViewController()?.isKind(of: FeedDetailViewController.self) == true {
            let vc:FeedDetailViewController = APPDELEGATE?.topMostViewController() as! FeedDetailViewController
            vc.player?.pause()
        }
        
        if APPDELEGATE?.topMostViewController()?.isKind(of: ChattingFriendViewController.self) == true {
            let chatId = Int(sender.accessibilityHint!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chattingViewReload"), object: chatId)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabbarIndexChange"), object: 1)
            let time = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: time) {
                let storyboard: UIStoryboard = UIStoryboard(name: "Chatting", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "ChattingFriendViewController") as! ChattingFriendViewController
                newViewController.chat_id = Int(sender.accessibilityHint!)!
                APPDELEGATE?.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: false)
            }
        }
    }
    
}
