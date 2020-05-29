//
//  ReplyLikeViewController.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/27.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class ReplyLikeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var likeTitle: UIFixedLabel!
    @IBOutlet var topRadiusView: UIView!
    @IBOutlet var titleView: GradientView!
    @IBOutlet var backView: UIView!
    
    /** **뷰의 y값 */
    var contentY:CGFloat = 0
    /** **뷰의 숨기는 속도 */
    var minimumVelocityToHide = 1500 as CGFloat
    /** **뷰의 숨기는 화면 비율 */
    var minimumScreenRatioToHide = 0.5 as CGFloat
    /** **애니메이션 시간 */
    var animationDuration = 0.2 as TimeInterval
    
    var friendList:FeedReplyLikeModel?
    
    var friendArr:Array = Array<LikeFriendList>()
    /** **댓글 리스트 */
    var appClass: FeedAppClassDetailReplyModel?
    var replyArray:Array? = Array<AppClassCommentList>()
    var viewCheck = ""
    var comment_id = 0
    var comment_str_id = ""
    var page = 1
    var friend_id_row = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGesture.delegate = self
        self.titleView.addGestureRecognizer(panGesture)
//        self.backView.addGestureRecognizer(panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if comment_id != 0 || comment_str_id != ""{
            friend_List()
        }else{
            self.dismiss(animated: true, completion: {})
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //let userInfo = [ "comment_id" : self.comment_id ,"replyCount": replyArray?.count ?? 0 , "commentLikeCount":appClass?.results?.list?.like ?? 0,"preHave":appClass?.results?.list?.like_me ?? "N"] as [String : Any]
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "curriculumParamChange"), object: nil,userInfo: userInfo)
        
    }

    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    @IBAction func moveBtnClicked(_ sender: UIButton) {
        let row = sender.tag/10000
        let tag = sender.tag%10000
        
        var type = ""
        if tag == 1 {
            type = "delete"
        }else{
            type = "post"
        }
          
           if UserManager.shared.userInfo.results?.user?.id == self.friendArr[row].user_id ?? 0 {
            let selectedIndexPath = IndexPath(item:row , section: 0)
            let cell = self.tableView.cellForRow(at: selectedIndexPath) as! ReplyLikeTableViewCell
            
            if self.viewCheck == "childDetail" || self.viewCheck == "replyDetail" {
                FeedApi.shared.replyCommentLike(comment_id: self.replyArray?[row].id ?? 0, method_type: type,success: { [unowned self] result in
                      
                if tag == 1{
                    cell.moveBtn.layer.borderWidth = 1
                    cell.moveBtn.layer.borderColor = UIColor(hexString: "#EFEFEF").cgColor
                    cell.moveBtn.setImage(UIImage(named: "likeComment"), for: .normal)
                    cell.moveBtn.backgroundColor = .white
                    //cell.moveBtn.tag = row*10000 + 2
                    self.replyArray?[row].like_me = "N"
                    self.replyArray?[row].like = self.replyArray?[row].like ?? 0 - 1
                }else{
                    //cell.moveBtn.tag = row*10000 + 1
                    self.replyArray?[row].like_me = "Y"
                    cell.moveBtn.backgroundColor = UIColor(hexString: "#EFEFEF")
                    cell.moveBtn.setImage(UIImage(named: "likeCancelText"), for: .normal)
                    self.replyArray?[row].like = self.replyArray?[row].like ?? 0 + 1
                }
//                    let userInfo = ["preHave":self.replyArray?[sender.tag].like_me ?? ""] as [String : Any]
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateLikeCount"), object: nil, userInfo: userInfo)
                }) { error in
                }
                
            } else {
                ProfileApi.shared.profileV2CommentLike(comment_id: comment_str_id, type: type, success: { [unowned self] result in
                      
                   if tag == 1{
                        cell.moveBtn.layer.borderWidth = 1
                        cell.moveBtn.layer.borderColor = UIColor(hexString: "#EFEFEF").cgColor
                        cell.moveBtn.setImage(UIImage(named: "likeComment"), for: .normal)
                        cell.moveBtn.backgroundColor = .white
                        cell.moveBtn.tag = row*10000 + 2
                        self.friendArr[row].like_yn = "N"
                   }else{
                        cell.moveBtn.tag = row*10000 + 1
                        self.friendArr[row].like_yn = "Y"
                        cell.moveBtn.backgroundColor = UIColor(hexString: "#EFEFEF")
                        cell.moveBtn.setImage(UIImage(named: "likeCancelText"), for: .normal)
                   }
                
                  }) { error in
                }
            }
       } else if tag == 1 && UserManager.shared.userInfo.results?.user?.id != self.friendArr[row].user_id ?? 0 {
            let userInfo = ["chattingUrl":self.friendArr[row].chat_address ?? ""] as [String : Any]
                dismiss(animated: true, completion: {
                if self.viewCheck == "childDetail" {
                   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classDetailchattingValueSend"), object: nil,userInfo: userInfo)
               }else if self.viewCheck == "replyDetail" {
                   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "replyDetailValueSend"), object: nil,userInfo: userInfo)
               }else if self.viewCheck == "feedDetail" {
                   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "feedDetailValueSend"), object: nil,userInfo: userInfo)
               }else{
               }
           })
       }else{
           friend_add(sender: sender)
       }
        
    }
    
    @IBAction func friendProfileBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        self.friend_id_row = tag
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: self.dismissFriendCheck)
        }
    }
    
    func dismissCheck(){
//        self.navigationController?.popToRootViewController(animated: true)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabbarIndexChange"), object: 3)
        if self.viewCheck == "childDetail"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classDetailFriend"), object: friendArr[self.friend_id_row].user_id ?? 0,userInfo: nil)
        }else if self.viewCheck == "replyDetail"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "replyDetailFriend"), object: friendArr[self.friend_id_row].user_id ?? 0,userInfo: nil)
        }else if self.viewCheck == "feedDetail"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "feedDetailFriend"), object: friendArr[self.friend_id_row].user_id ?? 0,userInfo: nil)
        }else{
            
        }
    }
    
    func dismissFriendCheck(){
        if self.viewCheck == "childDetail"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "classDetailFriend"), object: friendArr[self.friend_id_row].user_id ?? 0,userInfo: nil)
        }else if self.viewCheck == "replyDetail"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "replyDetailFriend"), object: friendArr[self.friend_id_row].user_id ?? 0,userInfo: nil)
        }else if self.viewCheck == "feedDetail"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "feedDetailFriend"), object: friendArr[self.friend_id_row].user_id ?? 0,userInfo: nil)
        }else{
            
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 친구를 추가 하거나 삭제하는 함수
     
     - Parameters:
        - sender: 버튼 태그
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func friend_add(sender: UIButton){
        let row = sender.tag/10000
        let user_id = friendArr[row].user_id ?? 0
        let friend_status = "N"
        FeedApi.shared.friend_add(user_id: user_id,friend_status:friend_status,success: { [unowned self] result in
            if result.code == "200"{
                let indexPath = IndexPath(row: row, section: 0)
                if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows?.firstIndex(of: indexPath as IndexPath) {
                    if visibleIndexPaths != NSNotFound {
                        self.friendArr[row].friend_status = "Y"
                        Toast.showFriend(message:"\(self.friendArr[row].user_name ?? "")님에게 함께해요 전송완료", controller: self)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }else{
                Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                    
                })
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {

            })
        }
    }
    
    func friend_List(){
        
        FeedApi.shared.replyLikeList(comment_id: self.comment_id, comment_str_id: self.comment_str_id, page: self.page, success: { [unowned self] result in
            if result.code == "200"{
                self.friendList = result
                
                for addArray in 0 ..< (self.friendList?.results?.friend_list.count)! {
                    self.friendArr.append((self.friendList?.results?.friend_list[addArray])!)
                }
                
                let str = "좋아요 \(self.friendList?.results?.total ?? 0)"
                let attributedString = NSMutableAttributedString(string: str)
                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AppleSDGothicNeo-Bold", size: 14)!, range: (str as NSString).range(of:"\(self.friendList?.results?.total ?? 0)"))
                
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#484848") , range: (str as NSString).range(of:"\(self.friendList?.results?.total ?? 0)"))

                self.likeTitle.attributedText = attributedString
                
                self.tableView.reloadData()
            }else{
                Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                    
                })
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {

            })
        }
    }
}

extension ReplyLikeViewController:UITableViewDataSource,UITableViewDelegate{
    
    /** **테이블 셀이 보이기 시작할때 타는 함수 */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0{
            if row == (self.friendArr.count)-2{
                if self.friendArr.count < friendList?.results?.total ?? 0 {
                    self.page = self.page + 1
                    self.friend_List()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.friendArr.count > 0 {
            return self.friendArr.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell : ReplyLikeTableViewCell =  tableView.dequeueReusableCell(withIdentifier:  "ReplyLikeTableViewCell") as! ReplyLikeTableViewCell
        if friendArr[row].coach_yn ?? "N" == "Y"{
            cell.coachStar.isHidden = false
        }else{
            cell.coachStar.isHidden = true
        }
        
        cell.user_photo.sd_setImage(with: URL(string: "\(friendArr[row].user_photo ?? "")"), placeholderImage: UIImage(named: "reply_user_default"))
        
        cell.nickname.text = "\(friendArr[row].user_name ?? "")"
        cell.stateComment.text = "\(friendArr[row].profile_comment ?? "")"
        if friendArr[row].friend_status ?? "N" == "Y"{
            cell.friendImg.isHidden = true
            cell.moveBtn.tag = (row*10000)+1
            cell.moveBtn.setImage(UIImage(named: "messageImgV2"), for: .normal)
        }else{
            cell.friendImg.isHidden = false
            cell.moveBtn.tag = (row*10000)+2
            cell.moveBtn.setImage(UIImage(named: "follow_profile"), for: .normal)
        }
        if UserManager.shared.userInfo.results?.user?.id ?? 0 == friendArr[row].user_id ?? 0 {
            cell.moveBtn.tag = row*10000 + 1
            friendArr[row].like_yn = "N"
            cell.moveBtn.layer.cornerRadius = 2
            cell.moveBtn.backgroundColor = UIColor(hexString: "#EFEFEF")
            cell.moveBtn.setImage(UIImage(named: "likeCancelText"), for: .normal)
            cell.friendImg.isHidden = true
        }
        cell.friendProfileBtn.tag = row//friendArr[row].user_id ?? 0
        
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ReplyLikeViewController: UIGestureRecognizerDelegate,UIScrollViewDelegate{
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 수직으로 슬라이드 될떄 타는 함수
     
     - Parameters:
        - y: y값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func slideViewVerticallyTo(_ y: CGFloat) {
        self.view.frame.origin = CGPoint(x: 0, y: y)
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 팬 제스처가 일어나기 시작하는 이벤트
     
     - Parameters:
        - panGesture: panGesture 이벤트 값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began, .changed:
            let translation = panGesture.translation(in: view)
            let y = max(0, translation.y+30)
            self.slideViewVerticallyTo(y)
            break
        case .ended:
            let translation = panGesture.translation(in: view)
            let velocity = panGesture.velocity(in: view)
            let closing = (translation.y > self.view.frame.size.height * minimumScreenRatioToHide) ||
                (velocity.y > minimumVelocityToHide)
            
            if closing {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(self.view.frame.size.height)
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: false, completion: {
//                            self.slideViewVerticallyTo(0)
                        })
                    }
                })
            } else {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(0)
                })
            }
            break
        default:
            UIView.animate(withDuration: animationDuration, animations: {
                self.slideViewVerticallyTo(0)
            })
            break
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 스크롤을 이용하여 스크롤이 상단 y=0 까지 올라오면 팬 제스처 실행
     
     - Parameters:
        - scrollView: scrollView 값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentY = scrollView.contentOffset.y
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 제스쳐 인식 함수
     
     - Parameters:
        - gestureRecognizer: gestureRecognizer 값
        - otherGestureRecognizer: otherGestureRecognizer 값
     
     - Throws: `Error` 네트워크가 제대로 연결되지 않은 경우 `Error`
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        if contentY == 0 {
            return true
        }else{
            return false
        }
    }
}
