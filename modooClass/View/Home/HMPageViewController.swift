//
//  HMPageViewController.swift
//  modooClass
//
//  Created by 조현민 on 2020/02/04.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit
import Firebase

class HMPageViewController : UIPageViewController {
    //hmPageDelegate
    weak var hmPageDelegate: HMPageViewControllerDelegate?
 
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        // The view controllers will be shown in this order
        return [self.newViewController("HomeIntroWebViewController"),
            self.newViewController("HomeClassViewController"),
            self.newViewController("HomeFeedWebViewController"),
            self.newViewController("ProfileV2NewViewController")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let initialViewController = orderedViewControllers.first{
            scrollToViewController(viewController: initialViewController)
        }
        
        self.hmPageDelegate?.hmPageViewController(hmPageViewController: self, didUpdatePageCount: self.orderedViewControllers.count)
        if UserManager.shared.userInfo.results?.class_yn ?? "N" == "Y"{
            self.scrollToViewController(index: 2)
            self.scrollToViewController(index: 1)
            Analytics.setAnalyticsCollectionEnabled(true)
        }else{
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "homeTitleChange"), object: 0)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(disableScrolling), name: NSNotification.Name(rawValue: "disableScrolling"), object: nil)
       
    }

    @objc func disableScrolling(_ notification : Notification) {
        let object = notification.object as! Int
        for view in self.view.subviews {
            if let subVIew = view as? UIScrollView {
                if object > 0 {
                    subVIew.isScrollEnabled = false
                } else {
                    subVIew.isScrollEnabled = true
                }
            }
        }
    }
    
    /**
     Scrolls to the next view controller.
     */
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController) {
                    scrollToViewController(viewController: nextViewController)
        }
    }
    
    /**
     Scrolls to the view controller at the given index. Automatically calculates the direction.
     
     - parameter newIndex: the new index to scroll to
     */
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.firstIndex(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
                let nextViewController = orderedViewControllers[newIndex]
                scrollToViewController(viewController: nextViewController, direction: direction)
        }
    }
    
    func newViewController(_ storyBoardName: String) -> UIViewController {
        return UIStoryboard(name: "Home2WebView", bundle: nil) .
            instantiateViewController(withIdentifier: "\(storyBoardName)")
    }
    
    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewController.NavigationDirection = .forward) {
        setViewControllers([viewController],
            direction: direction,
            animated: true,
            completion: { (finished) -> Void in
                // Setting the view controller programmatically does not fire
                // any delegate methods, so we have to manually notify the
                // 'hmPageDelegate' of the new index.
                self.notifyHMDelegateOfNewIndex()
        })
    }
    
    /**
     Notifies '_hmPageDelegate' that the current page index was updated.
     */
    private func notifyHMDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.firstIndex(of: firstViewController) {
//                print("index : ",index)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "homeTitleChange"), object: index)
            hmPageDelegate?.hmPageViewController(hmPageViewController: self, didUpdatePageIndex: index)
        }
    }
    
}

// MARK: UIPageViewControllerDataSource

extension HMPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            // User is on the first view controller and swiped left to loop to
            // the last view controller.
            guard previousIndex >= 0 else {
//                return orderedViewControllers.last
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            // User is on the last view controller and swiped right to loop to
            // the first view controller.
            guard orderedViewControllersCount != nextIndex else {
//                return orderedViewControllers.first
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
    }
    
}

extension HMPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        notifyHMDelegateOfNewIndex()
        
    }
}

extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}

protocol HMPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter hmPageViewController: the hmPageViewController instance
     - parameter count: the total number of pages. hmPageViewController
     */
    func hmPageViewController(hmPageViewController: HMPageViewController,
        didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter hmPageViewController: the hmPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func hmPageViewController(hmPageViewController: HMPageViewController,
        didUpdatePageIndex index: Int)
    
}
