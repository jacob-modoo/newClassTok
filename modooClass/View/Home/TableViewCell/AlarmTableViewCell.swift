//
//  AlarmTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 17/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var backdView: UIView!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var rollGubun: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var alarmBtn: UIButton!
    @IBOutlet weak var userBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
