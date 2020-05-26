//
//  ShareAppViewController.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/05/06.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit
import KakaoLink
import FBSDKCoreKit
import FBSDKShareKit
import Alamofire

class ShareAppViewController: UIViewController, UIGestureRecognizerDelegate {
    /** the Y value of the view**/
    var contentY:CGFloat = 0
    /** **뷰의 숨기는 속도 */
    var minimumVelocityToHide = 1500 as CGFloat
    /** **뷰의 숨기는 화면 비율 */
    var minimumScreenRatioToHide = 0.5 as CGFloat
    /** **애니메이션 시간 */
    var animationDuration = 0.2 as TimeInterval
    /** **클래스 커리큘럼 소개 리스트 */
    var feedDetailList:FeedAppClassModel?
    var replyArray:Array? = Array<AppClassCommentList>()
    var feedModel: FeedModel?
    var share_address:String?
    var share_content:String?
    var share_img:String?
    var share_point:Int?
    var class_name:String?
    //var class_info:String?
    var class_photo:String?
    var class_id:Int?
    
//  Content View
    @IBOutlet weak var shareViewExtBtn: UIButton!
    @IBOutlet weak var contentLbl: UILabel!
//  Main View
    @IBOutlet weak var shareAppLbl: UILabel!
    @IBOutlet weak var copyLinkBtn: UIButton!
    @IBOutlet weak var fbShareBtn: UIButton!
    @IBOutlet weak var kakaoShareBtn: UIButton!
    @IBOutlet weak var classShareImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setImageToImageView()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
        self.shareAppLbl.adjustsFontSizeToFitWidth = true
        self.shareAppLbl.text = self.share_content ?? "친구 초대하고 1,000원 적립금 받으세요!"
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
        print("ShareAppViewController deinit")
    }
    
    func fetchImage(from urlString: String, completionHandler: @escaping (_ data: Data?) -> ()) {
        let session = URLSession.shared
        let url = URL(string: self.share_img ?? "")
            
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error fetching the image! 😢")
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }
            
        dataTask.resume()
    }
    
    func setImageToImageView() {
        fetchImage(from: self.share_img ?? "") { (imageData) in
            if let data = imageData {
                // referenced imageView from main thread
                // as iOS SDK warns not to use images from
                // a background thread
                DispatchQueue.main.async {
                    self.classShareImg.image = UIImage(data: data)
                }
            } else {
                    // show as an alert if you want to
                print("Error loading image");
            }
        }
    }
    
    @IBAction func copyLinkBtnClicked(_ sender: UIButton) {
        UIPasteboard.general.string = self.share_address ?? ""
        showToast2(message: "링크 복사되었습니다.", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!)
        
    }
    
    @IBAction func fbShareBtnClicked(_ sender: UIButton) {
        
        let request = Alamofire.request("\(apiUrl)/tracking/share/\(self.class_id ?? 0)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedModel.init(dic: convertToDictionary(data: response.data!, apiURL: "post : \(apiUrl)/tracking/share/\(self.class_id ?? 0)"))
                
                let content = ShareLinkContent()
                content.contentURL = URL(string: self.share_address ?? "https://www.modooclass.net/class/interest")!
                
                let dialog = ShareDialog()
                dialog.shareContent = content
                dialog.fromViewController = self
                dialog.show()
                print("This is class_id dictionary: \(dic)")
            } else {
                print("Error while posting API: \(response.error ?? "Error:" as! Error)")
            }
        }
    }
    
    @IBAction func kakaoShareBtnClicked(_ sender: UIButton) {
        let url = self.share_address ?? ""
        let photoUrl = self.class_photo ?? ""
        let title = self.class_name ?? ""
        
        let request = Alamofire.request("\(apiUrl)/tracking/share/\(self.class_id ?? 0)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)

        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedModel.init(dic: convertToDictionary(data: response.data!, apiURL: "post : \(apiUrl)/tracking/share/\(self.class_id ?? 0)"))
                let template = KMTFeedTemplate.init { (feedTemplateBuilder) in
                    feedTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                        contentBuilder.title = title
                        //contentBuilder.desc = self.class_info
                        contentBuilder.imageURL = URL.init(string: photoUrl)!
                        contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                            //linkBuilder.webURL = URL(string: url ?? "")
                            linkBuilder.mobileWebURL = URL(string: url )
                        })
                    })
                    feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                        buttonBuilder.title = "클래스 보기"
                        buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                            linkBuilder.webURL = URL(string: url)
                            linkBuilder.mobileWebURL = URL(string: url)
                        })
                    }))
                }
                KLKTalkLinkCenter.shared().sendDefault(with: template,
                    success: { (warningMsg, argumentMsg) in
                        // 템플릿 밸리데이션과 쿼터 체크가 성공적으로 끝남.
                        // 톡에서 정상적으로 보내졌는지 보장은 할 수 없다.
                        // 전송 성공 유무는 서버콜백 기능을 이용하여야 한다.
                        print("warning message: \(String(describing: warningMsg))")
                        print("argument message: \(String(describing: argumentMsg))")
                    },
                    failure: { (error) in
                        // 실패
                        print(error.localizedDescription)
                        print("error \(error)")
                    })
                print("This is class_id dictionary: \(dic)")
            } else {
                print("Error while posting API: \(response.error ?? "Error:" as! Error)")
            }
        }
    }
    
    /** **exit shareAppView and return to FeedDetailView **/
    @IBAction func shareVCExtBtnClicked(_ sender: UIButton) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.slideViewVerticallyTo(self.view.frame.size.height)
        }) { (isCompleted) in
            if isCompleted {
                if let parentVC = self.parent as? FeedDetailViewController {
                    parentVC.tableViewCheck = 1
                    parentVC.detailClassData()
                }else{}
                self.slideViewVerticallyTo(0)
            }
        }
    }
    
    
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
