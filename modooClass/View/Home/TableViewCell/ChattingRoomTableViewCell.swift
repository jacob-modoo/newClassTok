//
//  ChattingFriendViewControllerCell.swift
//  modooClass
//
//  Created by iOS|Dev on 2021/01/06.
//  Copyright © 2021 신민수. All rights reserved.
//

import Foundation

class ChattingRoomTableViewCell: UITableViewCell {
    
//    ChatRoomSentMsgCell
    @IBOutlet weak var msgSentImgView: UIImageView!
    @IBOutlet weak var msgSentImgHeight: NSLayoutConstraint!
    @IBOutlet weak var msgSentImgWidth: NSLayoutConstraint!
    @IBOutlet weak var msgSentReadLbl: UIFixedLabel!
    @IBOutlet weak var msgSentTimeLbl: UIFixedLabel!
    @IBOutlet weak var msgSentTxtLbl: UIFixedTextView!
    
    
//    ChatRoomReceivedMsgCell
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UIFixedLabel!
    @IBOutlet weak var msgReceivedTimeLbl: UIFixedLabel!
    @IBOutlet weak var msgReceivedImg: UIImageView!
    @IBOutlet weak var msgReceivedTextView: UIFixedTextView!
    @IBOutlet weak var msgReceivedImgHeight: NSLayoutConstraint!
    @IBOutlet weak var msgReceivedImgWidth: NSLayoutConstraint!
    @IBOutlet weak var profileBtn: UIButton!
    
//    ChatRoomEmptyCell
    @IBOutlet weak var emptyChatLbl: UIFixedLabel!
    
//    ChatRoomDateCell
    @IBOutlet weak var msgDateLbl: UIFixedLabel!
    
    
}
