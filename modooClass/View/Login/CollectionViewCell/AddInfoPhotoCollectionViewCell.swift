//
//  AddInfoPhotoCollectionViewCell.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/04.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class AddInfoPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var defaultImg1: UIImageView!
    @IBOutlet var defaultImg2: UIImageView!
    @IBOutlet var sampleImgBtn1: UIButton!
    @IBOutlet var sampleImgBtn2: UIButton!
    
    override func awakeFromNib() {
        defaultImg1.layer.cornerRadius = defaultImg1.frame.height/2
        sampleImgBtn1.layer.cornerRadius = sampleImgBtn1.frame.height/2
        defaultImg1.clipsToBounds = true
        defaultImg2.layer.cornerRadius = defaultImg2.frame.height/2
        sampleImgBtn2.layer.cornerRadius = sampleImgBtn2.frame.height/2
        defaultImg2.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        defaultImg1.layer.cornerRadius = defaultImg1.frame.height/2
        defaultImg2.layer.cornerRadius = defaultImg2.frame.height/2
        sampleImgBtn1.layer.cornerRadius = sampleImgBtn1.frame.height/2
        sampleImgBtn2.layer.cornerRadius = sampleImgBtn2.frame.height/2
    }
}
