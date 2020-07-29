//
//  FeedApi.swift
//  modooClass
//
//  Created by 조현민 on 23/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import Alamofire

class FeedApi: NSObject {
    
    static let shared = FeedApi()
    
//    MARK: - 피드 리스트
    func feedList(success: @escaping(_ data: FeedModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        print(header)
        let request = Alamofire.request("\(apiUrl)/appMainV2", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/appMainV2"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 피드 배너
    func bannerList(success: @escaping(_ data: BannerModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/app_banner", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = BannerModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/app_banner"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 피드 순위
    func searchRank(success: @escaping(_ data: SearchRankModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/app_search", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = SearchRankModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/app_search"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 피드 검색 리스트
    func searchApp(search:String,order:String,page:Int,success: @escaping(_ data: SearchModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let param = [
            "order":order,
            "search":search
            ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/class_search/\(page)", method: .post, parameters: param, encoding: URLEncoding.default, headers: header)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = SearchModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/class_search\(page)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 피드 버튼 클릭시 클래스 이동
    func searchClassCategory(api_type:String,success: @escaping(_ data: SearchModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/app_category/\(api_type)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = SearchModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/app_category/\(api_type)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 알림 신청 및 취소
    func alarmSave(class_id:String,type:String,success: @escaping(_ data: HaveNAlarmSaveModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        if type == "post"{
            let request = Alamofire.request("\(apiUrl)/opencall/\(class_id)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = HaveNAlarmSaveModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/opencall/\(class_id)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }else{
            let request = Alamofire.request("\(apiUrl)/opencall/\(class_id)", method: .delete, parameters: nil, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = HaveNAlarmSaveModel.init(dic: convertToDictionary(data: response.data!,apiURL: "delete : \(apiUrl)/opencall/\(class_id)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }
    }
    
//    MARK: - 클래스 좋아요 혹은 취소
    func class_have(class_id:Int,type:String,success: @escaping(_ data: HaveNAlarmSaveModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        if type == "post"{
            let request = Alamofire.request("\(apiUrl)/have/\(class_id)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = HaveNAlarmSaveModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/have/\(class_id)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }else{
            let request = Alamofire.request("\(apiUrl)/have/\(class_id)", method: .delete, parameters: nil, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = HaveNAlarmSaveModel.init(dic: convertToDictionary(data: response.data!,apiURL: "delete : \(apiUrl)/have/\(class_id)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }
        
    }
    
//    MARK: - 클래스 디테일 데이터
    func appClassData(class_id:Int,success: @escaping(_ data: FeedAppClassModel)-> Void, fail: @escaping (_ error: Error?)-> Void){

        let request = Alamofire.request("\(apiUrl)/classMain/\(class_id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppClassModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/classMain/\(class_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 미션페이징
    func AppClassMissionPageListData(mission_id:Int,page:Int,success: @escaping(_ data: AppClassMissionPageList)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/curriculumMission/\(mission_id)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = AppClassMissionPageList.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/curriculumMission/\(mission_id)/\(page)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 커리큘럼 좋아요 혹은 취소
    func curriculumLike(curriculum_id:Int,method_type:String,success: @escaping(_ data: FeedAppClassDetailReplyLikeModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        if method_type == "post"{
            let request = Alamofire.request("\(apiUrl)/curriculumLike/\(curriculum_id)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = FeedAppClassDetailReplyLikeModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/curriculumLike/\(curriculum_id)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }else{
            let request = Alamofire.request("\(apiUrl)/curriculumLike/\(curriculum_id)", method: .delete, parameters: nil, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = FeedAppClassDetailReplyLikeModel.init(dic: convertToDictionary(data: response.data!,apiURL: "delete : \(apiUrl)/curriculumLike/\(curriculum_id)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }
        
    }
    
//    MARK: - 클래스 디테일 댓글
    func appClassDataComment(curriculum_id:Int,page:Int,success: @escaping(_ data: FeedAppClassDetailReplyModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/app_comment/curriculum/\(curriculum_id)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppClassDetailReplyModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/app_comment/curriculum/\(curriculum_id)/\(page)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 댓글 좋아요
    func replyCommentLike(comment_id:Int,method_type:String,success: @escaping(_ data: FeedAppClassDetailReplyLikeModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        if method_type == "post"{
            let request = Alamofire.request("\(apiUrl)/like/comment/\(comment_id)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = FeedAppClassDetailReplyLikeModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/like/comment/\(comment_id)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }else{
            let request = Alamofire.request("\(apiUrl)/like/comment/\(comment_id)", method: .delete, parameters: nil, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = FeedAppClassDetailReplyLikeModel.init(dic: convertToDictionary(data: response.data!,apiURL: "delete : \(apiUrl)/like/comment/\(comment_id)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }
        
    }
    
//    MARK: - commentType = class 클래스에 댓글 남기기 , curriculum 클래스안에 커리큘럼 댓글 남기기 , mcComment 댓글 상세에서 남기기
    func replySave(class_id:Int,curriculum:Int,mcComment_id:Int,content:String,commentType:String,commentChild:Bool,emoticon:Int,photo:UIImage?,success: @escaping(_ data: FeedAppClassDetailReplySendModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        var param1:Dictionary = [
            "content":content
            ] as [String : Any]
        
        if emoticon != 100{
            param1 = [
                "content":content,
                "emoticon":emoticon
            ] as [String : Any]
        }else{
            
        }
        
        var param2 = [
            "mcComment_id":mcComment_id,
            "content":content
        ] as [String : Any]
        
        if emoticon != 100{
            param2 = [
                "mcComment_id":mcComment_id,
                "content":content,
                "emoticon":emoticon
            ] as [String : Any]
        }
        
        var param:Dictionary = [:] as [String : Any]
        
        if commentType == "class"{
            if commentChild == true {
                param = param2
            }else{
                param = param1
            }
        }else{
            if commentChild == true {
                param = param2
            }else{
                param = param1
            }
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if photo != nil {
                let imageData = photo!.jpegData(compressionQuality: 0.5)
                multipartFormData.append(imageData!, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
            }
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: "\(apiUrl)/app_comment/\(class_id)" , method: .post, headers: multipartHeader){ (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("uploading \(progress)")
                })
                upload.response { response in
                    let statusCode = response.response?.statusCode
                    if statusCode == 200 {
                        let dic = FeedAppClassDetailReplySendModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/app_comment/\(class_id)"))
                        success(dic)
                    }else {
                        fail(response.error)
                    }
                }
            case .failure( _): break
                //print encodingError.description
            }
        }
        
    }
    
//    MARK: - 댓글 상세
    func replyDetail(comment_id:Int,page:Int,success: @escaping(_ data: FeedAppClassCommentDetailReplyModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/app_comment_content/\(comment_id)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppClassCommentDetailReplyModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/app_comment_content/\(comment_id)/\(page)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 댓글 커뮤니티
    func replyClass_feed(class_id:Int,page:Int,sort:String,success: @escaping(_ data: FeedAppClassCommunityReplyModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let param = "?page=\(page)&sort=\(sort)"
        let request = Alamofire.request("\(apiUrl)/class_feed/\(class_id)\(param)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppClassCommunityReplyModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/class_feed/\(class_id)\(param)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - 댓글 삭제
    func replyDelete(comment_id:Int,success: @escaping(_ data: FeedAppClassDefaultModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/comment/\(comment_id)", method: .delete, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppClassDefaultModel.init(dic: convertToDictionary(data: response.data!,apiURL: "delete : \(apiUrl)/comment/\(comment_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - delete feed
    func feed_delete(id: Int, success: @escaping(_ data: SquareDetailModel)-> Void, fail: @escaping(_ error: Error?)-> Void){
        
        let param = [
            "mode":"delete"
            ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/comment/\(id)", method: .post, parameters: param, encoding: URLEncoding.default, headers: header)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = SquareDetailModel.init(dic: convertToDictionary(data: response.data!, apiURL: "post : \(apiUrl)/comment/\(id)"))
                success(dic)
            } else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 앱 커리큘럼 데이터
    func app_curriculum(class_id:Int,success: @escaping(_ data: FeedAppCurriculumModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/curriculum_v2/\(class_id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppCurriculumModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/curriculum_v2/\(class_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - 다음 커리큘럼 데이터
    func curriculum_next(class_id:Int,curriculum_id:Int,success: @escaping(_ data: FeedAppCurriculumNextModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/curriculum_next/\(class_id)/\(curriculum_id)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppCurriculumNextModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/curriculum_next/\(class_id)/\(curriculum_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - 앱 응원하기 데이터
    func app_cheer(class_id:Int,success: @escaping(_ data: FeedAppCheerModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/cheering/\(class_id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppCheerModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/cheering/\(class_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - 모두 응원하기
    func cheering_all(class_id:Int,success: @escaping(_ data: FeedAppCheeringModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/cheering/\(class_id)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppCheeringModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/cheering/\(class_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - 한명 응원하기
    func cheering_one(class_id:Int,user_id:Int,success: @escaping(_ data: FeedAppCheeringModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/cheering/\(class_id)/\(user_id)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppCheeringModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/cheering/\(class_id)/\(user_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - 친구 추가하기 혹은 삭제하기
    func friend_add(user_id:Int,friend_status:String,success: @escaping(_ data: FeedAppCheeringModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        if friend_status == "Y"{
            let request = Alamofire.request("\(apiUrl)/friend/\(user_id)", method: .delete, parameters: nil, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = FeedAppCheeringModel.init(dic: convertToDictionary(data: response.data!,apiURL: "delete : \(apiUrl)/friend/\(user_id)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }else{
            let request = Alamofire.request("\(apiUrl)/friend/\(user_id)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = FeedAppCheeringModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/friend/\(user_id)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }
        
    }
    
//    MARK: - 미션완료
    func mission_done(mission_id:Int,comment:String,photo:UIImage?,review_point:Int,success: @escaping(_ data: FeedAppClassMissionCompleteModel)-> Void, fail: @escaping (_ error: Error?)-> Void){

        let param = [
            "comment":comment,
            "review_point":review_point
            ] as [String : Any]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if photo != nil {
                let imageData = photo!.jpegData(compressionQuality: 0.5)
                multipartFormData.append(imageData!, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpg")
            }
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: "\(mission_doneApi)/\(mission_id)" , method: .post, headers: multipartHeader){ (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("uploading \(progress)")
                })
                upload.response { response in
                    let statusCode = response.response?.statusCode
                    if statusCode == 200 {
                        let dic = FeedAppClassMissionCompleteModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post-mutipart : \(mission_doneApi)/\(mission_id)"))
                        success(dic)
                    }else {
                        fail(response.error)
                    }
                }
            case .failure( _): break
                //print encodingError.description
            }
        }
        
    }
    
//    MARK: - 클래스 나가기
    func class_out(class_id:Int,success: @escaping(_ data: FeedAppClassDefaultModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/drop/\(class_id)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppClassDefaultModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/drop/\(class_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 비디오 총 시간 보내기
    func playTracking(duration:Int,curriculum_id:Int,success: @escaping(_ data: FeedAppClassDefaultModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let param = [
            "duration":duration,
            "curriculum_id":curriculum_id
            ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/playTracking", method: .post, parameters: param, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppClassDefaultModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/playTracking"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 플레이 타임 10초 간격 보내기
    func playTrackingTime(user_id:Int,duration:Int,curriculum_id:Int,success: @escaping(_ data: FeedAppClassDefaultModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let param = [
            "user_id":user_id,
            "duration":duration,
            "curriculum_id":curriculum_id
            ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/playTracking", method: .post, parameters: param, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppClassDefaultModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/playTracking"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - play tracking for "spectator"
    func playTrackingTimeSpectator(class_id:Int, user_id:Int,success: @escaping(_ data: FeedAppClassDefaultModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        let url = URL.init(string: "https://search.enfit.net/api/v1/userLogging/class")!
        let param = [
            "class_id": class_id,
        "user_id": user_id] as [String : Any]

        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
             switch response.result
            {
            case .success:
                let dic = FeedAppClassDefaultModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(url)"))
                success(dic)
            case .failure:
                fail(response.error)
            }
        }
    }

//    MARK: - inform everytime ehen PopupSHowVC is shown
    func popupTracking(hash_id: String, success: @escaping(_ data: FeedAppClassDefaultModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let param = ["hash" : hash_id]
        let url = URL.init(string: "https://api2.enfit.net/api/v3/tracking")
        let request = Alamofire.request("\(url!)/event_popup", method: .post, parameters: param, encoding: URLEncoding.default, headers: header)
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppClassDefaultModel.init(dic: convertToDictionary(data: response.data!, apiURL: "post : \(url!)"))
                success(dic)
            } else {
                print(response.error ?? "Failed to POST request event_popup API")
            }
        }
    }
    
//    MARK: - auto-completing search function
    func autoCompleteSearch(keyword:String, success: @escaping(_ data: AutoSearchModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        let url = URL.init(string: "https://search.enfit.net/api/v1/class/search_suggest")!
        let param = ["keyword": keyword] as [String : Any]

        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
             switch response.result
            {
            case .success:
                let dic = AutoSearchModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(url)"))
                success(dic)
            case .failure:
                fail(response.error)
            }
        }
    }

//    MARK: - 운영중인 클래스 삭제하기
    func class_delete(class_id:Int ,success: @escaping(_ data: FeedAppClassDefaultModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let param = [
            "mode":"delete"
            ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/manager/class/\(class_id)", method: .post, parameters: param, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            
            if statusCode == 200 {
                let dic = FeedAppClassDefaultModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/manager/class/\(class_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
    func class_purchase(mcClass_id:Int ,mcPackage_id:Int,user_id:Int,iap_return:String,success: @escaping(_ data: FeedInAppPurchaseModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        let param = [
            "mcClass_id":mcClass_id
            ,"mcPackage_id":mcPackage_id
            ,"user_id":user_id
            ,"iap_return":iap_return
            ] as [String : Any]
        
        let request = Alamofire.request("https://api.enfit.net/api/v3/iap_complete?token=\(UserDefaultSetting.getUserDefaultsString(forKey: sessionToken) as! String)", method: .post, parameters: param, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            
            if statusCode == 200 {
                let dic = FeedInAppPurchaseModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : https://api.enfit.net/api/v3/iap_complete"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
//        https://api.enfit.net/api/v3/iap_complete
    }
    
    //    MARK: - 클래스 상태 보내기
    func class_conditioning(status:String,success: @escaping(_ data: FeedAppClassDefaultModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let param = [
            "status":status
            ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/conditionCheck", method: .post, parameters: param, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppClassDefaultModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/conditionCheck"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
    //    MARK: - 클래스 상태 보내기
    func class_conditionInfo(class_id:Int,success: @escaping(_ data: FeedAppClassConditionInfoModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/conditionInfo/\(class_id)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppClassConditionInfoModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/conditionInfo/\(class_id)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
    //    MARK: - 좋아요 멤버 리스트
    func replyLikeList(comment_id:Int,comment_str_id:String,page:Int,success: @escaping(_ data: FeedReplyLikeModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        if comment_id != 0{
            let request = Alamofire.request("\(apiUrl)/comment_like/\(comment_id)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = FeedReplyLikeModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/comment_like/\(comment_id)/\(page)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }else{
            let request = Alamofire.request("\(apiUrl)/comment_like/\(comment_str_id)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
            
            request.response { response in
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    let dic = FeedReplyLikeModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/comment_like/\(comment_str_id)/\(page)"))
                    success(dic)
                }else {
                    fail(response.error)
                }
            }
        }
        
    }
    
//    MARK: - 앱 메인 버전 2 리스트
    func appMainPilotV2(success: @escaping(_ data: PilotModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/pilot/appMain", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = PilotModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/pilot/appMain"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - App Event List
    func event_list(success: @escaping(_ data: EventModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/story_btn", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = EventModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/story_btn"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
//    MARK: - 앱 메인 버전 2 추천 리스트
    func appMainPilotRecommendV2(success: @escaping(_ data: PilotRecommendModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/pilot/appRecommend", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = PilotRecommendModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/pilot/appRecommend"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 앱 메인 버전 2 리뷰 대시보드
    func appMainPilotReviewDashboardV2(class_id:Int,success: @escaping(_ data: ReviewDashboardModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("https://api6.enfit.net/api/class/\(class_id)/dashboard", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ReviewDashboardModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : https://api6.enfit.net/api/class/\(class_id)/dashboard"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 앱 메인 버전 2 리뷰 리스트
    func appMainPilotReviewListV2(class_id:Int,page:Int,success: @escaping(_ data: ReviewModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("https://api6.enfit.net/api/class/\(class_id)/review/*/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = ReviewModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : https://api6.enfit.net/api/class/\(class_id)/review/*/\(page)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
//    MARK: - 피드 디테일 리스트
    func appSquareDetail(feedId:String,success: @escaping(_ data: SquareDetailModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/squareDetail/\(feedId)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = SquareDetailModel.init(dic: convertToDictionary(data: response.data!,apiURL: "get : \(apiUrl)/squareDetail/\(feedId)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
        
    }
    
    func squareReplySave(articleId:String,content:String,emoticon:Int,photo:UIImage?,success: @escaping(_ data: SquareReplySaveModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
//        {articleId: "M182264", content: "고생하셨습니다!", emoticon: null, file: null}
        
        var param1:Dictionary = [
            "content":content
            ] as [String : Any]
        
        if emoticon != 100{
            param1 = [
                "content":content,
                "emoticon":emoticon
            ] as [String : Any]
        }else{
            
        }
        
        var param:Dictionary = [:] as [String : Any]
        param = param1
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if photo != nil {
                let imageData = photo!.jpegData(compressionQuality: 0.5)
                multipartFormData.append(imageData!, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
            }
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: "\(apiUrl)/squareComment/\(articleId)" , method: .post, headers: multipartHeader){ (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("uploading \(progress)")
                })
                upload.response { response in
                    let statusCode = response.response?.statusCode
                    if statusCode == 200 {
                        let dic = SquareReplySaveModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/squareComment/\(articleId)"))
                        success(dic)
                    }else {
                        fail(response.error)
                    }
                }
            case .failure( _): break
                //print encodingError.description
            }
        }
        
    }
    
    func squareReplyDelete(articleId:String,success: @escaping(_ data: FeedAppClassDetailReplySendModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let param:Dictionary = [
        "type":"delete"
        ] as [String : Any]
        
        let request = Alamofire.request("\(apiUrl)/squareComment/\(articleId)", method: .post, parameters: param, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = FeedAppClassDetailReplySendModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/squareComment/\(articleId)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
    func squareCommentList(articleId:String,page:Int,success: @escaping(_ data: SquareReplyCommentListModel)-> Void, fail: @escaping (_ error: Error?)-> Void){
        
        let request = Alamofire.request("\(apiUrl)/squareDetail_comment/\(articleId)/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
        
        request.response { response in
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                let dic = SquareReplyCommentListModel.init(dic: convertToDictionary(data: response.data!,apiURL: "post : \(apiUrl)/squareDetail_comment/\(articleId)/\(page)"))
                success(dic)
            }else {
                fail(response.error)
            }
        }
    }
    
}
