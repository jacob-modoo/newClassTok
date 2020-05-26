//
//  AddInfoAgreeTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/07.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class AddInfoAgreeTableViewCell: UITableViewCell {

    @IBOutlet var agreeView: UIView!
    
    @IBOutlet var agreeCheckBtn: UIButton!

    @IBOutlet var agreeTitle: UILabel!
    @IBOutlet var agreeContent: UILabel!
    @IBOutlet var agreeCheckImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
