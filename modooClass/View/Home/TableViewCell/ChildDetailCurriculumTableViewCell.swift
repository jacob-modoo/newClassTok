//
//  ChildDetailCurriculumTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 22/08/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class ChildDetailCurriculumTableViewCell: UITableViewCell {

//    DetailCurriculumNavTableViewCell
    @IBOutlet weak var contNameLbl: UILabel!
    
//    CurriculumMainTitleTableViewCell
    @IBOutlet weak var classValidty: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classOutBtn: UIButton!
    
//    CurriculumContentTableViewCell
    @IBOutlet weak var curriculumChangeBtn: UIButton!
    @IBOutlet weak var curriculumTitle: UILabel!
    @IBOutlet weak var curriculumImg: UIImageView!
    @IBOutlet weak var curriculumPlayTimeLbl: UILabel!
    @IBOutlet weak var curriculumChapterLbl: UILabel!
    @IBOutlet weak var curriculumMissionCheckLbl: UILabel!
    @IBOutlet weak var curriculumMissionCheckImg: UIImageView!
    @IBOutlet weak var curriculumContentView: UIView!
    @IBOutlet weak var curriculumMissionCompletePlayLbl: UILabel!
    @IBOutlet weak var curriculumPlayLbl: UILabel!
    @IBOutlet weak var curriculumPlayImg: UIImageView!
    @IBOutlet weak var FreeBadge: UIImageView!
    
    @IBOutlet weak var backgroundColorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
