//
//  HomeClassTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 2019/12/26.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class HomeClassTableViewCell: UITableViewCell {
    
//    HomeClassNoticeCell
    @IBOutlet weak var noticeTitle: UILabel!
    @IBOutlet weak var noticeOpenImg: UIImageView!
    @IBOutlet weak var noticeOpenBtn: UIButton!
    
//    HomeClassTitleCell
    @IBOutlet weak var classTitle: UIFixedLabel!
    @IBOutlet weak var classTitleBtn: UIFixedButton!
    @IBOutlet weak var notificationBtn: UIFixedButton!
    
    @IBOutlet weak var iconLevelImg: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userBackgroundImg: UIImageView!
    
//    HomeClassTimerCell
    @IBOutlet weak var timerText: UILabel!
    
//    HomeClassManagerCell
    @IBOutlet weak var classImg: UIImageView!
    @IBOutlet weak var className: UIFixedLabel!
    @IBOutlet weak var classMember: UIFixedLabel!
    @IBOutlet weak var replyCount: UIFixedLabel!
    @IBOutlet weak var classManagerQuestionBtn: UIFixedButton!
    @IBOutlet weak var classManagerBtn: UIFixedButton!
    @IBOutlet weak var classInBtn: UIButton!
    @IBOutlet weak var managerReplyView: UIView!
    
//    HomeFeedMyClassCell
    @IBOutlet var class_open_view: UIView!
           
    @IBOutlet var class_open_dDay: UILabel!
    @IBOutlet var class_my_shadow_view: UIView!
    @IBOutlet var class_my_view: UIView!
    @IBOutlet var coachView: UIView!
    @IBOutlet var coachImg: UIImageView!
    @IBOutlet var class_name: UILabel!
    @IBOutlet var class_desc: UILabel!
    @IBOutlet var class_desc_progress: UILabel!
    @IBOutlet var class_week: UILabel!
    @IBOutlet var class_progress_view: UIView!
    @IBOutlet var class_group_img: UIImageView!
    @IBOutlet var class_group_mamber_count: UILabel!
    @IBOutlet var class_group_btn: UIButton!
    @IBOutlet var class_group_emoji: UIImageView!
    @IBOutlet var class_group_percentBtn: UIButton!
    @IBOutlet var class_progress_value: UILabel!
    @IBOutlet var class_progress_inView: UIView!
    @IBOutlet var class_new_count: UILabel!
    @IBOutlet var class_new_count_badge: UIImageView!
    @IBOutlet weak var class_my_progress: UIProgressView!
    
    @IBOutlet var class_participation_btn1: UIButton!
    @IBOutlet var class_participation_btn: UIButton!
    @IBOutlet var class_member_view: UIView!
    @IBOutlet var class_best_scrollview: UIScrollView!
    @IBOutlet var class_week_best_view: UIView!
    var week_best_list:Array = Array<Week_best>()
    
//    HomeClassAttendCell
    @IBOutlet weak var classDday: UIFixedLabel!
    @IBOutlet weak var myPercent: UIFixedLabel!
    @IBOutlet weak var groupPercent: UIFixedLabel!
    @IBOutlet weak var classMemberListBtn: UIFixedButton!
    @IBOutlet weak var classAttendBtn: UIFixedButton!
    @IBOutlet weak var lineProgressView: UIView!
    
//    HomeClassReviewCell
    @IBOutlet weak var classReviewStar1: UIImageView!
    @IBOutlet weak var reviewWriteCompleteBtn: UIFixedButton!
    @IBOutlet weak var classRePurchaseBtn: UIFixedButton!
    @IBOutlet weak var classRecommendBtn: UIFixedButton!
    @IBOutlet weak var reviewWriteBtn: UIButton!
    
//    HomeClassCategoryTitleCell
    @IBOutlet weak var categoryTitle: UIFixedLabel!
    
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
    
//    HomeClassRecommendTitleCell
    @IBOutlet weak var recommendTitle: UIFixedLabel!
    @IBOutlet weak var recommendSubTitle: UIFixedLabel!
    
//    HomeClassRecommendCell
    @IBOutlet weak var recommendClassImg: UIImageView!
    @IBOutlet weak var recommendClassName: UIFixedLabel!
    @IBOutlet weak var recommendCoachName: UIFixedLabel!
    @IBOutlet weak var recommendCategory1: UIFixedLabel!
    @IBOutlet weak var recommendCategory2: UIFixedLabel!
    
//    HomeClassRecommendAllCell
    @IBOutlet weak var recommendAllBtn: UIFixedButton!
    
//    HomeClassInterestCell
    @IBOutlet weak var classScrapBtn: UIButton!
    @IBOutlet weak var classFavoriteRecommendBtn: UIFixedButton!
    @IBOutlet weak var classParticipateBtn: UIFixedButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /** the hitTest method is used to make likeCountBtn to be visible even out of bounds of its parent view***/
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)
        return overlapHitTest(point: point, withEvent: event)
    }

}
