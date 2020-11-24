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
    var score = "*"
    var user_id = UserManager.shared.userInfo.results?.user?.id ?? 0
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
        let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
        newViewController.user_id = sender.tag
        if UserManager.shared.userInfo.results?.user?.id == sender.tag{
            newViewController.isMyProfile = true
        }else{
            newViewController.isMyProfile = false
        }
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    /** *Will filter feedbacks given to each class*/
    @IBAction func feedbackFilteringBtnClicked(_ sender: UIButton) {
        if sender.tag == 0 {
            self.page = 1
            self.score = "*"
            reviewListFiltering()
        } else if sender.tag == 1 {
            self.page = 1
            self.score = "1000"
            reviewListFiltering()
        } else {
            self.page = 1
            self.score = "2000"
            reviewListFiltering()
        }
    }
    
    
    @IBAction func reviewFeedbackLikeBtnCLicked(_ sender: UIButton) {
        feedbackLike(sender: sender)
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

    /** **테이블 셀의 섹션당 로우 개수 함수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        } else if section == 3 {
            if self.reviewModel?.results?.reviewList_arr.count ?? 0 == 0 {
                return 1
            } else {
                return 0
            }
        } else if section == 4 {
            return self.reviewList_arr.count
        } else {
            return 1
        }
    }
    
    /** **테이블 셀의 로우 및 섹션 데이터 함수 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let cell:ChildDetailReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailReviewNavCell", for: indexPath) as! ChildDetailReviewTableViewCell
            cell.selectionStyle = .none
            return cell
        } else if section == 1 {
            let cell:ChildDetailReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailReviewDashboardCell", for: indexPath) as! ChildDetailReviewTableViewCell
            cell.progress1.layer.cornerRadius = 2
            cell.progress2.layer.cornerRadius = 2
            cell.progress1.clipsToBounds = true
            cell.progress2.clipsToBounds = true

            if changeProgressTransform == false{
                cell.progress1.transform = cell.progress1.transform.scaledBy(x: 1, y: 5)
                cell.progress2.transform = cell.progress2.transform.scaledBy(x: 1, y: 5)
                changeProgressTransform = true
            }
           
            if self.reviewDashboardModel?.results != nil{
                let reviewStar1 = self.reviewDashboardModel?.results?.data_arr[0].value ?? 0
                let reviewStar2 = self.reviewDashboardModel?.results?.data_arr[1].value ?? 0
                let reviewStar3 = self.reviewDashboardModel?.results?.data_arr[2].value ?? 0
                let reviewStar4 = self.reviewDashboardModel?.results?.data_arr[3].value ?? 0
                let reviewStar5 = self.reviewDashboardModel?.results?.data_arr[4].value ?? 0
                cell.helpFeedbackCount.text = "\(reviewStar4+reviewStar5)"
                cell.sosoFeedbackCount.text = "\(reviewStar1+reviewStar2+reviewStar3)"
                cell.totalHelpCount.text = "\(reviewStar4+reviewStar5)명에게 도움이 되었어요"
                cell.reviewCount.text = "\(self.reviewDashboardModel?.results?.total ?? 0)개의 후기"
                cell.progress1.progress = Float(reviewStar4+reviewStar5)/Float(reviewStar1+reviewStar2+reviewStar3+reviewStar4+reviewStar5)
                cell.progress2.progress = Float(reviewStar1+reviewStar2+reviewStar3)/Float(reviewStar1+reviewStar2+reviewStar3+reviewStar4+reviewStar5)
            }
            cell.selectionStyle = .none
            return cell
        } else if section == 2 {
            let cell:ChildDetailReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailFeedbackFilterCell", for: indexPath) as! ChildDetailReviewTableViewCell
            if score == "*"{
                cell.totalFeedback.borderWidth = 1
                cell.totalFeedback.borderColor = UIColor(hexString: "#FF5A5F")
                cell.totalFeedback.backgroundColor = .white
                cell.totalFeedback.setTitleColor(UIColor(hexString: "FF5A5F"), for: .normal)
                cell.totalFeedback.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                cell.helpFeedback.borderWidth = 0
                cell.helpFeedback.backgroundColor = UIColor(hexString: "#F5F5F5")
                cell.helpFeedback.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
                cell.sosoFeedback.borderWidth = 0
                cell.sosoFeedback.backgroundColor = UIColor(hexString: "#F5F5F5")
                cell.sosoFeedback.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
            } else if score == "1000"{
                cell.helpFeedback.borderWidth = 1
                cell.helpFeedback.borderColor = UIColor(hexString: "#FF5A5F")
                cell.helpFeedback.backgroundColor = .white
                cell.helpFeedback.setTitleColor(UIColor(hexString: "FF5A5F"), for: .normal)
                cell.helpFeedback.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                cell.sosoFeedback.borderWidth = 0
                cell.sosoFeedback.backgroundColor = UIColor(hexString: "#F5F5F5")
                cell.sosoFeedback.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
                cell.totalFeedback.borderWidth = 0
                cell.totalFeedback.backgroundColor = UIColor(hexString: "#F5F5F5")
                cell.totalFeedback.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
            } else {
                cell.sosoFeedback.borderWidth = 1
                cell.sosoFeedback.borderColor = UIColor(hexString: "#FF5A5F")
                cell.sosoFeedback.backgroundColor = .white
                cell.sosoFeedback.setTitleColor(UIColor(hexString: "FF5A5F"), for: .normal)
                cell.sosoFeedback.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                cell.helpFeedback.borderWidth = 0
                cell.helpFeedback.backgroundColor = UIColor(hexString: "#F5F5F5")
                cell.helpFeedback.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
                cell.totalFeedback.borderWidth = 0
                cell.totalFeedback.backgroundColor = UIColor(hexString: "#F5F5F5")
                cell.totalFeedback.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
            }
            cell.selectionStyle = .none
            return cell
        } else if section == 3 {
            let cell : ChildDetailReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailNoFeedbackCell", for: indexPath) as! ChildDetailReviewTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
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
                        cell.coachProfileBtn.tag = self.reviewList_arr[row].coach_id ?? 0
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
                
                cell.reviewLikeBtnView.layer.cornerRadius = 12
                cell.reviewFeedbackLikeBtn.layer.shadowOpacity = 0.1
                cell.reviewFeedbackLikeBtn.layer.shadowRadius = 3
                cell.reviewFeedbackLikeBtn.layer.shadowOffset = CGSize(width: 0,height: 2)
                
                if self.reviewList_arr[row].like_yn ?? "N" == "Y" {
                    cell.reviewFeedbackLikeBtn.tag = row*10000 + 1
                    cell.reviewFeedbackLikeBtn.setTitle(" \(self.reviewList_arr[row].like_cnt ?? 0)", for: .normal)
                    cell.reviewFeedbackLikeBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                    cell.reviewFeedbackLikeBtn.setImage(UIImage(named: "comment_likeBtn_active"), for: .normal)
                } else {
                    cell.reviewFeedbackLikeBtn.tag = row*10000 + 2
                    cell.reviewFeedbackLikeBtn.setTitle(" \(self.reviewList_arr[row].like_cnt ?? 0)", for: .normal)
                    cell.reviewFeedbackLikeBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                    cell.reviewFeedbackLikeBtn.setImage(UIImage(named: "comment_likeBtn_default"), for: .normal)
                }
                
                if self.reviewList_arr[row].star ?? 0 == 4 || self.reviewList_arr[row].star ?? 0 == 5 {
                    cell.feedbackImg.image = UIImage(named: "like_btn_with_title")
                } else {
                    cell.feedbackImg.image = UIImage(named: "dislike_btn_with_title")
                }
                print("best flag value : \(reviewList_arr[row].best_flag ?? "")")
                if self.reviewList_arr[row].best_flag ?? "N" == "N" {
                    cell.bestFeedbackMark.isHidden = true
                }
                if self.reviewList_arr[row].best_flag ?? "N" == "Y" {
                    cell.bestFeedbackMark.isHidden = false
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section == 4{
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
    **파라미터가 있고 반환값이 없는 메소드 > feedback like & dislike function
    
     - Parameters:
        - sender: 버튼 태그값
     
    - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
    */
    func feedbackLike(sender:UIButton){
        sender.isUserInteractionEnabled = false
        let row = sender.tag / 10000
        let likeGubun = sender.tag % 10000 // 1 : Y delete  2 : N post
        let comment_id = "R\(reviewList_arr[row].id ?? 0)"

        var type = ""
        if likeGubun == 1{
            type = "delete"
        }else{
            type = "add"
        }
        
        FeedApi.shared.appSquareLike(comment_id: comment_id, type: type, success: { [unowned self] result in
            if result.code == "200" {
                DispatchQueue.main.async {
                    let selectedIndexPath = IndexPath(item:row , section: 4)
                    let cell = self.tableView.cellForRow(at: selectedIndexPath) as! ChildDetailReviewTableViewCell
                    
                    if likeGubun == 1{
                        self.reviewList_arr[row].like_cnt = (self.reviewList_arr[row].like_cnt ?? 0)-1
                        cell.reviewFeedbackLikeBtn.tag = row*10000 + 2
                        self.reviewList_arr[row].like_yn = "N"
                        cell.reviewFeedbackLikeBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                        cell.reviewFeedbackLikeBtn.setImage(UIImage(named: "comment_likeBtn_default"), for: .normal)
                        cell.reviewFeedbackLikeBtn.setTitle(" \(self.reviewList_arr[row].like_cnt ?? 0)", for: .normal)
                    }else{
                        self.reviewList_arr[row].like_cnt = (self.reviewList_arr[row].like_cnt ?? 0)+1
                        cell.reviewFeedbackLikeBtn.tag = row*10000 + 1
                        self.reviewList_arr[row].like_yn = "Y"
                        cell.reviewFeedbackLikeBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                        cell.reviewFeedbackLikeBtn.setImage(UIImage(named: "comment_likeBtn_active"), for: .normal)
                        cell.reviewFeedbackLikeBtn.setTitle(" \(self.reviewList_arr[row].like_cnt ?? 0)", for: .normal)
                    }
                    
                    sender.isUserInteractionEnabled = true
                }
            }else{
                print("Error is occured!")
                sender.isUserInteractionEnabled = true
            }
        }) { error in
            sender.isUserInteractionEnabled = true
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 응원하기 리스트 불러오는 함수
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func app_review(){
        self.reviewDashboardModel = FeedDetailManager.shared.reviewDashboardModel
        app_reviewList()
        
    }
    
    func app_reviewList(){
        FeedApi.shared.appMainPilotReviewListV2(user_id:self.user_id, class_id: self.class_id, score: self.score, page:self.page, success: { [unowned self] result in
            self.reviewModel = result
            if result.code == "200"{
                if result.results?.page_total ?? 0 >= result.results?.page ?? 0 {
                    for addArray in 0 ..< (self.reviewModel?.results?.reviewList_arr.count ?? 0)! {
                        self.reviewList_arr.append((self.reviewModel?.results?.reviewList_arr[addArray])!)
                    }
                }
                self.tableView.reloadData()
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {

            })
        }
    }
    
    /** *The function which filters the review feedbacks */
    func reviewListFiltering(){
        self.reviewList_arr.removeAll()
        DispatchQueue.main.async {
            self.app_reviewList()
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
