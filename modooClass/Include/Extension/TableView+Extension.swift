//
//  TableView+Extension.swift
//  modooClass
//
//  Created by 조현민 on 02/09/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

extension UITableView {
    
    func reloadDataWithoutScroll() {
        let offset = contentOffset
        beginUpdates()
        reloadData()
        endUpdates()
        layoutIfNeeded()
        layer.removeAllAnimations()
        setContentOffset(offset, animated: false)
        
    }
    
}
