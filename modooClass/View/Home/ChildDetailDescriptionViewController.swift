//
//  ChildDetailClassDescriptionViewController.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/12/08.
//  Copyright © 2020 신민수. All rights reserved.
//

import Foundation
import QuickLook
import UIKit
import Alamofire

class ChildDetailDescriptionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topRoundedView: UIView!
    
    /** **클래스 아이디 */
    var class_id = 0
    /** the Y value of the view**/
    var contentY:CGFloat = 0
    /** **뷰의 숨기는 속도 */
    var minimumVelocityToHide = 1500 as CGFloat
    /** **뷰의 숨기는 화면 비율 */
    var minimumScreenRatioToHide = 0.5 as CGFloat
    /** *animation duration */
    var animationDuration = 0.2 as TimeInterval
    /** **클래스 커리큘럼 소개 리스트 */
    var feedDetailList:FeedAppClassModel?
    /** *interaction controller */
    var interaction: UIDocumentInteractionController?
    var filePath:Any?
    
    lazy var previewItem = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topRoundedView.roundedView(usingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 12))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataReload), name: NSNotification.Name(rawValue: "ClassDescriptionSend"), object: nil)
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
        print("ChildDetailDescriptionViewController deinit")
    }
    
    
    
    @IBAction func exitBtnClicked(_ sender: UIButton) {
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
    
    func downloadfile(completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        let stringUrl = "\(feedDetailList?.results?.curriculum?.materials_file ?? "")"
        guard let itemUrl = stringUrl.getCleanedURL()
        else {
            print("oshibka url :", stringUrl.getCleanedURL()!)
            return
        }
        print("item url is : ", itemUrl)
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("filename.pdf")
        
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            completion(true, destinationUrl)
            
            // if the file doesn't exist
        } else {
            
            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: itemUrl, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    print("File moved to documents folder")
                    completion(true, destinationUrl)
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(false, nil)
                }
            }).resume()
        }
    }
    
    @IBAction func downloadBtnClicked(_ sender: UIButton) {
        if self.filePath != nil {
            self.openFileWithPath(pdfPath: self.filePath as! URL)
            print("** ochil sim sim")
        } else {
            self.showToast2(message: "파일이 다운로드중입니다..", font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13)!)
        }
    }
    
    /** *will update the api data*/
    @objc func dataReload(notification:Notification){
        if let temp = notification.object {
            self.class_id = temp as! Int
            
            self.feedDetailList = FeedDetailManager.shared.feedDetailList
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fileDownload(completion: @escaping (_ success:Bool, _ pdfURL:URL) -> ()) {
        let stringUrl = "\(feedDetailList?.results?.curriculum?.materials_file ?? "")"
        // Check pdfURL
        guard let url = stringUrl.getCleanedURL()
        else {
            return
        }

        // set up URLRequest
        let urlRequest = URLRequest(url: url)

        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)


        let task = session.dataTask(with: urlRequest) { (data, response, error) in

            // getting Data Error
            guard error == nil else {
                debugPrint("Error!!")
                return
            }

            // Respose Data Empty
            guard let responseData = data else {
                print("Error: data empty!!")
                return
            }

            // FileManager 인스턴스 생성
            let fileManager = FileManager()

            let fileName = String(url.lastPathComponent)

            // document 디렉토리의 경로 저장
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

            // 해당 디렉토리 이름 지정
            let dataPath = documentsDirectory.appendingPathComponent("FileManager Directory")

            do {
                // 디렉토리 생성
                try fileManager.createDirectory(atPath: dataPath.path, withIntermediateDirectories: false, attributes: nil)

            } catch let error as NSError {
                print("Error creating directory: \(error.localizedDescription)")
            }

            do {

                print("filename is ",fileName)
                // 파일 이름을 기존의 경로에 추가
                let writePath = dataPath.appendingPathComponent(fileName)

                // 쓰기 작업
                try responseData.write(to: writePath)

                completion(true, writePath)

            } catch let error as NSError {
                print("Error Writing File : \(error.localizedDescription)")
            }

        }

        task.resume()

    }
    
    func openFileWithPath(pdfPath : URL) {
        interaction = UIDocumentInteractionController(url: pdfPath)
        interaction?.delegate = self
        interaction?.presentPreview(animated: true) // IF SHOW DIRECT
    }
    
}
    
extension ChildDetailDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if feedDetailList != nil {
            switch section {
            case 0,1,2,3:
                return 1
//            case 1:
//                if feedDetailList?.results?.curriculum?.materials_file ?? "" != "" {
//                    return 1
//                } else {
//                    return 0
//                }
//            case 2,3:
//                if feedDetailList?.results?.curriculum?.materials_subject ?? "" != "" {
//                    return 1
//                } else {
//                    return 0
//                }
            default:
                return 0
            }
//        } else {
//            return 0
//        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailDescriptionTitleCell", for: indexPath) as! ChildDetailDescriptionTableViewCell
            cell.descriptionTitleLbl.text = "\(feedDetailList?.results?.curriculum?.head ?? "") 수업파일"
            cell.selectionStyle = .none
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailDescriptionDownloadCell", for: indexPath) as! ChildDetailDescriptionTableViewCell
            if feedDetailList?.results?.curriculum?.materials_subject ?? "" != "" {
                cell.fileTitleLbl.text = feedDetailList?.results?.curriculum?.materials_subject ?? ""
                cell.fileTitleLbl.textColor = UIColor(hexString: "#767676")
                cell.downloadBtn.setImage(UIImage(named: "file_download_active"), for: .normal)
                cell.downloadBtn.isUserInteractionEnabled = true
            } else {
                cell.fileTitleLbl.font = UIFont.italicSystemFont(ofSize: 12.5)
                cell.fileTitleLbl.text = "수업파일이 존재하지 않습니다."
                cell.fileTitleLbl.textColor = UIColor(hexString: "#B4B4B4")
                cell.downloadBtn.setImage(UIImage(named: "file_download_default"), for: .normal)
                cell.downloadBtn.isUserInteractionEnabled = false
            }
            cell.selectionStyle = .none
            return cell
        } else if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailDescriptionTitleCell", for: indexPath) as! ChildDetailDescriptionTableViewCell
            cell.descriptionTitleLbl.text = feedDetailList?.results?.curriculum?.study?.head ?? ""
            cell.selectionStyle = .none
            return cell
        } else if section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailDescriptionContentCell", for: indexPath) as! ChildDetailDescriptionTableViewCell
            cell.descriptionSubtitle.text = feedDetailList?.results?.curriculum?.study?.title ?? ""
            cell.descriptionContent.text = (feedDetailList?.results?.curriculum?.study?.content ?? "").html2String
            
            if feedDetailList?.results?.curriculum?.materials_subject ?? "" != "" {
                self.fileDownload { (success, filePath) in
                    self.filePath = filePath
                }
            }
            cell.descriptionContent.sizeToFit()
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChildDetailDescriptionTitleCell", for: indexPath) as! ChildDetailDescriptionTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension ChildDetailDescriptionViewController: UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
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
    **파라미터가 있고 반환값이 없는 메소드 > 수직으로 슬라이드 될떄 타는 함수
     
     - Parameters:
        - y: y값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func slideViewVerticallyTo(_ y: CGFloat) {
        self.view.frame.origin = CGPoint(x: 0, y: y)
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
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 스크롤을 이용하여 스크롤이 상단 y=0 까지 올라오면 팬 제스처 실행
     
     - Parameters:
        - scrollView: scrollView 값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentY = scrollView.contentOffset.y
    }
}

extension ChildDetailDescriptionViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        interaction = nil
    }
}


extension ChildDetailDescriptionViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem as QLPreviewItem
    }
    
    
}
