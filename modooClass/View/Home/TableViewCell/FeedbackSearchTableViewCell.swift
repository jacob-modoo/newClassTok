//
//  FeedbackSearchTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 16/09/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

protocol MoreTableViewCellDelegate :AnyObject{
    func moreTableViewCellDidTappedButton(sender: UIButton)
}

class FeedbackSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var beforeTitle: UIFixedLabel!
    
    @IBOutlet weak var collectionViewHeightConst1: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConst2: NSLayoutConstraint!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    
//    SearchBeforeEventViewCell
    @IBOutlet weak var newClassEventLbl: UIFixedLabel!
    @IBOutlet weak var newClassEventImg: UIImageView!
    @IBOutlet weak var diamondPlanLbl: UIFixedLabel!
    @IBOutlet weak var diamondPlanImg: UIImageView!
    @IBOutlet weak var specialRewardLbl: UIFixedLabel!
    @IBOutlet weak var specialRewardImg: UIImageView!
    @IBOutlet weak var eventImg: UIImageView!
    @IBOutlet weak var eventImgHeight: NSLayoutConstraint!
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var eventCollectionViewHeight: NSLayoutConstraint!
    
//    SearchAfterTitleCell
    @IBOutlet weak var afterTitle: UIFixedLabel!
    @IBOutlet weak var favoriteTitle: UIFixedLabel!
    
//    SearchAfterListTitleCell
    @IBOutlet weak var searchCount: UIFixedLabel!
    @IBOutlet weak var searchOrderBtn: UIFixedButton!
    
//    SearchAfterListCell (view 1)
    @IBOutlet weak var classPhoto: UIImageView!
    @IBOutlet weak var coachName: UIFixedLabel!
    @IBOutlet weak var className: UIFixedLabel!
    @IBOutlet weak var classSalePer: UIFixedLabel!
    @IBOutlet weak var classSalePrice: UIFixedLabel!
    @IBOutlet weak var classActiveCount: UIFixedLabel!
    @IBOutlet weak var scrapBtn: UIButton!
    @IBOutlet weak var classDetailMoveBtn: UIButton!
    @IBOutlet weak var memberView: UIView!
    
//    SearchAfterListCell (view 2)
    @IBOutlet weak var classPhoto2: UIImageView!
    @IBOutlet weak var coachName2: UIFixedLabel!
    @IBOutlet weak var className2: UIFixedLabel!
    @IBOutlet weak var classSalePer2: UIFixedLabel!
    @IBOutlet weak var classSalePrice2: UIFixedLabel!
    @IBOutlet weak var classActiveCount2: UIFixedLabel!
    @IBOutlet weak var classDetailMoveBtn2: UIButton!
    @IBOutlet weak var scrapBtn2: UIButton!
    @IBOutlet weak var memberView2: UIView!
    @IBOutlet weak var gradientView2: GradientView!
    
    
    //    HomeClassCategoryCell
    @IBOutlet weak var categoryImg1: UIImageView!
    @IBOutlet weak var categorySubject1: UIFixedLabel!
    @IBOutlet weak var categoryImg2: UIImageView!
    @IBOutlet weak var categorySubject2: UIFixedLabel!
    @IBOutlet weak var categoryImg3: UIImageView!
    @IBOutlet weak var categorySubject3: UIFixedLabel!
    @IBOutlet weak var categoryImg4: UIImageView!
    @IBOutlet weak var categorySubject4: UIFixedLabel!
    @IBOutlet weak var categoryBtn1: UIButton!
    @IBOutlet weak var categoryBtn2: UIButton!
    @IBOutlet weak var categoryBtn3: UIButton!
    @IBOutlet weak var categoryBtn4: UIButton!
    @IBOutlet weak var bottomLineView: UIView!
    
    weak var delegate : MoreTableViewCellDelegate?
    var timer = Timer()
    var counter = 0
    var collectionTag = 1
    var rankList:SearchRankModel?
    var eventListArr:Array = Array<EventList>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func scrollEventImg() {
        print("** collection view img count : \(rankList?.results?.event_list_arr.count ?? 0)\n** counter : \(counter)")
        var index = IndexPath.init(item: counter, section: 0)
        if rankList?.results?.event_list_arr.count ?? 0 > counter {
            eventCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        } else {
            counter = 0
            index = IndexPath.init(item: counter, section: 0)
            eventCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        }
    }

    func callColection(){
        print("** call collection is called!")
        let layout = LeftAlignedFlowLayout()
        if collectionTag == 1{
            let layout = LeftAlignedFlowLayout()
            layout.estimatedItemSize = CGSize(width: 50, height: 30)
            collectionView1.collectionViewLayout = layout
            collectionView1.reloadData()
        }else if collectionTag == 2{
            layout.estimatedItemSize = CGSize(width: 50, height: 30)
            collectionView2.collectionViewLayout = layout
            collectionView2.reloadData()
        }
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
    
    @IBAction func searchOrderBtnClicked(_ sender: UIButton) {
        if delegate != nil {
            delegate?.moreTableViewCellDidTappedButton(sender: sender)
        }
    }
    
    deinit {
    }
    
}

extension FeedbackSearchTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return rankList?.results?.search_list_arr.count ?? 0
        }else{
//        }else if collectionView == collectionView2 {
            return rankList?.results?.interest_list_arr.count ?? 0
        }
//        else{
//            return rankList?.results?.event_list_arr.count ?? 0
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        
        if collectionView == collectionView1 {
            let cell:FeedbackSearchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedbackSearch1", for: indexPath) as! FeedbackSearchCollectionViewCell
            cell.searchWord.text = "  # \(rankList?.results?.search_list_arr[row].name ?? "")  "
            cell.searchWord.layer.cornerRadius = 15
            cell.searchWord.layer.masksToBounds = true
            cell.searchListBtn.tag = row
            return cell
//        }else if collectionView == collectionView2 {
        } else {
            let cell:FeedbackSearchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedbackSearch2", for: indexPath) as! FeedbackSearchCollectionViewCell
            cell.searchWord.text = "  # \(rankList?.results?.interest_list_arr[row].name ?? "")  "
            cell.searchWord.layer.cornerRadius = 15
            cell.searchWord.layer.masksToBounds = true
            cell.searchListBtn.tag = row
            return cell
        }
//        else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchBeforeEventCollectionViewCell", for: indexPath) as! SearchBeforeEventCollectionViewCell
//
//            /** *this piece of code sets image height according to its size */
//            let url = URL(string: "\(self.rankList?.results?.event_list_arr[row].image ?? "")")!
//            let ratio = (sizeOfImageAt(url: url)?.width ?? 0)/(sizeOfImageAt(url: url)?.height ?? 0)
//            let newHeight = cell.eventImg.frame.width/ratio
//            if self.rankList?.results?.event_list_arr[row].image ?? "" != "" {
//                eventCollectionViewHeight.constant = newHeight
//                cell.eventImg.sd_setImage(with: url, completed: nil)
////                timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollEventImg), userInfo: nil, repeats: true)
//            } else {
//                eventCollectionViewHeight.constant = 0
//            }
//
//            return cell
//        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SearchKeyBoardHide"), object: nil)
        if collectionView == eventCollectionView {
            print("** the collectionCell is tapped!")
        }
    }
    
}

extension FeedbackSearchTableViewCell :UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        if collectionView == eventCollectionView {
//            let size = CGSize(width: self.eventCollectionView.frame.width, height: self.eventCollectionView.frame.height)
//            return size
//        } else {
//            return UICollectionViewFlowLayout.automaticSize
//        }
//
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}
