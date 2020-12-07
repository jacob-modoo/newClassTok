//
//  ProfileV2NewTableViewCell.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/11/11.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

class ProfileV2NewTableViewCell: UITableViewCell {
    
//    ProfileV2UserIntroTableViewCell
    @IBOutlet weak var profileIconImg: UIImageView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var userBackgroundImg: UIImageView!
    @IBOutlet weak var profileBtn: UIButton!
    
    @IBOutlet weak var userNickname: UIFixedLabel!
    @IBOutlet weak var userLevelLbl: UIFixedLabel!
    @IBOutlet weak var helpfulCountLbl: UIFixedLabel!
    
//    ProfileV2IntroCell
    @IBOutlet weak var introTextLbl: UIFixedLabel!
    @IBOutlet weak var readMoreBtn: UIButton!
    @IBOutlet weak var readMoreBtnHeight: NSLayoutConstraint!
    
//    ProfileV2SocialNetworkCell
    @IBOutlet weak var instagramView: UIView!
    @IBOutlet weak var instagramViewWidth: NSLayoutConstraint!
    @IBOutlet weak var instaToFbConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var fbViewWidth: NSLayoutConstraint!
    @IBOutlet weak var fbToYtConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var youtubeView: UIView!
    @IBOutlet weak var ytViewWidth: NSLayoutConstraint!
    @IBOutlet weak var ytToHmConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var hmViewWidth: NSLayoutConstraint!
    
//    ProfileV2FriendOfferCell
    @IBOutlet weak var profileMainBtn: UIFixedButton!
    @IBOutlet weak var profileFollowingBtn: UIFixedButton!
    @IBOutlet weak var profileMsgBtnLeadConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileMsgBtnWidth: NSLayoutConstraint!
    
    
//    ProfileV2TableTitleCell
    @IBOutlet weak var profileTableViewTitleLbl: UIFixedLabel!
    @IBOutlet weak var coachStudioBtn: UIButton!
    @IBOutlet weak var commenCountLbl: UIFixedLabel!
    
//    ProfileV2ShareContentCell
    
//    ProfileV2ActiveTableViewCell
    @IBOutlet weak var noPhotoView1: GradientView!
    @IBOutlet weak var noPhotoView2: GradientView!
    @IBOutlet weak var noPhotoView3: GradientView!
    
    @IBOutlet weak var noPhotoUserImg1: UIImageView!
    @IBOutlet weak var noPhotoUserImg2: UIImageView!
    @IBOutlet weak var noPhotoUserImg3: UIImageView!
    
    @IBOutlet weak var noPhotoEmoticon1: UIImageView!
    @IBOutlet weak var noPhotoEmoticon2: UIImageView!
    @IBOutlet weak var noPhotoEmoticon3: UIImageView!
    
    @IBOutlet weak var noPhotoProfileText1: UIFixedLabel!
    @IBOutlet weak var noPhotoProfileText2: UIFixedLabel!
    @IBOutlet weak var noPhotoProfileText3: UIFixedLabel!
    
    @IBOutlet weak var noPhotoLikeCount1: UIFixedLabel!
    @IBOutlet weak var noPhotoLikeCount2: UIFixedLabel!
    @IBOutlet weak var noPhotoLikeCount3: UIFixedLabel!
    
    @IBOutlet weak var noPhotoBtn1: UIFixedButton!
    @IBOutlet weak var noPhotoBtn2: UIFixedButton!
    @IBOutlet weak var noPhotoBtn3: UIFixedButton!
    
    @IBOutlet weak var noPhotoLikeBtn1: UIButton!
    @IBOutlet weak var noPhotoLikeBtn2: UIButton!
    @IBOutlet weak var noPhotoLikeBtn3: UIButton!
    
    @IBOutlet weak var photoView1: UIView!
    @IBOutlet weak var photoView2: UIView!
    @IBOutlet weak var photoView3: UIView!
    
    @IBOutlet weak var photoBackImage1: UIImageView!
    @IBOutlet weak var photoBackImage2: UIImageView!
    @IBOutlet weak var photoBackImage3: UIImageView!
    
    @IBOutlet weak var photoLikeCount1: UIFixedLabel!
    @IBOutlet weak var photoLikeCount2: UIFixedLabel!
    @IBOutlet weak var photoLikeCount3: UIFixedLabel!
    
    @IBOutlet weak var photoPlayImg1: UIImageView!
    @IBOutlet weak var photoPlayImg2: UIImageView!
    @IBOutlet weak var photoPlayImg3: UIImageView!
    
    @IBOutlet weak var photoBtn1: UIFixedButton!
    @IBOutlet weak var photoBtn2: UIFixedButton!
    @IBOutlet weak var photoBtn3: UIFixedButton!
    
    @IBOutlet weak var photoLikeBtn1: UIButton!
    @IBOutlet weak var photoLikeBtn2: UIButton!
    @IBOutlet weak var photoLikeBtn3: UIButton!
    
//    ProfileV2EmptyActivityCell
    @IBOutlet weak var feedbackNoHaveLbl: UIFixedLabel!
    @IBOutlet weak var profileNoStoryBtn: UIFixedButton!
    @IBOutlet weak var profileNoStoryLblView: UIView!
    @IBOutlet weak var profileEmptyViewWidth: NSLayoutConstraint!
    
//    ProfileV2CollectionViewCell
    @IBOutlet private weak var classCollectionView: UICollectionView!
    
    var class_list_arr:Array = Array<Class_New_List>()
    var comment_list_arr:Array = Array<Comment_List>()
    var profileNewModel:ProfileNewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    /** the hitTest method is used to make likeCountBtn to be visible even out of bounds of its parent view***/
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)
        return overlapHitTest(point: point, withEvent: event)
    }
    
}

extension ProfileV2NewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if class_list_arr.count > 0 {
            return class_list_arr.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell:ProfileV2NewCollectionViewCell = classCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileV2NewCollectionViewCell", for: indexPath) as! ProfileV2NewCollectionViewCell
        cell.collectionViewImg.sd_setImage(with: URL(string: "\(class_list_arr[row].class_photo ?? "")"), placeholderImage: UIImage(named: "home_default_photo"))
        cell.collectionViewClassNameLbl.text = "\(class_list_arr[row].class_name ?? "NO TITLE")"
        cell.collectionViewHelpCountLbl.text  = "👍\(convertCurrency(money: NSNumber(value: class_list_arr[row].helpful_cnt ?? 0), style: .decimal))"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let class_id = class_list_arr[indexPath.row].class_id ?? 0
        NotificationCenter.default.post(name: NSNotification.Name("goToClassDetail"), object: class_id)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: 168, height: 112)
        return cellSize
    }
}
