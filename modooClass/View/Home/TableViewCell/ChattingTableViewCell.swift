//
//  ChattingTableViewCell.swift
//  modooClass
//
//  Created by iOS|Dev on 2021/01/20.
//  Copyright © 2021 신민수. All rights reserved.
//

import UIKit

class ChattingTableViewCell: UITableViewCell {

//    ChattingListAdminCell
    @IBOutlet weak var adminPhoto: UIImageView!
    @IBOutlet weak var adminName: UIFixedLabel!
    @IBOutlet weak var adminMessage: UIFixedLabel!
    
//    ChattingListMessageCell
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userName: UIFixedLabel!
    @IBOutlet weak var timeLbl: UIFixedLabel!
    @IBOutlet weak var messageLbl: UIFixedLabel!
    @IBOutlet weak var messagePhoto: UIImageView!
    @IBOutlet weak var messagePhotoWidth: NSLayoutConstraint!
    @IBOutlet weak var msgTrailingCons: NSLayoutConstraint!
    @IBOutlet weak var userOnlineBadge: UIButton!
    @IBOutlet weak var messageCount: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
