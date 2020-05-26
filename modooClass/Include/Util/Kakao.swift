//
//  Kakao.swift
//  modooClass
//
//  Created by 조현민 on 07/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//
import Foundation


class Kakao {
    // kakao sdk 설치 -> 프레임웍에 sdk 추가 후 -> 프로젝트 info -> custom ios target properties -> KAKAO_APP_KEY 추가 -> urlType 추가 -> 브릿지헤더 연결 -> info.plist LSApplicationQueriesSchemes kakao 관련 추가
    // 순서 카카오 버튼 생성후 KOLoginButton 클래스를 준뒤 컨트롤러와 연결 -> 그뒤에 밑에 소스에 맞는것들 채워넣을것
    
    func checkRequestKakao() -> Bool{
        let session : KOSession = KOSession.shared()
        return session.isOpen()
    }
    
    func kakaoLogin(){
        KOSession.shared()?.close()
        
        //카카오 로그인
        KOSession.shared()?.open(completionHandler: { error in
            if (KOSession.shared()?.isOpen())! {
                print("login succeeded.")
                //                print("KOSession.shared()?.accessToken : \(KOSession.shared()?.accessToken)")
            }else{
                print("login failed.")
            }
        })
    }
    
    func kakaoConnectionTermination(){
        //카카오 로그아웃
        KOSessionTask.unlinkTask(completionHandler: { success, error in
            if success {
                // success
                print("login unLink success")
            } else {
                print("login unLink failed")
                // failed
            }
        })
    }
    
    func kakaoLogout(){
        KOSession.shared()?.logoutAndClose(completionHandler: { success, error in
            if success {
                // logout success.
            } else {
                // failed
                print("failed to logout.")
            }
        })
        
    }
    
    func kakaoGetId(success: @escaping(_ id: String , _ nickname:String)-> Void, fail: @escaping (_ error: Error?)-> Void) {
        //카카오 아이디 닉네임 가져오기
        KOSessionTask.userMeTask(completion: { error, me in
            if error != nil {
                // fail
                fail(error)
            } else {
                // success
                success((me?.id)!, (me?.nickname)!)
            }
        })
    }
    
    func kakaoGetId() -> (id:String,nickname:String){
        //카카오 아이디 닉네임 가져오기
        var ID:String = ""
        var nickname:String = ""
        KOSessionTask.userMeTask(completion: { error, me in
            if error != nil {
                // fail
            } else {
                // success
                ID = me?.id ?? ""
                nickname = me?.nickname ?? ""
            }
        })
        return (ID,nickname)
    }
    
    //동의가 필요
    func kakaoGetEmailBirth(){
        KOSession.shared().updateScopes(["account_email", "birthday"], completionHandler: { error in
            if error != nil {
                switch (error as NSError?)?.code {
                case Int(Float(KOErrorCancelled.rawValue))?:
                    // 동의 안함
                    break
                default:
                    break
                }
            } else {
                // 사용자가 동의함
            }
        })
    }
    
    //동의가 필요
    func kakaoGetEmail(){
        //사용자 이메일 가져오기
        KOSessionTask.userMeTask(completion: { error, me in
            if error != nil {
                // fail
            } else {
                // success
                
                if me?.account!.email != nil {
                    // 이메일 가져오기 성공
                } else if me?.account!.emailNeedsAgreement != nil {
                    // 이메일 제공에 대한 사용자 동의가 필요한 상황 (이메일 동의창 요청이 가능한 상황)
                    
                    KOSession.shared().updateScopes(["account_email"], completionHandler: { error in
                        if error != nil {
                            if (error as NSError?)?.code == Int(Float(KOErrorCancelled.rawValue)) {
                                // 동의 안함
                            } else {
                                // 기타 에러
                            }
                        } else {
                            // 동의함
                            // *** userMe를 다시 요청하면 이메일 획득 가능 ***
                        }
                    })
                } else {
                    // 이메일 가져오기 실패
                }
            }
        })
    }
    
    
    func kakaoGetToken(){
        KOSessionTask.accessTokenInfoTask(completionHandler: { accessTokenInfo, error in
            if error != nil {
                switch (error as NSError?)?.code {
                case Int(Float(KOErrorDeactivatedSession.rawValue))?:
                    break
                default:
                    break
                }
            } else {
                // 성공 (토큰이 유효함)
                if let expiresInMillis = accessTokenInfo?.expiresInMillis {
                    print("남은 유효시간: \(expiresInMillis) (단위: ms)")
                }
            }
        })
    }
    
    func kakaoToKenRemove(){
        
    }
    
    //카카오 로그인,로그아웃 상태 변경
    // 카카오계정의 세션 연결 상태가 변했을 시,
    // Notification을 kakaoSessionDidChangeWithNotification 메소드에 전달하도록 설정
    
    
}
