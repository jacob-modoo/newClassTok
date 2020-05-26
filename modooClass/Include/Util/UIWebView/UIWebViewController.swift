//
//  UIWebViewController.swift
//  modooClass
//
//  Created by 조현민 on 26/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import Lottie
import WebKit
import JavaScriptCore

class UIWebViewController: UIViewController,UIWebViewDelegate {
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var lottiSubView: UIView!
    @IBOutlet var lottiView: UIView!
    var keyboardShow = false
    var url = ""
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        let animationView = AnimationView(name: "webViewLodingLottie")
        animationView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        animationView.center = self.view.center
        
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 0.5
        
        // Applying UIView animation
        let minimizeTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        animationView.transform = minimizeTransform
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            animationView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        lottiSubView.addSubview(animationView)
        
        animationView.play()
        
        let session:String = UserDefaultSetting.getUserDefaultsString(forKey: sessionToken) as! String
        
        let myURL = URL(string:"\(url)?token=\(session)")
        let request = URLRequest(url: myURL!)
        
        webView.loadRequest(request)
        lottiView.fadeOut(completion: {
            (finished: Bool) -> Void in
            animationView.stop()
            self.lottiView.removeFromSuperview()
            self.backBtn.isHidden = true
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let userAgent = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent")! + " Modooclass/Modooclass"
        UserDefaults.standard.register(defaults: ["UserAgent" : userAgent])
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        print("Strat Loading")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Finish Loading")
    }
    
    func webView(_ webView: UIWebView,
                 didFailLoadWithError error: Error){
        
    }
    
    func webView(_ webView: UIWebView,
                 shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebView.NavigationType) -> Bool {
        print("으아아아아아아아아ㅏ아아아아아아아")
        if let s = request.url?.absoluteString {
            if s.hasPrefix("js:"){
                let array = s.components(separatedBy: "://")
                let funcName = array[1] // array[0] value is 'js'
                print(funcName)
                switch(funcName){
                case "changeGroupHandler" :
                    self.navigationController?.popViewControllers(viewsToPop: 1)
                    break;
                default:
                    break;
                }

                return false
            }
        }
        return true
    }
//    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebView.NavigationType) -> Bool {
//        //        if let s = request.url?.absoluteString {
//        //            if s.hasPrefix("js:"){
//        //                var array = s.components(separatedBy: "://")
//        //                let funcName = array[1] // array[0] value is 'js'
//        //                print(funcName)
//        //                switch(funcName){
//        //                case "changeGroupHandler" :
//        //                    self.navigationController?.popViewControllers(viewsToPop: 1)
//        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mainClassUpdate"), object: nil)
//        //                    break;
//        //                default:
//        //                    break;
//        //                }
//        //
//        //                return false
//        //            }
//        //        }
//        //        if request.url?.scheme == "js" {
//        //            print(123123123)
//        //        }
//
//
//
//        return true
//    }
}

extension UIWebViewController{
    
}

//webView.stringByEvaluatingJavaScriptFromString("자바스크립트에서 수행할 함수 이름()")


//function test(){
//    document.location = "js://customfuncname";
//}
