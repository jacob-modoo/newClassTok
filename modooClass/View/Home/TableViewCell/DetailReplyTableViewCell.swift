//
//  DetailReplyTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 10/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class DetailReplyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reply_userPhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var replyTime: UILabel!
    @IBOutlet weak var replyPhoto: UIImageView!
    @IBOutlet weak var replyPhotoHightConst: NSLayoutConstraint!
    @IBOutlet weak var replyPhotoWidthConst: NSLayoutConstraint!
    
    @IBOutlet weak var replyCount: UILabel!
    
    @IBOutlet weak var replyContentTextView: UITextView!
    @IBOutlet weak var replyContentLabel: UILabel!
    @IBOutlet weak var rollGubunImg: UIImageView!
    @IBOutlet weak var replyReadBtn: UIButton!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var noticeLbl: UILabel!
    
    @IBOutlet weak var coachStar: UIImageView!
    
    @IBOutlet weak var friendProfileBtn: UIButton!
    @IBOutlet weak var friendProfile2Btn: UIButton!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var replyContentView: UIView!
    
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
