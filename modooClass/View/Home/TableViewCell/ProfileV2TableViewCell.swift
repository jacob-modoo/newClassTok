//
//  ProfileV2TableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 2020/01/06.
//  Copyright © 2020 조현민. All rights reserved.
//

import UIKit

class ProfileV2TableViewCell: UITableViewCell {

//    ProfileTitleTableViewCell
    @IBOutlet var user_photo_btn: UIButton!
    @IBOutlet var nickName: UIFixedLabel!
    @IBOutlet var withoutText: UIFixedLabel!
    @IBOutlet var age: UIFixedLabel!
    @IBOutlet var job: UIFixedLabel!
    @IBOutlet var age_job_view: UIView!
    @IBOutlet var job_gender_view: UIView!
    @IBOutlet var genderText: UIFixedLabel!
    @IBOutlet var genderImg: UIImageView!
    @IBOutlet var infoViewSort: UIView!
    @IBOutlet var profile_emptyBtn: UIButton!
    @IBOutlet weak var levelLbl: UIFixedLabel!
    @IBOutlet weak var levelBtwView: UIView!
    
    @IBOutlet weak var userBackgroundImg: UIImageView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var iconImg: UIImageView!
    
//    ProfileInterestTableViewCell
    @IBOutlet var interestCollectionView: UICollectionView!
    @IBOutlet var interestCollectionViewHeightConst: NSLayoutConstraint!
    
//    ProfileFriendViewCell
    @IBOutlet var friendAddBtn: UIFixedButton!
    @IBOutlet var messageBtn: UIFixedButton!
    @IBOutlet var messageBtnWidthConst: NSLayoutConstraint!
    @IBOutlet var messageBtnLeadingConst: NSLayoutConstraint!
    
//    ProfileV2IntroCell
    @IBOutlet var myIntroTextView: UIFixedTextView!
    
//    ProfileV2CoachIntroCell
    @IBOutlet var addTextView: UIView!
    
//    ProfileV2CoachMoreCell
    @IBOutlet var introBtn: UIFixedButton!
    
//    ProfileActiveMenuTableViewCell
    @IBOutlet var activeTitle: UIFixedLabel!
    @IBOutlet var reviewTitle: UIFixedLabel!
    @IBOutlet var scrapTitle: UIFixedLabel!
    
    
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
    
    @IBOutlet weak var noPhotoView1: GradientView!
    @IBOutlet weak var noPhotoView2: GradientView!
    @IBOutlet weak var noPhotoView3: GradientView!
    
    @IBOutlet weak var noPhotoUserImg1: UIImageView!
    @IBOutlet weak var noPhotoUserImg2: UIImageView!
    @IBOutlet weak var noPhotoUserImg3: UIImageView!
    
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
    
    
    //    ProfilePhotoTableViewCell
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pagecontroller: UIPageControl!
    @IBOutlet weak var userPhotoImg: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    
//    ProfileV2ManagerTitleCell
    @IBOutlet weak var managerTitle: UIFixedLabel!
    
    //    ProfileV2ManagerContentCell
    @IBOutlet weak var managerImg1: UIImageView!
    @IBOutlet weak var managerTitle1: UIFixedLabel!
    @IBOutlet weak var managerBtn1: UIButton!
    @IBOutlet weak var managerImg2: UIImageView!
    @IBOutlet weak var managerTitle2: UIFixedLabel!
    @IBOutlet weak var managerBtn2: UIButton!
    @IBOutlet weak var managerViewTopConst: NSLayoutConstraint!
    @IBOutlet weak var managerViewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var managerView2: GradientView!
    @IBOutlet weak var managerView1: GradientView!
    
    
    
    var interest_list_list:Array = Array<Interest_list>()
    var profileModel:ProfileV2Model?
    var active_comment_list:Array = Array<Active_comment>()
    
    var user_info:User_info?
    
    var collectionTag = 99999
    var user_id = 0
    var page = 1
    let storyColor = ["#CDDEF2", "#B2C1D2", "#D9DFEE", "#DFDFDF"]
    let missionColor = ["#E6D8DB", "#D4DCD9"]
    let questionColor = ["#DED8D2", "#E6E4D7", "#E2E8D7"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func callColection(){
        let layout = LeftAlignedFlowLayout()
        if collectionTag == 0{
            imageCollectionView.reloadData()
        }else if collectionTag == 1{
            layout.estimatedItemSize = CGSize(width: 50, height: 20)
            interestCollectionView.collectionViewLayout = layout
            interestCollectionView.reloadData()
        }
    }
    
    
    
}

extension ProfileV2TableViewCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionTag == 0{
            return 1
        }else if collectionTag == 1{
//            let user_idCheck = UserManager.shared.userInfo.results?.user?.id
//            if user_id == user_idCheck{
//                return (interest_list_list.count + 1)
//            }else{
//                return interest_list_list.count
//            }
            return interest_list_list.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        if collectionTag == 0{
            let cell:ProfileV2CollectionViewCell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileIImageCollectionViewCell", for: indexPath) as! ProfileV2CollectionViewCell
//            cell.profilePageImg.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "home_default_photo"))
            if user_info != nil{
                if (user_info?.photo_list.count)! > 0{
                    cell.profilePageImg.sd_setImage(with: URL(string: "\(user_info?.photo_list[indexPath.section].photo_url ?? "")"), placeholderImage: UIImage(named: "cover_defaultV2"))
                }else{
                    cell.profilePageImg.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "cover_defaultV2"))
                }
            }
            return cell
        }else{
            let cell:ProfileV2CollectionViewCell = interestCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfileInterestCollectionViewCell", for: indexPath) as! ProfileV2CollectionViewCell
           cell.interestText.text = "#\(interest_list_list[item].name ?? "") "
//            if interest_list_list.count == item{
//                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileInterestAddCollectionViewCell", for: indexPath) as! ProfileV2CollectionViewCell
//            }else{
//                cell.interestText.text = " #\(interest_list_list[item].name ?? "") "
//                cell.interestText.layer.cornerRadius = 15
//                cell.interestText.layer.masksToBounds = true
//            }
            return cell
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionTag == 0{
            if (user_info?.photo_list.count ?? 0) > 0{
                pagecontroller.numberOfPages = user_info?.photo_list.count ?? 0
                return user_info?.photo_list.count ?? 0
            }else{
                pagecontroller.numberOfPages = 1
                return 1
            }
        }else{
            return 1
        }
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
        print(collectionView.cellForItem(at: indexPath)?.frame)
    }
    */
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let item = indexPath.item
//        print("self.page : ",self.page)
//        if collectionTag == 2{
//           if self.active_comment_list.count-3 == item{
//               if self.profileModel?.results?.active_comment_total_page ?? 0 > page{
//                   self.page = page + 1
//                   activeList()
//               }
//           }
//        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      let page = Int(targetContentOffset.pointee.x / self.frame.width)
      self.pagecontroller.currentPage = page
    }
    
}

extension ProfileV2TableViewCell : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0 , bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionTag == 0{
            return CGSize(width: imageCollectionView.frame.width, height: imageCollectionView.frame.height)
        }else if collectionTag == 1{
            return CGSize(width: interestCollectionView.frame.width/4, height: 24)
        }else{
            return CGSize(width: 0, height: 0)
        }
        
    }
    
    /** the hitTest method is used to make likeCountBtn to be visible even out of bounds of its parent view***/
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)
        return overlapHitTest(point: point, withEvent: event)
    }
}
