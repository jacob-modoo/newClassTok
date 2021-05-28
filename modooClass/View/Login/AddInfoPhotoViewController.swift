//
//  AddInfoPhotoViewController.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/01.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CropViewController

class AddInfoPhotoViewController: UIViewController {

    @IBOutlet var samplePictureCollectionView: UICollectionView!
    
    /** **돌아가기 버튼 */
    @IBOutlet var retrunBackBtn: UIButton!
    /** **제목 라벨 */
    @IBOutlet var titleLabel: UILabel!
    /** **설명 라벨 */
    @IBOutlet var titleDescLabel: UILabel!
    /** **다음 버튼 */
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var imageSelectBtn1: UIButton!
    @IBOutlet var imageSelectBtn2: UIButton!
    @IBOutlet var imageSelectBtn3: UIButton!
    @IBOutlet var imageRemoveBtn1: UIButton!
    @IBOutlet var imageRemoveBtn2: UIButton!
    @IBOutlet var imageRemoveBtn3: UIButton!
    
    var profile_image:UIImage!
    
    var nick = ""
    var gender = ""
    var birthYear = ""
    var interestArr:Array<Int> = []
    var jobArr:Array<Int> = []
    var sampleNumbering:Array<Int> = [0,0,0]
    
    private let imageView = UIImageView()
    /** **미션 이미지 */
    private var image: UIImage?
    /** **사진 크롭 스타일 */
    private var croppingStyle = CropViewCroppingStyle.default
    /** **크롭 사이즈 */
    private var croppedRect = CGRect.zero
    /** **크롭 각도 */
    private var croppedAngle = 0
    var imageTag = 0
    @IBOutlet var progressBar: UIProgressView!
    
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        checkImgField()
        setProfileImg()
        image1.layer.cornerRadius = image1.frame.width/2
        imageSelectBtn1.layer.cornerRadius = imageSelectBtn1.bounds.width/2
        image1.clipsToBounds = true
//        image2.layer.cornerRadius = image2.frame.width/2
//        imageSelectBtn2.layer.cornerRadius = imageSelectBtn2.frame.width/2
//        image2.clipsToBounds = true
//        image3.layer.cornerRadius = image3.frame.width/2
//        imageSelectBtn3.layer.cornerRadius = imageSelectBtn3.frame.width/2
//        image3.clipsToBounds = true
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)
        // Do any additional setup after loading the view.
    }
    
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /** **뷰가 사라지기 시작 할 때 타는 메소드 */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /** **뷰가 나타나고 타는 메소드 */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @IBAction func returnBackBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    /** **다음 버튼 클릭 > 로그인 절차 다음단계 가기 */
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoIntroWordViewController") as! AddInfoIntroWordViewController
        newViewController.nick = self.nick
        newViewController.gender = self.gender
//        newViewController.birthYear = self.birthYear
//        newViewController.interestArr = self.interestArr
//        newViewController.jobArr = self.jobArr
        
        if image1.image != profile_image {
            print("New image is picked...")
            newViewController.photo1 = image1.image ?? UIImage(named: "reply_user_default")!
        } else {
            print("The old image is kept")
            newViewController.photo1 = profile_image ?? UIImage(named: "reply_user_default")!
        }
        
//        newViewController.photo2 = self.image2.image!
//        newViewController.photo3 = self.image3.image!
        newViewController.sampleNumbering = self.sampleNumbering
        print("sampleNumbering: \(sampleNumbering)")
        self.navigationController?.pushViewController(newViewController, animated: false)
    }
    
    @IBAction func skipBtnClicked(_ sender: UIButton) {
        let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoIntroWordViewController") as! AddInfoIntroWordViewController
        newViewController.nick = self.nick
        newViewController.gender = self.gender
//        newViewController.birthYear = self.birthYear
//        newViewController.interestArr = self.interestArr
//        newViewController.jobArr = self.jobArr
//        newViewController.photo1 = self.image1.image ?? UIImage(named: "reply_user_default")!
        newViewController.photo1 = self.profile_image ?? UIImage(named: "reply_user_default")!
//        newViewController.photo3 = self.image3.image ?? UIImage(named: "reply_user_default")!
        newViewController.sampleNumbering = self.sampleNumbering
        print("sampleNumbering: \(sampleNumbering)")
        self.navigationController?.pushViewController(newViewController, animated: false)
    }
    
    @IBAction func sampleImgClicked(_ sender: UIButton) {
        let tag = sender.tag
        if image1.image == nil {
            image1.image = UIImage(named: "sampleImg\(tag)")
            imageRemoveBtn1.isHidden = false
            sampleNumbering[0] = tag
//        }
//        if image2.image == nil{
//            image2.image = UIImage(named: "sampleImg\(tag)")
//            imageRemoveBtn2.isHidden = false
//            sampleNumbering[1] = tag
//        }else if image3.image == nil{
//            image3.image = UIImage(named: "sampleImg\(tag)")
//            imageRemoveBtn3.isHidden = false
//            sampleNumbering[2] = tag
        }
        
        if image1.image != nil {    //&& image2.image != nil && image3.image != nil{
            nextBtn.layer.borderColor = UIColor(hexString: "#ff5a5f").cgColor
            nextBtn.setTitleColor(UIColor(named:"MainPoint_mainColor"), for: .normal)
            nextBtn.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func imageRemoveBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        if tag == 1{
            image1.image = nil
            imageRemoveBtn1.isHidden = true
            nextBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
            nextBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
            nextBtn.layer.borderWidth = 1
            nextBtn.isUserInteractionEnabled = false
            sampleNumbering[0] = 0
//        }else if tag == 2{
//            image2.image = nil
//            imageRemoveBtn2.isHidden = true
//            nextBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
//            nextBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
//            nextBtn.layer.borderWidth = 1
//            nextBtn.isUserInteractionEnabled = false
//            sampleNumbering[1] = 0
//        }else if tag == 3{
//            image3.image = nil
//            imageRemoveBtn3.isHidden = true
//            nextBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
//            nextBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
//            nextBtn.layer.borderWidth = 1
//            nextBtn.isUserInteractionEnabled = false
//            sampleNumbering[2] = 0
        }
    }
    
    @IBAction func imagePickerBtnClicked(_ sender: UIButton) {
        imageTag = sender.tag
        imagePicked()
    }
    
    func setProfileImg() {
        let userImgUrl = UserManager.shared.userInfo.results?.user?.photo ?? ""
        if userImgUrl != "" {
            guard let url = URL(string: userImgUrl) else {
                return
            }
            let defaultImgData = UIImage(named: "reply_user_default")
            let data = (try? Data(contentsOf: url))
            let image = UIImage(data: ((data ?? defaultImgData?.pngData())!))
            image1.image = image
            profile_image = image
            imageRemoveBtn1.isHidden = false
            nextBtn.layer.borderColor = UIColor(hexString: "#ff5a5f").cgColor
            nextBtn.setTitleColor(UIColor(named:"MainPoint_mainColor"), for: .normal)
            nextBtn.isUserInteractionEnabled = true
        } else {
            image1.image = nil //UIImage(named: "reply_user_default")
        }
    }
    
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
}

extension AddInfoPhotoViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row
        let cell:AddInfoPhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddInfoPhotoCollectionViewCell", for: indexPath) as! AddInfoPhotoCollectionViewCell
        cell.layoutIfNeeded()
        cell.defaultImg1.image = UIImage(named: "sampleImg\(row+1)")
        cell.defaultImg2.image = UIImage(named: "sampleImg\(row+7)")
        cell.defaultImg1.layer.cornerRadius = cell.defaultImg1.frame.height/2
        cell.defaultImg2.layer.cornerRadius = cell.defaultImg2.frame.height/2
        cell.sampleImgBtn1.tag = row+1
        cell.sampleImgBtn2.tag = row+7
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension AddInfoPhotoViewController :UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width :self.samplePictureCollectionView.frame.width / 4.5,height: self.samplePictureCollectionView.frame.height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

extension AddInfoPhotoViewController:CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        if imageTag == 1{
            self.image1.image = ImageScale().scaleImage(image: image)
            imageRemoveBtn1.isHidden = false
            self.imageTag = 0
//        }else if imageTag == 2{
//            self.image2.image = ImageScale().scaleImage(image: image)
//            imageRemoveBtn2.isHidden = false
//            self.imageTag = 0
//        }else if imageTag == 3{
//            self.image3.image = ImageScale().scaleImage(image: image)
//            imageRemoveBtn3.isHidden = false
//            self.imageTag = 0
        }
        
        checkImgField()
        
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
    
    func checkImgField() {
        if image1.image != nil {    // && image2.image != nil && image3.image != nil{
            nextBtn.layer.borderColor = UIColor(hexString: "#ff5a5f").cgColor
            nextBtn.setTitleColor(UIColor(named:"MainPoint_mainColor"), for: .normal)
            nextBtn.layer.borderWidth = 1
            nextBtn.isUserInteractionEnabled = true
        } else {
            nextBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
            nextBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
            nextBtn.layer.borderWidth = 1
            nextBtn.isUserInteractionEnabled = false
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
