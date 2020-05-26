//
//  FeedDetailManager.swift
//  modooClass
//
//  Created by 조현민 on 11/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class FeedDetailManager: NSObject {
    static let shared = FeedDetailManager()
    var feedDetailList = FeedAppClassModel()
    var feedAppCurriculumModel = FeedAppCurriculumModel()
    var feedAppCheerModel = FeedAppCheerModel()
    var reviewDashboardModel = ReviewDashboardModel()
    var eventModel = EventModel()
}
