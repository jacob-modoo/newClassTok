//
//  ProfileV2CollectionViewCell.swift
//  modooClass
//
//  Created by 조현민 on 2020/01/06.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit

class ProfileV2CollectionViewCell: UICollectionViewCell {
    
//    ProfileInterestCollectionViewCell
    @IBOutlet var interestText: UIFixedLabel!
    @IBOutlet var interestAddBtn: UIButton!
    
//  Common :  ProfileManage1CollectionViewCell,ProfileManage2CollectionViewCell , ProfileActive1CollectionViewCell ,ProfileActive2CollectionViewCell
    @IBOutlet var backImage: UIImageView!
    
//    ProfileManage2CollectionViewCell , ProfileActive2CollectionViewCell
    @IBOutlet var likeCount: UIFixedLabel!
    
//    ProfileManage3CollectionViewCell , ProfileActive3CollectionViewCell
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var profileText: UIFixedLabel!
    
    @IBOutlet var activeMoveBtn: UIFixedButton!
    
    @IBOutlet weak var playImg: UIImageView!
    @IBOutlet weak var profile_likeBtn: UIButton!
    //    ProfileIImageCollectionViewCell
    
    @IBOutlet weak var profilePageImg: UIImageView!
    
    @IBOutlet weak var backgroundColorView: GradientView!
}
