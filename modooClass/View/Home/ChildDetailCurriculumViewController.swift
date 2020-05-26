//
//  ChildDetailCurriculumViewController.swift
//  modooClass
//
//  Created by 조현민 on 05/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

/**
 # ChildDetailCurriculumViewController.swift 클래스 설명
 
 ## UIViewController 상속 받음
 - 강의 클래스들의 검색 리스트를 보기 위한 화면
 */
class ChildDetailCurriculumViewController: UIViewController{
    
    /** **테이블뷰 */
    @IBOutlet weak var tableView: UITableView!
    /** **커리큘럼 리스트 */
    var feedAppCurriculumModel:FeedAppCurriculumModel?
    /** **클래스 아이디 */
    var class_id = 0
    /** **뷰의 y값 */
    var contentY:CGFloat = 0
    /** **뷰의 숨기는 속도 */
    var minimumVelocityToHide = 1500 as CGFloat
    /** **뷰의 숨기는 화면 비율 */
    var minimumScreenRatioToHide = 0.5 as CGFloat
    /** **애니메이션 시간 */
    var animationDuration = 0.2 as TimeInterval
    var freeCheck:Bool = false
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataReload), name: NSNotification.Name(rawValue: "DetailCurriculumSend"), object: nil )
        self.app_curriculum()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
    }
    
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /** **뷰가 사라지기 시작 할 때 타는 메소드 */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    /** **부모 뷰가 움직일때 */
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent:parent)
    }
    
    /** **부모 뷰가 움직인뒤 */
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent:parent)
    }
    
    /** **팬제스처 아래로 */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
    }
    
    /** **팬제스처 아래로 */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("ChildDetailCurriculumViewController deinit")
    }
    
    /** **클래스 나가기 버튼 클릭 > 클래스 나가는 함수를 실행 */
    @IBAction func classOutBtnClicked(_ sender: UIButton) {
        Alert.With(self, title: "알림", content: "클래스를 나가시겠습니까?", btn1Title: "취소", btn1Handler: {
            
        }, btn2Title: "확인", btn2Handler: {
            self.app_class_out()
        })
    }
    
    /** **커리큘럼뷰 나가기 버튼 클릭 > 커리큘럼뷰를 숨김 */
    @IBAction func curriculumOutBtn(_ sender: UIButton) {
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
    
    /** **커리큘럼 버튼 클릭 > 커리큘럼뷰를 숨기면서 커리큘럼 이동 */
    @IBAction func curriculumChangeBtnClicked(_ sender: UIButton) {
        FeedDetailManager.shared.feedDetailList.results?.curriculum?.id = sender.tag
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        DispatchQueue.main.async {
            self.app_curriculum_next(curriculum_id: sender.tag)
        }
        
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 커리큘럼 데이터 변경 함수
     
     - Parameters:
        - notification: 오브젝트에 클래스 아이디가 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func dataReload(notification:Notification){
        if let temp = notification.object {
            self.class_id = temp as! Int
            DispatchQueue.main.async {
                self.app_curriculum()
            }
        }
    }
    
}

extension ChildDetailCurriculumViewController:UITableViewDelegate,UITableViewDataSource{
    
    /** **테이블 셀의 섹션당 로우 개수 함수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }else if section == 2{
            if feedAppCurriculumModel != nil{
                return (feedAppCurriculumModel?.results?.manageList.count ?? 0)!
            }else{
                return 0
            }
        }else{
            return 1
        }
    }
    
    /** **테이블 셀의 로우 및 섹션 데이터 함수 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0{
            let cell:ChildDetailCurriculumTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailCurriculumNavTableViewCell", for: indexPath) as! ChildDetailCurriculumTableViewCell
            cell.selectionStyle = .none
            return cell
        }else if section == 1{
            let cell:ChildDetailCurriculumTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CurriculumMainTitleTableViewCell", for: indexPath) as! ChildDetailCurriculumTableViewCell
            if feedAppCurriculumModel != nil{
                cell.className.text = feedAppCurriculumModel?.results?.class_name ?? ""
                if self.freeCheck == true{
                    cell.classValidty.text = "수강권 구매 시 전체 강의를 시청할 수 있습니다."
                }else{
                    cell.classValidty.text = feedAppCurriculumModel?.results?.comment ?? ""
                }
                if feedAppCurriculumModel?.results?.class_type ?? "" == "free"{
                    cell.classOutBtn.isHidden = false
                }else{
                    cell.classOutBtn.isHidden = true
                }
            }
            cell.selectionStyle = .none
            return cell
        }else{
            var cell:ChildDetailCurriculumTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CurriculumContentTableViewCell", for: indexPath) as! ChildDetailCurriculumTableViewCell
            if self.freeCheck == true{
                cell = tableView.dequeueReusableCell(withIdentifier: "CurriculumContentFreeTableViewCell", for: indexPath) as! ChildDetailCurriculumTableViewCell
                cell.curriculumPlayTimeLbl.layer.cornerRadius = 5
                cell.curriculumImg.layer.cornerRadius = 5
                if feedAppCurriculumModel != nil{
                    cell.curriculumImg.sd_setImage(with: URL(string: "\(feedAppCurriculumModel?.results?.manageList[row].photo ?? "")"), placeholderImage: UIImage(named: "curriculumV2_default"))
                    cell.curriculumTitle.text = feedAppCurriculumModel?.results?.manageList[row].title ?? ""
                    if feedAppCurriculumModel?.results?.manageList[row].duration ?? "" != "" {
                        cell.curriculumPlayTimeLbl.text = " \(feedAppCurriculumModel?.results?.manageList[row].duration ?? "") "
                    }else{
                        cell.curriculumPlayTimeLbl.text = " New "
                    }
                    if feedAppCurriculumModel?.results?.manageList[row].data ?? 0 == 0{
                        cell.curriculumChapterLbl.text = "OT"
                    }else{
                        cell.curriculumChapterLbl.text = "\(feedAppCurriculumModel?.results?.manageList[row].data ?? 0)강"
                    }
                    
                    cell.curriculumChangeBtn.tag = feedAppCurriculumModel?.results?.manageList[row].id ?? 0
                    if FeedDetailManager.shared.feedDetailList.results?.curriculum?.id == feedAppCurriculumModel?.results?.manageList[row].id{
                        if feedAppCurriculumModel?.results?.manageList[row].mcMission_stamp_id ?? 0 > 0{
                            cell.curriculumPlayImg.isHidden = true
                        }else{
                            cell.curriculumPlayImg.isHidden = false
                        }
                    }else{
                        cell.curriculumPlayImg.isHidden = true
                    }
                    cell.curriculumPlayLbl.isHidden = false
                    
                    if feedAppCurriculumModel?.results?.manageList[row].status ?? "" == "open" {
                        cell.curriculumPlayLbl.text = "전체 재생 가능"
                        cell.FreeBadge.isHidden = false
                        cell.curriculumChangeBtn.isUserInteractionEnabled = true
                    } else {
                        cell.curriculumPlayLbl.text = "수강생 전용"
                        cell.FreeBadge.isHidden = true
                        cell.curriculumChangeBtn.isUserInteractionEnabled = false
                    }
                }
            }else{
                cell.curriculumPlayTimeLbl.layer.cornerRadius = 5
                cell.curriculumImg.layer.cornerRadius = 5
                if feedAppCurriculumModel != nil{
                    cell.curriculumImg.sd_setImage(with: URL(string: "\(feedAppCurriculumModel?.results?.manageList[row].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo2"))
                    cell.curriculumTitle.text = feedAppCurriculumModel?.results?.manageList[row].title ?? ""
                    if feedAppCurriculumModel?.results?.manageList[row].duration ?? "" != "" {
                        cell.curriculumPlayTimeLbl.text = " \(feedAppCurriculumModel?.results?.manageList[row].duration ?? "") "
                    }else{
                        cell.curriculumPlayTimeLbl.text = " New "
                    }
                    if feedAppCurriculumModel?.results?.manageList[row].data ?? 0 == 0{
                        cell.curriculumChapterLbl.text = "OT"
                    }else{
                        cell.curriculumChapterLbl.text = "\(feedAppCurriculumModel?.results?.manageList[row].data ?? 0)강"
                    }

                    if feedAppCurriculumModel?.results?.manageList[row].mcMission_stamp_id ?? 0 > 0{
                        cell.curriculumMissionCheckLbl.isHidden = false
                        cell.curriculumMissionCheckImg.isHidden = false
                    }else{
                        cell.curriculumMissionCheckLbl.isHidden = true
                        cell.curriculumMissionCheckImg.isHidden = true
                    }
                    cell.curriculumChangeBtn.tag = feedAppCurriculumModel?.results?.manageList[row].id ?? 0
                    if FeedDetailManager.shared.feedDetailList.results?.curriculum?.id == feedAppCurriculumModel?.results?.manageList[row].id{
                        if feedAppCurriculumModel?.results?.manageList[row].mcMission_stamp_id ?? 0 > 0{
                            cell.curriculumMissionCompletePlayLbl.isHidden = false
                            cell.curriculumPlayLbl.isHidden = true
                            cell.curriculumPlayImg.isHidden = true
                        }else{
                            cell.curriculumMissionCompletePlayLbl.isHidden = true
                            cell.curriculumPlayLbl.isHidden = false
                            cell.curriculumPlayImg.isHidden = false
                        }
                    }else{
                        cell.curriculumMissionCompletePlayLbl.isHidden = true
                        cell.curriculumPlayLbl.isHidden = true
                        cell.curriculumPlayImg.isHidden = true
                    }
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }
    
    }
    
    /** **테이블 셀의 섹션 개수 함수 */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /** **테이블 셀의 높이 함수 */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /** **테이블 셀의 선택시 함수 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ChildDetailCurriculumViewController{
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 커리큘럼 리스트 불러오는 함수
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func app_curriculum(){
        self.feedAppCurriculumModel = FeedDetailManager.shared.feedAppCurriculumModel
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 앱 커리큘럼 다른거로 넘기는 함수
     
     - Parameters:
        - curriculum_id: 커리큘럼 아이디
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func app_curriculum_next(curriculum_id:Int){
        FeedApi.shared.curriculum_next(class_id: self.class_id, curriculum_id:curriculum_id ,success: { [unowned self] result in
            if result.code == "200"{
                UIView.animate(withDuration: self.animationDuration, animations: {
                    self.slideViewVerticallyTo(self.view.frame.size.height)
                }, completion: { (isCompleted) in
                    if isCompleted {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: "")
                        self.slideViewVerticallyTo(0)
                    }
                })
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                
            })
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 클래스 나가기 ( 무료인경우 )
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func app_class_out(){
        FeedApi.shared.class_out(class_id: self.class_id,success: { [unowned self] result in
            if result.code == "200"{
                FeedApi.shared.appClassData(class_id:self.class_id,success: { [unowned self] result in
                    if result.code == "200"{
                        if let parentVC = self.parent as? FeedDetailViewController {
                            parentVC.videoStop()
                        }
                        Alert.With(self, title: "알림", content: "클래스를 나가셨습니다.", btn1Title: "확인", btn1Handler: {
                           
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }) { error in
                    Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                        
                    })
                }
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                
            })
        }
    }
}

extension ChildDetailCurriculumViewController: UIGestureRecognizerDelegate,UIScrollViewDelegate{
    
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
