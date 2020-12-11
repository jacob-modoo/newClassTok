//
//  ChildDetailIntroViewController.swift
//  modooClass
//
//  Created by 조현민 on 2020/01/10.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit

class ChildDetailIntroViewController: UIViewController {
    
    /** **테이블뷰 */
    @IBOutlet var tableView: UITableView!
    /** **클래스 아이디 */
    var class_id = 0
    /** **응원하기 리스트 */
    var feedAppCheerModel:FeedAppCheerModel?
    /** **뷰의 y값 */
    var contentY:CGFloat = 0
    /** **뷰의 숨기는 속도 */
    var minimumVelocityToHide = 1500 as CGFloat
    /** **뷰의 숨기는 화면 비율 */
    var minimumScreenRatioToHide = 0.5 as CGFloat
    /** **애니메이션 시간 */
    var animationDuration = 0.2 as TimeInterval
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataReload), name: NSNotification.Name(rawValue: "DetailCheerSend"), object: nil )
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
    }
    
    /** **부모 뷰가 움직일때 */
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent:parent)
    }
    
    /** **부모 뷰가 움직인뒤 */
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent:parent)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        print("ChildDetailIntroViewController viewDidDisappear")
    }
    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    /** **커리큘럼뷰 나가기 버튼 클릭 > 커리큘럼뷰를 숨김 */
    @IBAction func infoOutBtn(_ sender: UIButton) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.slideViewVerticallyTo(self.view.frame.size.height)
        }, completion: { (isCompleted) in
            if isCompleted {
                if let parentVC = self.parent as? FeedDetailViewController {
                    parentVC.tableViewCheck = 1
                    parentVC.detailClassData()
                }else{}
                self.slideViewVerticallyTo(0)
            }
        })
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 응원하기 데이터 변경 함수
     
     - Parameters:
        - notification: 오브젝트에 클래스 아이디가 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func dataReload(notification:Notification){
        
        if let temp = notification.object {
            self.class_id = temp as! Int
            self.feedAppCheerModel = FeedDetailManager.shared.feedAppCheerModel
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}


extension ChildDetailIntroViewController:UITableViewDelegate,UITableViewDataSource{
    
    /** **테이블 셀의 섹션당 로우 개수 함수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }
        return 1
    }
    
    /** **테이블 셀의 로우 및 섹션 데이터 함수 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0{
            let cell:ChildDetailIntroTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailIntroNavCell", for: indexPath) as! ChildDetailIntroTableViewCell
            cell.selectionStyle = .none
            return cell
        }else{
            let cell:ChildDetailIntroTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailIntroContentCell", for: indexPath) as! ChildDetailIntroTableViewCell
            let setHeightUsingCSS = "<html><head><style type=\"text/css\"> img{ max-height: 100%; max-width: \(self.view.frame.width - 32); !important; width: auto; height: auto;} </style> </head><body> \(FeedDetailManager.shared.feedDetailList.results?.class_info ?? "") </body></html>"
            
            cell.classIntroContent.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
            cell.classIntroContent.attributedText = setHeightUsingCSS.html2AttributedString
//            let iframeView:YouTubeTextView = YouTubeTextView()
//            iframeView.setText(text: setHeightUsingCSS)
//            cell.classIntroContent.attributedText = iframeView.attributedText
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    /** **테이블 셀의 높이 함수 */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /** **테이블 셀의 섹션 개수 함수 */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension ChildDetailIntroViewController: UIGestureRecognizerDelegate,UIScrollViewDelegate{
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 수직으로 슬라이드 될떄 타는 함수
     
     - Parameters:
        - y: y값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func slideViewVerticallyTo(_ y: CGFloat) {
        self.view.frame.origin = CGPoint(x: 0, y: y)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 팬 제스처가 일어나기 시작하는 이벤트
     
     - Parameters:
        - panGesture: panGesture 이벤트 값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began, .changed:
            let translation = panGesture.translation(in: view)
            let y = max(0, translation.y)
            self.slideViewVerticallyTo(y)
            break
        case .ended:
            let translation = panGesture.translation(in: view)
            let velocity = panGesture.velocity(in: view)
            let closing = (translation.y > self.view.frame.size.height * minimumScreenRatioToHide) ||
                (velocity.y > minimumVelocityToHide)
            
            if closing {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(self.view.frame.size.height)
                }, completion: { (isCompleted) in
                    if isCompleted {
                        if let parentVC = self.parent as? FeedDetailViewController {
                            parentVC.tableViewCheck = 1
                            parentVC.detailClassData()
                        }else{}
                        self.slideViewVerticallyTo(0)
                    }
                })
            } else {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(0)
                })
            }
            break
        default:
            UIView.animate(withDuration: animationDuration, animations: {
                self.slideViewVerticallyTo(0)
            })
            break
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 스크롤을 이용하여 스크롤이 상단 y=0 까지 올라오면 팬 제스처 실행
     
     - Parameters:
        - scrollView: scrollView 값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentY = scrollView.contentOffset.y
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 제스쳐 인식 함수
     
     - Parameters:
        - gestureRecognizer: gestureRecognizer 값
        - otherGestureRecognizer: otherGestureRecognizer 값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        if contentY == 0 {
            return true
        }else{
            return false
        }
    }
}
