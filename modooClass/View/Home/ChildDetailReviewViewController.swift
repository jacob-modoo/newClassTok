//
//  ChildDetailReviewViewController.swift
//  modooClass
//
//  Created by 조현민 on 2020/01/10.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit
import Foundation

class ChildDetailReviewViewController: UIViewController {
    
    /** **테이블뷰 */
    @IBOutlet var tableView: UITableView!
    /** **클래스 아이디 */
    var class_id = 0
    /** **응원하기 리스트 */
    var reviewDashboardModel:ReviewDashboardModel?
    var reviewModel:ReviewModel?
    var reviewList_arr:Array = Array<ReviewList>()
    /** **뷰의 y값 */
    var contentY:CGFloat = 0
    /** **뷰의 숨기는 속도 */
    var minimumVelocityToHide = 1500 as CGFloat
    /** **뷰의 숨기는 화면 비율 */
    var minimumScreenRatioToHide = 0.5 as CGFloat
    /** **애니메이션 시간 */
    var animationDuration = 0.2 as TimeInterval
    
    var page = 1
    var changeProgressTransform = false
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataReload), name: NSNotification.Name(rawValue: "DetailReviewSend"), object: nil )
        
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
        print("ChildDetailReviewViewController viewDidDisappear")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("ChildDetailReviewViewController deinit")
    }
    
    /** **커리큘럼뷰 나가기 버튼 클릭 > 커리큘럼뷰를 숨김 */
    @IBAction func reviewOutBtn(_ sender: UIButton) {
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
    
    @IBAction func profileBtnClicked(_ sender: UIButton) {
        let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
        newViewController.user_id = sender.tag
        self.navigationController?.pushViewController(newViewController, animated: true)
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
            DispatchQueue.main.async {
                self.app_review()
            }
        }
    }
    
}


extension ChildDetailReviewViewController:UITableViewDelegate,UITableViewDataSource{
    func progressCheck(cell:ChildDetailReviewTableViewCell,point:Int){
        if self.reviewDashboardModel?.results?.data_per_arr[point].score ?? 0 == 1{
            if let cost = Double(self.reviewDashboardModel?.results?.data_per_arr[point].value ?? "") {
                cell.progress5.progress = Float(cost/100)
            }
        }else if self.reviewDashboardModel?.results?.data_per_arr[point].score ?? 0 == 2{
            if let cost = Double(self.reviewDashboardModel?.results?.data_per_arr[point].value ?? "") {
                cell.progress4.progress = Float(cost/100)
            }
        }else if self.reviewDashboardModel?.results?.data_per_arr[point].score ?? 0 == 3{
            if let cost = Double(self.reviewDashboardModel?.results?.data_per_arr[point].value ?? "") {
                cell.progress3.progress = Float(cost/100)
            }
        }else if self.reviewDashboardModel?.results?.data_per_arr[point].score ?? 0 == 4{
            if let cost = Double(self.reviewDashboardModel?.results?.data_per_arr[point].value ?? "") {
                cell.progress2.progress = Float(cost/100)
            }
        }else if self.reviewDashboardModel?.results?.data_per_arr[point].score ?? 0 == 5{
            if let cost = Double(self.reviewDashboardModel?.results?.data_per_arr[point].value ?? "") {
                cell.progress1.progress = Float(cost/100)
            }
        }
    }
    /** **테이블 셀의 섹션당 로우 개수 함수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }else if section == 2{
            return self.reviewList_arr.count
        }else{
            return 1
        }
    }
    
    /** **테이블 셀의 로우 및 섹션 데이터 함수 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0{
            let cell:ChildDetailReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailReviewNavCell", for: indexPath) as! ChildDetailReviewTableViewCell
            cell.selectionStyle = .none
            return cell
        }else if section == 1{
            let cell:ChildDetailReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailReviewDashboardCell", for: indexPath) as! ChildDetailReviewTableViewCell
            cell.progress1.layer.cornerRadius = 2
            cell.progress2.layer.cornerRadius = 2
            cell.progress3.layer.cornerRadius = 2
            cell.progress4.layer.cornerRadius = 2
            cell.progress5.layer.cornerRadius = 2
            cell.progress1.clipsToBounds = true
            cell.progress2.clipsToBounds = true
            cell.progress3.clipsToBounds = true
            cell.progress4.clipsToBounds = true
            cell.progress5.clipsToBounds = true
            if changeProgressTransform == false{
                cell.progress1.transform = cell.progress1.transform.scaledBy(x: 1, y: 5)
                cell.progress2.transform = cell.progress2.transform.scaledBy(x: 1, y: 5)
                cell.progress3.transform = cell.progress3.transform.scaledBy(x: 1, y: 5)
                cell.progress4.transform = cell.progress4.transform.scaledBy(x: 1, y: 5)
                cell.progress5.transform = cell.progress5.transform.scaledBy(x: 1, y: 5)
                changeProgressTransform = true
            }
            if self.reviewDashboardModel?.results != nil{
                cell.reviewCount.text = "\(self.reviewDashboardModel?.results?.total ?? 0)개의 후기"
                cell.reviewTotalCount.text = "총 \(self.reviewDashboardModel?.results?.total ?? 0)개의 리뷰"

                cell.reviewAvg.text = "\(self.reviewDashboardModel?.results?.avg ?? "0.0")"
                progressCheck(cell: cell, point: 0)
                progressCheck(cell: cell, point: 1)
                progressCheck(cell: cell, point: 2)
                progressCheck(cell: cell, point: 3)
                progressCheck(cell: cell, point: 4)
                var avg: String = "\(self.reviewDashboardModel?.results?.avg ?? "")"
                if avg == ""{
                    avg = "0.0"
                }
                let avgArr = avg.components(separatedBy: ".")
                
                let firstAvg = Int(avgArr[0]) ?? 0
                var secondAvg = ""
                let secondAvgCalculate = avgArr[1]
                
                secondAvg = "0.\(secondAvgCalculate)"
                
                if firstAvg == 5{
                    cell.reviewStar1.image = UIImage(named: "profile_star_active")
                    cell.reviewStar2.image = UIImage(named: "profile_star_active")
                    cell.reviewStar3.image = UIImage(named: "profile_star_active")
                    cell.reviewStar4.image = UIImage(named: "profile_star_active")
                    cell.reviewStar5.image = UIImage(named: "profile_star_active")
                }else if firstAvg == 4{
                    cell.reviewStar1.image = UIImage(named: "profile_star_active")
                    cell.reviewStar2.image = UIImage(named: "profile_star_active")
                    cell.reviewStar3.image = UIImage(named: "profile_star_active")
                    cell.reviewStar4.image = UIImage(named: "profile_star_active")
                    if let cost = Double(secondAvg){
                        if cost > 0.5{
                            cell.reviewStar5.image = UIImage(named: "profile_star_active")
                        }else if cost > 0.0{
                            cell.reviewStar5.image = UIImage(named: "profile_star_half_active")
                        }else{
                            cell.reviewStar5.image = UIImage(named: "profile_star_default")
                        }
                    }
                }else if firstAvg == 3{
                    cell.reviewStar1.image = UIImage(named: "profile_star_active")
                    cell.reviewStar2.image = UIImage(named: "profile_star_active")
                    cell.reviewStar3.image = UIImage(named: "profile_star_active")
                    cell.reviewStar5.image = UIImage(named: "profile_star_default")
                    if let cost = Double(secondAvg) {
                        if cost > 0.5{
                            cell.reviewStar4.image = UIImage(named: "profile_star_active")
                        }else if cost > 0.0{
                            cell.reviewStar4.image = UIImage(named: "profile_star_half_active")
                        }else{
                            cell.reviewStar4.image = UIImage(named: "profile_star_default")
                        }
                    }
                }else if firstAvg == 2{
                    cell.reviewStar1.image = UIImage(named: "profile_star_active")
                    cell.reviewStar2.image = UIImage(named: "profile_star_active")
                    cell.reviewStar4.image = UIImage(named: "profile_star_default")
                    cell.reviewStar5.image = UIImage(named: "profile_star_default")
                    if let cost = Double(secondAvg) {
                        if cost > 0.5{
                            cell.reviewStar3.image = UIImage(named: "profile_star_active")
                        }else if cost > 0.0{
                            cell.reviewStar3.image = UIImage(named: "profile_star_half_active")
                        }else{
                            cell.reviewStar3.image = UIImage(named: "profile_star_default")
                        }
                    }
                }else if firstAvg == 1{
                    cell.reviewStar1.image = UIImage(named: "profile_star_active")
                    cell.reviewStar3.image = UIImage(named: "profile_star_default")
                    cell.reviewStar4.image = UIImage(named: "profile_star_default")
                    cell.reviewStar5.image = UIImage(named: "profile_star_default")
                    if let cost = Double(secondAvg) {
                        if cost > 0.5{
                            cell.reviewStar2.image = UIImage(named: "profile_star_active")
                        }else if cost > 0.0{
                            cell.reviewStar2.image = UIImage(named: "profile_star_half_active")
                        }else{
                            cell.reviewStar2.image = UIImage(named: "profile_star_default")
                        }
                    }
                }else{
                    cell.reviewStar2.image = UIImage(named: "profile_star_default")
                    cell.reviewStar3.image = UIImage(named: "profile_star_default")
                    cell.reviewStar4.image = UIImage(named: "profile_star_default")
                    cell.reviewStar5.image = UIImage(named: "profile_star_default")
                    if let cost = Double(secondAvg) {
                        if cost > 0.5{
                            cell.reviewStar1.image = UIImage(named: "profile_star_active")
                        }else if cost > 0.0{
                            cell.reviewStar1.image = UIImage(named: "profile_star_half_active")
                        }else{
                            cell.reviewStar1.image = UIImage(named: "profile_star_default")
                        }
                    }
                }
            }
            cell.selectionStyle = .none
            return cell
        }else{
            var cell:ChildDetailReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailReview1Cell", for: indexPath) as! ChildDetailReviewTableViewCell
            if self.reviewList_arr.count > 0{
                if self.reviewList_arr[row].review_photo ?? "" == ""{
                    if self.reviewList_arr[row].coach_content ?? "" == ""{
                        cell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailReview1Cell", for: indexPath) as! ChildDetailReviewTableViewCell
                        
                    }else{
                        cell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailReview2Cell", for: indexPath) as! ChildDetailReviewTableViewCell
                        cell.coachImg.sd_setImage(with: URL(string: "\(self.reviewList_arr[row].coach_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                        cell.coachNick.text = "\(self.reviewList_arr[row].coach_name ?? "")"
                        cell.coachReviewContent.text = "\(self.reviewList_arr[row].coach_content ?? "")"
                    }
                }else{
                    if self.reviewList_arr[row].coach_content ?? "" == ""{
                        cell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailReview4Cell", for: indexPath) as! ChildDetailReviewTableViewCell
                    }else{
                        cell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailReview3Cell", for: indexPath) as! ChildDetailReviewTableViewCell
                        cell.coachImg.sd_setImage(with: URL(string: "\(self.reviewList_arr[row].coach_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                        cell.coachNick.text = "\(self.reviewList_arr[row].coach_name ?? "")"
                        cell.coachReviewContent.text = "\(self.reviewList_arr[row].coach_content ?? "")"
                        cell.coachProfileBtn.tag = self.reviewList_arr[row].coach_id ?? 0
                    }
                    cell.userReviewImg.sd_setImage(with: URL(string: "\(self.reviewList_arr[row].review_photo ?? "")"), placeholderImage: UIImage(named: "home_default"))
                }
                cell.userImg.sd_setImage(with: URL(string: "\(self.reviewList_arr[row].photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                cell.userNick.text = "\(self.reviewList_arr[row].user_name ?? "")"
                cell.userReviewDate.text = "\(self.reviewList_arr[row].gap_text ?? "")"
                cell.userReviewContent.text = "\(self.reviewList_arr[row].content ?? "")"
                cell.userProfileBtn.tag = self.reviewList_arr[row].user_id ?? 0
                if self.reviewList_arr[row].star ?? 0 == 5{
                    cell.userReviewStar5.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar4.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar3.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar2.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar1.image = UIImage(named: "profile_star_active")
                }else if self.reviewList_arr[row].star ?? 0 == 4{
                    cell.userReviewStar5.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar4.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar3.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar2.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar1.image = UIImage(named: "profile_star_default")
                }else if self.reviewList_arr[row].star ?? 0 == 3{
                    cell.userReviewStar5.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar4.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar3.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar2.image = UIImage(named: "profile_star_default")
                    cell.userReviewStar1.image = UIImage(named: "profile_star_default")
                }else if self.reviewList_arr[row].star ?? 0 == 2{
                    cell.userReviewStar5.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar4.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar3.image = UIImage(named: "profile_star_default")
                    cell.userReviewStar2.image = UIImage(named: "profile_star_default")
                    cell.userReviewStar1.image = UIImage(named: "profile_star_default")
                }else if self.reviewList_arr[row].star ?? 0 == 1{
                    cell.userReviewStar5.image = UIImage(named: "profile_star_active")
                    cell.userReviewStar4.image = UIImage(named: "profile_star_default")
                    cell.userReviewStar3.image = UIImage(named: "profile_star_default")
                    cell.userReviewStar2.image = UIImage(named: "profile_star_default")
                    cell.userReviewStar1.image = UIImage(named: "profile_star_default")
                }else{
                    cell.userReviewStar5.image = UIImage(named: "profile_star_default")
                    cell.userReviewStar4.image = UIImage(named: "profile_star_default")
                    cell.userReviewStar3.image = UIImage(named: "profile_star_default")
                    cell.userReviewStar2.image = UIImage(named: "profile_star_default")
                    cell.userReviewStar1.image = UIImage(named: "profile_star_default")
                }
            }
            
            cell.reviewBackgroundView.layer.cornerRadius = 10
            cell.reviewBackgroundView.layer.borderColor = UIColor(hexString: "#efefef").cgColor
            cell.reviewBackgroundView.layer.borderWidth = 1
            cell.reviewBackgroundView.clipsToBounds = true
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section == 2{
            if row == (reviewList_arr.count)-2{
                if reviewList_arr.count < reviewModel?.results?.total ?? 0 {
                    self.page = self.page + 1
                    app_reviewList()
                }
            }
        }
    }
}

extension ChildDetailReviewViewController{
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 응원하기 리스트 불러오는 함수
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func app_review(){
        self.reviewDashboardModel = FeedDetailManager.shared.reviewDashboardModel
        app_reviewList()
        
    }
    
    func app_reviewList(){
        FeedApi.shared.appMainPilotReviewListV2(class_id: self.class_id,page:self.page, success: { [unowned self] result in
            self.reviewModel = result
            if result.code == "200"{
                for addArray in 0 ..< (self.reviewModel?.results?.reviewList_arr.count ?? 0)! {
                    self.reviewList_arr.append((self.reviewModel?.results?.reviewList_arr[addArray])!)
                }
                self.tableView.reloadData()
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {

            })
        }
    }
}

extension ChildDetailReviewViewController: UIGestureRecognizerDelegate,UIScrollViewDelegate{
    
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
