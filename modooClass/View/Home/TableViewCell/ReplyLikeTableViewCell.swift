//
//  ReplyLikeTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/27.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class ReplyLikeTableViewCell: UITableViewCell {

    @IBOutlet var user_photo: UIImageView!
    @IBOutlet var coachStar: UIImageView!
    @IBOutlet var friendImg: UIImageView!
    @IBOutlet var nickname: UIFixedLabel!
    @IBOutlet var stateComment: UIFixedLabel!
    @IBOutlet var moveBtn: UIButton!
    @IBOutlet var friendProfileBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
