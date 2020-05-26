//
//  DetailMissionCompleteTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 13/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class DetailMissionCompleteTableViewCell: UITableViewCell {

    @IBOutlet var addTextView: UIView!
    @IBOutlet var missionImg: UIImageView!
    @IBOutlet var missionImgPickerBtn: UIButton!
    @IBOutlet var missionCompleteTextView: UITextView!
    @IBOutlet var missionView: UIView!
    @IBOutlet var labelView: UIView!
    @IBOutlet var missionCompleteTextViewPlaceHolder: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
