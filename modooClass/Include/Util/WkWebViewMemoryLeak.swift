//
//  WkWebViewMemoryLeak.swift
//  modooClass
//
//  Created by 조현민 on 2019/12/17.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
import WebKit

class LeakAvoider: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?
    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
    
    deinit {
        print("LeakAvoider - dealloc")
    }
}
