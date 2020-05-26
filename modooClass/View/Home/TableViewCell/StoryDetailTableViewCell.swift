//
//  StoryDetailTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 2020/02/17.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit

class StoryDetailTableViewCell: UITableViewCell {
    
    //  StoryDetail1TableViewCell , StoryDetail2TableViewCell , StoryDetail3TableViewCell
    @IBOutlet weak var reply_userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var replyTime: UILabel!
    @IBOutlet weak var replyPhoto: UIImageView!
    @IBOutlet weak var replyPhotoHightConst: NSLayoutConstraint!
    @IBOutlet weak var replyPhotoWidthConst: NSLayoutConstraint!
    @IBOutlet weak var replyContentTextView: UITextView!
    @IBOutlet weak var rollGubunImg: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var coachStar: UIImageView!
    @IBOutlet weak var friendProfileBtn: UIButton!
    @IBOutlet weak var friendProfile2Btn: UIButton!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var replyContentView: UIView!
    
//    StoryDetailActiveTitleTableViewCell
    @IBOutlet weak var classCoachImg: UIImageView!
    @IBOutlet weak var classWithoutCnt: UIFixedLabel!
    @IBOutlet weak var classCoachName: UIFixedLabel!
    @IBOutlet weak var classCoachWithBtn: UIButton!
    @IBOutlet weak var classCoachProfileBtn: UIButton!
    @IBOutlet weak var coachGradientView: GradientView!
    @IBOutlet weak var genderBadge: UIImageView!
    
//    StoryDetailClassInfoTableViewCell
    @IBOutlet weak var classPriceImg: UIImageView!
    @IBOutlet weak var classPriceName: UIFixedLabel!
    @IBOutlet weak var classSalePrice: UIFixedLabel!
    
//    StoryDetailClassInfoTableViewCell
    @IBOutlet weak var replyUserPhoto: UIImageView!
    @IBOutlet weak var replyUserName: UIFixedLabel!
    
//    StoryDetailActiveTableViewCell
    @IBOutlet weak var photoView1: UIView!
    @IBOutlet weak var photoView2: UIView!
    @IBOutlet weak var photoView3: UIView!
    @IBOutlet weak var photoBackImage1: UIImageView!
    @IBOutlet weak var photoBackImage2: UIImageView!
    @IBOutlet weak var photoBackImage3: UIImageView!
    @IBOutlet weak var photoLikeCount1: UIFixedLabel!
    @IBOutlet weak var photoLikeCount2: UIFixedLabel!
    @IBOutlet weak var photoLikeCount3: UIFixedLabel!
    @IBOutlet weak var photoPlayImg1: UIImageView!
    @IBOutlet weak var photoPlayImg2: UIImageView!
    @IBOutlet weak var photoPlayImg3: UIImageView!
    @IBOutlet weak var photoBtn1: UIFixedButton!
    @IBOutlet weak var photoBtn2: UIFixedButton!
    @IBOutlet weak var photoBtn3: UIFixedButton!
    @IBOutlet weak var photoLikeBtn1: UIButton!
    @IBOutlet weak var photoLikeBtn2: UIButton!
    @IBOutlet weak var photoLikeBtn3: UIButton!
    @IBOutlet weak var noPhotoView1: GradientView!
    @IBOutlet weak var noPhotoView2: GradientView!
    @IBOutlet weak var noPhotoView3: GradientView!
    @IBOutlet weak var noPhotoUserImg1: UIImageView!
    @IBOutlet weak var noPhotoUserImg2: UIImageView!
    @IBOutlet weak var noPhotoUserImg3: UIImageView!
    @IBOutlet weak var noPhotoProfileText1: UIFixedLabel!
    @IBOutlet weak var noPhotoProfileText2: UIFixedLabel!
    @IBOutlet weak var noPhotoProfileText3: UIFixedLabel!
    @IBOutlet weak var noPhotoLikeCount1: UIFixedLabel!
    @IBOutlet weak var noPhotoLikeCount2: UIFixedLabel!
    @IBOutlet weak var noPhotoLikeCount3: UIFixedLabel!
    @IBOutlet weak var noPhotoBtn1: UIFixedButton!
    @IBOutlet weak var noPhotoBtn2: UIFixedButton!
    @IBOutlet weak var noPhotoBtn3: UIFixedButton!
    @IBOutlet weak var noPhotoLikeBtn1: UIButton!
    @IBOutlet weak var noPhotoLikeBtn2: UIButton!
    @IBOutlet weak var noPhotoLikeBtn3: UIButton!
    
//    StoryDetailReview1TableViewCell,StoryDetailReview2TableViewCell
    @IBOutlet weak var reviewClassName: UIFixedLabel!
    @IBOutlet weak var reviewBackgroundView: GradientView!
    @IBOutlet weak var userReviewStar1: UIImageView!
    @IBOutlet weak var userReviewStar2: UIImageView!
    @IBOutlet weak var userReviewStar3: UIImageView!
    @IBOutlet weak var userReviewStar4: UIImageView!
    @IBOutlet weak var userReviewStar5: UIImageView!
    @IBOutlet weak var userReviewContent: UIFixedTextView!
    @IBOutlet weak var coachReviewContent: UIFixedTextView!
    @IBOutlet weak var coachNick: UIFixedLabel!
    @IBOutlet weak var coachImg: UIImageView!
    @IBOutlet weak var coachProfileBtn: UIButton!
    
//    StoryDetailInterestTableViewCell
    @IBOutlet var interestCollectionView: UICollectionView!
    @IBOutlet var interestCollectionViewHeightConst: NSLayoutConstraint!
    var interest_arr:Array = Array<SquareInterest>()
    
//    StoryDetailLikeInfoTableViewCell
    @IBOutlet weak var replyLikeCountBtn: UIFixedButton!
    @IBOutlet weak var replyCountBtn: UIFixedButton!
    
//    StoryDetailClassInfoITableViewCell
    @IBOutlet weak var replyPhotoImg: UIImageView!
    @IBOutlet weak var replyPhotoImgHeightConst: NSLayoutConstraint!
    @IBOutlet weak var missionCompleteImg: UIImageView!
    
//    StoryDetailLikeInfo2TableViewCell
    @IBOutlet weak var infoLikeCnt: UIFixedLabel!
    @IBOutlet weak var infoReplyCnt: UIFixedLabel!
    @IBOutlet weak var infoWriteDate: UIFixedLabel!
    
//    StoryDetailOverTableViewCell
    @IBOutlet weak var replyDetailMoveBtn: UIFixedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
        // Configure the view for the selected state
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)
        return overlapHitTest(point: point, withEvent: event)
    }
    
    func callColection(){
        let layout = LeftAlignedFlowLayout()
        layout.estimatedItemSize = CGSize(width: 50, height: 24)
//        interestCollectionView.collectionViewLayout = layout
        interestCollectionView.reloadData()
    }

}

extension StoryDetailTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interest_arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let cell:StoryDetailCollectionViewCell = interestCollectionView.dequeueReusableCell(withReuseIdentifier: "StoryDetailCollectionViewCell", for: indexPath) as! StoryDetailCollectionViewCell
        cell.interestText.text = "  # \(interest_arr[item].name ?? "")  "
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
}

extension StoryDetailTableViewCell : UICollectionViewDelegateFlowLayout{
    
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
        return CGSize(width: interestCollectionView.frame.width/4, height: 24)
    }

}
