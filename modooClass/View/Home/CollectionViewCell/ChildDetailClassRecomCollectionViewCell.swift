//
//  ChildDetailClassRecomCollectionViewCell.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/11/24.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

class ChildDetailClassRecomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionViewImg: UIImageView!
    @IBOutlet weak var collectionViewClassName: UIFixedLabel!
    @IBOutlet weak var collectionViewHelpCnt: UIFixedLabel!
    @IBOutlet weak var collectionViewPriceLbl: UIFixedLabel!
    @IBOutlet weak var price_per_lbl: UIFixedLabel!
    
/** the hitTest method is used to make likeCountBtn to be visible even out of bounds of its parent view***/
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let hitView = super.hitTest(point, with: event)
//        print(String(describing: hitView))
//        if hitView == self {
//            print("collection cell is clicked")
//        } else {
//            print("collection cell is not recognized")
//        }
//        return self
//    }
}
