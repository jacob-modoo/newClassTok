//
//  ChildDetailClassTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 21/08/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class ChildDetailClassTableViewCell: UITableViewCell {

//    DetailClassMenuTableViewCell
    @IBOutlet weak var chapterSubjectLbl: UILabel!
    @IBOutlet weak var classContentBtn: UIButton!
    @IBOutlet weak var classSatisFiedBtn: UIButton!
    @IBOutlet weak var classSatisFiedLbl: UILabel!
    @IBOutlet weak var classCheerBtn: UIButton!
    @IBOutlet weak var classCurriculumBtn: UIButton!
    @IBOutlet weak var classGroupChatBtn: UIButton!
    @IBOutlet weak var classGroupChatLbl: UILabel!
    @IBOutlet weak var classLikeView: UIView!
    @IBOutlet weak var classLikeViewExitBtn: UIButton!
    @IBOutlet weak var classHashTagLbl: UILabel!
    @IBOutlet weak var classSatisFiedImg: UIImageView!
    @IBOutlet weak var classGroupChatNew: UIImageView!
    @IBOutlet weak var classCheerLbl: UIFixedLabel!
    @IBOutlet weak var classCheerImg: UIImageView!
    @IBOutlet weak var classGroupImg: UIImageView!
    @IBOutlet weak var nextClassBtn: UIButton!
    @IBOutlet weak var previousClassBtn: UIButton!
    @IBOutlet weak var classDescriptionImg: UIImageView!
    @IBOutlet weak var classDescriptionLbl: UIFixedLabel!
    @IBOutlet weak var classDescriptionBtn: UIButton!
    @IBOutlet weak var sharePointImg: UIImageView!
    
//    DetailClassContentTitleTableViewCell
    @IBOutlet weak var contentTitleLbl: UILabel!
    
//    DetailClassContentDetailTableViewCell
    @IBOutlet weak var addDetailView: UIView!
    
//    DetailClassNoticeTitleTableViewCell
    @IBOutlet weak var coachImg: UIImageView!
    @IBOutlet weak var coachRollGubunImg: UIImageView!
    @IBOutlet weak var coachProfileBtn: UIButton!
    
//    DetailClassNoticeContent1TableViewCell , DetailClassNoticeContent2TableViewCell
    @IBOutlet weak var noticeView: UIView!
    @IBOutlet weak var noticeTextView: UITextView!
    @IBOutlet weak var noticeDetailBtn: UIButton!
    
//    DetailClassTotalReplyTitleTableViewCell
    @IBOutlet var totalReplyCount: UILabel!
    
//  DetailClassReply1TableViewCell , DetailClassReply2TableViewCell , DetailClassReply3TableViewCell , DetailClassReply4TableViewCell
    @IBOutlet weak var reply_userPhoto: UIImageView!
    @IBOutlet weak var rollGubunImg: UIImageView!
    @IBOutlet weak var friendProfileBtn: UIButton!
    @IBOutlet weak var replyContentView: UIView!
    @IBOutlet weak var replyContentTextView: UITextView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var friendProfile2Btn: UIButton!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var readMoreBtn: UIButton!
    @IBOutlet weak var replyTime: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var replyReadBtn: UIButton!
    @IBOutlet weak var replyMoreBtn: UIButton! // 1 , 3 셀에서만 사용
    @IBOutlet weak var replyPhoto: UIImageView! // 3 , 4 셀에서만 사용
    @IBOutlet weak var replyPhotoHeightConst: NSLayoutConstraint!
    @IBOutlet weak var replyPhotoWidthConst: NSLayoutConstraint!
    @IBOutlet weak var coachStar: UIImageView!
    @IBOutlet weak var replyPhotoBtn: UIButton!
    @IBOutlet weak var youtubePlayImg: UIImageView!
    @IBOutlet weak var likeCountView: UIView!
    
//    DetailClassCurriculumCell
    @IBOutlet var curriculumClassTitleLbl: UILabel!
    @IBOutlet var curriculumTitleTime: UILabel!
    @IBOutlet var curriculumFirstClass: UILabel!
    @IBOutlet var curriculumFirstClassTime: UILabel!
    @IBOutlet var curriculumSecondClass: UILabel!
    @IBOutlet var curriculumSecondClassTime: UILabel!
    @IBOutlet var curriculumThirdClass: UILabel!
    @IBOutlet var curriculumThirdClassTime: UILabel!
    @IBOutlet weak var curriculumFirstClassImg: UIImageView!
    @IBOutlet weak var curriculumSecondClassImg: UIImageView!
    @IBOutlet weak var curriculumThirdClassImg: UIImageView!
    
//    DetailClassPriceCell
    @IBOutlet weak var classPriceImg: UIImageView!
    @IBOutlet weak var classPriceName: UIFixedLabel!
    @IBOutlet weak var classSalePrice: UIFixedLabel!
    @IBOutlet weak var classOriginalPrice: UIFixedLabel!
    
//    DetailClassCoachCell
    @IBOutlet weak var classCoachImg: UIImageView!
    @IBOutlet weak var classCoachName: UIFixedLabel!
    @IBOutlet weak var classCoachWithBtn: UIButton!
    @IBOutlet weak var classCoachProfileBtn: UIButton!
    @IBOutlet weak var coachGradientView: GradientView!
    
//    DetailClassReview1Cell
    @IBOutlet weak var reviewScore: UIFixedLabel!
    @IBOutlet weak var reviewCount: UIFixedLabel!
    @IBOutlet weak var reviewUserImg: UIImageView!
    @IBOutlet weak var reviewUserName: UIFixedLabel!
    @IBOutlet weak var reviewUserDate: UIFixedLabel!
    @IBOutlet weak var reviewUserStar1: UIImageView!
    @IBOutlet weak var reviewUserStar2: UIImageView!
    @IBOutlet weak var reviewUserStar3: UIImageView!
    @IBOutlet weak var reviewUserStar4: UIImageView!
    @IBOutlet weak var reviewUserStar5: UIImageView!
    @IBOutlet weak var reviewUserContent: UIFixedLabel!
    @IBOutlet weak var reviewMoveBtn: UIFixedButton!
    @IBOutlet weak var reviewUserProfileBtn: UIButton!
    @IBOutlet weak var reviewUserBackView: GradientView!
    
    @IBOutlet weak var review2UserImg: UIImageView!
    @IBOutlet weak var review2UserName: UIFixedLabel!
    @IBOutlet weak var review2UserDate: UIFixedLabel!
    @IBOutlet weak var review2UserStar1: UIImageView!
    @IBOutlet weak var review2UserStar2: UIImageView!
    @IBOutlet weak var review2UserStar3: UIImageView!
    @IBOutlet weak var review2UserStar4: UIImageView!
    @IBOutlet weak var review2UserStar5: UIImageView!
    @IBOutlet weak var review2UserContent: UIFixedLabel!
    @IBOutlet weak var review2UserProfileBtn: UIButton!
    @IBOutlet weak var review2UserBackView: UIView!
    
//    DetailClassChangeBodyCell
    @IBOutlet weak var classChangeBodyTitle: UIFixedLabel!
    @IBOutlet weak var changeBodyCollectionView: UICollectionView!
    var class_recommend_arr:Array = Array<Class_recommend>()
    
    var spectorCheck = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
/** the hitTest method is used to make likeCountBtn to be visible even out of bounds of its parent view***/
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)
        return overlapHitTest(point: point, withEvent: event)
    }

}

extension ChildDetailClassTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if class_recommend_arr.count > 0{
            return class_recommend_arr.count
        }else{
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let row = indexPath.row
        let cell:ChildDetailClassCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildDetailClassCollectionViewCell", for: indexPath) as! ChildDetailClassCollectionViewCell
        cell.classInfoImg.sd_setImage(with: URL(string: "\(class_recommend_arr[row].photo ?? "")"), placeholderImage: UIImage(named: "home_default"))
        cell.classInfoTitle.text = "\(class_recommend_arr[row].recommend ?? "")"
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}

extension ChildDetailClassTableViewCell :UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width :self.changeBodyCollectionView.frame.height,height: self.changeBodyCollectionView.frame.height)
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
