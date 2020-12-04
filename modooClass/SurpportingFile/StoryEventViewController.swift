//
//  StoryEventViewController.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/05/19.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

@IBDesignable class StoryEventViewController: UIView{
    
    @IBOutlet weak var classKesolLbl: UILabel!
    @IBOutlet weak var pointLbl: UIFixedLabel!
    @IBOutlet weak var storyWriteLbl: UILabel!
    

    @IBAction func icon1BtnClicked(_ sender: UIButton) {
        print("btn 1 is clicked")
    }
    
    @IBAction func icon2BtnCLicked(_ sender: UIButton) {
    }

}
