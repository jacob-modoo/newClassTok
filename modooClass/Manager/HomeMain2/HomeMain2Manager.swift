//
//  HomeMain2Manager.swift
//  modooClass
//
//  Created by 조현민 on 2019/12/31.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class HomeMain2Manager: NSObject {
    static let shared = HomeMain2Manager()
    var pilotAppMain = PilotModel()
    var pilotRecommendMain = PilotRecommendModel()
    var profileModel = ProfileModel()
    var profileV2Model = ProfileV2Model()
    var profileNewModel = ProfileNewModel()
}
