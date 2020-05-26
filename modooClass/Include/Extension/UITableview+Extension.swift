//
//  UITableview+Extension.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/11.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

extension UITableView {
    var dataHasChanged: Bool {
        guard let dataSource = dataSource else { return false }
        let sections = dataSource.numberOfSections?(in: self) ?? 0
        if numberOfSections != sections {
            return true
        }
        for section in 0..<sections {
            if numberOfRows(inSection: section) != dataSource.tableView(self, numberOfRowsInSection: section) {
                return true
            }
        }
        return false
    }
}
