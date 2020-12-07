//
//  AlamofireNetworkCancel.swift
//  modooClass
//
//  Created by 조현민 on 20/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
import Alamofire

func alamofireNetCheck(){
    let sessionManager = AF.session
    sessionManager.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
        dataTasks.forEach { $0.cancel() }
        uploadTasks.forEach { $0.cancel() }
        downloadTasks.forEach { $0.cancel() }
    }
}
