//
//  StoryWritingView.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/05/18.
//  Copyright © 2020 신민수. All rights reserved.
//
import Foundation
import UIKit

@IBDesignable class StoryWritingView: UIView {

    @IBOutlet var parentView: StoryWritingView!
    @IBOutlet weak var storyView: UIView!
    @IBOutlet weak var eventImg: UIImageView!
    @IBOutlet weak var eventText: UIFixedLabel!
    @IBOutlet weak var titleFirst: UILabel!
    @IBOutlet weak var titleSecond: UILabel!
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: "StoryWritingView", bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
//
//    func commonInit(){
//
//        let bundle = Bundle.init(for: StoryWritingView.self)
//        if let viewToAdd = bundle.loadNibNamed("StoryWritingView", owner: self, options: nil), let contentView = viewToAdd.first as? UIView {
//            addSubview(contentView)
//            contentView.frame = self.bounds
//            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        }
//        UIApplication.shared.keyWindow?.addSubview(parentView)
//    }
    class func getScreen() -> StoryWritingView {
//        let xib = Bundle.main.loadNibNamed(String(describing :self), owner: self, options: nil)
//        let me = xib![0] as! StoryWritingView
//        return me
        return UINib(nibName: "StoryWritingView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! StoryWritingView
    }
    
}
