//
//  ChildDetailReviewTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 2020/01/10.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit

class ChildDetailReviewTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var reviewBackgroundView: GradientView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNick: UIFixedLabel!
    @IBOutlet weak var userReviewDate: UIFixedLabel!
    @IBOutlet weak var userReviewStar1: UIImageView!
    @IBOutlet weak var userReviewStar2: UIImageView!
    @IBOutlet weak var userReviewStar3: UIImageView!
    @IBOutlet weak var userReviewStar4: UIImageView!
    @IBOutlet weak var userReviewStar5: UIImageView!
    @IBOutlet weak var userReviewContent: UIFixedTextView!
    @IBOutlet weak var userReviewImg: UIImageView!
    @IBOutlet weak var coachReviewContent: UIFixedTextView!
    @IBOutlet weak var coachNick: UIFixedLabel!
    @IBOutlet weak var coachImg: UIImageView!
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var coachProfileBtn: UIButton!
    
//    ChildDetailReviewDashboardCell
    @IBOutlet weak var reviewCount: UIFixedLabel!
    @IBOutlet weak var reviewAvg: UIFixedLabel!
    @IBOutlet weak var reviewStar1: UIImageView!
    @IBOutlet weak var reviewStar2: UIImageView!
    @IBOutlet weak var reviewStar3: UIImageView!
    @IBOutlet weak var reviewStar4: UIImageView!
    @IBOutlet weak var reviewStar5: UIImageView!
    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var progress2: UIProgressView!
    @IBOutlet weak var progress3: UIProgressView!
    @IBOutlet weak var progress4: UIProgressView!
    @IBOutlet weak var progress5: UIProgressView!
    @IBOutlet weak var reviewTotalCount: UIFixedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
