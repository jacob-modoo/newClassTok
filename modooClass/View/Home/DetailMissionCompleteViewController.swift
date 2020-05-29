//
//  DetailMissionCompleteViewController.swift
//  modooClass
//
//  Created by 조현민 on 13/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CropViewController

/**
# DetailMissionCompleteViewController.swift 클래스 설명

## UIViewController 상속 받음
- 강의 클래스들의 검색 리스트를 보기 위한 화면
*/
class DetailMissionCompleteViewController: UIViewController {
    /** **키보드 숨김 유무 */
    var keyboardShow:Bool = false
    /** **미션 아이디 */
    var mission_id:Int = 0
    /** **미션 내용 텍스트뷰 */
    var missionTextView:UITextView = UITextView()
    /** **active text field*/
    var activeTextField:UITextField?
    /** **다음강의 버튼 */
    @IBOutlet var missionNextBtn: UIButton!
    /** **미션 완료 버튼 */
    @IBOutlet var missionDoneBtn: UIButton!
    /** **미션 이미지뷰 */
    private let imageView = UIImageView()
    /** **미션 이미지 */
    private var image: UIImage?
    /** **사진 크롭 스타일 */
    private var croppingStyle = CropViewCroppingStyle.default
    /** **크롭 사이즈 */
    private var croppedRect = CGRect.zero
    /** **크롭 각도 */
    private var croppedAngle = 0
    /** **테이블뷰 */
    @IBOutlet var tableView: UITableView!
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.navigationController?.navigationBar.barTintColor  = UIColor.white
        tableView.layer.cornerRadius = 10
        
        let dismiss = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.tableView.addGestureRecognizer(dismiss)
        
    }
    
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let width: CGFloat = 200.0
        self.missionTextView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        let setHeightUsingCSS = "<html><head><style type=\"text/css\"> img{ max-height: 100%; max-width: \(self.view.frame.width - 68); !important; width: auto; height: auto;} </style> </head><body> \(FeedDetailManager.shared.feedDetailList.results?.curriculum?.mission?.missionDescription ?? "\n\n\n") </body></html>"
        let noSpaceAttributedString = setHeightUsingCSS.html2AttributedString
        self.missionTextView.attributedText = noSpaceAttributedString
        self.missionTextView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
        self.missionTextView.translatesAutoresizingMaskIntoConstraints = true
        self.missionTextView.sizeToFit()
        self.missionTextView.isScrollEnabled = false
        self.missionTextView.isEditable = false
        self.missionTextView.dataDetectorTypes = .link
        self.missionTextView.isSelectable = true
        
        if FeedDetailManager.shared.feedDetailList.results?.curriculum?.button_next_curriculum_id ?? 0 == 0{
            self.missionNextBtn.setTitle("리뷰쓰기", for: .normal)
        }
        
    }
    
    /** **뷰가 사라지기 시작 할 때 타는 메소드 */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }

    /** **미션완료 버튼 클릭 > 미션 완료 함수를 실행 */
    @IBAction func missionDoneClicked(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! DetailMissionCompleteTableViewCell
        sender.isUserInteractionEnabled = false
        Indicator.showActivityIndicator(uiView: self.view)
        if cell.missionCompleteTextView.text == "내용을 적어주세요...." {
            cell.missionCompleteTextView.text = ""
        }
        mission_done(comment: cell.missionCompleteTextView.text!, photo: cell.missionImg.image,sender:sender)
    }
    
    /** **클래스 다음 강의 버튼 클릭 > 다음강의로 넘어가는 함수를 실행*/
    @IBAction func curriculumNextBtnClicked(_ sender: UIButton) {
        if FeedDetailManager.shared.feedDetailList.results?.curriculum?.button_next_curriculum_id ?? 0 == 0{
            Alert.WithReview(self, btn1Title: "리뷰쓰기", btn1Handler: {
                self.view.endEditing(true)
                let newViewController = UIStoryboard(name: "ChildWebView", bundle: nil).instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                newViewController.url = FeedDetailManager.shared.feedDetailList.results?.curriculum?.button_review ?? ""
//                self.navigationController?.pushViewController(newViewController, animated: true)
                self.navigationController?.popToViewBottomController(ofClass: FeedDetailViewController.self)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: "review")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classLikeView"), object: "false")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reviewWebViewCheck"), object: newViewController.url)
                //object: result.results?.study_address
            }, btn2Title: "거절", btn2Handler: {
            self.navigationController?.popToViewBottomController(ofClass: FeedDetailViewController.self)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: "")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classLikeView"), object: "false")
                }
            })
        }else{
            FeedApi.shared.curriculum_next(class_id: FeedDetailManager.shared.feedDetailList.results?.mcClass_id ?? 0, curriculum_id:FeedDetailManager.shared.feedDetailList.results?.curriculum?.button_next_curriculum_id ?? 0 ,success: { [unowned self] result in
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
    
    /** **전화면 돌아가기 버튼 클릭 > 전 화면 이동 */
    @IBAction func returnBackBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popToViewBottomController(ofClass: FeedDetailViewController.self)
    }
    
    /** **이미지 버튼 클릭 > 앨범, 카메라 이동 */
    @IBAction func imagePickerBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        imagePicked()
    }
    /** **will hide keyboard when view is tapped*/
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
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
            imagePicker.modalPresentationStyle = .overCurrentContext
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
    
}

extension DetailMissionCompleteViewController:UITableViewDelegate,UITableViewDataSource{
    
    /** **테이블 셀의 섹션당 로우 개수 함수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /** **테이블 셀의 로우 및 섹션 데이터 함수 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DetailMissionCompleteTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailMissionCompleteTableViewCell", for: indexPath) as! DetailMissionCompleteTableViewCell
        cell.addTextView.addSubview(self.missionTextView)
        self.missionTextView.snp.makeConstraints { (make) in
            make.bottom.equalTo(cell.addTextView).offset(-10)
            make.top.equalTo(cell.addTextView).offset(10)
            make.right.equalTo(cell.addTextView).offset(-10)
            make.left.equalTo(cell.addTextView).offset(10)
        }
        cell.addTextView.layer.cornerRadius = 10
        cell.missionView.layer.cornerRadius = 10
        cell.missionView.layer.borderColor = UIColor(named: "MainPoint_mainColor")?.cgColor
        cell.missionView.layer.borderWidth = 1
        cell.labelView.layer.cornerRadius = 10
        cell.selectionStyle = .none
        return cell
    }
    
    /** **테이블 셀의 높이 함수 */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return tableView.bounds.height
        return UITableView.automaticDimension
    }
    
    /** **테이블 셀의 선택시 함수 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}

extension DetailMissionCompleteViewController :UITextViewDelegate{
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 텍스트뷰가 변경될때 타는 함수
     
     - Parameters:
        - textView: 텍스트뷰 값이 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    func textViewDidChange(_ textView: UITextView) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as! DetailMissionCompleteTableViewCell
        if textView.text == "" {
            cell.missionCompleteTextViewPlaceHolder.isHidden = false
        }else{
            cell.missionCompleteTextViewPlaceHolder.isHidden = true
        }
        
        if !textView.text.isEmpty {
            self.missionDoneBtn.backgroundColor = UIColor(named: "MainPoint_mainColor")
            self.missionDoneBtn.isUserInteractionEnabled = true
            cell.missionView.layer.borderWidth = 0
        }else{
            if cell.missionImg.image == nil{
                cell.missionView.layer.borderWidth = 1
                self.missionDoneBtn.backgroundColor = UIColor(hexString: "#A5A3B0")
                self.missionDoneBtn.isUserInteractionEnabled = false
            }else{
                self.missionDoneBtn.backgroundColor = UIColor(named: "MainPoint_mainColor")
                self.missionDoneBtn.isUserInteractionEnabled = true
                cell.missionView.layer.borderWidth = 0
            }
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 키보드가 보일때 함수
      
     - Parameters:
        - notification: 키보드가 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func keyboardWillShow(notification: Notification) {
        if keyboardShow == false {
            if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.5, animations: {
                    let baseFrame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-kbSize.height)
                    self.view.frame = baseFrame
                   // self.view.frame.origin.y = self.view.frame.origin.y - kbSize.height
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    }
                    self.keyboardShow = true
                    self.view.layoutIfNeeded()
                }) { success in
                    
                }
                
            }
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 키보드가 보이지 않을때 함수
     
     - Parameters:
        - notification: 키보드가 넘어옴
     
     - Throws: `Error` 오브젝트 값이 제대로 안넘어 오는경우 `Error`
     */
    @objc func keyboardWillHide(notification: Notification) {
        if keyboardShow == true {
            if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.5, animations: {
                    let baseFrame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height+kbSize.height)
                    self.view.frame = baseFrame
//                    self.view.frame.origin.y = self.view.frame.origin.y + kbSize.height
//                    self.tableView.frame.origin.y = self.tableView.frame.origin.y + kbSize.height
                    self.keyboardShow = false
                    self.view.layoutIfNeeded()
                }) { success in
                    
                }
            }
        }
    }
}


extension DetailMissionCompleteViewController{
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 미션 완료를 알리는 함수
     
     - Parameters:
        - comment: 미션 완료 내용
        - photo: 미션 완료 이미지
        - sender:버튼 태그
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func mission_done(comment:String,photo:UIImage? ,sender:UIButton){
        FeedApi.shared.mission_done(mission_id: mission_id, comment: comment, photo: photo, review_point: 5,success: { [unowned self] result in
            Indicator.hideActivityIndicator(uiView: self.view)
            if result.code == "200"{
                sender.isUserInteractionEnabled = true
                Alert.With(self, title: result.results!.title!, content: result.results!.content!, imageType: result.results!.type!, btn1Title: "확인", btn1Handler: {
                    if result.results?.study_type ?? "" == "end"{
                        DispatchQueue.main.async {
                            Alert.WithReview(self, btn1Title: "리뷰쓰기", btn1Handler: {
                                self.navigationController?.popToViewBottomController(ofClass: FeedDetailViewController.self)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: "review")
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reviewWebViewCheck"), object: result.results?.study_address)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classLikeView"), object: "false")
                            }, btn2Title: "거절", btn2Handler: {
                                self.navigationController?.popToViewBottomController(ofClass: FeedDetailViewController.self)
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: "")
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classLikeView"), object: "false")
                                }
                            })
                        }
                    }else{
                        self.navigationController?.popToViewBottomController(ofClass: FeedDetailViewController.self)
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumUpdatePost"), object: "")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classLikeView"), object: "false")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "flashNextClassBtn"), object: nil)
                        }
                        
                    }
                    
                })
            }else{
                sender.isUserInteractionEnabled = true
            }
        }) { error in
            Indicator.hideActivityIndicator(uiView: self.view)
            sender.isEnabled = true
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                
            })
        }
    }
}


extension DetailMissionCompleteViewController:CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
//        layoutImageView()
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! DetailMissionCompleteTableViewCell
        
        cell.missionImg.image = ImageScale().scaleImage(image: image)
        cell.missionImgPickerBtn.setImage(UIImage(named: ""), for: .normal)
        cell.missionView.layer.borderWidth = 0
        self.missionDoneBtn.backgroundColor = UIColor(named: "MainPoint_mainColor")//UIColor(hexString: "#7461F2")
        self.missionDoneBtn.isUserInteractionEnabled = true
        
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
        cropViewController.delegate = self
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
