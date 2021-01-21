//
//  UserManager.swift
//  modooClass
//
//  Created by 조현민 on 20/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

class UserManager: NSObject {
    static let shared = UserManager()
    var userInfo = LoginModel()
    var chatList = ChatListModel()
}
