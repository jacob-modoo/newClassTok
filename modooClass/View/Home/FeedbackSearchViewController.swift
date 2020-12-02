//
//  FeedbackSearchViewController.swift
//  modooClass
//
//  Created by 조현민 on 28/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift
import Firebase
/**
 # FeedbackSearchViewController.swift 클래스 설명
 
 ## UIViewController 상속 받음
 - 클래스들의 검색 리스트를 보기 위한 화면
 */
class FeedbackSearchViewController: UIViewController,MoreTableViewCellDelegate{
    
    /** **검색뷰 */
    @IBOutlet var searchView: UIView!
    /** **돌아가기 버튼 */
    @IBOutlet var returnBackBtn: UIButton!
    /** **정보 검색 텍스트필드 */
    @IBOutlet var textField: UITextField!
    /** **테이블뷰 */
    @IBOutlet var tableView: UITableView!
    /** **검색 확인 버튼 */
    @IBOutlet var searchBtn: UIButton!
    /** **검색 전 순위 리스트 */
    var rankList:SearchRankModel?
    /** **검색 후 클래스 리스트 */
    var searchList:SearchModel?
    var searchListArr:Array = Array<SearchList>()
    /** **검색 체크 유무 */
    var searchCheck:Bool = false
    /** **키보드 보임 유무 */
    var keyboardShow:Bool = false
    var searchWord = ""
    /** **새로고침 컨트롤 */
    var refreshControl = UIRefreshControl()
    var order = "match_score" // (match_score / signup / price / laster) - 정확도순, 참여인기순, 가격순, 최신순)
    
    var autoSearchList:AutoSearchModel?
    var autoSearchList_arr:Array = Array<DataList>()
    var suggestedSource : [String] = [String]()
    let dropDown = AutoSearchEngine()
    var page = 1
    
    let sameView = UIView()
    let feedStoryboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
    let webViewStoryboard: UIStoryboard = UIStoryboard(name: "WebView", bundle: nil)
    let childWebViewStoryboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        tableView.addSubview(refreshControl)
        
        Indicator.showActivityIndicator(uiView: self.view)
        if searchWord == "" {
            app_search_before()
        }else{
            if searchWord == "all"{
                searchWord = ""
                app_search(query: "",order : self.order)
            }else{
                app_search(query: searchWord,order : self.order)
            }
        }

        searchView.layer.cornerRadius = 15
        searchView.layer.borderColor = UIColor(hexString: "#efefef").cgColor
        searchView.layer.borderWidth = 1
        searchView.layer.masksToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldFocusOut), name: NSNotification.Name(rawValue: "SearchKeyBoardHide"), object: nil )
        self.textField.addTarget(self, action: #selector(self.textFieldDidChangeSelection(_:)), for: .editingChanged)
        
    }
    
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /** **뷰가 사라지기 시작 할 때 타는 메소드 */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.setScreenName("검색", screenClass: "FeedbackSearchViewController")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        textField.delegate = nil
        NotificationCenter.default.removeObserver(self)
        print("FeedbackSearchViewController deinit")
    }
    
    /** **검색 버튼 클릭 > 검색 후 리스트를 가져옴 */
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.textField.text?.isBlank == false{
            self.page = 1
//            self.searchList = nil
            self.searchListArr.removeAll()
            let searchParam = textField.text!
            app_search(query: searchParam,order : self.order)
        }
    }
    
    /** **이전 버튼 클릭 > 앞단계 뷰로 이동 */
    @IBAction func returnBtnClicked(_ sender: UIButton) {
        if self.sameView.superview?.subviews.last == self.sameView {
            self.sameView.removeFromSuperview()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func categoryBtnClicked(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .transitionFlipFromTop, animations: {
            let indexPath = IndexPath(row: 0, section: 0)
//            let indexPath = NSIndexPath(row: NSNotFound, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }, completion: {_ in
            DispatchQueue.main.async {
                if sender.tag == 10000{
                    self.searchWord = ""
                    self.app_search(query: "",order : self.order)
                }else{
                    if self.searchCheck == false{
                        self.searchWord = self.rankList?.results?.category_arr[sender.tag].name ?? ""
                        self.app_search(query: self.rankList?.results?.category_arr[sender.tag].name ?? "",order : self.order)
                    }else{
                        self.page = 1
                        self.searchListArr.removeAll()
                        print(self.searchList?.results?.category_arr[sender.tag].name ?? "")
//                        self.searchList = nil
                        self.searchWord = self.searchList?.results?.category_arr[sender.tag].name ?? ""
                        self.app_search(query: self.searchList?.results?.category_arr[sender.tag].name ?? "",order : self.order)
                    }
                }
            }
        })
        
    }
    
    /** **좋아요 버튼 클릭 > 검색한 클래스에 찜을 하거나 찜을 취소함 */
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        haveSave(sender:sender)
    }
    
    @IBAction func lastSearchBtnClicked(_ sender: UIButton) {
        app_search(query: rankList?.results?.search_list_arr[sender.tag].name ?? "",order : self.order)
    }
    
    @IBAction func poppularSearchBtnClicked(_ sender: UIButton) {
        app_search(query: rankList?.results?.interest_list_arr[sender.tag].name ?? "",order : self.order)
    }
    
    @IBAction func classDetailMoveBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        self.navigationController?.popOrPushController(class_id: searchListArr[tag].class_id ?? 0)
    }
    
    @IBAction func eventViewBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        let url = "\(self.rankList?.results?.event_icon_list_arr[tag].link ?? "")"
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        
        if tag == 0 {
            newViewController.url = url
            self.navigationController?.pushViewController(newViewController, animated: true)
        } else if tag == 1 {
            newViewController.url = url
            self.navigationController?.pushViewController(newViewController, animated: true)
        } else {
            newViewController.url = url
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func eventImgBtnClicked(_ sender: UIButton) {
        let url = "\(self.rankList?.results?.event_list_arr[0].link ?? "")"
        let newViewController = childWebViewStoryboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
        newViewController.url = url
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 새로고침 컨트롤이 끝났을때 타는 함수
     
     - Throws: `Error` 새로고침이 끝나지 않는 경우 `Error`
     */
    func endOfWork() {
        refreshControl.endRefreshing()
    }
    
  /**
    **파라미터가 있고 반환값이 없는 메소드 > 스크롤이 멈췄을시 타는 함수
     
     - Parameters:
        - scrollView: 스크롤뷰 관련 된 처리 가능하도록 스크롤뷰 넘어옴
     
     - Throws: `Error` 스크롤이 이상한 값으로 넘어올 경우 `Error`
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            if searchCheck == false{
                DispatchQueue.main.async {
//                    self.searchList = nil
                    self.app_search_before()
                }
            }else{
                DispatchQueue.main.async {
//                    self.searchList = nil
                    self.searchListArr.removeAll()
                    self.page = 1
                    let searchParam = self.textField.text!
                    self.app_search(query: searchParam,order : self.order)
                }
            }
        }
    }
    
    func moreTableViewCellDidTappedButton(sender: UIButton) {
        let config = FTConfiguration.shared
        config.backgoundTintColor = UIColor.white
        config.menuSeparatorColor = UIColor(hexString: "#FF5A5F")
        
        let cellConfiguration = FTCellConfiguration()
        cellConfiguration.textAlignment = .center
        cellConfiguration.textColor = UIColor(hexString: "#1a1a1a")//.black
        let cellconfig = [cellConfiguration,cellConfiguration,cellConfiguration,cellConfiguration]
        
        var menuOptionNameArray : [String] {
            return ["정확도순","참여 인기순","가격 낮은순","최신 등록순"]
        }
        var menuImageNameArray : [String] {
            return ["","","",""]
        }
        
        FTPopOverMenu.showForSender(sender: sender, with: menuOptionNameArray, menuImageArray: nil, cellConfigurationArray: cellconfig, done: { [unowned self] (selectedIndex) -> () in
//            (match_score / signup / price / laster)
            if selectedIndex == 0{
                self.order = "match_score"
            }else if selectedIndex == 1{
                self.order = "signup"
            }else if selectedIndex == 2{
                self.order = "price"
            }else{
                self.order = "laster"
            }
            self.searchListArr.removeAll()
//            self.searchList = nil
            self.page = 1
            sender.setTitle("\(menuOptionNameArray[selectedIndex])", for: .normal)
            self.app_search(query: self.textField.text ?? "",order : self.order)
        })
    }
    
    func sizeOfImageAt(url: URL) -> CGSize? {
            // with CGImageSource we avoid loading the whole image into memory
            guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
                return nil
            }

            let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
                return nil
            }

            if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
                let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
                return CGSize(width: width, height: height)
            } else {
                return nil
            }
        }
    
    func underline(fullStr:String , str:String) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: fullStr)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AppleSDGothicNeo-Bold", size: 18)!, range: (fullStr as NSString).range(of:str))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 2, range: (fullStr as NSString).range(of:str))
        
        attributedString.addAttribute(NSAttributedString.Key.underlineColor , value: UIColor(hexString: "#FF5A5F"), range: (fullStr as NSString).range(of:str))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#1a1a1a") , range: (fullStr as NSString).range(of:str))
        return attributedString
    }
    
    func strikeline(str:String) -> NSAttributedString{
            let attributedString = NSMutableAttributedString(string: str)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!, range: (str as NSString).range(of:str))
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#b4b4b4") , range: (str as NSString).range(of:str))
            return attributedString
    }
    
    func gradientView1(cell: FeedbackSearchTableViewCell, row: Int) {
        let checkRow = (row*2)
        cell.classPhoto.sd_setImage(with: URL(string: "\(searchListArr[checkRow].class_photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
        cell.coachName.text = "\(searchListArr[checkRow].coach_name ?? "")•총 \(searchListArr[checkRow].curriculum_cnt ?? 0)강"
        cell.className.text = "\(searchListArr[checkRow].class_name ?? "")"
        if searchListArr[checkRow].price_sale ?? "" != "0"{
            print("price sale : \(searchListArr[checkRow].price_sale ?? "")")
            cell.classSalePer.text = "\(searchListArr[checkRow].price_sale ?? "")%"
        }
        cell.classSalePrice.text = "월 \(searchListArr[checkRow].payment_price ?? "")원"
        print("payment info : \(searchListArr[checkRow].payment_price ?? "")")
        if searchListArr[checkRow].class_have_status ?? "N" == "N"{
            cell.scrapBtn.setImage(UIImage(named:"search_scrap_icon_defaultV2"), for: .normal)
            cell.scrapBtn.tag = checkRow
        }else{
            cell.scrapBtn.setImage(UIImage(named:"search_scrap_icon_activeV2"), for: .normal)
            cell.scrapBtn.tag = checkRow
        }
        cell.classDetailMoveBtn.tag = checkRow
        cell.classActiveCount.text = "\(convertCurrency(money: (NSNumber(value: searchListArr[checkRow].helpful_cnt ?? 0)), style : NumberFormatter.Style.decimal))명 참여"
        
    }
    
    func gradientView2(cell: FeedbackSearchTableViewCell, row: Int) {
        let checkRow = (row*2)+1
        cell.classPhoto2.sd_setImage(with: URL(string: "\(searchListArr[checkRow].class_photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
        cell.coachName2.text = "\(searchListArr[checkRow].coach_name ?? "")•총 \(searchListArr[checkRow].curriculum_cnt ?? 0)강"
        cell.className2.text = "\(searchListArr[checkRow].class_name ?? "")"
        if searchListArr[checkRow].price_sale ?? "" != "0"{
            cell.classSalePer2.text = "\(searchListArr[checkRow].price_sale ?? "")%"
        }
        cell.classSalePrice2.text = "월 \(searchListArr[checkRow].payment_price ?? "")원"

        if searchListArr[checkRow].class_have_status ?? "N" == "N"{
            cell.scrapBtn2.setImage(UIImage(named:"search_scrap_icon_defaultV2"), for: .normal)
            cell.scrapBtn2.tag = checkRow
        }else{
            cell.scrapBtn2.setImage(UIImage(named:"search_scrap_icon_activeV2"), for: .normal)
            cell.scrapBtn2.tag = checkRow
        }
        cell.classDetailMoveBtn2.tag = checkRow
        cell.classActiveCount2.text = "\(convertCurrency(money: (NSNumber(value: searchListArr[checkRow].helpful_cnt ?? 0)), style : NumberFormatter.Style.decimal))명 참여"
    }
}

extension FeedbackSearchViewController:UITableViewDelegate,UITableViewDataSource{
    
    /** **테이블 셀의 섹션당 로우 개수 함수 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchCheck == false{
            switch section {
            case 0,1:
                if self.rankList?.results?.search_list_arr.count ?? 0 > 0{
                    return 1
                }else {
                    return 0
                }
            case 2,3:
                if self.rankList?.results?.interest_list_arr.count ?? 0 > 0{
                    return 1
                }else {
                    return 0
                }
            case 4:
                if self.rankList?.results?.event_list_arr.count ?? 0 > 0 {
                    return 1
                }  else {
                    return 0
                }
            case 5:
                if rankList?.results?.category_arr.count ?? 0 > 0{
                    return 1
                }else{
                    return 0
                }
            case 6:
                if rankList?.results?.category_arr.count ?? 0 > 0{
                    if ((rankList?.results?.category_arr.count ?? 0 )+1) % 4 == 0{
                        return (((rankList?.results?.category_arr.count ?? 0)+1) / 4)
                    }else{
                        return (((rankList?.results?.category_arr.count ?? 0)+1) / 4) + 1
                    }
                }else{
                    return 0
                }
            default:
                return 0
            }
        }else{
            if searchList != nil{
                if searchListArr.count > 0{
                    if section == 0 {
                        return 0
                    } else if section == 2{
                        if self.searchListArr.count % 2 == 0 {
                            return self.searchListArr.count/2
                        } else {
                            return self.searchListArr.count/2 + 1
                        }
                    }else if section == 4{
                        if searchList != nil{
                            if searchList?.results?.category_arr.count ?? 0 > 0{
                                if ((searchList?.results?.category_arr.count ?? 0)+1) % 4 == 0{
                                    return (((searchList?.results?.category_arr.count ?? 0)+1) / 4)
                                }else{
                                    return (((searchList?.results?.category_arr.count ?? 0)+1) / 4) + 1
                                }
                            }else{
                                return 0
                            }
                        }else{
                            return 0
                        }
                    }else{
                        return 1
                    }
                }else{
                    if section == 2{
                        if searchList != nil{
                            if searchList?.results?.category_arr.count ?? 0 > 0{
                                if ((searchList?.results?.category_arr.count ?? 0)+1) % 4 == 0{
                                    return (((searchList?.results?.category_arr.count ?? 0)+1) / 4)
                                }else{
                                    return (((searchList?.results?.category_arr.count ?? 0)+1) / 4) + 1
                                }
                            }else{
                                return 0
                            }
                        }else{
                            return 0
                        }
                    }else{
                        return 1
                    }
                }
            }else{
                return 0
            }
            
        }
    }
    
    /** **테이블 셀의 섹션 개수 함수 */
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchCheck == false{
            return 7
        }else{
            if searchListArr.count > 0{
                return 5
            }else{
                return 3
            }
        }
        
    }

    
    /** **테이블 셀의 높이 함수 */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /** **테이블 셀의 로우 및 섹션 데이터 함수 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if searchCheck == false{
            switch section {
            case 0:
                let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchBeforeTitleCell", for: indexPath) as! FeedbackSearchTableViewCell
                cell.beforeTitle.text = "최근 검색어"
                cell.beforeTitle.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12.5)!
                cell.beforeTitle.textColor = UIColor(hexString: "#767676")
                cell.selectionStyle = .none
                return cell
            case 1:
                let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchBeforeList1Cell", for: indexPath) as! FeedbackSearchTableViewCell
                
                if self.rankList != nil{
                    cell.collectionTag = 1
                    cell.rankList = self.rankList
                    cell.callColection()
                    DispatchQueue.main.async {
                        self.tableView.beginUpdates()
                        cell.collectionViewHeightConst1.constant = cell.collectionView1.contentSize.height
                        self.tableView.endUpdates()
                        
                    }
                }
                DispatchQueue.main.async {
                    cell.layoutIfNeeded()
                }
                cell.selectionStyle = .none
                return cell
            case 2:
                let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchBeforeTitleCell", for: indexPath) as! FeedbackSearchTableViewCell
                cell.beforeTitle.text = "실시간 인기 관심사"
                cell.beforeTitle.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 12.5)!
                cell.beforeTitle.textColor = UIColor(hexString: "#767676")
                cell.selectionStyle = .none
                return cell
            case 3:
                let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchBeforeList2Cell", for: indexPath) as! FeedbackSearchTableViewCell
                if rankList != nil{
                    cell.collectionTag = 2
                    cell.rankList = self.rankList
                    cell.callColection()
                    DispatchQueue.main.async {
                        self.tableView.beginUpdates()
                        cell.collectionViewHeightConst2.constant = cell.collectionView2.contentSize.height
                        self.tableView.endUpdates()
                        
                    }
                }
                cell.selectionStyle = .none
                return cell
            case 4:
                let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchBeforeEventViewCell", for: indexPath) as! FeedbackSearchTableViewCell
                
                cell.newClassEventLbl.text = self.rankList?.results?.event_icon_list_arr[0].txt ?? "오픈알림"
                cell.newClassEventImg.sd_setImage(with: URL(string: "\(self.rankList?.results?.event_icon_list_arr[0].image ?? "")"), completed: nil)
                cell.diamondPlanLbl.text = self.rankList?.results?.event_icon_list_arr[1].txt ?? "기획전"
                cell.diamondPlanImg.sd_setImage(with: URL(string: "\(self.rankList?.results?.event_icon_list_arr[1].image ?? "")"), completed: nil)
                cell.specialRewardLbl.text = self.rankList?.results?.event_icon_list_arr[2].txt ?? "얼리버드 특가"
                cell.specialRewardImg.sd_setImage(with: URL(string: "\(self.rankList?.results?.event_icon_list_arr[2].image ?? "")"), completed: nil)
                
                let url = URL(string: "\(self.rankList?.results?.event_list_arr[0].image ?? "")")!
                let ratio = (sizeOfImageAt(url: url)?.width ?? 0)/(sizeOfImageAt(url: url)?.height ?? 0)
                let newHeight = cell.eventImg.frame.width/ratio
                cell.eventImgHeight.constant = newHeight
                
                cell.eventImg.sd_setImage(with: url, completed: nil)
                
                cell.selectionStyle = .none
                return cell
            case 5:
                let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchBeforeTitleCell", for: indexPath) as! FeedbackSearchTableViewCell
                cell.beforeTitle.text = "다른 관심사에 도전해보세요."
                cell.beforeTitle.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)!
                cell.beforeTitle.textColor = UIColor(hexString: "#484848")
                cell.selectionStyle = .none
                return cell
            case 6:
                let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchAfterCategoryCell", for: indexPath) as! FeedbackSearchTableViewCell
                
                var rowCount = 0
                let divideCount = ((rankList?.results?.category_arr.count ?? 0)+1) % 4
                if rankList?.results != nil{
                    if rankList?.results?.category_arr.count ?? 0 > 0{
                        if ((rankList?.results?.category_arr.count ?? 0)+1) % 4 == 0{
                            rowCount = (((rankList?.results?.category_arr.count ?? 0)+1) / 4)
                        }else{
                            rowCount = (((rankList?.results?.category_arr.count ?? 0)+1) / 4) + 1
                        }
                        if rowCount > 0{
                            if rowCount - 1 == row{
                                if divideCount == 3{
                                    rankCategoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: true, cellCheck4: false,checkAllRow:3,checkLastRow:true)
                                }else if divideCount == 2{
                                    rankCategoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: false, cellCheck4: false,checkAllRow:2,checkLastRow:true)
                                }else if divideCount == 1{
                                    rankCategoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: false, cellCheck3: false, cellCheck4: false,checkAllRow:1,checkLastRow:true)
                                }else{
                                    rankCategoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: true, cellCheck4: true,checkAllRow:4,checkLastRow:true)
                                }
                            }else{
                                rankCategoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: true, cellCheck4: true,checkAllRow:4,checkLastRow:false)
                            }
                        }else{
                            if divideCount == 3{
                                rankCategoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: true, cellCheck4: false,checkAllRow:3,checkLastRow:true)
                            }else if divideCount == 2{
                                rankCategoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: false, cellCheck4: false,checkAllRow:2,checkLastRow:true)
                            }else if divideCount == 1{
                                rankCategoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: false, cellCheck3: false, cellCheck4: false,checkAllRow:1,checkLastRow:true)
                            }else{}
                        }

                    }
                }
                
                cell.selectionStyle = .none
                return cell
                
            default:
                let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchBeforeList2Cell", for: indexPath) as! FeedbackSearchTableViewCell
                cell.selectionStyle = .none
                return cell
            }
        }else{
            if searchListArr.count > 0{
                switch section {
                case 0:
                    let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchAfterTitleCell", for: indexPath) as! FeedbackSearchTableViewCell
                    if searchList?.results?.search ?? "" == "" {
                        cell.afterTitle.text = "전체"
                    }else{
                        cell.afterTitle.text = "\(searchList?.results?.search ?? "")"
                    }
                    let fullStr = "즐겨찾기 후 무료 체험하세요."
                    let str = "즐겨찾기"
                    let attributedString = NSMutableAttributedString(string: fullStr)
                    attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!, range: (fullStr as NSString).range(of:str))
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#FF5A5F") , range: (fullStr as NSString).range(of:str))

                    cell.favoriteTitle.attributedText = attributedString
                    cell.selectionStyle = .none
                    return cell
                case 1:
                    let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchAfterListTitleCell", for: indexPath) as! FeedbackSearchTableViewCell
                    cell.searchCount.text = "검색결과 \(searchList?.results?.total ?? 0)건"
                    cell.delegate = self
                    cell.selectionStyle = .none
                    return cell
                case 2:
                    let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchAfterListCell", for: indexPath) as! FeedbackSearchTableViewCell
                    if searchListArr.count > (row*2)+1 {
                        self.gradientView1(cell: cell, row: row)
                        self.gradientView2(cell: cell, row: row)
                    } else {
                        self.gradientView1(cell: cell, row: row)
                    }
                    cell.selectionStyle = .none
                    return cell
                case 3:
                    let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchBeforeTitleCell", for: indexPath) as! FeedbackSearchTableViewCell
                    cell.beforeTitle.text = "다른 관심사에 도전해보세요."
                    cell.beforeTitle.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)!
                    cell.beforeTitle.textColor = UIColor(hexString: "#484848")
                    cell.selectionStyle = .none
                    return cell
                case 4:
                    let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchAfterCategoryCell", for: indexPath) as! FeedbackSearchTableViewCell

                    var rowCount = 0
                    let divideCount = ((searchList?.results?.category_arr.count ?? 0)+1) % 4
                    if searchList?.results != nil{
                        if searchList?.results?.category_arr.count ?? 0 > 0{
                            if ((searchList?.results?.category_arr.count ?? 0)+1) % 4 == 0{
                                rowCount = (((searchList?.results?.category_arr.count ?? 0)+1) / 4)
                            }else{
                                rowCount = (((searchList?.results?.category_arr.count ?? 0)+1) / 4) + 1
                            }

                            if rowCount > 0{
                                if rowCount - 1 == row{
                                    if divideCount == 3{
                                        categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: true, cellCheck4: false,checkAllRow:3,checkLastRow:true)
                                    }else if divideCount == 2{
                                        categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: false, cellCheck4: false,checkAllRow:2,checkLastRow:true)
                                    }else if divideCount == 1{
                                        categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: false, cellCheck3: false, cellCheck4: false,checkAllRow:1,checkLastRow:true)
                                    }else{
                                        categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: true, cellCheck4: true,checkAllRow:4,checkLastRow:true)
                                    }
                                }else{
                                    categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: true, cellCheck4: true,checkAllRow:1,checkLastRow:false)
                                }
                            }else{
                                if divideCount == 3{
                                    categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: true, cellCheck4: false,checkAllRow:3,checkLastRow:true)
                                }else if divideCount == 2{
                                    categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: false, cellCheck4: false,checkAllRow:2,checkLastRow:true)
                                }else if divideCount == 1{
                                    categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: false, cellCheck3: false, cellCheck4: false,checkAllRow:1,checkLastRow:true)
                                }else{}
                            }

                        }
                    }
                    
                    cell.selectionStyle = .none
                    return cell
                default:
                    let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchAfterTitleCell", for: indexPath) as! FeedbackSearchTableViewCell
                    
                    cell.selectionStyle = .none
                    return cell
                }
            }else{
                switch section {
                case 0:
                    let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchEmptyCell", for: indexPath) as! FeedbackSearchTableViewCell
                    cell.selectionStyle = .none
                    return cell
                case 1:
                    let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchBeforeTitleCell", for: indexPath) as! FeedbackSearchTableViewCell
                    cell.beforeTitle.text = "다른 관심사에 도전해보세요."
                    cell.beforeTitle.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)!
                    cell.beforeTitle.textColor = UIColor(hexString: "#484848")
                    cell.selectionStyle = .none
                    return cell
                case 2:
                    let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchAfterCategoryCell", for: indexPath) as! FeedbackSearchTableViewCell
                    
                    var rowCount = 0
                    let divideCount = ((searchList?.results?.category_arr.count ?? 0)+1) % 4
                    if searchList?.results != nil{
                        if searchList?.results?.category_arr.count ?? 0 > 0{
                            if ((searchList?.results?.category_arr.count ?? 0)+1) % 4 == 0{
                                rowCount = (((searchList?.results?.category_arr.count ?? 0)+1) / 4)
                            }else{
                                rowCount = (((searchList?.results?.category_arr.count ?? 0)+1) / 4) + 1
                            }

                            if rowCount > 0{
                                if rowCount - 1 == row{
                                    if divideCount == 3{
                                        categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: true, cellCheck4: false,checkAllRow:3,checkLastRow:true)
                                    }else if divideCount == 2{
                                        categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: false, cellCheck4: false,checkAllRow:2,checkLastRow:true)
                                    }else if divideCount == 1{
                                        categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: false, cellCheck3: false, cellCheck4: false,checkAllRow:1,checkLastRow:true)
                                    }else{
                                        categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: true, cellCheck4: true,checkAllRow:4,checkLastRow:true)
                                    }
                                }else{
                                    categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: true, cellCheck4: true,checkAllRow:1,checkLastRow:false)
                                }
                            }else{
                                if divideCount == 3{
                                    categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: true, cellCheck4: false,checkAllRow:3,checkLastRow:true)
                                }else if divideCount == 2{
                                    categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: true, cellCheck3: false, cellCheck4: false,checkAllRow:2,checkLastRow:true)
                                }else if divideCount == 1{
                                    categoryCheckCell(cell: cell, row: row, cellCheck1: true, cellCheck2: false, cellCheck3: false, cellCheck4: false,checkAllRow:1,checkLastRow:true)
                                }else{}
                            }

                        }
                    }
                    
                    cell.selectionStyle = .none
                    return cell
                default:
                    let cell:FeedbackSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchAfterTitleCell", for: indexPath) as! FeedbackSearchTableViewCell

                    cell.selectionStyle = .none
                    return cell
                }
            }
            
        }
    }
    
    /** **테이블 셀 선택시 함수 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if searchCheck == true{
            if section == 2{
                if row == (searchListArr.count/2)-2{
                    if searchList?.results?.total_page ?? 0 > page {
                        self.page = self.page + 1
                        app_search(query: searchWord,order : self.order)
                    }
                }
            }
        }
    }
}

extension FeedbackSearchViewController{
    
    func rankCategoryCheckCell(cell: FeedbackSearchTableViewCell, row:Int, cellCheck1:Bool, cellCheck2: Bool, cellCheck3: Bool, cellCheck4: Bool, checkAllRow: Int, checkLastRow: Bool) {
        
        if cellCheck1 == true{
            if checkLastRow == true{
                if checkAllRow == 1{
                    cell.categoryImg1.image = UIImage(named: "allCategory")
                    cell.categorySubject1.text = "전체보기"
                    cell.categoryImg1.isHidden = false
                    cell.categoryBtn1.tag = 10000
                }else{
                    cell.categoryImg1.sd_setImage(with: URL(string: "\(rankList?.results?.category_arr[(row*4)].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                    cell.categorySubject1.text = "\(rankList?.results?.category_arr[(row*4)].name ?? "")"
                    cell.categoryImg1.isHidden = false
                    cell.categoryBtn1.tag = row*4
                }
            }else{
                cell.categoryImg1.sd_setImage(with: URL(string: "\(rankList?.results?.category_arr[(row*4)].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.categorySubject1.text = "\(rankList?.results?.category_arr[(row*4)].name ?? "")"
                cell.categoryImg1.isHidden = false
                cell.categoryBtn1.tag = row*4
            }
        }else{
            cell.categoryImg1.image = nil
            cell.categoryImg1.isHidden = true
            cell.categorySubject1.text = ""
        }
        if cellCheck2 == true{
            if checkLastRow == true{
                if checkAllRow == 2{
                    cell.categoryImg2.image = UIImage(named: "allCategory")
                    cell.categorySubject2.text = "전체보기"
                    cell.categoryImg2.isHidden = false
                    cell.categoryBtn2.tag = 10000
                }else{
                    cell.categoryImg2.sd_setImage(with: URL(string: "\(rankList?.results?.category_arr[(row*4)+1].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                    cell.categorySubject2.text = "\(rankList?.results?.category_arr[(row*4)+1].name ?? "")"
                    cell.categoryImg2.isHidden = false
                    cell.categoryBtn2.tag = (row*4)+1
                }
            }else{
                cell.categoryImg2.sd_setImage(with: URL(string: "\(rankList?.results?.category_arr[(row*4)+1].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.categorySubject2.text = "\(rankList?.results?.category_arr[(row*4)+1].name ?? "")"
                cell.categoryImg2.isHidden = false
                cell.categoryBtn2.tag = (row*4)+1
            }
        }else{
            cell.categoryImg2.image = nil
            cell.categoryImg2.isHidden = true
            cell.categorySubject2.text = ""
        }
        if cellCheck3 == true{
            if checkLastRow == true{
                if checkAllRow == 3{
                    cell.categoryImg3.image = UIImage(named: "allCategory")
                    cell.categorySubject3.text = "전체보기"
                    cell.categoryImg3.isHidden = false
                    cell.categoryBtn3.tag = 10000
                }else{
                    cell.categoryImg3.sd_setImage(with: URL(string: "\(rankList?.results?.category_arr[(row*4)+2].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                    cell.categorySubject3.text = "\(rankList?.results?.category_arr[(row*4)+2].name ?? "")"
                    cell.categoryImg3.isHidden = false
                    cell.categoryBtn3.tag = (row*4)+2
                }
            }else{
                cell.categoryImg3.sd_setImage(with: URL(string: "\(rankList?.results?.category_arr[(row*4)+2].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.categorySubject3.text = "\(rankList?.results?.category_arr[(row*4)+2].name ?? "")"
                cell.categoryImg3.isHidden = false
                cell.categoryBtn3.tag = (row*4)+2
            }
        }else{
            cell.categoryImg3.image = nil
            cell.categoryImg3.isHidden = true
            cell.categorySubject3.text = ""
        }
        if cellCheck4 == true{
            if checkLastRow == true{
                if checkAllRow == 4{
                    cell.categoryImg4.image = UIImage(named: "allCategory")
                    cell.categorySubject4.text = "전체보기"
                    cell.categoryImg4.isHidden = false
                    cell.categoryBtn4.tag = 10000
                }else{
                    cell.categoryImg4.sd_setImage(with: URL(string: "\(rankList?.results?.category_arr[(row*4)+3].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                    cell.categorySubject4.text = "\(rankList?.results?.category_arr[(row*4)+3].name ?? "")"
                    cell.categoryImg4.isHidden = false
                    cell.categoryBtn4.tag = (row*4)+3
                }
            }else{
                cell.categoryImg4.sd_setImage(with: URL(string: "\(rankList?.results?.category_arr[(row*4)+3].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.categorySubject4.text = "\(rankList?.results?.category_arr[(row*4)+3].name ?? "")"
                cell.categoryImg4.isHidden = false
                cell.categoryBtn4.tag = (row*4)+3
            }
        }else{
            cell.categoryImg4.image = nil
            cell.categoryImg4.isHidden = true
            cell.categorySubject4.text = ""
        }
    }
    
    func categoryCheckCell(cell: FeedbackSearchTableViewCell, row: Int, cellCheck1: Bool, cellCheck2: Bool, cellCheck3: Bool, cellCheck4: Bool, checkAllRow: Int, checkLastRow: Bool){
        if cellCheck1 == true{
            if checkLastRow == true{
                if checkAllRow == 1{
                    cell.categoryImg1.image = UIImage(named: "allCategory")
                    cell.categorySubject1.text = "전체보기"
                    cell.categoryImg1.isHidden = false
                    cell.categoryBtn1.tag = 10000
                }else{
                    cell.categoryImg1.sd_setImage(with: URL(string: "\(searchList?.results?.category_arr[(row*4)].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                    cell.categorySubject1.text = "\(searchList?.results?.category_arr[(row*4)].name ?? "")"
                    cell.categoryImg1.isHidden = false
                    cell.categoryBtn1.tag = row*4
                }
            }else{
                cell.categoryImg1.sd_setImage(with: URL(string: "\(searchList?.results?.category_arr[(row*4)].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.categorySubject1.text = "\(searchList?.results?.category_arr[(row*4)].name ?? "")"
                cell.categoryImg1.isHidden = false
                cell.categoryBtn1.tag = row*4
            }
        }else{
            cell.categoryImg1.image = nil
            cell.categoryImg1.isHidden = true
            cell.categorySubject1.text = ""
        }
        if cellCheck2 == true{
            if checkLastRow == true{
                if checkAllRow == 2{
                    cell.categoryImg2.image = UIImage(named: "allCategory")
                    cell.categorySubject2.text = "전체보기"
                    cell.categoryImg2.isHidden = false
                    cell.categoryBtn2.tag = 10000
                }else{
                    cell.categoryImg2.sd_setImage(with: URL(string: "\(searchList?.results?.category_arr[(row*4)+1].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                    cell.categorySubject2.text = "\(searchList?.results?.category_arr[(row*4)+1].name ?? "")"
                    cell.categoryImg2.isHidden = false
                    cell.categoryBtn2.tag = (row*4)+1
                }
            }else{
                cell.categoryImg2.sd_setImage(with: URL(string: "\(searchList?.results?.category_arr[(row*4)+1].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.categorySubject2.text = "\(searchList?.results?.category_arr[(row*4)+1].name ?? "")"
                cell.categoryImg2.isHidden = false
                cell.categoryBtn2.tag = (row*4)+1
            }
        }else{
            cell.categoryImg2.image = nil
            cell.categoryImg2.isHidden = true
            cell.categorySubject2.text = ""
        }
        if cellCheck3 == true{
            if checkLastRow == true{
                if checkAllRow == 3{
                    cell.categoryImg3.image = UIImage(named: "allCategory")
                    cell.categorySubject3.text = "전체보기"
                    cell.categoryImg3.isHidden = false
                    cell.categoryBtn3.tag = 10000
                }else{
                    cell.categoryImg3.sd_setImage(with: URL(string: "\(searchList?.results?.category_arr[(row*4)+2].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                    cell.categorySubject3.text = "\(searchList?.results?.category_arr[(row*4)+2].name ?? "")"
                    cell.categoryImg3.isHidden = false
                    cell.categoryBtn3.tag = (row*4)+2
                }
            }else{
                cell.categoryImg3.sd_setImage(with: URL(string: "\(searchList?.results?.category_arr[(row*4)+2].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.categorySubject3.text = "\(searchList?.results?.category_arr[(row*4)+2].name ?? "")"
                cell.categoryImg3.isHidden = false
                cell.categoryBtn3.tag = (row*4)+2
            }
            
        }else{
            cell.categoryImg3.image = nil
            cell.categoryImg3.isHidden = true
            cell.categorySubject3.text = ""
        }
        if cellCheck4 == true{
            if checkLastRow == true{
                if checkAllRow == 4{
                    cell.categoryImg4.image = UIImage(named: "allCategory")
                    cell.categorySubject4.text = "전체보기"
                    cell.categoryImg4.isHidden = false
                    cell.categoryBtn4.tag = 10000
                }else{
                    cell.categoryImg4.sd_setImage(with: URL(string: "\(searchList?.results?.category_arr[(row*4)+3].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                    cell.categorySubject4.text = "\(searchList?.results?.category_arr[(row*4)+3].name ?? "")"
                    cell.categoryImg4.isHidden = false
                    cell.categoryBtn4.tag = (row*4)+3
                }
            }else{
                cell.categoryImg4.sd_setImage(with: URL(string: "\(searchList?.results?.category_arr[(row*4)+3].photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
                cell.categorySubject4.text = "\(searchList?.results?.category_arr[(row*4)+3].name ?? "")"
                cell.categoryImg4.isHidden = false
                cell.categoryBtn4.tag = (row*4)+3
            }
        }else{
            cell.categoryImg4.image = nil
            cell.categoryImg4.isHidden = true
            cell.categorySubject4.text = ""
        }
    }

    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 랭크를 알기위해 가져오는 함수
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func app_search_before(){
        FeedApi.shared.searchRank(success: { [unowned self] result in
            
            if result.code! == "200"{
                self.rankList = result
                DispatchQueue.main.async {
                    self.endOfWork()
                   
                    self.tableView.reloadData()
                    Indicator.hideActivityIndicator(uiView: self.view)
                }
            }else{
                Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                    Indicator.hideActivityIndicator(uiView: self.view)
                    self.endOfWork()
                })
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                Indicator.hideActivityIndicator(uiView: self.view)
                self.endOfWork()
            })
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 검색어로 리스트를 가져오는 함수
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func app_search(query: String, order: String) {
        Indicator.showActivityIndicator(uiView: self.view)
        FeedApi.shared.searchApp(search: query, order: order,page: self.page,success: { [unowned self] result in
            
            if result.code! == "200"{
                self.searchCheck = true
                self.searchList = result

                for addArray in 0 ..< (self.searchList?.results?.list_arr.count ?? 0)! {
                    self.searchListArr.append((self.searchList?.results?.list_arr[addArray])!)
                }
                
                DispatchQueue.main.async {
                    self.endOfWork()
                    Indicator.hideActivityIndicator(uiView: self.view)
                    self.textField.text = query
                    self.tableView.reloadData()
                }
            }else{
                Indicator.hideActivityIndicator(uiView: self.view)
                self.endOfWork()
            }
        }) { error in
            Indicator.hideActivityIndicator(uiView: self.view)
            self.endOfWork()
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 해당 클래스에 찜을하거나 찜을 취소하는 함수
     
     - Parameters:
        - sender: 버튼 태그값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func haveSave(sender:UIButton){
        let tag = sender.tag
        let class_id = searchListArr[tag].class_id ?? 0
        var type = ""
        if searchListArr[tag].class_have_status ?? "" == "N"{
            type = "post"
        }else{
            type = "delete"
        }
        
        FeedApi.shared.class_have(class_id:class_id,type:type,success: { [unowned self] result in
            if result.code == "200"{
                if self.searchListArr[tag].class_have_status ?? "" == "N"{
                    sender.setImage(UIImage(named: "search_scrap_icon_activeV2"), for: .normal)
                    self.searchListArr[tag].class_have_status = "Y"
                    Toast.showFavorite(message: "즐겨찾기 목록에 추가되었습니다.", controller: self)
                }else{
                    sender.setImage(UIImage(named: "search_scrap_icon_defaultV2"), for: .normal)
                    self.searchListArr[tag].class_have_status = "N"
                }
            }
        }) { error in
            
        }
    }
}


extension FeedbackSearchViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("typing started...")
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("End editing..")
        self.sameView.removeFromSuperview()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("shouldChangeCharacters")
        sameView.frame = self.tableView.frame
        dropDown.onView = sameView
        self.view.addSubview(sameView)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("textField did Change")
        getSuggestion(key: self.textField.text ?? "")
    }

    func autoSearch() {
        self.suggestedSource.removeAll()

        for i in 0..<(self.autoSearchList?.results?.data_list_arr.count ?? 0)! {
            self.suggestedSource.append((self.autoSearchList?.results?.data_list_arr[i].key)!)
        }
        dropDown.dataSource = suggestedSource
        dropDown.onTextField = self.textField
        dropDown.show { (str, index) in
            self.textField.text = str
            self.app_search(query: str, order: self.order)
            self.sameView.removeFromSuperview()
        }
    }
    
    func getSuggestion(key: String){
            FeedApi.shared.autoCompleteSearch(keyword: key, success: { [unowned self] result in
                if result.code! == "200"{
                    self.autoSearchList = result
                    DispatchQueue.main.async {
                        for addArray in 0..<(self.autoSearchList?.results?.data_list_arr.count ?? 0)! {
                            self.autoSearchList_arr.append((self.autoSearchList?.results?.data_list_arr[addArray])!)
                        }
                        self.autoSearch()
                    }
                }else{
                    print("Error in catching data from API!!!")
                }
            }) { error in
                print(error ?? "Error occured in calling AutoSearch API")
            }
        
        }
    
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 텍스트 필드 작성 완료 함수
     
     - Parameters:
        - textField: 텍스트필드 넘어옴
     
     - Throws: `Error` 텍스트필드값이 안넘어오는 경우 `Error`
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        self.page = 1
        self.searchList = nil
        self.searchListArr.removeAll()
        let searchParam = textField.text!
        app_search(query: searchParam ,order:self.order)
        return true
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 텍스트필드에서 포커스가 사라지는 경우
     
     - Parameters:
        - notification: 함수 호출용도로 사용
     
     - Throws: `Error` 함수가 인코딩 안된 경우 `Error`
     */
    @objc func textFieldFocusOut(notification: Notification) {
        self.view.endEditing(true)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 키보드가 보이는 경우
     
     - Parameters:
        - notification: 키보드 값이 유저인포에 담겨져서 넘어옴
     
     - Throws: `Error` 키보드가 구동이 안되는 경우 `Error`
     */
    @objc func keyboardWillShow(notification: Notification) {
        if keyboardShow == false {

            if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                UIView.animate(withDuration: 0.3, animations: {
                    let baseFrame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-kbSize.height)
                    self.view.frame = baseFrame
                    self.keyboardShow = true
                }) { success in

                }
            }
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 키보드가 사라지는 경우
     
     - Parameters:
        - notification: 키보드 값이 유저인포에 담겨져서 넘어옴
     
     - Throws: `Error` 키보드가 구동이 안되는 경우 `Error`
     */
    @objc func keyboardWillHide(notification: Notification) {
        if keyboardShow == true {

            if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

                UIView.animate(withDuration: 0.3, animations: {

                    let baseFrame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height+kbSize.height)
                    self.view.frame = baseFrame
                    self.keyboardShow = false

                }) { success in

                }
            }
        }
    }
}
