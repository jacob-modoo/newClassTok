//
//  BaseViewController.swift
//  modooClass
//
//  Created by 조현민 on 08/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

/**
# BaseViewController.swift 클래스 설명
 
## UIViewController 상속 받음
- 기본 베이스로 사용되는 컨트롤러
*/
class BaseViewController: UIViewController{
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeRightGesture(_:)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeLeftGesture(_:)))
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeTopGesture(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeBottomGesture(_:)))
        swipeRight.direction = .right
        swipeLeft.direction = .left
        swipeUp.direction = .up
        swipeDown.direction = .down
        self.view.gestureRecognizers = [swipeLeft, swipeRight]
        self.view.gestureRecognizers = [swipeUp, swipeDown, swipeLeft, swipeRight]
    }
    
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 전 단계 뷰로 가기 위한 함수
     
    - Throws: `Error` 뷰가 잘못된 경로이면 `Error`
    */
    func dismiss() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 다음단계 뷰를 위에서 나오게끔 표현하는 함수
     
    - Parameters:
        - viewControllerToPresent: 뷰컨트롤러
     
    - Throws: `Error` 뷰가 잘못된 경로이면 `Error`
    */
    func presentFromTop(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 다음단계 뷰로 가는 함수
     
    - Parameters:
        - viewControllerToPresent: 뷰컨트롤러
     
    - Throws: `Error` 뷰가 잘못된 경로이면 `Error`
    */
    func present(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 위로 스와이프 했을경우 실행되는 메소드
     
    - Parameters:
        - recognizer: 스와이프제스처
     
    - Throws: `Error` 제스처가 아닌 경우 `Error`
    */
    @objc func handleSwipeTopGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("This swipe is top")
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 아래로 스와이프 했을경우 실행되는 메소드
     
    - Parameters:
        - recognizer: 스와이프제스처
     
    - Throws: `Error` 제스처가 아닌 경우 `Error`
    */
    @objc func handleSwipeBottomGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("This swipe is bottom")
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 오른쪽으로 스와이프 했을경우 실행되는 메소드
     
    - Parameters:
        - recognizer: 스와이프제스처
     
    - Throws: `Error` 제스처가 아닌 경우 `Error`
    */
    @objc func handleSwipeRightGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("This swipe is right")
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 왼쪽으로 스와이프 했을경우 실행되는 메소드
     
    - Parameters:
        - recognizer: 스와이프제스처
     
    - Throws: `Error` 제스처가 아닌 경우 `Error`
    */
    @objc func handleSwipeLeftGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("This swipe is left")
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 길게 누르고있는 경우 실행되는 메소드
     
    - Throws: `Error` 제스처가 아닌 경우 `Error`
    */
    func addLongPressGesture() {
        print("addLongPressGesture")
        let longPressLeft = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressLeftGesture(_:)))
        let longPressRight = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressRightGesture(_:)))
        longPressRight.allowableMovement = 10
        longPressLeft.allowableMovement = 50
        
        let leftAreaFrame = CGRect.init(x: 0, y: 0, width: 40, height: self.view.frame.height)
        let rightAreaFrame = CGRect.init(x: self.view.frame.width-40, y: 0, width: 40, height: self.view.frame.height)
        
        let longPressLeftArea = UIView(frame: leftAreaFrame)
        let longPressRightArea = UIView(frame: rightAreaFrame)
        
        longPressLeftArea.addGestureRecognizer(longPressLeft)
        longPressRightArea.addGestureRecognizer(longPressRight)
        
        self.view.addSubview(longPressLeftArea)
        self.view.addSubview(longPressRightArea)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 오른쪽화면을 길게 누르고 있는 경우 실행되는 메소드
     
    - Parameters:
        - recognizer: 스와이프제스처
     
    - Throws: `Error` 제스처가 아닌 경우 `Error`
    */
    @objc func handleLongPressRightGesture(_ recognizer: UILongPressGestureRecognizer) {
        print("handleLongClickRightGesture")
        if recognizer.state == .began {
            print("handleLongClickRightGesture began")
        }else if recognizer.state == .ended{
            print("handleLongClickRightGesture ended")
        }else  if recognizer.state == .recognized {
            print("handleLongClickRightGesture recognized")
        }else if recognizer.state == .changed {
            print("handleLongClickRightGesture changed")
        }else if recognizer.state == .cancelled {
            print("handleLongClickRightGesture cancelled")
        }else if recognizer.state == .failed {
            print("handleLongClickRightGesture failed")
        }else if recognizer.state == .possible {
            print("handleLongClickRightGesture possible")
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 왼쪽을 길게 누르고 있는 경우 실행되는 메소드
     
    - Parameters:
        - recognizer: 스와이프제스처
     
    - Throws: `Error` 제스처가 아닌 경우 `Error`
    */
    @objc func handleLongPressLeftGesture(_ recognizer: UILongPressGestureRecognizer) {
        print("handleLongClickLeftGesture")
        if recognizer.state == .began {
            print("handleLongClickLeftGesture began")
        }else if recognizer.state == .ended{
            print("handleLongClickLeftGesture ended")
        }else  if recognizer.state == .recognized {
            print("handleLongClickLeftGesture recognized")
        }else if recognizer.state == .changed {
            print("handleLongClickRightGesture changed")
        }else if recognizer.state == .cancelled {
            print("handleLongClickRightGesture cancelled")
        }else if recognizer.state == .failed {
            print("handleLongClickRightGesture failed")
        }else if recognizer.state == .possible {
            print("handleLongClickRightGesture possible")
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 애플제공 기본 알림창
     
    - Parameters:
        - title: 알림 제목
        - cancelTitle: 취소 버튼 제목
        - cancelHandler: 취소 버튼 누를시 동작
     
    - Throws: `Error` 제스처가 아닌 경우 `Error`
    */
    func showAlert(title:String, cancelTitle:String, cancelHandler: ((UIAlertAction) -> Void)? = nil!) {
        self.showAlert(title: title, message: nil, submitTitle: nil, submitHandler: nil, cancelTitle: cancelTitle, cancelHandler: cancelHandler)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 애플제공 기본 알림창
     
    - Parameters:
        - title: 알림 제목
        - message: 알림 내용
        - submitTitle: 확인 버튼 제목
        - cancelTitle: 취소 버튼 제목
     
    - Throws: `Error` 제스처가 아닌 경우 `Error`
    */
    func showAlert(title:String, message:String, submitTitle:String, cancelTitle:String) {
        self.showAlert(title: title, message: message, submitTitle: submitTitle, submitHandler: nil, cancelTitle: cancelTitle, cancelHandler: nil)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 애플제공 기본 알림창
     
    - Parameters:
        - title: 알림 제목
        - message: 알림 내용
        - submitTitle: 확인 버튼 제목
        - submitHandler: 확인 버튼 누를시 동작
        - cancelTitle: 취소 버튼 제목
        - cancelHandler: 취소 버튼 누를시 동작
     
    - Throws: `Error` 제스처가 아닌 경우 `Error`
    */
    func showAlert(title:String, message:String!, submitTitle:String!, submitHandler: ((UIAlertAction) -> Void)? = nil!, cancelTitle:String!, cancelHandler: ((UIAlertAction) -> Void)? = nil!) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        if let submitText = submitTitle {
            if let submitHandle = submitHandler {
                alert.addAction(UIAlertAction.init(title: submitText, style: .default, handler: submitHandle))
            }else {
                alert.addAction(UIAlertAction.init(title: submitText, style: .default, handler: nil))
            }
        }
        if let cancelText = cancelTitle {
            if let cancelHandle = cancelHandler {
                alert.addAction(UIAlertAction.init(title: cancelText, style: .cancel, handler: cancelHandle))
            }else {
                alert.addAction(UIAlertAction.init(title: cancelText, style: .cancel, handler: nil))
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}

