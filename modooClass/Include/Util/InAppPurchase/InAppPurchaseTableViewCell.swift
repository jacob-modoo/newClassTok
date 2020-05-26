//
//  InAppPurchaseTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 31/10/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class InAppPurchaseTableViewCell: UITableViewCell {
//    InAppPurchaseTitleCell
    
    @IBOutlet var myPointLbl: UILabel!
    @IBOutlet var productionPriceLbl: UILabel!
    @IBOutlet var lackPointLbl: UILabel!
    
//    InAppPurchaseContentCell
    @IBOutlet var purchasePointLbl: UILabel!
    @IBOutlet var purchaseBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
