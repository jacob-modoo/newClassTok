//
//  ChildDetailClassViewController.swift
//  modooClass
//
//  Created by 조현민 on 05/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CropViewController

/**
# ChildDetailClassViewController.swift 클래스 설명
 
 ## UIViewController 상속 받음
 - 클래스 참여 화면에 자식 뷰 컨트롤러
 */
class ChildDetailClassViewController: UIViewController {
    
    @IBOutlet weak var scrapCount: UIFixedLabel!
    @IBOutlet weak var scrapImg: UIImageView!
    @IBOutlet weak var scrapBtn: UIButton!
    @IBOutlet weak var tableViewBottom2: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottom1: NSLayoutConstraint!
    @IBOutlet weak var coachQuestionView: UIView!
    @IBOutlet weak var paymentView: UIView!
    /** **댓글 보내기 버튼*/
    @IBOutlet weak var replySendBtn: UIButton!
    /** **댓글 보내기 넓이 값*/
    @IBOutlet weak var replySendBtnWidthConst: NSLayoutConstraint!
    /** **댓글 입력창 감싸는 뷰*/
    @IBOutlet weak var replySendView: UIView!
    /** **테이블뷰 */
    @IBOutlet weak var tableView: UITableView!
    /** **댓글 입력 텍스트뷰 */
    @IBOutlet weak var replyTextView: UITextView!
    /** **댓글 입력 전 PlaceHolder용 라벨 */
    @IBOutlet weak var replyTextViewLbl: UILabel!
    /** **댓글 입력 텍스트뷰 높이 */
    @IBOutlet weak var replyTextViewHeight: NSLayoutConstraint!
    /** **다음강의 or 리뷰 or 미션 버튼 */
    @IBOutlet weak var classMoveBtn: UIButton!
    /** **댓글 테두리 뷰 */
    @IBOutlet weak var replyBorderView: UIView!
    /** **댓글 이모티콘 버튼 */
    @IBOutlet weak var replyEmoticonBtn: UIButton!
    /** **선택된 이모티콘 뷰 나가기 버튼 */
    @IBOutlet weak var emoticonViewExitBtn: UIButton!
    /** **선택된 이모티콘 뷰 */
    @IBOutlet weak var emoticonSelectView: UIView!
    /** **이모티콘 이미지뷰 */
    @IBOutlet weak var emoticonImg: UIImageView!
    /** **클래스 커리큘럼 소개 리스트 */
    var feedDetailList:FeedAppClassModel?
    /** **클래스 커리큘럼 댓글 리스트 */
    var feedReplyList:FeedAppClassDetailReplyModel?
    /** **클래스 커리큘럼 댓글 배열 */
    var replyArray:Array? = Array<AppClassCommentList>()
    var memberList:FeedAppClassConditionInfoModel?
    /** **이모티콘 구분 숫자 */
    var emoticonNumber:Int = 0
    /** **클래스 아이디 */
    var class_id = 0
    /** **댓글 페이징 */
    var page = 1
    /** *filtering variable*/
    var type = "all"
    /** **키보드 숨김 유무 */
    var keyboardShow = false
    /** **커리큘럼 소개 표시 유무 */
    var showContent:Bool = false
    /** **커리큘럼 만족하기 뷰 숨김 유무 */
    var curriculumLikeViewHidden:Bool = true
    /** **키보드 위 이모티콘 뷰 올리기 위한 뷰 */
    var customView: UIView?
    /** **키보드 사이즈 */
    var keyBoardSize:CGRect?
    
    var curriculum_id:Int?
    /** **Html 렌더링을 위한 뷰 */
    var classTextView:UITextView?
    private let imageView = UIImageView()
    /** **미션 이미지 */
    private var image: UIImage?
    /** **사진 크롭 스타일 */
    private var croppingStyle = CropViewCroppingStyle.default
    /** **크롭 사이즈 */
    private var croppedRect = CGRect.zero
    /** **크롭 각도 */
    private var croppedAngle = 0
    /** **이모티콘 확장 뷰 */
    lazy var emoticonView: EmoticonView? = {
        let tv = EmoticonView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    @IBOutlet weak var classMoveBtnWidthConst: NSLayoutConstraint!
    @IBOutlet weak var questionImg: UIImageView!
    @IBOutlet weak var questionBtn: UIButton!
    var cheerViewExitCheck = false
    let home2WebViewStoryboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
 //       NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardFrameWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.classIdCheck), name: NSNotification.Name(rawValue: "DetailClassIdSend"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.replyParamChange), name: NSNotification.Name(rawValue: "curriculumParamChange"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.replyDeleteChange), name: NSNotification.Name(rawValue: "curriculumReplyDelete"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.classLikeView), name: NSNotification.Name(rawValue: "classLikeView"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.noticeReplyDelete), name: NSNotification.Name(rawValue: "noticeReplyDelete"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.noticeParamChange), name: NSNotification.Name(rawValue: "noticeParamChange"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.chattingCheck), name: NSNotification.Name(rawValue: "classDetailchattingValueSend"), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(self.flashNextClassBtn), name: NSNotification.Name(rawValue: "flashNextClassBtn"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLikeCount), name: NSNotification.Name(rawValue: "updateLikeCount"), object: nil)

        replyBorderView.layer.borderWidth = 1
        replyBorderView.layer.borderColor = UIColor(hexString: "#eeeeee").cgColor
        replyBorderView.layer.cornerRadius = 15
        replyTextView.layer.cornerRadius = 15
        replyTextView.autocorrectionType = .no

        coachQuestionView.layer.shadowColor = UIColor(hexString: "#757575").cgColor
        coachQuestionView.layer.shadowOffset = CGSize(width: 0.0, height: -6.0)
        coachQuestionView.layer.shadowOpacity = 0.05
        coachQuestionView.layer.shadowRadius = 4
        coachQuestionView.layer.masksToBounds = false

        emoticonView?.WithEmoticon { [unowned self] eNumber in
            self.emoticonSelectView.isHidden = false
            self.emoticonImg.image = UIImage(named: "emti\(eNumber+1)")
            self.emoticonNumber = eNumber+1
            self.image = nil
        }
        
        let dismiss = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(dismiss)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        replyArray = nil
        print("ChildDetailClassViewController deinit")
    }
    
    /** **부모 뷰가 움직일때 */
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent:parent)
    }
    
    /** **부모 뷰가 움직인뒤 */
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent:parent)
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.feedDetailList?.results?.user_status ?? "" != "spectator" {
            let checkGuide = UserDefaultSetting.getUserDefaultsInteger(forKey: "checkGuide")
            if checkGuide == 1{
                print("the guide is already has been shown!")
            } else {
                let done = 1
                UserDefaultSetting.setUserDefaultsInteger(done, forKey: "checkGuide")
                self.moveGuide()
            }
        }else {
            print("user status is 'spectator'")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        print("ChildDetailClassViewController viewDidDisappear")
//        emoticonView = nil
    }
    
    /** **클래스 소개 보기 버튼 클릭 > 클래스 소개를 펼쳐줌 */
    @IBAction func classContentBtnClicked(_ sender: UIButton) {
        self.showContent = !self.showContent
        DispatchQueue.main.async {
            if self.showContent == true{
                sender.setImage(UIImage(named: "arrow_top_gray"), for: .normal)
                self.tableView.reloadSections([1,2,3], with: .fade)
            }else{
                sender.setImage(UIImage(named: "arrow_bottom_gray"), for: .normal)
                self.tableView.reloadSections([1,2,3], with: .fade)
            }
            
        }
    }
    
    func videoStop(){
        if let parentVC = self.parent as? FeedDetailViewController {
            parentVC.videoStop()
        }else{}
    }
    
    func moveGuide() {
        videoStop()
        let url = HomeMain2Manager.shared.pilotAppMain.results?.app_guidance_link ?? "https://www.modooclass.net/class/activityguidance"
        let newViewController = UIStoryboard(name: "ChildWebView", bundle: nil).instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = url
        
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    /** **클래스 메뉴의 버튼 클릭 > 1-커리큘럼 만족 2-응원하기 3-커리큘럼보기 4-그룹채팅 or 채팅관리 */
    @IBAction func menuBtnClicked(_ sender: UIButton) {
        if sender.tag == 1 {
            Indicator.showActivityIndicator(uiView: self.view)
            curriculumLike(sender: sender)
        }else if sender.tag == 2{
            if self.feedDetailList?.results?.user_status ?? "" == "spectator" {
                if let parentVC = self.parent as? FeedDetailViewController {
                    self.view.endEditing(true)
                    parentVC.tableViewCheck = 4
                    parentVC.detailClassData()
                }else{}
            } else {
                self.showContent = !self.showContent
                DispatchQueue.main.async {
                    if self.showContent == true{
                        self.tableView.reloadSections([1,2,3], with: .fade)
                    }else{
                        self.tableView.reloadSections([1,2,3], with: .fade)
                    }
                }
            }
        }else if sender.tag == 3{
            self.view.endEditing(true)
            self.emoticonSelectView.isHidden = true
            if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
                replyWriteCheck()
            }else{
                self.view.endEditing(true)
                
                if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                    if let parentVC = self.parent as? FeedDetailViewController {
                        parentVC.tableViewCheck = 3
                        parentVC.detailClassData()
                    }else{}
                }else{
                    videoStop()
                    self.feedDetailList?.results?.chatState = "N"
                    let newViewController = UIStoryboard(name: "ChildWebView", bundle: nil).instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                    if UserManager.shared.userInfo.results?.user?.id == self.feedDetailList?.results?.curriculum?.coach_class?.coach_id {
                        newViewController.url = self.feedDetailList?.results?.coachCommunityAddress ?? ""
                    }else{
                        newViewController.url = self.feedDetailList?.results?.memberAddress ?? ""
                    }
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }
            }
        }else{
            self.view.endEditing(true)
            self.emoticonSelectView.isHidden = true
            if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
                replyWriteCheck()
            }else{
                self.view.endEditing(true)
                if UserManager.shared.userInfo.results?.user?.id == self.feedDetailList?.results?.coach_id {
                    let newViewController = UIStoryboard(name: "ChildWebView", bundle: nil).instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                    newViewController.url = self.feedDetailList?.results?.coachCommunityAddress ?? ""
                    self.navigationController?.pushViewController(newViewController, animated: true)
                } else {
                 let parentVC = self.parent as? FeedDetailViewController
                    parentVC?.tableViewCheck = 5
                    parentVC?.share_content = self.feedDetailList?.results?.share_content ?? ""
                    parentVC?.share_img = self.feedDetailList?.results?.share_image ?? ""
                    parentVC?.share_address = self.feedDetailList?.results?.share_address ?? ""
                    parentVC?.share_point = self.feedDetailList?.results?.share_point ?? ""
                    parentVC?.class_photo = self.feedDetailList?.results?.class_photo ?? ""
                    //parentVC?.class_info = self.feedDetailList?.results?.class_info ?? ""
                    parentVC?.class_name = self.feedDetailList?.results?.class_name ?? ""
                    parentVC?.detailClassData()
                    
                    tableView.reloadData()
                }
            }
        }
    }
    
    /** **친구 사진 버튼 클릭 > 친구 프로필로 이동 ( ProfileFriendViewController ) */
    @IBAction func coachfriendProfileBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            videoStop()
            if UserManager.shared.userInfo.results?.user?.id == sender.tag{
                let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
                newViewController.user_id = self.feedDetailList?.results?.curriculum?.coach_class?.coach_id ?? 0
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else{
                self.view.endEditing(true)
                let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
                newViewController.user_id = self.feedDetailList?.results?.curriculum?.coach_class?.coach_id ?? 0//sender.tag
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
    }
    
    /** **친구 사진 버튼 클릭 > 친구 프로필로 이동 ( ProfileFriendViewController ) */
    @IBAction func friendProfileBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            videoStop()
            if UserManager.shared.userInfo.results?.user?.id == sender.tag{
                let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
                newViewController.user_id = self.replyArray?[sender.tag].user_id ?? 0
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else{
                self.view.endEditing(true)
                let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
                newViewController.user_id = self.replyArray?[sender.tag].user_id ?? 0
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
    }
    @IBAction func reviewUserProfileBtnClicked(_ sender: UIButton) {
        let newViewController = self.home2WebViewStoryboard.instantiateViewController(withIdentifier: "ProfileV2ViewController") as! ProfileV2ViewController
        newViewController.user_id = sender.tag
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    /** **친구 사진 버튼 클릭 > 친구 프로필로 이동 ( ProfileFriendViewController ) */
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        haveSave(sender: sender)
    }
    
    @IBAction func likeCountBtnClicked(_ sender: UIButton) {
        let row = sender.tag / 10000
        let likeValue = replyArray?[row].like_me ?? ""
        let comment_id = replyArray?[row].id ?? 0
        if likeValue == "N" {
             haveSave(sender: sender)
        } else {
            let nextView = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "ReplyLikeViewController") as! ReplyLikeViewController
            nextView.modalPresentationStyle = .overFullScreen
            nextView.replyArray = replyArray
            nextView.comment_id = comment_id
            nextView.viewCheck = "childDetail"
            self.present(nextView, animated:true,completion: nil)
        }
        
    }
    
    /** **이모티콘 닫기 버튼 클릭 > 이모티콘뷰 닫기 */
    @IBAction func emoticonViewExitBtnClicked(_ sender: UIButton) {
        emoticonSelectView.isHidden = true
        emoticonImg.image = nil
        self.image = nil
    }
    
    @IBAction func questionBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 0{
            sender.tag = 1
            self.replyTextView.becomeFirstResponder()
            self.questionImg.image = UIImage(named: "question_checkbox_true")
            self.replyTextView.text = "#질문 \(self.replyTextView.text ?? "")"
            self.replyTextView.attributedText = resolveHashTags(text: self.replyTextView.text)
            
            self.replyTextView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
            self.replyTextViewLbl.isHidden = true
        }else{
            sender.tag = 0
            self.questionImg.image = UIImage(named: "question_checkbox_false")
            let str = self.replyTextView.text ?? ""
            self.replyTextView.text = str.replace(target:"#질문 ", withString: "")
            
            if self.replyTextView.text.isEmpty {
                self.replyTextViewLbl.isHidden = false
            }else{
                self.replyTextViewLbl.isHidden = true
            }
        }
    }
    @IBAction func videoManaginBtnClicked(_ sender: UIButton) {
        
        let tag = sender.tag
        if tag == 1 {
            if self.feedDetailList?.results?.user_status == "spectator" {
                if self.feedDetailList?.results?.curriculum_before_id ?? 0 == 0 {
                    self.showToast(message: "        🔊 체험판은 강의 이동이 불가합니다.>.<수강신청 하기.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
                } else {
                    FeedApi.shared.curriculum_next(class_id: self.feedDetailList?.results?.mcClass_id ?? 0, curriculum_id: self.feedDetailList?.results?.curriculum_before_id ?? 0 ,success: { [unowned self] result in
                        if result.code == "200"{
                            self.navigationController?.popToViewBottomController(ofClass: FeedDetailViewController.self)
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: "")
                            }
                        }
                    }) { error in
                        Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {

                        })
                    }
                }
            } else {
                if self.feedDetailList?.results?.curriculum?.id ?? 0 != self.feedDetailList?.results?.curriculum_before_id ?? 0 {
                    self.type = "all"
                    self.curriculum_id = feedDetailList?.results?.curriculum?.id ?? 0
                }
                if self.feedDetailList?.results?.curriculum_before_id ?? 0 == 0 {
                    self.showToast(message: "        🔊 첫번째 강의 입니다.>.<더이상 이동할수 없습니다.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
                } else {
                    FeedApi.shared.curriculum_next(class_id: feedDetailList?.results?.mcClass_id ?? 0, curriculum_id: feedDetailList?.results?.curriculum?.button_before_id ?? 0 ,success: { [unowned self] result in
                        if result.code == "200"{
                            self.navigationController?.popToViewBottomController(ofClass: FeedDetailViewController.self)
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: "")
                            }
                        } else {
                            // write popup notification function here
                        }
                    }) { error in
                        Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                            
                        })
                    }
                }
            }
        } else if tag == 2 {
            self.view.endEditing(true)
            self.emoticonSelectView.isHidden = true
            if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
                replyWriteCheck()
            }else{
                self.view.endEditing(true)
                if let parentVC = self.parent as? FeedDetailViewController {
                    parentVC.tableViewCheck = 2
                    parentVC.detailClassData()
                }else{}
            }
        } else {
            if self.feedDetailList?.results?.user_status == "spectator" {
                if self.feedDetailList?.results?.curriculum_after_id ?? 0 == 0 {
                    print("afterID is called")
                    self.showToast(message: "        🔊 체험판은 강의 이동이 불가합니다.>.<수강신청 하기.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
                } else {
                    FeedApi.shared.curriculum_next(class_id: self.feedDetailList?.results?.mcClass_id ?? 0, curriculum_id: self.feedDetailList?.results?.curriculum_after_id ?? 0 ,success: { [unowned self] result in
                        if result.code == "200"{
                            self.navigationController?.popToViewBottomController(ofClass: FeedDetailViewController.self)
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: "")
                            }
                        }
                    }) { error in
                        Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {

                        })
                    }
                }
            } else {
                if self.feedDetailList?.results?.curriculum?.id ?? 0 != self.feedDetailList?.results?.curriculum_after_id ?? 0 {
                    self.type = "all"
                }
                if self.feedDetailList?.results?.curriculum_after_id ?? 0 == 0{
                    self.view.endEditing(true)
                    let newViewController = UIStoryboard(name: "ChildWebView", bundle: nil).instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                    newViewController.url = self.feedDetailList?.results?.curriculum?.button_review ?? ""
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }else{
                    FeedApi.shared.curriculum_next(class_id: self.feedDetailList?.results?.mcClass_id ?? 0, curriculum_id: self.feedDetailList?.results?.curriculum_after_id ?? 0 ,success: { [unowned self] result in
                        if result.code == "200"{
                            self.navigationController?.popToViewBottomController(ofClass: FeedDetailViewController.self)
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: "")
                            }
                        }
                    }) { error in
                        Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {

                        })
                    }
                }
            }
        }
    }
   
    /** **강의 이동 버튼 클릭 > 다음강의 or 리뷰 or 미션 분기  */
    @IBAction func classMoveBtnClicked(_ sender: UIButton) {
        
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            DispatchQueue.main.async {
                self.videoStop()
            }
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            let cell = self.tableView.cellForRow(at: indexPath) as! ChildDetailClassTableViewCell
            let newViewController = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "DetailMissionCompleteViewController") as! DetailMissionCompleteViewController
            
            //if feedDetailList?.results?.curriculum?.button_api ?? "" == "curriculum_next" || feedDetailList?.results?.curriculum?.button_api ?? "" == "review" {
                if feedDetailList?.results?.mission_yn ?? "Y" == "N" {
                    //self.classMoveBtn.setImage(UIImage(named: "mission_done"), for: .normal)
                    //self.classMoveBtn.isUserInteractionEnabled = false
                    self.showToast2(message: "🔊 미션이 완료 했습니다.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
                } else {
                    if feedDetailList?.results?.mission_count ?? 0 > 0 {
                        //self.classMoveBtn.setImage(UIImage(named: "mission_do-again"), for: .normal)
                        self.view.endEditing(true)
                        newViewController.mission_id = feedDetailList?.results?.curriculum?.mission?.id ?? 0
                        self.navigationController?.pushToViewBottomController(vc: newViewController)
                        cell.classLikeView.isHidden = false
                    } else {
                        //self.classMoveBtn.setImage(UIImage(named: "mission_check"), for: .normal)
                        newViewController.mission_id = feedDetailList?.results?.curriculum?.mission?.id ?? 0
                        self.navigationController?.pushToViewBottomController(vc: newViewController)
                    }
                    
                }
//            }else{
//
//            }
        }
    }
    
    
    @IBAction func curriculumMoreBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            self.view.endEditing(true)
            if let parentVC = self.parent as? FeedDetailViewController {
                parentVC.tableViewCheck = 2
                parentVC.detailClassData()
            }else{}
        }
    }
    
    /** **댓글 더 읽기 버튼 클릭 > 댓글 상세 뷰로 이동 ( DetailReplyViewController ) */
    @IBAction func readMoreBtnClicked(_ sender: UIButton) {
        print(feedDetailList?.results?.user_status ?? "")
        if feedDetailList?.results?.user_status == "spectator" {
            self.showToast(message: "        🔊 체험판은 강의 이동이 불가합니다.>.<수강신청 하기.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
        } else {
            let tag = sender.tag
            self.view.endEditing(true)
            self.emoticonSelectView.isHidden = true
            if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
                replyWriteCheck()
            }else{
                self.view.endEditing(true)
                videoStop()
                let newViewController = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "DetailReplyViewController") as! DetailReplyViewController
                newViewController.comment_id = replyArray?[tag].id ?? 0
                newViewController.curriculum_id = self.feedDetailList?.results?.curriculum?.id ?? 0
                newViewController.class_id = self.class_id
                newViewController.commentType = "curriculum"
                newViewController.missionCheck = false
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
    }
    
    /** **공지사항 더 읽기 버튼 클릭 > 공지사항 상세 뷰로 이동 ( DetailReplyViewController ) */
    @IBAction func noticeReadMoreBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            self.view.endEditing(true)
            videoStop()
            let newViewController = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "DetailReplyViewController") as! DetailReplyViewController
            newViewController.comment_id = sender.tag
            newViewController.curriculum_id = self.feedDetailList?.results?.curriculum?.id ?? 0
            newViewController.class_id = self.class_id
            newViewController.commentType = "curriculum"
            newViewController.missionCheck = false
            newViewController.noticeCheck = true
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    /** **이모티콘 클릭 > 이모티콘셀렉 뷰에 이미지 보이기 */
    @IBAction func replyEmoticonBtnClicked(_ sender: UIButton) {
        replyTextView.becomeFirstResponder()
        DispatchQueue.main.async {
            if self.customView == nil {
                self.customView = UIView.init(frame: CGRect.init(x: 0, y: (self.keyBoardSize?.origin.y)!, width: self.view.frame.width, height: self.keyBoardSize!.height))
                self.customView?.addSubview(self.emoticonView ?? UIView.init(frame: CGRect.zero))
                self.emoticonView?.snp.makeConstraints { (make) in
                    make.bottom.top.leading.trailing.equalToSuperview()
                }
                let tapOut: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.textViewTab))
                self.replyTextView.addGestureRecognizer(tapOut)
                UIApplication.shared.windows.last?.addSubview(self.customView ?? UIView.init(frame: CGRect.zero))
            }else {
                self.customView?.removeFromSuperview()
                self.customView = nil
            }
        }
    }
    
    /** **댓글 입력완료 버튼 클릭 > 댓글을 서버에 저장 */
    @IBAction func replySendBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.replyTextView.text?.isBlank == false || self.emoticonImg.image != nil{
            replySend(sender:sender)
        }else{
            Alert.With(self, title: "댓글을 입력해주세요", btn1Title: "확인", btn1Handler: {
                self.replyTextView.becomeFirstResponder()
            })
        }
    }
    
    /** **댓글 더보기 클릭 > 댓글을 삭제할지 선택 */
    @IBAction func moreBtnClicked(_ sender: UIButton) {
        Alert.With(self, btn1Title: "삭제", btn1Handler: {
            DispatchQueue.main.async {
                self.replyDelete(comment_id: sender.tag)
            }
        })
    }
    
    /** **강의를 만족해주세요 뷰 나가기 버튼 클릭 > 강의 만족 뷰 없애기 */
    @IBAction func classLikeViewExitBtnClicked(_ sender: UIButton) {

        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ChildDetailClassTableViewCell
        cell.classLikeView.fadeOut(completion: {
                (finished: Bool) -> Void in
            cell.classLikeView.isHidden = true
        })
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        if imageView.image != nil{
            Alert.WithImageView(self, image: imageView.image!, btn1Title: "", btn1Handler: {
                
            })
        }
    }
    
    /** **이미지 버튼 클릭 > 앨범, 카메라 이동 */
    @IBAction func imagePickerBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        imagePicked()
    }
    
    @IBAction func reviewMoveBtn(_ sender: UIButton) {
        if let parentVC = self.parent as? FeedDetailViewController {
            parentVC.tableViewCheck = 3
            parentVC.detailClassData()
        }else{}
    }
    
    
    @IBAction func coachFriendBtnClicked(_ sender: UIButton) {
        if sender.tag == 1{
            friend_add(sender: sender)
        }else{
            videoStop()
            let newViewController = UIStoryboard(name: "ChattingWebView", bundle: nil).instantiateViewController(withIdentifier: "ChattingFriendWebViewViewController") as! ChattingFriendWebViewViewController
            
            newViewController.url = self.feedDetailList?.results?.coach_chat_address ?? ""
            newViewController.tokenCheck = true
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    @IBAction func paymentBtnClicked(_ sender: UIButton) {
        videoStop()
        let newViewController = UIStoryboard(name: "ChildWebView", bundle: nil).instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = self.feedDetailList?.results?.package_address ?? ""
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func scrapBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        var type = ""
        if tag == 1{
            type = "post"
        }else{
            type = "delete"
        }
        
        FeedApi.shared.class_have(class_id:self.class_id,type:type,success: { [unowned self] result in
            if result.code == "200"{
                if tag == 1{
                    sender.tag = 2
                    self.feedDetailList?.results?.classScrap_cnt = (self.feedDetailList?.results?.classScrap_cnt ?? 0) + 1
//                    self.scrapBtn.setImage(UIImage(named:"participation_scrap_active"), for: .normal)
                    self.scrapImg.image = UIImage(named:"participation_scrap_active")
                    self.scrapCount.textColor = UIColor(hexString: "#FF0F16")
//                    self.scrapCount.fontWeight = .Bold
                    self.scrapCount.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12.5)!
                }else{
                    sender.tag = 1
                    self.feedDetailList?.results?.classScrap_cnt = (self.feedDetailList?.results?.classScrap_cnt ?? 0) - 1
                    self.scrapImg.image = UIImage(named:"participation_scrap_default")
                    self.scrapCount.textColor = UIColor(hexString: "#1A1A1A")
//                    self.scrapCount.fontWeight = .Regular
                    self.scrapCount.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12.5)!
//                    self.scrapBtn.setImage(UIImage(named:"participation_scrap_default"), for: .normal)
                }
                
                self.scrapCount.text = "\(self.feedDetailList?.results?.classScrap_cnt ?? 0)"
            }
        }) { error in
            
        }
    }
    
    /** *This button is used to filter comments*/
    @IBAction func filteringBtnClicked(_ sender: UIButton) {
        if sender.tag == 0 {
            self.type = "all"
            filteredComment(type: self.type)
            print(self.type)
        } else if sender.tag == 1 {
            self.type = "questions"
            filteredComment(type: self.type)
            print(self.type)
        } else {
            self.type = "coach"
            filteredComment(type: self.type)
            print(self.type)
        }
    }
    
    /** *The function which filters the comments */
    func filteredComment(type:String) {
        self.replyArray?.removeAll()
        DispatchQueue.main.async {
            if self.feedDetailList?.results?.user_status ?? "" != "spectator" {
                self.appDetailComment(curriculum_id: self.feedDetailList?.results?.curriculum?.id ?? 0, page: self.page, type: type)
            }
        }
    }
    
    //MARK: - Image Picked Method (from Photos or Camera)
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 이미지 선택을 위한 알림창 띄움 앨범 or 카메라
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    
    func imagePicked(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "사진첩", style: .default) { (action) in
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .overFullScreen
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let profileAction = UIAlertAction(title: "카메라", style: .default) { (action) in
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.modalPresentationStyle = .overFullScreen
            //            imagePicker.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
            imagePicker.preferredContentSize = CGSize(width: 320, height: 568)
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        alertController.addAction(profileAction)
        alertController.addAction(defaultAction)
        alertController.modalPresentationStyle = .overFullScreen
        
        //        let presentationController = alertController.popoverPresentationController
        //        presentationController?.barButtonItem = (sender as! UIBarButtonItem)
        present(alertController, animated: true, completion: nil)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 >친구 추가 or 삭제 함수
     
     - Parameters:
        - sender: 버튼 태그
     
    - Throws: `Error` 값의 타입이 제대로 넘어오지 않을 경우 `Error`
    */
    func friend_add(sender: UIButton){
        let user_id = self.feedDetailList?.results?.coach_id ?? 0
        let friend_status = self.feedDetailList?.results?.friend_status ?? "N"
        FeedApi.shared.friend_add(user_id: user_id,friend_status:friend_status,success: { [unowned self] result in
            if result.code == "200"{
                sender.setImage(UIImage(named: "messageImgV2"), for: .normal)
                self.feedDetailList?.results?.friend_status = "Y"
                sender.tag = 2
            }
        }) { error in
            
        }
    }
    
    /**
     - will update the count of likes in comment section [8] in tableView
     */
//    @objc func updateLikeCount(notification: Notification) {
//        guard let preHave = notification.userInfo?["preHave"] as? String else { return }
////        guard let commentLikeCount = notification.userInfo?["commentLikeCount"] as? Int else { return }
//
//        for i in 0..<replyArray!.count {
//            if replyArray?[i].like_me != preHave { //|| replyArray?[i].like != commentLikeCount{
//                replyArray?[i].like_me = preHave
////                replyArray?[i].like = commentLikeCount
//                let indexPath = IndexPath(row: i, section: 8)
//                if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
//                    if visibleIndexPaths != NSNotFound {
//                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
//                    }
//                }
//            } else {
//                replyArray?[i].like_me = preHave
////                replyArray?[i].like = commentLikeCount
//            }
//        }
//        print("post recieved!\n\(replyArray?.count ?? 999)\nlikeIsEqual: \(String(describing: replyArray?[0].like))\nlikeMeIsEqual: \(String(describing: replyArray?[0].like_me))")
////        let indexSet: IndexSet = [8]
////        self.tableView.reloadSections(indexSet, with: .automatic)
//    }
//
    @objc func chattingCheck(notification:Notification){
        guard let chattingUrl = notification.userInfo?["chattingUrl"] as? String else { return }
        videoStop()
        let newViewController = UIStoryboard(name: "ChattingWebView", bundle: nil).instantiateViewController(withIdentifier: "ChattingFriendWebViewViewController") as! ChattingFriendWebViewViewController
        print(chattingUrl)
        newViewController.url = chattingUrl
        newViewController.tokenCheck = true
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    /** **will hide keyboard when view is tapped */
    @objc func hideKeyboard() {
        view.endEditing(true)
        print("view is tapped!")
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 공지사항 데이터 변경 함수
     
     - Parameters:
        - notification: 오브젝트에 댓글갯수 , 댓글 좋아요 갯수 , 나의 찜 여부 가 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func noticeParamChange(notification: Notification){
        guard let replyCount = notification.userInfo?["replyCount"] as? Int else { return }
        guard let commentLikeCount = notification.userInfo?["commentLikeCount"] as? Int else { return }
        guard let preHave = notification.userInfo?["preHave"] as? String else { return }
        
        self.tableView.beginUpdates()
        if self.feedDetailList?.results?.curriculum?.coach_class?.notice?.like_cnt != commentLikeCount || self.feedDetailList?.results?.curriculum?.coach_class?.notice?.reply_cnt != replyCount || self.feedDetailList?.results?.curriculum?.coach_class?.notice?.like_me != preHave{
            
            self.feedDetailList?.results?.curriculum?.coach_class?.notice?.like_cnt = commentLikeCount
            self.feedDetailList?.results?.curriculum?.coach_class?.notice?.reply_cnt = replyCount
            self.feedDetailList?.results?.curriculum?.coach_class?.notice?.like_me = preHave
            
        }else{
            self.feedDetailList?.results?.curriculum?.coach_class?.notice?.like_cnt = commentLikeCount
            self.feedDetailList?.results?.curriculum?.coach_class?.notice?.reply_cnt = replyCount
            self.feedDetailList?.results?.curriculum?.coach_class?.notice?.like_me = preHave
        }
        self.tableView.endUpdates()
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 댓글 데이터 변경 함수
     
     - Parameters:
        - notification: 오브젝트에 댓글갯수 , 댓글 좋아요 갯수 , 나의 찜 여부 , 댓글 아이디가 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func replyParamChange(notification: Notification){
        guard let comment_id = notification.userInfo?["comment_id"] as? Int else { return }
        guard let replyCount = notification.userInfo?["replyCount"] as? Int else { return }
        guard let commentLikeCount = notification.userInfo?["commentLikeCount"] as? Int else { return }
        guard let preHave = notification.userInfo?["preHave"] as? String else { return }
        for i in 0..<replyArray!.count {
            if replyArray?[i].id == comment_id {
                if replyArray?[i].like != commentLikeCount || replyArray?[i].reply_count != replyCount || replyArray?[i].like_me != preHave {
                    replyArray?[i].like = commentLikeCount
                    replyArray?[i].reply_count = replyCount
                    replyArray?[i].like_me = preHave
                    let indexPath = IndexPath(row: i, section: 8)
                    if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                        if visibleIndexPaths != NSNotFound {
                            self.tableView.reloadRows(at: [indexPath], with: .none)
                        }
                    }
                }else{
                    replyArray?[i].like = commentLikeCount
                    replyArray?[i].reply_count = replyCount
                    replyArray?[i].like_me = preHave
                }
            }
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 텍스트뷰를 탭한경우 이모티콘 뷰를 숨기는 함수
     
     - Throws: `Error` 이모티콘뷰가 이미 없는 경우 `Error`
     */
    @objc func textViewTab(){
        if self.customView != nil {
            self.customView?.removeFromSuperview()
            self.customView = nil
        }
        self.replyTextView.becomeFirstResponder()
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 댓글 데이터 변경 함수
     
     - Parameters:
        - notification: 오브젝트에 클래스 아이디가 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func classIdCheck(notification: Notification){
        Indicator.showActivityIndicator(uiView: self.view)
        if let temp = notification.object {
            self.class_id = temp as! Int
            DispatchQueue.main.async {
                self.replyArray?.removeAll()
                self.page = 1
                self.appClassDetail()
            }
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 강의 만족뷰를 보여주는 함수
     
     - Parameters:
     - notification: 오브젝트에 클래스 아이디가 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func classLikeView(notification: Notification){
        if self.feedDetailList?.results?.curriculum?.like_me ?? "N" == "N"{
            if let temp = notification.object {
                if temp as? String == "true"{
                    curriculumLikeViewHidden = true
                }else{
                    curriculumLikeViewHidden = false
                }
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                    if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                        if visibleIndexPaths != NSNotFound {
                            let cell = self.tableView.cellForRow(at: indexPath) as! ChildDetailClassTableViewCell
                            if self.curriculumLikeViewHidden == false{
                                cell.classLikeView.isHidden = false
                                DispatchQueue.main.async {
                                    cell.classLikeView.fadeIn(completion: {
                                        (finished: Bool) -> Void in
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }else{
            
        }
    }
    
    /**
     ** this is to flash next class btn
     */
    @objc func flashNextClassBtn(notification: Notification){
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as! ChildDetailClassTableViewCell
        cell.nextClassBtn.flash()
        print("message received!")
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 공지사항 댓글을 삭제 하는 함수
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func noticeReplyDelete(notification:Notification){
        self.feedDetailList?.results?.curriculum?.coach_class?.notice = nil
        DispatchQueue.main.async {
            self.tableView.reloadSections([4], with: .automatic)
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 키보드가 보일때 함수
     
     - Parameters:
        - notification: 키보드가 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     
     Use either keyboardWillChange or next 2 functions (willShow & willHide)
     
     */
//    @objc func keyboardFrameWillChange(notification: Notification) {
//
//        if #available(iOS 11.0, *) {
//        guard let userInfo = notification.userInfo,
//            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//            else {
//                return
//        }
//
//            let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
//            let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
//            let intersection = safeAreaFrame.intersection(keyboardFrameInView)
//
//            let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
//            let animationDuration : TimeInterval = (keyboardAnimationDuration as? NSNumber)?.doubleValue ?? 0
//            let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
//            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
//            let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
//
//            UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: {
//                self.additionalSafeAreaInsets.bottom = intersection.height
//                self.replySendBtnWidthConst.constant = 30
//                self.classMoveBtn.alpha = 0
//                self.classMoveBtnWidthConst.constant = 0
//                self.view.layoutIfNeeded()
//
//            }, completion: nil)
//
//            self.keyboardShow = true
//            self.coachQuestionView.isHidden = false
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        }
//
//    }
    
    
    @objc func keyboardWillShow(notification: Notification) {
            
            guard let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                
                else {
                    return
                }

                UIView.animate(withDuration: 0, animations: {
                    if #available(iOS 11.0, *) {
                        self.keyBoardSize = kbSize
                        let keyboardFrameInView = self.view.convert(self.keyBoardSize!, from: nil)
                        let safeAreaFrame = self.view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -self.additionalSafeAreaInsets.bottom)
                        let intersection = safeAreaFrame.intersection(keyboardFrameInView)

                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
                            self.additionalSafeAreaInsets.bottom = intersection.height
                            self.replySendBtnWidthConst.constant = 30
                            self.classMoveBtn.alpha = 0
                            self.classMoveBtnWidthConst.constant = 0
                            self.view.layoutIfNeeded()
                        }, completion: nil)

                        self.keyboardShow = true
        //                    if APPDELEGATE?.topMostViewController()?.isKind(of: FeedDetailViewController.self) == true{
                            self.coachQuestionView.isHidden = false
        //                    }
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    }
                }) {
                    success in
        }
    }


    /**
    **파라미터가 있고 반환값이 없는 메소드 > 키보드가 보이지 않을때 함수

     - Parameters:
        - notification: 키보드가 넘어옴

     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func keyboardWillHide(notification: Notification) {

            if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
                UIView.animate(withDuration: 0, animations: {
                self.keyBoardSize = nil
                if self.customView != nil {
                self.customView?.removeFromSuperview()
                self.customView = nil
                if APPDELEGATE?.topMostViewController()?.isKind(of: FeedDetailViewController.self) == true{
                    self.replyTextView.gestureRecognizers?.removeLast()
                }
            }
//                if APPDELEGATE?.topMostViewController()?.isKind(of: FeedDetailViewController.self) == true{
                self.coachQuestionView.isHidden = true
                
                
                    if #available(iOS 11.0, *) {
                        self.keyBoardSize = kbSize
                        let keyboardFrameInView = self.view.convert(self.keyBoardSize!, from: nil)
                        let safeAreaFrame = self.view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: 0)
                        let intersection = safeAreaFrame.intersection(keyboardFrameInView)
                        self.additionalSafeAreaInsets.bottom = intersection.height
                    
                }

                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
                    self.replySendBtnWidthConst.constant = 0
                    self.classMoveBtn.alpha = 1
                    self.classMoveBtnWidthConst.constant = 112
                    self.view.layoutIfNeeded()
                }, completion: nil)

                self.keyboardShow = false
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

                }) { success in
                    
                }
        }
    }

    /**
    ** 파라미터가 있고 반환값이 없는 메소드 > 댓글을 삭제하는 함수

      - Parameters:
        - notification: 오브젝트에 댓글 아이디가 넘어옴

      - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func replyDeleteChange(notification: Notification){
        guard let comment_id = notification.userInfo?["comment_id"] as? Int else { return }
        var arrayNumber = 0
        for i in 0..<replyArray!.count {
            if replyArray?[i].id == comment_id {
                arrayNumber = i
            }
        }
        self.replyArray?.remove(at: arrayNumber)
        DispatchQueue.main.async {
            self.tableView.reloadSections([8], with: .automatic)
        }
    }
}

extension ChildDetailClassViewController:UITextViewDelegate{
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let selectedRange = textView.selectedTextRange {
            let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
            if cursorPosition < 4{
                let text:String = self.replyTextView.text
                let words:[String] = text.separate(withChar: " ")
                if words[0] == "#질문"{
                    let arbitraryValue: Int = 4
                    if let newPosition = textView.position(from: textView.beginningOfDocument, offset: arbitraryValue) {
                        textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
                    }
                }
            }
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 텍스트뷰가 변경될때 타는 함수
     
     - Parameters:
        - textView: 텍스트뷰 값이 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    func textViewDidChange(_ textView: UITextView) {
        
        let text:String = self.replyTextView.text
        let words:[String] = text.separate(withChar: " ")
        
        if words.count > 1{
            if words[0] == "#질문"{
                self.questionImg.image = UIImage(named: "question_checkbox_true")
                self.questionBtn.tag = 1
            }else{
                self.questionImg.image = UIImage(named: "question_checkbox_false")
                self.questionBtn.tag = 0
            }
        }else{
            if words[0] == "#질문"{
                self.replyTextView.attributedText = self.resolveHashTags(text: self.replyTextView.text)
                let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#484848")];
                let attributedString = NSAttributedString(string: self.replyTextView.text, attributes: attributedStringColor)
                self.replyTextView.attributedText = attributedString
            }
        }
        
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        
        if self.replyTextView.contentSize.height >= 45 {
            self.replyTextView.isScrollEnabled = true
        }else{
            self.replyTextView.isScrollEnabled = false
            let sizeToFitIn = CGSize(width: self.replyTextView.bounds.size.width, height: CGFloat(MAXFLOAT))
            let newSize = self.replyTextView.sizeThatFits(sizeToFitIn)
            self.replyTextViewHeight.constant = newSize.height
        }
        
        if self.replyTextView.text == "" {
            replyTextViewLbl.isHidden = false
        }else{
            replyTextViewLbl.isHidden = true
        }
        
        if(textView.text == UIPasteboard.general.string){
            let newTextViewHeight = ceil(textView.sizeThatFits(textView.frame.size).height)
            if newTextViewHeight > 45 {
                self.replyTextView.isScrollEnabled = true
                self.replyTextViewHeight.constant = 45
            }else{
                self.replyTextViewHeight.constant = newTextViewHeight
            }
        }
        
    }
    
    func resolveHashTags(text : String) -> NSAttributedString{
        var length : Int = 0
        let text:String = text
        let words:[String] = text.separate(withChar: " ")
        
        let hashtagWords = words.flatMap({$0.separate(withChar: "#질문")})
        let attrs = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#484848")]
        let attrString = NSMutableAttributedString(string: text, attributes: attrs)
        
        
        if words.count > 1{
            if words[0] == "#질문"{
                self.questionImg.image = UIImage(named: "question_checkbox_true")
                self.questionBtn.tag = 1
            }else{
                self.questionImg.image = UIImage(named: "question_checkbox_false")
                self.questionBtn.tag = 0
            }
        }else{
            if words[0] == "#질문"{
                DispatchQueue.main.async {
                    self.replyTextView.text = ""
                    self.questionImg.image = UIImage(named: "question_checkbox_false")
                    self.questionBtn.tag = 0
                    self.replyTextViewLbl.isHidden = false
                }
            }else{
                
            }
        }
        
        for word in hashtagWords {
            if word.hasPrefix("#질문") {
                let matchRange:NSRange = NSMakeRange(length, 3)//word.count)
                let stringifiedWord:String = word
                attrString.addAttribute(NSAttributedString.Key.link, value: "\(stringifiedWord)", range: matchRange)
            }
            length += word.count
        }
        return attrString
    }
    
    func strikeline(str:String) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: str)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AppleSDGothicNeo-Regular", size: 12.5)!, range: (str as NSString).range(of:str))
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#b4b4b4") , range: (str as NSString).range(of:str))
        return attributedString
    }
}

extension ChildDetailClassViewController:UITableViewDelegate,UITableViewDataSource{
    
    /** **테이블 셀의 섹션당 로우 개수 함수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.feedDetailList != nil{
            if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                switch section {
                case 0:
                    if feedDetailList?.results?.curriculum != nil{
                        return 1
                    }else{
                        return 0
                    }
//                case 1,3,7,10:
                case 1,5,6,8,11:
                    return 1
                case 2:
                    if feedDetailList?.results?.class_recommend_arr.count ?? 0 > 0{
                        return 1
                    }else{
                        return 0
                    }
                case 3:
                    return 0
                case 4:
                    if self.feedDetailList?.results?.review_list_arr.count ?? 0 > 0{
                        return 1
                    }else{
                        return 0
                    }
//                case 5:
//                    if self.feedDetailList?.results?.curriculum?.coach_class?.notice?.content ?? "" == ""{
//                        return 0
//                    }else{
//                        return 1
//                    }
                case 7:
                    if (feedDetailList?.results?.conditionList.count ?? 0)! > 0{
                        if cheerViewExitCheck == false{
                            return 1
                        }else{
                            return 0
                        }
                        
                    }else{
                        return 0
                    }
                case 9:
                    if replyArray != nil{
                        if replyArray!.count > 0{
                            return 1
                        }else{
                            return 0
                        }
                    }else{
                        return 0
                    }
                case 10:
                    if replyArray != nil{
                        if replyArray!.count > 0{
                            return replyArray!.count
                        }else{
                            return 0
                        }
                    }else{
                        return 0
                    }
                default:
                    return 0
                }
            }else{
                switch section {
                case 0:
                    if feedDetailList?.results?.curriculum != nil{
                        return 1
                    }else{
                        return 0
                    }
                case 1,2,3:
                    if feedDetailList?.results?.curriculum?.study != nil {
                        if showContent == true{
                            return 1
                        }else{
                            return 0
                        }
                    }else{
                        return 0
                    }
                case 4:
                    if self.feedDetailList?.results?.curriculum?.coach_class?.notice?.content ?? "" == ""{
                        return 0
                    }else{
                        return 1
                    }
                case 5:
                    if (feedDetailList?.results?.conditionList.count ?? 0)! > 0{
                        if cheerViewExitCheck == false{
                            return 1
                        }else{
                            return 0
                        }
                        
                    }else{
                        return 0
                    }
                case 6,7,8,11:
                    return 1
                case 9:
                    if replyArray!.count == 0 {
                        return 1
                    } else {
                        return 0
                    }
                case 10:
                    if replyArray != nil{
                        if replyArray!.count > 0{
                            return replyArray!.count
                        }else{
                            return 0
                        }
                    }else{
                        return 0
                    }
                default:
                    return 0
                }
            }
        }else{
            return 0
        }
    }
    
    /** **테이블 셀의 선택시 함수 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.emoticonSelectView.isHidden = true
        if self.replyTextView.text.isEmpty != true || self.emoticonImg.image != nil{
            replyWriteCheck()
        }else{
            
        }
    }
    
    /** **테이블 셀의 로우 및 섹션 데이터 함수 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
            if section == 0{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassMenuTableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                if self.feedDetailList != nil{
                    cell.chapterSubjectLbl.text = "\(self.feedDetailList?.results?.curriculum?.head ?? ""). \(self.feedDetailList?.results?.curriculum?.title ?? "")"
                    if self.feedDetailList?.results?.curriculum?.study?.content ?? "" == "" {
                        cell.classContentBtn.isHidden = true
                    }else{
                        cell.classContentBtn.isHidden = false
                    }
                    let numberCheck:Int = self.feedDetailList?.results?.curriculum?.like_count ?? 0
                    cell.classSatisFiedLbl.text = "\(numberCheck.numberFormatterModooClass(to: numberCheck)) 명"
                    if self.feedDetailList?.results?.curriculum?.like_me ?? "N" == "Y"{
                        cell.classSatisFiedImg.image = UIImage(named: "class_satisfied_active2")
                    }else{
                        cell.classSatisFiedImg.image = UIImage(named: "class_satisfied_default2")
                    }
                    
                    cell.sharePointBtnView.setTitle("₩\(self.feedDetailList?.results?.share_point ?? "1000")", for: .normal)
                    feedDetailList?.results?.curriculum_before_id == 0 ? (cell.sharePointBtnView.isHidden = false) : (cell.sharePointBtnView.isHidden = true)
                    
                    cell.classHashTagLbl.text = self.feedDetailList?.results?.head_comment ?? ""
                    cell.classCheerLbl.text = "\(self.feedDetailList?.results?.star_avg ?? 0)(\(self.feedDetailList?.results?.star_cnt ?? 0))"
                    cell.classGroupChatLbl.text = "공유하기"
                    cell.classContentBtn.isHidden = true
                    cell.classCheerImg.image = UIImage(named:"class_review2")
                    cell.classGroupImg.image = UIImage(named:"class_share")
                    cell.classDescriptionImg.image = UIImage(named: "class_detail2")
                    cell.classDescriptionLbl.text = "상세"
                
                }
                cell.selectionStyle = .none
                return cell
            }else if section == 1{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassPriceCell", for: indexPath) as! ChildDetailClassTableViewCell
                if self.feedDetailList != nil{
                    cell.classPriceImg.sd_setImage(with: URL(string: "\(feedDetailList?.results?.photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                    cell.classPriceName.text = "\(feedDetailList?.results?.class_name ?? "")"
                    cell.classSalePrice.text = "[\(feedDetailList?.results?.sale_per ?? "")%] \(feedDetailList?.results?.price ?? "")원"
//                    cell.classSalePrice.text = "[\(feedDetailList?.results?.sale_per ?? "")%] 월 49,000원"
//                    cell.classSalePrice.text = "월 49,000원"
                    cell.classOriginalPrice.attributedText = strikeline(str: "\(feedDetailList?.results?.origin_price ?? "")원")
                    cell.classOriginalPrice.text = "\(feedDetailList?.results?.origin_price ?? "")원"
                }
                cell.selectionStyle = .none
                return cell
            }else if section == 2{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassChangeBodyCell", for: indexPath) as! ChildDetailClassTableViewCell
                if self.feedDetailList != nil{
                    cell.class_recommend_arr = (feedDetailList?.results?.class_recommend_arr)!
                    cell.changeBodyCollectionView.reloadData()
                }
                cell.selectionStyle = .none
                return cell
            }else if section == 3{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassCoachCell", for: indexPath) as! ChildDetailClassTableViewCell
                if self.feedDetailList != nil{
                    cell.classCoachImg.sd_setImage(with: URL(string: "\(feedDetailList?.results?.coach_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                    cell.classCoachName.text = "\(feedDetailList?.results?.coach_name ?? "")"
                    if feedDetailList?.results?.friend_status ?? "N" == "N"{
                        cell.classCoachWithBtn.setImage(UIImage(named: "follow_profile"), for: .normal)
                        cell.classCoachWithBtn.tag = 1
                    }else{
                        cell.classCoachWithBtn.setImage(UIImage(named: "messageImgV2"), for: .normal)
                        cell.classCoachWithBtn.tag = 2
                    }
                    cell.classCoachProfileBtn.tag = feedDetailList?.results?.coach_id ?? 0
                }
                cell.selectionStyle = .none
                return cell
            }else if section == 4{
                var cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassReview1Cell", for: indexPath) as! ChildDetailClassTableViewCell
                
                if self.feedDetailList != nil{
                    if self.feedDetailList?.results?.review_list_arr.count ?? 0 > 1{
                        cell = tableView.dequeueReusableCell(withIdentifier: "DetailClassReview2Cell", for: indexPath) as! ChildDetailClassTableViewCell
                        cell.review2UserImg.sd_setImage(with: URL(string: "\(feedDetailList?.results?.review_list_arr[1].photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                        cell.review2UserName.text = "\(feedDetailList?.results?.review_list_arr[1].user_name ?? "")"
                        cell.review2UserDate.text = "\(feedDetailList?.results?.review_list_arr[1].created_at ?? "")"
                        cell.review2UserContent.text = "\(feedDetailList?.results?.review_list_arr[1].content ?? "")"
                        cell.review2UserStar1.isHidden = false
                        cell.review2UserStar2.isHidden = false
                        cell.review2UserStar3.isHidden = false
                        cell.review2UserStar4.isHidden = false
                        cell.review2UserStar5.isHidden = false
                        if feedDetailList?.results?.review_list_arr[1].star ?? 0 == 4{
                            cell.review2UserStar5.isHidden = true
                        }else if feedDetailList?.results?.review_list_arr[1].star ?? 0 == 3{
                            cell.review2UserStar4.isHidden = true
                            cell.review2UserStar5.isHidden = true
                        }else if feedDetailList?.results?.review_list_arr[1].star ?? 0 == 2{
                            cell.review2UserStar3.isHidden = true
                            cell.review2UserStar4.isHidden = true
                            cell.review2UserStar5.isHidden = true
                        }else if feedDetailList?.results?.review_list_arr[1].star ?? 0 == 1{
                            cell.review2UserStar2.isHidden = true
                            cell.review2UserStar3.isHidden = true
                            cell.review2UserStar4.isHidden = true
                            cell.review2UserStar5.isHidden = true
                        }
                        cell.review2UserProfileBtn.tag = feedDetailList?.results?.review_list_arr[1].user_id ?? 0
                        
                        cell.review2UserBackView.layer.cornerRadius = 10
                        cell.review2UserBackView.layer.borderColor = UIColor(hexString: "#efefef").cgColor
                        cell.review2UserBackView.layer.borderWidth = 1
                        cell.review2UserBackView.clipsToBounds = true
                    }
                    if self.feedDetailList?.results?.review_list_arr.count ?? 0 > 0{
                        cell.reviewUserImg.sd_setImage(with: URL(string: "\(feedDetailList?.results?.review_list_arr[0].photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                        cell.reviewUserName.text = "\(feedDetailList?.results?.review_list_arr[0].user_name ?? "")"
                        cell.reviewUserDate.text = "\(feedDetailList?.results?.review_list_arr[0].created_at ?? "")"
                        cell.reviewUserContent.text = "\(feedDetailList?.results?.review_list_arr[0].content ?? "")"
                        cell.reviewUserStar1.isHidden = false
                        cell.reviewUserStar2.isHidden = false
                        cell.reviewUserStar3.isHidden = false
                        cell.reviewUserStar4.isHidden = false
                        cell.reviewUserStar5.isHidden = false
                        if feedDetailList?.results?.review_list_arr[0].star ?? 0 == 4{
                            cell.reviewUserStar5.isHidden = true
                        }else if feedDetailList?.results?.review_list_arr[0].star ?? 0 == 3{
                            cell.reviewUserStar4.isHidden = true
                            cell.reviewUserStar5.isHidden = true
                        }else if feedDetailList?.results?.review_list_arr[0].star ?? 0 == 2{
                            cell.reviewUserStar3.isHidden = true
                            cell.reviewUserStar4.isHidden = true
                            cell.reviewUserStar5.isHidden = true
                        }else if feedDetailList?.results?.review_list_arr[0].star ?? 0 == 1{
                            cell.reviewUserStar2.isHidden = true
                            cell.reviewUserStar3.isHidden = true
                            cell.reviewUserStar4.isHidden = true
                            cell.reviewUserStar5.isHidden = true
                        }
                        cell.reviewUserProfileBtn.tag = feedDetailList?.results?.review_list_arr[0].user_id ?? 0
                        cell.reviewScore.text = "리뷰 \(self.feedDetailList?.results?.star_avg ?? 0)"
                        cell.reviewCount.text = "(\(self.feedDetailList?.results?.star_cnt ?? 0)명 평가)"
                        cell.reviewUserBackView.layer.cornerRadius = 10
                        cell.reviewUserBackView.layer.borderColor = UIColor(hexString: "#efefef").cgColor
                        cell.reviewUserBackView.layer.borderWidth = 1
                        cell.reviewUserBackView.clipsToBounds = true
                    }
                }
                
                cell.selectionStyle = .none
                return cell
            }else if section == 5{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassCurriculumCell", for: indexPath) as! ChildDetailClassTableViewCell
                if self.feedDetailList != nil {
                    cell.curriculumClassTitleLbl.text = feedDetailList?.results?.curriculum_head?.title ?? ""
                    cell.curriculumTitleTime.text = feedDetailList?.results?.curriculum_head?.duration ?? ""
//                    for i in 0..<(self.feedDetailList?.results?.curriculum_list_array.count)! {
//                        cell.curriculumFirstClass.text = feedDetailList?.results?.curriculum_list_array[i].title ?? ""
//                        cell.curriculumFirstClassTime.text = feedDetailList?.results?.curriculum_list_array[i].video_duration ?? ""
//                        if feedDetailList?.results?.curriculum_list_array[i].freeview ?? "N" == "N" {
//                            cell.curriculumFirstClassImg.isHidden = true
//                        }
//                    }
                    cell.curriculumFirstClass.text = feedDetailList?.results?.curriculum_list_array[0].title ?? ""
                    cell.curriculumFirstClassTime.text = feedDetailList?.results?.curriculum_list_array[0].video_duration ?? ""
                    if feedDetailList?.results?.curriculum_list_array[0].freeview ?? "N" == "N" {
                        cell.curriculumFirstClassImg.isHidden = true
                    }
                    
                    cell.curriculumSecondClass.text = feedDetailList?.results?.curriculum_list_array[1].title ?? ""
                    cell.curriculumSecondClassTime.text = feedDetailList?.results?.curriculum_list_array[1].video_duration ?? ""
                    if feedDetailList?.results?.curriculum_list_array[1].freeview ?? "N" == "N" {
                        cell.curriculumSecondClassImg.isHidden = true
                    }
                    
                    cell.curriculumThirdClass.text = feedDetailList?.results?.curriculum_list_array[2].title ?? ""
                    cell.curriculumThirdClassTime.text = feedDetailList?.results?.curriculum_list_array[2].video_duration ?? ""
                    if feedDetailList?.results?.curriculum_list_array[2].freeview ?? "N" == "N" {
                        cell.curriculumThirdClassImg.isHidden = true
                    }
                }
                cell.selectionStyle = .none
                return cell
            }else if section == 6{
                var cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassCoachCell", for: indexPath) as! ChildDetailClassTableViewCell
                if self.feedDetailList != nil{
                    
                    if self.feedDetailList?.results?.curriculum?.coach_class?.notice?.content ?? "" != ""{
                        cell = tableView.dequeueReusableCell(withIdentifier: "DetailClassCoach2Cell", for: indexPath) as! ChildDetailClassTableViewCell
                        cell.noticeTextView.textContainer.maximumNumberOfLines = 3
                        cell.noticeTextView.textContainer.lineBreakMode = .byTruncatingTail
                        cell.noticeTextView.attributedText = (self.feedDetailList?.results?.curriculum?.coach_class?.notice?.content ?? "").html2AttributedString
                        cell.noticeTextView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
                    }
                    
                    cell.classCoachImg.sd_setImage(with: URL(string: "\(feedDetailList?.results?.coach_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                    cell.classCoachName.text = "\(feedDetailList?.results?.coach_name ?? "")"
                    if feedDetailList?.results?.friend_status ?? "N" == "N"{
                        cell.classCoachWithBtn.setImage(UIImage(named: "follow_profile"), for: .normal)
                        cell.classCoachWithBtn.tag = 1
                    }else{
                        cell.classCoachWithBtn.setImage(UIImage(named: "messageImgV2"), for: .normal)
                        cell.classCoachWithBtn.tag = 2
                    }
                    cell.classCoachProfileBtn.tag = feedDetailList?.results?.coach_id ?? 0
                    
                    cell.coachGradientView.layer.borderColor = UIColor(hexString: "#EFEFEF").cgColor
                    cell.coachGradientView.layer.borderWidth = 1
                }
                
                cell.selectionStyle = .none
                return cell
            }else if section == 7{
                let cell = tableView.dequeueReusableCell(withIdentifier: "height1cell", for: indexPath)
                cell.backgroundView?.backgroundColor = UIColor.white
                return cell
            }else if section == 8{
                let cell = tableView.dequeueReusableCell(withIdentifier: "height1ReduceCell", for: indexPath)
                cell.selectionStyle = .none
                return cell
            }else if section == 9{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassTotalReplyTitleTableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                if replyArray != nil{
                    replyArray!.count > 0 ? (cell.totalReplyCount.text = "이 강의 댓글 \(feedReplyList?.results?.total ?? 0)개") : (cell.totalReplyCount.text = "이 강의 댓글이 아직 없습니다") /*turnary operator*/
                }
                cell.selectionStyle = .none
                return cell
            }else if section == 10{
                var cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassReply1TableViewCell") as! ChildDetailClassTableViewCell
                if replyArray != nil{
                    if replyArray!.count > 0{
                        cell = replyCell(cell: cell, indexPath: indexPath , rowCheck:false)
                    }
                }
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "height1cell", for: indexPath)
                cell.backgroundView?.backgroundColor = UIColor.white
                return cell
            }
        }else{
            if section == 0{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassMenuTableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                if self.feedDetailList != nil{
                    cell.chapterSubjectLbl.text = "\(self.feedDetailList?.results?.curriculum?.head ?? ""). \(self.feedDetailList?.results?.curriculum?.title ?? "")"
                    if self.feedDetailList?.results?.curriculum?.study?.content ?? "" == "" {
                        cell.classContentBtn.isHidden = true
                    }else{
                        cell.classContentBtn.isHidden = false
                    }
                    let numberCheck:Int = self.feedDetailList?.results?.curriculum?.like_count ?? 0
                    cell.classSatisFiedLbl.text = "\(numberCheck.numberFormatterModooClass(to: numberCheck)) 명"
                    if self.feedDetailList?.results?.curriculum?.like_me ?? "N" == "Y"{
                        cell.classSatisFiedImg.image = UIImage(named: "class_satisfied_active2")
                    }else{
                        cell.classSatisFiedImg.image = UIImage(named: "class_satisfied_default2")
                    }
                    cell.classHashTagLbl.text = self.feedDetailList?.results?.head_comment ?? ""
                    cell.sharePointBtnView.setTitle("₩\(self.feedDetailList?.results?.share_point ?? "1000")", for: .normal)
                    feedDetailList?.results?.curriculum_before_id == 0 ? (cell.sharePointBtnView.isHidden = false) : (cell.sharePointBtnView.isHidden = true)

                    if UserManager.shared.userInfo.results?.user?.id == self.feedDetailList?.results?.curriculum?.coach_class?.coach_id {
                        cell.classCheerLbl.text = "수강생"
                        cell.classGroupImg.image = UIImage(named: "class_cheer2")
                        cell.classGroupChatLbl.text = "커뮤니티"
                        cell.sharePointBtnView.isHidden = true
                        
                        if feedDetailList?.results?.curriculum_after_id ?? 0 == 0 {
                            cell.nextClassBtn.setTitle("리뷰쓰기 ", for: .normal)
                            cell.nextClassBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                            cell.nextClassBtn.setImage(UIImage(named: "last_class"), for: .normal)
                            cell.nextClassBtn.isUserInteractionEnabled = false
                        } else {
                            cell.nextClassBtn.setImage(UIImage(named: "next_btn"), for: .normal)
                            cell.nextClassBtn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
                            cell.nextClassBtn.setTitle("다음강의 ", for: .normal)
                            cell.nextClassBtn.isUserInteractionEnabled = true
                        }
                    }else{
                        cell.classCheerLbl.text = "보고서"
                        cell.classGroupChatLbl.text = "공유하기"
                        cell.classGroupImg.image = UIImage(named: "class_share")
                        
                        if feedDetailList?.results?.curriculum_after_id ?? 0 == 0 {
                            cell.nextClassBtn.setTitle("리뷰쓰기 ", for: .normal)
                            cell.nextClassBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                            cell.nextClassBtn.setImage(UIImage(named: "last_class"), for: .normal)
                        } else {
                            cell.nextClassBtn.setImage(UIImage(named: "next_btn"), for: .normal)
                            cell.nextClassBtn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
                            cell.nextClassBtn.setTitle("다음강의 ", for: .normal)
                        }
                    }
                }
                cell.selectionStyle = .none
                return cell
            }else if section == 1{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassContentTitleTableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                if self.feedDetailList != nil{
                    cell.contentTitleLbl.text = "\(feedDetailList?.results?.curriculum?.study?.title ?? "")"
                }
                cell.selectionStyle = .none
                return cell
            }else if section == 2{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassContentDetailTableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                if self.feedDetailList != nil{
                    cell.addDetailView.addSubview(self.classTextView!)
                    self.classTextView!.snp.makeConstraints { (make) in
                        make.top.bottom.left.right.equalTo(cell.addDetailView)
                    }
                }
                cell.selectionStyle = .none
                return cell
            }else if section == 3{
                let cell = tableView.dequeueReusableCell(withIdentifier: "height1ReduceCell", for: indexPath)
                cell.selectionStyle = .none
                return cell
            }else if section == 4{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassNoticeTitleTableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                if self.feedDetailList != nil{
                    cell.coachImg.sd_setImage(with: URL(string: "\(feedDetailList?.results?.curriculum?.coach_class?.coach_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                    cell.coachRollGubunImg.isHidden = true
    //                cell.coachProfileBtn.tag = feedDetailList?.results?.curriculum?.coach_class?.coach_id ?? 0
                    cell.noticeTextView.attributedText = (self.feedDetailList?.results?.curriculum?.coach_class?.notice?.content ?? "").html2AttributedString
                    cell.noticeTextView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
    //                cell.noticeTextView.text = self.feedDetailList?.results?.curriculum?.coach_class?.notice?.content ?? ""
                    cell.noticeTextView.textContainer.maximumNumberOfLines = 3
                    cell.noticeTextView.textContainer.lineBreakMode = .byTruncatingTail
                    cell.noticeDetailBtn.tag = self.feedDetailList?.results?.curriculum?.coach_class?.notice?.id ?? 0
                }
                cell.noticeView.layer.cornerRadius = 12
                cell.selectionStyle = .none
                return cell
            }else if section == 5{
                let cell = tableView.dequeueReusableCell(withIdentifier: "height1cell", for: indexPath)
                cell.backgroundView?.backgroundColor = UIColor.white
                return cell
            }else if section == 6{
                let cell = tableView.dequeueReusableCell(withIdentifier: "height1ReduceCell", for: indexPath)
                cell.selectionStyle = .none
                return cell
            }else if section == 7{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassTotalReplyTitleTableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                if replyArray != nil{
                    if replyArray!.count > 0 {
                        cell.totalReplyCount.text = "이 강의 댓글 \(feedReplyList?.results?.total ?? 0)개"
                    } else {
//                        if self.type == "all" {
//                            cell.totalReplyCount.text = "이 강의 댓글이 아직 없습니다"
//                        } else if self.type == "questions" {
//                            cell.totalReplyCount.text = "이 강의 질문 댓글이 아직 없습니다"
//                        } else {
//                            cell.totalReplyCount.text = "이 강의 코치 댓글이 아직 없습니다"
//                        }
                        switch self.type {
                        case "all":
                            cell.totalReplyCount.text = "이 강의 댓글이 아직 없습니다"
                        case "questions":
                            cell.totalReplyCount.text = "이 강의 질문 댓글이 아직 없습니다"
                        case "coach":
                            cell.totalReplyCount.text = "이 강의 코치 댓글이 아직 없습니다"
                        default:
                            cell.totalReplyCount.text = "이 강의 댓글이 아직 없습니다"
                        }
                    }
                }
                cell.selectionStyle = .none
                return cell
            }else if section == 8{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassCommentFilteringTableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                if self.type == "all"{
                    cell.totalComment.borderWidth = 1
                    cell.totalComment.borderColor = UIColor(hexString: "#FF5A5F")
                    cell.totalComment.backgroundColor = .white
                    cell.totalComment.setTitleColor(UIColor(hexString: "FF5A5F"), for: .normal)
                    cell.questionComment.borderWidth = 0
                    cell.questionComment.backgroundColor = UIColor(hexString: "#F5F5F5")
                    cell.questionComment.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
                    cell.coachComment.borderWidth = 0
                    cell.coachComment.backgroundColor = UIColor(hexString: "#F5F5F5")
                    cell.coachComment.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
                } else if self.type == "questions"{
                    cell.questionComment.borderWidth = 1
                    cell.questionComment.borderColor = UIColor(hexString: "#FF5A5F")
                    cell.questionComment.backgroundColor = .white
                    cell.questionComment.setTitleColor(UIColor(hexString: "FF5A5F"), for: .normal)
                    cell.totalComment.borderWidth = 0
                    cell.totalComment.backgroundColor = UIColor(hexString: "#F5F5F5")
                    cell.totalComment.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
                    cell.coachComment.borderWidth = 0
                    cell.coachComment.backgroundColor = UIColor(hexString: "#F5F5F5")
                    cell.coachComment.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
                } else {
                    cell.coachComment.borderWidth = 1
                    cell.coachComment.borderColor = UIColor(hexString: "#FF5A5F")
                    cell.coachComment.backgroundColor = .white
                    cell.coachComment.setTitleColor(UIColor(hexString: "FF5A5F"), for: .normal)
                    cell.questionComment.borderWidth = 0
                    cell.questionComment.backgroundColor = UIColor(hexString: "#F5F5F5")
                    cell.questionComment.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
                    cell.totalComment.borderWidth = 0
                    cell.totalComment.backgroundColor = UIColor(hexString: "#F5F5F5")
                    cell.totalComment.setTitleColor(UIColor(hexString: "#767676"), for: .normal)
                }
                cell.selectionStyle = .none
                return cell
            }else if section == 9{
                let cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassNoCommentTableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                cell.noCommentLbl.text = "댓글이 존재하지 않습니다."
                cell.selectionStyle = .none
                return cell
            }else if section == 10{
                var cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassReply1TableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                if replyArray != nil{
                    if replyArray!.count > 0{
                        cell = replyCell(cell: cell, indexPath: indexPath , rowCheck:false)
                    }
                }
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "height1cell", for: indexPath)
                cell.backgroundView?.backgroundColor = UIColor.white
                return cell
            }
        }
    }
    
    /** **테이블 셀의 섹션 개수 함수 */
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
            return 11
        }else{
            return 12
        }
    }
    
    /** **테이블 셀의 높이 함수 */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
            switch section {
            case 8:
                return 0.5
            case 0,1,2,3,4,5,6,7,9:
                return UITableView.automaticDimension
            case 10:
                return UITableView.automaticDimension
            case 11:
                return 25
            default:
                return 1
            }
        }else{
            switch section {
            case 1:
                return 60
            case 3,6:
                return 0.5
            case 0,2,4,5,7,8,9,10:
                return UITableView.automaticDimension
            case 11:
                return 25
            default:
                return 1
            }
        }
    }
    
    /** **테이블 셀이 보이기 시작할때 타는 함수 */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        DispatchQueue.main.async {
            if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                if section == 10{
                    if self.replyArray != nil{
                        if row == (self.replyArray!.count){
                            if self.replyArray!.count < self.feedReplyList?.results!.total ?? 0 {
                                Indicator.showActivityIndicator(uiView: self.view)
                                self.page = self.page + 1
                                self.appDetailComment(curriculum_id: self.feedDetailList?.results?.curriculum?.id ?? 0, page: self.page, type: self.type)
                            }
                        }
                    }
                }
            }else{
                if section == 10{
                    if self.replyArray != nil{
                        if row == (self.replyArray!.count){
                            if self.replyArray!.count < self.feedReplyList?.results!.total ?? 0 {
                                Indicator.showActivityIndicator(uiView: self.view)
                                self.page = self.page + 1
                                self.appDetailComment(curriculum_id: self.feedDetailList?.results?.curriculum?.id ?? 0, page: self.page, type: self.type)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func replyCell(cell:ChildDetailClassTableViewCell,indexPath:IndexPath , rowCheck:Bool) -> ChildDetailClassTableViewCell{
        var cell:ChildDetailClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailClassReply1TableViewCell") as! ChildDetailClassTableViewCell
        let row = indexPath.row
        if replyArray != nil{
            if replyArray!.count > 0{
                if replyArray?[row].reply_count ?? 0 > 0 {
                    if replyArray?[row].photo ?? "" == "" && replyArray?[row].emoticon ?? 0 == 0{
                        cell = tableView.dequeueReusableCell(withIdentifier: "DetailClassReply1TableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                        cell.readMoreBtn.tag = row
                        if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                            cell.readMoreBtn.isUserInteractionEnabled = true
                        }
                    }else{
                        if replyArray?[row].content ?? "" != "" {
                            cell = tableView.dequeueReusableCell(withIdentifier: "DetailClassReply3TableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                            cell.readMoreBtn.tag = row
                            if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                                cell.readMoreBtn.isUserInteractionEnabled = true
                            }
                        }else{
                            cell = tableView.dequeueReusableCell(withIdentifier: "DetailClassReply5TableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                        }
                        cell.replyPhotoBtn.tag = row
                        if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                            cell.replyPhotoBtn.isUserInteractionEnabled = false
                        }
                        if replyArray?[row].emoticon ?? 0 == 0{
                            cell.replyPhoto.sd_setImage(with: URL(string: "\(replyArray?[row].photo ?? "")"), placeholderImage: UIImage(named: "user_default"))
                            cell.replyPhotoHeightConst.constant = 160
                            cell.replyPhotoWidthConst.constant = 160
                        }else{
                            cell.replyPhoto.image = UIImage(named: "emti\(replyArray?[row].emoticon ?? 0)")
                            cell.replyPhotoHeightConst.constant = 80
                            cell.replyPhotoWidthConst.constant = 80
                        }
                        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                        cell.replyPhoto.addGestureRecognizer(pictureTap)
                        if replyArray?[row].play_file ?? "" == ""{
                            cell.youtubePlayImg.isHidden = true
                        }else{
                            cell.youtubePlayImg.isHidden = false
                        }
                    }
                    if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                        cell.replyMoreBtn.isUserInteractionEnabled = false
                    }
                    cell.replyMoreBtn.tag = row
                    cell.replyMoreBtn.setTitle("답글 \(replyArray?[row].reply_count ?? 0)개 보기", for: .normal)
                }else{
                    if replyArray?[row].photo ?? "" == "" && replyArray?[row].emoticon ?? 0 == 0{
                        cell = tableView.dequeueReusableCell(withIdentifier: "DetailClassReply2TableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                        if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                            cell.readMoreBtn.isUserInteractionEnabled = true
                        }
                        cell.readMoreBtn.tag = row
                    }else{
                        if replyArray?[row].content ?? "" != "" {
                            cell = tableView.dequeueReusableCell(withIdentifier: "DetailClassReply4TableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                            cell.readMoreBtn.tag = row
                            if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                                cell.readMoreBtn.isUserInteractionEnabled = true
                            }
                        }else{
                            cell = tableView.dequeueReusableCell(withIdentifier: "DetailClassReply6TableViewCell", for: indexPath) as! ChildDetailClassTableViewCell
                        }
                        cell.replyPhotoBtn.tag = row
                        if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                            cell.replyPhotoBtn.isUserInteractionEnabled = false
                        }
                        if replyArray?[row].emoticon ?? 0 == 0{
                            cell.replyPhoto.sd_setImage(with: URL(string: "\(replyArray?[row].photo ?? "")"), placeholderImage: UIImage(named: "user_default"))
                            cell.replyPhotoHeightConst.constant = 160
                            cell.replyPhotoWidthConst.constant = 160
                        }else{
                            cell.replyPhoto.image = UIImage(named: "emti\(replyArray?[row].emoticon ?? 0)")
                            cell.replyPhotoHeightConst.constant = 80
                            cell.replyPhotoWidthConst.constant = 80
                        }
                        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                        cell.replyPhoto.addGestureRecognizer(pictureTap)
                        if replyArray?[row].play_file ?? "" == ""{
                            cell.youtubePlayImg.isHidden = true
                        }else{
                            cell.youtubePlayImg.isHidden = false
                        }
                    }
                    cell.replyCount.text = "답글 달기"
                }
                if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                    cell.replyReadBtn.isUserInteractionEnabled = false
                }
                cell.replyReadBtn.tag = row
                
                if replyArray?[row].like_me == "Y" {
                    cell.likeBtn.tag = row*10000 + 1
                    cell.likeBtn.setTitleColor(UIColor(named: "MainPoint_mainColor"), for: .normal)
                    cell.likeCountBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                    cell.likeCountBtn.tag = row*10000 + 1
                    cell.likeCountBtn.setImage(UIImage(named: "heart_red"), for: .normal)
                    cell.likeCountBtn.setTitle(" \(self.replyArray?[row].like ?? 0)", for: .normal)
                }else{
                    cell.likeBtn.tag = row*10000 + 2
                    cell.likeBtn.setTitleColor(UIColor(named: "FontColor_mainColor"), for: .normal)
                    cell.likeCountBtn.tag = row*10000 + 2
                    cell.likeCountBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                    cell.likeCountBtn.setImage(UIImage(named: "heart_grey"), for: .normal)
                    cell.likeCountBtn.setTitle(" \(self.replyArray?[row].like ?? 0)", for: .normal)
                }
                if replyArray?[row].user_id == UserManager.shared.userInfo.results?.user?.id {
                    cell.moreBtn.tag = replyArray?[row].id ?? 0
                    cell.moreBtn.isHidden = false
                }else{
                    cell.moreBtn.isHidden = true
                }
                if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                    cell.moreBtn.isUserInteractionEnabled = false
                }
                cell.friendProfileBtn.tag = row//replyArray[row].user_id ?? 0
                cell.friendProfile2Btn.tag = row//replyArray[row].user_id ?? 0
                cell.reply_userPhoto.sd_setImage(with: URL(string: "\(replyArray?[row].user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
                cell.userName.text = replyArray?[row].user_name ?? ""
                if replyArray?[row].content ?? "" != "" {
                    cell.replyContentTextView.text = replyArray?[row].content ?? ""
    //                cell.replyContentTextView.textContainer.maximumNumberOfLines = 5
                    cell.replyContentTextView.textContainer.lineBreakMode = .byTruncatingTail
                }else{ }
              
//                if replyArray?[row].like ?? 0 > 0 {
//                    cell.likeCountBtn.setTitle(" \(replyArray?[row].like ?? 0)", for: .normal)
//                }
                
                cell.replyContentView.layer.cornerRadius = 12
                cell.likeCountBtn.layer.shadowOpacity = 0.1
                cell.likeCountBtn.layer.shadowRadius = 3
                cell.likeCountBtn.layer.shadowOffset = CGSize(width: 0,height: 2)
                cell.replyTime.text = replyArray?[row].time_spilled ?? "0분전"
                
                if replyArray?[row].friend_status ?? "Y" != "Y"{
                    if replyArray?[row].user_id ?? 0 == UserManager.shared.userInfo.results?.user?.id ?? 0 {
                        cell.rollGubunImg.isHidden = true
                    }else{
                        cell.rollGubunImg.isHidden = false
                    }
                }else{
                    cell.rollGubunImg.isHidden = true
                }
                if replyArray?[row].coach_yn ?? "N" == "Y"{
                    cell.coachStar.isHidden = false
                }else{
                    cell.coachStar.isHidden = true
                }
            }
        }
        
        return cell
    }
}

extension ChildDetailClassViewController{
    
    func replyWriteCheck(){
        Alert.WithReply(self, btn1Title: "삭제", btn1Handler: {
            self.emoticonImg.image = nil
            self.image = nil
            self.replyTextViewHeight.constant = 33
            if self.customView != nil{
                self.customView?.removeFromSuperview()
                self.customView = nil
            }
            self.replyTextViewLbl.isHidden = false
            self.questionImg.image = UIImage(named: "question_checkbox_false")
            self.questionBtn.tag = 0
            let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#484848")];
            let attributedString = NSAttributedString(string: self.replyTextView.text, attributes: attributedStringColor)
            self.replyTextView.attributedText = attributedString
            self.replyTextView.text = ""
            self.coachQuestionView.isHidden = true
        }, btn2Title: "이어서 작성", btn2Handler: {
            if self.emoticonImg.image != nil {
                self.emoticonSelectView.isHidden = false
            }
            self.coachQuestionView.isHidden = false
            self.replyTextView.becomeFirstResponder()
        })
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 강의의 소개를 가져오기 위한 함수
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func appClassDetail(){
        self.feedDetailList = FeedDetailManager.shared.feedDetailList
        
        if feedDetailList?.results?.mission_yn ?? "Y" == "N" {
            self.classMoveBtn.setImage(UIImage(named: "mission_done"), for: .normal)
        } else {
            if feedDetailList?.results?.mission_count ?? 0 > 0 {
                self.classMoveBtn.setImage(UIImage(named: "mission_do_again"), for: .normal)
            } else {
                self.classMoveBtn.setImage(UIImage(named: "mission_check"), for: .normal)
            }
        }
        
        
//        if feedDetailList?.results?.curriculum?.button_api ?? "" == "curriculum_next" || feedDetailList?.results?.curriculum?.button_api ?? "" == "review" {
//            if feedDetailList?.results?.mission_count == 0{
//               //self.classMoveBtn.setImage(UIImage(named: "mission_done"), for: .normal)
//                self.classMoveBtn.setImage(UIImage(named: "mission_check"), for: .normal)
//            } else {
//               self.classMoveBtn.setImage(UIImage(named: "mission_do_again"), for: .normal)
//            }
//        }else{
//            self.classMoveBtn.setImage(UIImage(named: "mission_check"), for: .normal)
//        }
        
        if let parentVC = self.parent as? FeedDetailViewController {
            parentVC.videoLoadCheck(button_api: self.feedDetailList?.results?.curriculum?.button_api ?? "", curriculum_id: self.feedDetailList?.results?.curriculum?.id ?? 0, loadUrl: FeedDetailManager.shared.feedDetailList.results?.curriculum?.study?.video ?? "")
        }else{}

        let width: CGFloat = 200.0
        self.classTextView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        let setHeightUsingCSS = "<html><head><style type=\"text/css\"> img{ max-height: 100%; max-width: \(self.view.frame.width - 32); !important; width: auto; height: auto;} </style> </head><body> \(self.feedDetailList?.results?.curriculum?.study?.content ?? "\n\n\n") </body></html>"
        let noSpaceAttributedString = setHeightUsingCSS.html2AttributedString
        self.classTextView!.attributedText = noSpaceAttributedString
        self.classTextView!.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14.5)
        self.classTextView!.textColor = UIColor(named: "FontColor_subColor2")
        self.classTextView!.translatesAutoresizingMaskIntoConstraints = true
        self.classTextView!.sizeToFit()
        self.classTextView!.isScrollEnabled = false
        self.classTextView!.isEditable = false
        self.classTextView!.dataDetectorTypes = .link
        self.classTextView!.isSelectable = true
        
        self.paymentView.isHidden = true

        if self.feedDetailList?.results?.curriculum?.button_api ?? "" == "done"{
            self.replySendView.isHidden = true
            
            if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                self.paymentView.isHidden = false
                if tableViewBottom1 != nil{
                    self.tableViewBottom1.isActive = true
                }
                if tableViewBottom2 != nil{
                    self.tableViewBottom2.isActive = false
                }
                if self.feedDetailList?.results?.classScrap_status ?? "N" == "N"{
                    self.scrapImg.image = UIImage(named:"participation_scrap_default")
                    self.scrapCount.textColor = UIColor(hexString: "#1A1A1A")
                    self.scrapCount.fontWeight = .Regular
                    self.scrapCount.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12.5)!
                    self.scrapBtn.tag = 1
                }else{
                    self.scrapImg.image = UIImage(named:"participation_scrap_active")
                    self.scrapCount.textColor = UIColor(hexString: "#FF0F16")
                    self.scrapCount.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12.5)!
                    self.scrapBtn.tag = 2
                }
                self.scrapCount.text = "\(self.feedDetailList?.results?.classScrap_cnt ?? 0)"
            }else{
                if tableViewBottom1 != nil{
                    self.tableViewBottom1.isActive = false
                }
                if tableViewBottom2 != nil{
                    self.tableViewBottom2.isActive = true
                }
            }
        }else{
            self.replySendView.isHidden = false
            if tableViewBottom1 != nil{
                self.tableViewBottom1.isActive = true
            }
            if tableViewBottom2 != nil{
                self.tableViewBottom2.isActive = false
            }
        }
        self.view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.appDetailComment(curriculum_id: self.feedDetailList?.results?.curriculum?.id ?? 0, page: self.page, type: self.type)
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 강의의 댓글 리스트를 가져오기 위한 함수
     
     - Parameters:
        - curriculum_id: 커리큘럼 아이디
        - page: 페이지번호
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func appDetailComment(curriculum_id:Int, page:Int, type:String){
        FeedApi.shared.appClassDataComment(curriculum_id: curriculum_id, page: page, type: type, success: { [unowned self] result in
            if result.code == "200"{
                self.feedReplyList = result
                for addArray in 0 ..< (self.feedReplyList?.results?.appClassCommentList.count ?? 0)! {
                    self.replyArray?.append((self.feedReplyList?.results?.appClassCommentList[addArray])!)
                }
                self.tableView.reloadData()
                Indicator.hideActivityIndicator(uiView: self.view)
            }
        }) { error in
            Indicator.hideActivityIndicator(uiView: self.view)
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 공지사항 종아요 혹은 취소를 하기 위한 함수
     
     - Parameters:
        - sender: 버튼 태그값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func noticeHaveSave(sender:UIButton){
        sender.isUserInteractionEnabled = false
        let likeGubun = sender.tag // 1 : Y delete  2 : N post
        let comment_id = self.feedDetailList?.results?.curriculum?.coach_class?.notice?.id ?? 0
        
        var type = ""
        if likeGubun == 1{
            type = "delete"
            self.feedDetailList?.results?.curriculum?.coach_class?.notice!.like_cnt = (self.feedDetailList?.results?.curriculum?.coach_class?.notice!.like_cnt ?? 0)-1
        }else{
            type = "post"
            self.feedDetailList?.results?.curriculum?.coach_class?.notice!.like_cnt = (self.feedDetailList?.results?.curriculum?.coach_class?.notice!.like_cnt ?? 0)+1
        }
        
        FeedApi.shared.replyCommentLike(comment_id: comment_id, method_type: type,success: { [unowned self] result in
            if result.code == "200"{
                if likeGubun == 1{
                    sender.setTitleColor(UIColor(named: "FontColor_mainColor"), for: .normal)
                    sender.tag = sender.tag+1
                    self.feedDetailList?.results?.curriculum?.coach_class?.notice?.like_me = "N"
                }else{
                    sender.setTitleColor(UIColor(named: "MainPoint_mainColor"), for: .normal)
                    sender.tag = sender.tag-1
                    self.feedDetailList?.results?.curriculum?.coach_class?.notice?.like_me = "Y"
                }
                DispatchQueue.main.async {
                    self.tableView.reloadSections([4], with: .automatic)
                    sender.isUserInteractionEnabled = true
                }
            }else{
                sender.isUserInteractionEnabled = true
            }
        }) { error in
            sender.isUserInteractionEnabled = true
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 댓글 종아요 혹은 취소를 하기 위한 함수
    
     - Parameters:
        - sender: 버튼 태그값
     
    - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
    */
    func haveSave(sender:UIButton){
        sender.isUserInteractionEnabled = false
        let row = sender.tag / 10000
        let likeGubun = sender.tag % 10000 // 1 : Y delete  2 : N post
        let comment_id = replyArray?[row].id ?? 0
        
        var type = ""
        if likeGubun == 1{
            type = "delete"
        }else{
            type = "post"
        }
        
        FeedApi.shared.replyCommentLike(comment_id: comment_id, method_type: type,success: { [unowned self] result in
            if result.code == "200" {
                DispatchQueue.main.async {
                    var selectedIndexPath = IndexPath(item:row , section: 10)
                    if self.feedDetailList?.results?.user_status ?? "" == "spectator"{
                        selectedIndexPath = IndexPath(item: row , section: 10)
                    }
                    let cell = self.tableView.cellForRow(at: selectedIndexPath) as! ChildDetailClassTableViewCell
                    if likeGubun == 1{
                        self.replyArray?[row].like = (self.replyArray?[row].like ?? 0)-1
                        cell.likeBtn.setTitleColor(UIColor(named: "FontColor_mainColor"), for: .normal)
                        cell.likeBtn.tag = row*10000 + 2
                        cell.likeCountBtn.tag = row*10000 + 2
                        self.replyArray?[row].like_me = "N"
                        cell.likeCountBtn.setTitleColor(UIColor(hexString: "#B4B4B4"), for: .normal)
                        cell.likeCountBtn.setImage(UIImage(named: "heart_grey"), for: .normal)
                        cell.likeCountBtn.setTitle(" \(self.replyArray?[row].like ?? 0)", for: .normal)
                    }else{
                        self.replyArray?[row].like = (self.replyArray?[row].like ?? 0)+1
                        cell.likeBtn.setTitleColor(UIColor(named: "MainPoint_mainColor"), for: .normal)
                        cell.likeBtn.tag = row*10000 + 1
                        cell.likeCountBtn.tag = row*10000 + 1
                        self.replyArray?[row].like_me = "Y"
                        cell.likeCountBtn.setTitleColor(UIColor(hexString: "#FF5A5F"), for: .normal)
                        cell.likeCountBtn.setImage(UIImage(named: "heart_red"), for: .normal)
                        cell.likeCountBtn.setTitle(" \(self.replyArray?[row].like ?? 0)", for: .normal)
                    }
                    
                    sender.isUserInteractionEnabled = true
                }
            }else{
                sender.isUserInteractionEnabled = true
            }
        }) { error in
            sender.isUserInteractionEnabled = true
        }
    }
    
    /**
     **파라미터가 있고 반환값이 없는 메소드 > 댓글 종아요 혹은 취소를 하기 위한 함수
     
      - Parameters:
        - sender: 버튼 태그값
     
      - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func replySend(sender:UIButton){
        sender.isUserInteractionEnabled = false
        let curriculum_id = self.feedDetailList?.results?.curriculum?.id ?? 0
        let content = self.replyTextView.text
        Indicator.showActivityIndicator(uiView: self.view)
        FeedApi.shared.replySave(class_id: self.class_id, curriculum: curriculum_id, mcComment_id: 0, content: content ?? "", commentType: "curriculum", commentChild: false,emoticon:self.emoticonNumber,photo:self.image,success: { [unowned self] result in
            if result.code == "200"{
                let temp = AppClassCommentList.init()
                temp.id = result.results?.id
                temp.type = result.results?.type
                temp.user_id = result.results?.user_id
                temp.user_photo = result.results?.user_photo
                temp.user_name = result.results?.user_name
                temp.time_spilled = result.results?.time_spilled
                temp.content = result.results?.content
                temp.reply_count = result.results?.reply_count
                temp.like = result.results?.like
                temp.like_me = result.results?.like_me
                temp.photo = result.results?.photo
                temp.roll = result.results?.roll
                temp.like_user = result.results?.like_user
                temp.emoticon = result.results?.emoticon
                temp.mcCurriculum_id = result.results?.mcCurriculum_id

                self.emoticonSelectView.isHidden = true
                self.emoticonImg.image = nil
                self.replyTextViewLbl.isHidden = false
                self.questionBtn.tag = 0
                self.questionImg.image = UIImage(named: "question_checkbox_false")
                let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#484848")];
                let attributedString = NSAttributedString(string: self.replyTextView.text, attributes: attributedStringColor)
                self.replyTextView.attributedText = attributedString
                self.replyTextView.text = ""
                if self.customView != nil{
                    self.customView?.removeFromSuperview()
                    self.customView = nil
                }
                
                self.replyArray?.insert(temp, at: 0)
                self.feedReplyList?.results?.total = (self.feedReplyList?.results?.total ?? 0) + 1
                self.emoticonNumber = 0
                sender.isUserInteractionEnabled = true
                DispatchQueue.main.async {
                    self.tableView.reloadSections([7,10], with: .automatic)
                    Indicator.hideActivityIndicator(uiView: self.view)
                }
            }else{
                Indicator.hideActivityIndicator(uiView: self.view)
            }
        }) { error in
            Indicator.hideActivityIndicator(uiView: self.view)
            sender.isUserInteractionEnabled = true
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 댓글을 삭제하기 위한 함수
     
     - Parameters:
        - comment_id: 댓글 아이디
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func replyDelete(comment_id:Int){
        FeedApi.shared.replyDelete(comment_id: comment_id,success: { [unowned self] result in
            if result.code == "200"{
                var row = 0
                if self.replyArray != nil{
                    for i in 0..<self.replyArray!.count{
                        if self.replyArray?[i].id == result.results{
                            row = i
                        }else{}
                    }
                    self.replyArray?.remove(at: row)
                    self.feedDetailList?.results?.curriculum?.comment?.total = self.replyArray!.count
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }) { error in
            
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 다음 커리큘럼으로 넘기는 함수
     
     - Parameters:
        - curriculum_id: 커리큘럼 아이디
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func app_curriculum_next(curriculum_id:Int){
        FeedApi.shared.curriculum_next(class_id: self.class_id, curriculum_id:curriculum_id ,success: { [unowned self] result in
            if result.code == "200"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: "")
                self.curriculumLikeViewHidden = true
            }
        }) { error in
            
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 커리큘럼을 만족하거나 아님 만족 취소를 하는 함수
     
     - Parameters:
        - sender: 버튼 태그
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func curriculumLike(sender:UIButton){
        var methodType = ""
        if self.feedDetailList?.results?.curriculum?.like_me ?? "N" == "Y"{
            methodType = "delete"
        }else{
            methodType = "post"
        }
        FeedApi.shared.curriculumLike(curriculum_id:feedDetailList?.results?.curriculum?.id ?? 0 , method_type:methodType,success: { [unowned self] result in
            Indicator.hideActivityIndicator(uiView: self.view)
            if result.code == "200"{
                DispatchQueue.main.async {
                    if methodType == "delete"{
//                        sender.setImage(UIImage(named: "class_satisfied_default2"), for: .normal)
                        self.feedDetailList?.results?.curriculum?.like_me = "N"
                        self.feedDetailList?.results?.curriculum?.like_count = (self.feedDetailList?.results?.curriculum!.like_count)!-1
                    }else{
//                        sender.setImage(UIImage(named: "class_satisfied_active2"), for: .normal)
                        self.feedDetailList?.results?.curriculum?.like_me = "Y"
                        self.feedDetailList?.results?.curriculum?.like_count = (self.feedDetailList?.results?.curriculum!.like_count)!+1
                    }
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    
                    if self.tableView.dataHasChanged {
                        self.tableView.reloadData()
                    } else {
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }) { error in
            Indicator.hideActivityIndicator(uiView: self.view)
        }
    }
}

extension ChildDetailClassViewController: CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 이미지를 선택하는 함수
     
     - Parameters:
        - picker: imageViewController
        - info: 이미지 Data
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
        
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        //cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        //cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        //cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        //cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        
        //cropController.rotateButtonsHidden = true
        //cropController.rotateClockwiseButtonHidden = true
        
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        self.image = image
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            if picker.sourceType == .camera {
                picker.dismiss(animated: true, completion: {
                    if #available(iOS 13.0, *) {
                        cropController.modalPresentationStyle = .fullScreen
                    }
                    self.present(cropController, animated: true, completion: nil)
                })
            } else {
                picker.pushViewController(cropController, animated: true)
            }
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                if #available(iOS 13.0, *) {
                    cropController.modalPresentationStyle = .fullScreen
                }
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 이미지를 사각형으로 자르는 함수
     
     - Parameters:
        - cropViewController: imageViewController
        - image: 이미지 Data
        - cropRect: 자른 이미지 사각형 크기
        - angle: 자른 이미지 각도
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 이미지를 원형으로 자르는 함수
     
     - Parameters:
        - cropViewController: imageViewController
        - image: 이미지 Data
        - cropRect: 자른 이미지 사각형 크기
        - angle: 자른 이미지 각도
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 형태를 변형한 이미지를 보여주고 이미지뷰에 넣는 함수
     
     - Parameters:
        - cropViewController: imageViewController
        - image: 이미지 Data
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        imageView.image = image
        self.emoticonSelectView.isHidden = false
        self.emoticonImg.image = ImageScale().scaleImage(image: image)//.resized(withPercentage: 0.5)
        self.image = ImageScale().scaleImage(image: image)
        self.coachQuestionView.isHidden = false
        self.emoticonNumber = 0
        self.replyTextView.becomeFirstResponder()
        
        if cropViewController.croppingStyle != .circular {
            imageView.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                   toView: imageView,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.layoutImageView() },
                                                   completion: { self.imageView.isHidden = false })
        }
        else {
            self.imageView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 이미지뷰를 선택시 앨범 or 카메라 선택하게 하는 탭 함수
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    @objc public func didTapImageView() {
        // When tapping the image view, restore the image to the previous cropping state
        let cropViewController = CropViewController(croppingStyle: self.croppingStyle, image: self.image!)
        cropViewController.delegate? = self
        let viewFrame = view.convert(imageView.frame, to: navigationController!.view)
        
        cropViewController.modalPresentationStyle = .overFullScreen
        cropViewController.presentAnimatedFrom(self, fromImage: self.imageView.image, fromView: nil, fromFrame: viewFrame, angle: self.croppedAngle, toImageFrame: self.croppedRect, setup: { self.imageView.isHidden = true }, completion: nil)
    }
    
    /** **뷰가 불려오고난뒤 레이아웃의 뷰들 */
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    /** ** 이미지뷰의 크기 조절  함수 */
    public func layoutImageView() {
        guard imageView.image != nil else { return }

        let padding: CGFloat = 20.0

        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))

        var imageFrame = CGRect.zero
        imageFrame.size = imageView.image!.size;

        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imageView.frame = imageFrame
        }
        else {
            self.imageView.frame = imageFrame;
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
    
}

extension UIViewController {

    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height - 43, width: self.view.frame.size.width, height: 43))
        toastLabel.backgroundColor = UIColor(hexString: "#1A1A1A")
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .left
        toastLabel.text = message
        toastLabel.alpha = 1.0
        //toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 3.0, animations: {
         toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToast2(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height - 120, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor(hexString: "#1A1A1A")
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .left
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.textAlignment = NSTextAlignment.center
        toastLabel.layer.cornerRadius = 17;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 3.0, animations: {
         toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
