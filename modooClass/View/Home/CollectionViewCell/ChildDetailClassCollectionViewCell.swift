//
//  ChildDetailClassCollectionViewCell.swift
//  modooClass
//
//  Created by 조현민 on 21/08/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class ChildDetailClassCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var classInfoImg: UIImageView!
    @IBOutlet weak var classInfoTitle: UIFixedLabel!
    deinit {
        print("deinit : ChildDetailClassCollectionViewCell")
    }
}
