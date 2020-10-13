//
//  HomeProfileTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 2019/12/26.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class HomeProfileTableViewCell: UITableViewCell {
    
//    HomeProfileInfoCell
    
    @IBOutlet weak var levelCheckBtn: UIButton!
    @IBOutlet weak var levelProgressInfoRightLbl: UILabel!
    @IBOutlet weak var levelProgressInfoLeftLbl: UILabel!
    @IBOutlet weak var levelProgressView: UIProgressView!
    @IBOutlet weak var levelProgressRightView: GradientView!
    @IBOutlet weak var levelProgressLeftView: GradientView!
    @IBOutlet weak var levelPointInfoLbl: UILabel!
    @IBOutlet weak var levelPointLbl: UILabel!
    @IBOutlet weak var levelImg: UIImageView!
    @IBOutlet weak var levelMainLbl: UILabel!
    @IBOutlet weak var levelBodyView: GradientView!
    @IBOutlet weak var levelBackground: GradientView!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var profileTitle: UIFixedLabel!
    
//    HomeProfileTabCell
    @IBOutlet weak var pointText: UIFixedLabel!
    @IBOutlet weak var withmeCnt: UIFixedLabel!
    @IBOutlet weak var favoriteCnt: UIFixedLabel!

//    HomeProfileTitleCell
    @IBOutlet weak var titleSubject: UIFixedLabel!
    
//    HomeProfileContentCell
    @IBOutlet weak var contentSubTitle: UIFixedLabel!
    @IBOutlet weak var contentTitle: UIFixedLabel!
    @IBOutlet weak var contentBtn: UIButton!
    @IBOutlet weak var arrowImgWidthConst: NSLayoutConstraint!
    
//    HomeProfileSwitchCell
    @IBOutlet weak var switchTitle: UIFixedLabel!
    @IBOutlet weak var switchBtn: UIButton!
    
//    HomeProfilePrivacyCell
    @IBOutlet weak var serviceBtn: UIFixedButton!
    @IBOutlet weak var policyBtn: UIFixedButton!
    
//    HomeProfileLogoutCell
    @IBOutlet weak var logoutBtn: UIFixedButton!
    
//    HomeProfileMemberListCell
    @IBOutlet weak var memberListTitle: UIFixedLabel!
    @IBOutlet weak var memberListChapter: UIFixedLabel!
    @IBOutlet weak var memberListCollectionView: UICollectionView!
    @IBOutlet weak var memberListPageTitle: UIFixedLabel!
    @IBOutlet weak var memberPageLeftBtn: UIButton!
    @IBOutlet weak var memberPageRightBtn: UIButton!
    @IBOutlet weak var pagecontroller: UIPageControl!
    var memberList_arr:Array = Array<ProfileMemberList>()
    var page = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func callColection(){
        memberListCollectionView.reloadData()
    }
    
    
}

extension HomeProfileTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let cell:HomeProfileCollectionViewCell = memberListCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeProfileCollectionViewCell", for: indexPath) as! HomeProfileCollectionViewCell
        cell.memberListPhoto.sd_setImage(with: URL(string: "\(memberList_arr[section].user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
        cell.memberListName.text = "\(memberList_arr[section].user_name ?? "")"
        cell.memberListBackgroundView.layer.borderColor = UIColor(hexString: "#efefef").cgColor
        cell.memberListBackgroundView.layer.borderWidth = 1
        cell.memberListBackgroundView.layer.cornerRadius = 10
        cell.memberListBackgroundView.layer.masksToBounds = true
        cell.profileBtn.tag = memberList_arr[section].user_id ?? 0
        if memberList_arr[section].friend_status ?? "N" == "N"{
            cell.memberListBtn.setImage(UIImage(named: "follow_profile"), for: .normal)
        }else{
            cell.memberListBtn.setImage(UIImage(named: "profile_chat_iconV2"), for: .normal)
        }
        
        cell.memberListBtn.tag = section
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        if memberList_arr.count%3 > 0{
//            pagecontroller.numberOfPages = (memberList_arr.count/3)+1
//        }else{
//            pagecontroller.numberOfPages = memberList_arr.count/3
//        }
        return memberList_arr.count
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let page = Int(targetContentOffset.pointee.x / self.memberListCollectionView.frame.width)
//        self.pagecontroller.currentPage = page
    }

}

extension HomeProfileTableViewCell : UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0 , bottom: 0.0, right: 0.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: memberListCollectionView.frame.width/3.5, height: 128)

    }
}
