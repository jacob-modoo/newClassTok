//
//  ChildDetailDescriptionTableViewCell.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/12/09.
//  Copyright © 2020 신민수. All rights reserved.
//

import Foundation

class ChildDetailDescriptionTableViewCell: UITableViewCell {
    
//    ChildDetailDescriptionTitleCell
    @IBOutlet weak var descriptionTitleLbl: UIFixedLabel!
    
//    ChildDetailDescriptionDownloadCell
    @IBOutlet weak var fileTitleLbl: UIFixedLabel!
    @IBOutlet weak var downloadBtn: UIButton!
    
    
//    ChildDetailDescriptionContentCell
    @IBOutlet weak var descriptionSubtitle: UIFixedLabel!
    @IBOutlet weak var descriptionContent: UITextView!
    
}
