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
    var collectionTag = 1
    
    var rankList:SearchRankModel?
    
    @IBOutlet weak var collectionViewHeightConst1: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConst2: NSLayoutConstraint!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    
//    SearchAfterTitleCell
    @IBOutlet weak var afterTitle: UIFixedLabel!
    @IBOutlet weak var favoriteTitle: UIFixedLabel!
    
//    SearchAfterListTitleCell
    @IBOutlet weak var searchCount: UIFixedLabel!
    @IBOutlet weak var searchOrderBtn: UIFixedButton!
    
//    SearchAfterListCell
    @IBOutlet weak var classPhoto: UIImageView!
    @IBOutlet weak var coachPhoto: UIImageView!
    @IBOutlet weak var coachName: UIFixedLabel!
    @IBOutlet weak var reviewStar: UIImageView!
    @IBOutlet weak var reviewAvgCount: UIFixedLabel!
    @IBOutlet weak var className: UIFixedLabel!
    @IBOutlet weak var classSalePer: UIFixedLabel!
    @IBOutlet weak var classSalePrice: UIFixedLabel!
    @IBOutlet weak var classOriginalPrice: UIFixedLabel!
    @IBOutlet weak var classFirstOpen: UIImageView!
    @IBOutlet weak var classMemberCount: UIFixedLabel!
    @IBOutlet weak var classActiveCount: UIFixedLabel!
    @IBOutlet weak var classMemberPhoto1: UIImageView!
    @IBOutlet weak var classMemberPhoto2: UIImageView!
    @IBOutlet weak var classMemberPhoto3: UIImageView!
    @IBOutlet weak var classMemberPhoto4: UIImageView!
    @IBOutlet weak var scrapBtn: UIButton!
    @IBOutlet weak var classDetailMoveBtn: UIButton!
    @IBOutlet weak var memberView: UIView!
    
    
    //    HomeClassCategoryCell
    @IBOutlet weak var topLineView: UIView!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func callColection(){
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
        if collectionTag == 1{
            return rankList?.results?.search_list_arr.count ?? 0
        }else if collectionTag == 2{
            return rankList?.results?.interest_list_arr.count ?? 0
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        
        if collectionTag == 1{
            let cell:FeedbackSearchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedbackSearch1", for: indexPath) as! FeedbackSearchCollectionViewCell
            cell.searchWord.text = "  # \(rankList?.results?.search_list_arr[row].name ?? "")  "
            cell.searchWord.layer.cornerRadius = 15
            cell.searchWord.layer.masksToBounds = true
            cell.searchListBtn.tag = row
            return cell
        }else{
            let cell:FeedbackSearchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedbackSearch2", for: indexPath) as! FeedbackSearchCollectionViewCell
            cell.searchWord.text = "  # \(rankList?.results?.interest_list_arr[row].name ?? "")  "
            cell.searchWord.layer.cornerRadius = 15
            cell.searchWord.layer.masksToBounds = true
            cell.searchListBtn.tag = row
            return cell
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SearchKeyBoardHide"), object: nil)
    }
    
}

extension FeedbackSearchTableViewCell :UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let size = CGSize(width :self.collectionView.frame.width,height: self.collectionView.frame.height)
//        return size
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
