//
//  AppDelegate.swift
//  modooClass
//
//  Created by 조현민 on 02/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FBSDKCoreKit
import NaverThirdPartyLogin
import AudioToolbox
import AppsFlyerLib
import AVFoundation

/**
# AppDelegate.swift 클래스 설명

## UIResponder ,UIApplicationDelegate ,UNUserNotificationCenterDelegate ,AppsFlyerTrackerDelegate 상속 받음
- 알림 메인 화면을 보기 위한 뷰 컨트롤러
*/
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UNUserNotificationCenterDelegate , AppsFlyerTrackerDelegate{
    

    /** **앱 윈도우 */
    var window: UIWindow?
    /** **원격 설정 */
    var remoteConfig: RemoteConfig?
    /** **첫 시작 푸쉬 타입 */
    var firstExecPushType = 0
    /** **푸쉬 내용 */
    var body = ""
    /** **푸쉬 타입 */
    var push_type = 99
    /** **푸쉬 URL */
    var push_url = ""
    /** **푸쉬 클래스 아이디 */
    var mcClass_id = 0
    /** **푸쉬 댓글 아이디 */
    var mcComment_id = 0
    /** **푸쉬 커리큘럼 아이디 */
    var mcCurriculum_id = 0
    /** **푸쉬 친구 아이디 */
    var friend_id = 0
    /** **푸쉬 알림 아이디 */
    var appnotify_id = 0
    /** **푸쉬 사진 */
    var photo = ""
    /** **푸쉬 알림 읽음 유무 */
    var read_status = "N"
    /** **푸쉬 시간 */
    var created_at = ""
    /** **푸쉬 알림 지난 시간 */
    var time_spilled = ""
    /** **푸쉬 닉네임 */
    var short_name = ""
    /** **푸쉬 친구 이름 */
    var friend_name = ""
    /** **푸쉬 채팅 카운트 */
    var chat_count = 0
    /** **푸쉬 알림 카운트 */
    var alarm_count = 0
    /** **프로필 URL */
    var profile_url = ""
    /** **앱 방향 */
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]!) {
        
    }
    
    func onConversionDataFail(_ error: Error!) {
        
    }
    
    
    /** **앱이 설치가 완료 되면 타는 메소드 */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 1.0)
        //fcm 버전체크
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig!.setDefaults(fromPlist: "RemoteConfigDefaults")
        checkFirebaseRemote()
        
        //naver
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isInAppOauthEnable = true
        instance?.isNaverAppOauthEnable = true
        instance?.isOnlyPortraitSupportedInIphone()
        
        instance?.serviceUrlScheme = "naverloginModooClass"
        instance?.consumerKey = "N6YxgA6WdMRwG4JQh2zJ"
        instance?.consumerSecret = "Cqnn8FRe6T"
        instance?.appName = "클래스톡"
        
//        UserDefaults.standard.set(nil, forKey: userProvider)
//        UserDefaults.standard.set(nil, forKey: userId)
//        UserDefaults.standard.set(nil, forKey: userPw)
//        UserDefaults.standard.set(nil, forKey: userName)
//        UserDefaults.standard.set(nil, forKey: sessionToken)
        
        rootViewCheck(StoryBoard:"Launch",StoryBoardName:"LaunchNavViewController")
        
        //apns
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        //TODO: 다크모드 작업 필요함
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        //페이스북 연결시 풀것
        //facebook
        FBSDKCoreKit.ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //appsflyer
        AppsFlyerTracker.shared().appsFlyerDevKey = "ejNYPJw3wf5SXtqbyjhAaK";
        AppsFlyerTracker.shared().appleAppID = "1464482964"  /* id 값이 붙지 않습니다 */
        AppsFlyerTracker.shared().delegate = self
        AppsFlyerTracker.shared().isDebug = true
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        return true
    }
    
    /** **앱의 방향  메소드 */
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    /** **앱의 방향  메소드 */
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
    /** **카카오 로그인 및 페이스북 로그인 및 네이버 로그인 */
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
        
        //카카오 로그인
        if KOSession.isKakaoAccountLoginCallback(url) {
            //kakao
            KOSession.shared()?.isAutomaticPeriodicRefresh = true
            return KOSession.handleOpen(url)
        }
//        enfitmodooclass:///class?class_id=449
        let url_path:String = url.path
        print("url_path : ",url_path)
        if (url_path == "/appSchemeClass") {
            var class_id:String
            
            if let seq:String = getQueryStringParameter(url: url.absoluteString, param: "class_id") {
                class_id = seq
            }else {
                class_id = ""
            }
            print(class_id)
            let preferences = UserDefaults.standard
            preferences.set(class_id, forKey: "class_id")
            preferences.synchronize()
            
            if topMostViewController()?.isKind(of: LoginViewController.self) == false && topMostViewController()?.isKind(of: FirstStartViewController.self) == false && topMostViewController()?.isKind(of: PasswordSearchViewController.self) == false && topMostViewController()?.isKind(of: JoinViewController.self) == false && topMostViewController()?.isKind(of: PhoneLoginViewController.self) == false && topMostViewController()?.isKind(of: LaunchViewController.self) == false{
                topMostViewController()?.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabbarIndexChange"), object: 0)
                DispatchQueue.main.async {
                    if class_id != ""{
//                        let storyboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
//                        let newViewController = storyboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
//                        newViewController.class_id = Int(class_id)!
//                        newViewController.pushGubun = 1
                        UserDefaults.standard.set(0, forKey: "class_id")
//                        self.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: false)
                        self.topMostViewController()?.navigationController?.popOrPushController(class_id: Int(class_id)!)
                    }
                }
            }
            return true
        }
        // facebook sharing delegate
//        ApplicationDelegate.shared.application(
//                application,
//                open: url,
//                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//            )

        
        
        //페이스북 로그인
        let facebookSession = FBSDKCoreKit.ApplicationDelegate.shared.application(application, open: url, options: options)
        
        let naverSession = NaverThirdPartyLoginConnection.getSharedInstance().application(application, open: url, options: options)
        
        return facebookSession || naverSession
        
    }
    
    /** **스키마 파라미터 */
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }

    /** **애플리케이션이 활성상태에서 비활성 상태로 옮길때 메소드 */
    func applicationWillResignActive(_ application: UIApplication) {
        
        // 애플리케이션이 활성 상태에서 비활성 상태로 옮길 때 전송됩니다. 이것은 특정 유형의 일시적인 중단 (들어오는 전화 통화 또는 SMS 메시지) 또는 사용자가 응용 프로그램을 종료하고 백그라운드 상태로의 전환을 시작할 때 발생할 수 있습니다.
        //이 메서드를 사용하여 진행중인 작업을 일시 중지하고 타이머를 비활성화하고 그래픽 렌더링 콜백을 무효화합니다. 게임은이 방법을 사용하여 게임을 일시 중지해야합니다.
    }
    
    /** **애플리케이션이 포그라운드에서 백그라운드로 이동할때 */
    func applicationDidEnterBackground(_ application: UIApplication) {
        KOSession.handleDidEnterBackground()
        //이 메소드를 사용하여 공유 리소스를 해제하고 사용자 데이터를 저장하고 타이머를 무효화하고 나중에 종료 될 경우를 대비하여 응용 프로그램 상태 정보를 저장하여 응용 프로그램을 현재 상태로 복원합니다.
        // 응용 프로그램이 백그라운드 실행을 지원하는 경우 사용자가 종료 할 때 applicationWillTerminate : 대신이 메서드가 호출됩니다.
    }
    
    /** **애플리케이션이 백그라운드에서 포그라운드로 이동할때 */
    func applicationWillEnterForeground(_ application: UIApplication) {
        // 백그라운드에서 활성 상태로의 전환의 일부로 호출됩니다. 여기서 배경을 입력 할 때 변경된 사항 중 많은 부분을 취소 할 수 있습니다.
    }
    
    /** **애플리케이션이 백그라운드에서 포그라운드로 이동하고 난뒤 */
    func applicationDidBecomeActive(_ application: UIApplication) {
        //카카오 로그인
        KOSession.handleDidBecomeActive()
        
        //앱스 플라이어
        AppsFlyerTracker.shared().trackAppLaunch() 
        
        // 응용 프로그램이 비활성 상태 일 때 일시 중지되었거나 아직 시작되지 않은 모든 작업을 다시 시작합니다. 응용 프로그램이 백그라운드에서 이전에 있었던 경우 선택적으로 사용자 인터페이스를 새로 고칩니다.
        
    }
    
    /** **애플리케이션이 종료 될때 */
    func applicationWillTerminate(_ application: UIApplication) {
        // 응용 프로그램이 종료 될 때 호출됩니다. 적절한 경우 데이터를 저장하십시오. applicationDidEnterBackground :를 참조하십시오.
    }
    
    /** **애플리케이션이 Notification 에러 */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    /** **애플리케이션이 APNS 토큰 받는곳 */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var pushKey: String = ""
        for i in 0..<deviceToken.count {
            pushKey += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print("pushKey : ",pushKey)
        UserDefaultSetting.setUserDefaultsString(pushKey, forKey: apnsToken)
    }
    
    /** **애플리케이션이 APNS 받으면 태그 나누는곳 */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        self.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: { result in
        })
        
    }
    
    /** **애플리케이션이 APNS 받으면 태그 나누는곳 */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let state: UIApplication.State = application.applicationState
        print("userInfo : ",userInfo)
        let apsNotificationDict = userInfo["aps"] as? [AnyHashable : Any]
        if apsNotificationDict == nil {
            return
        }
//        let badge = apsNotificationDict?["badge"] as? Int
//        let title = alertNotificationDict?["title"] as? String
        let alertNotificationDict = apsNotificationDict?["alert"] as? [AnyHashable : Any]
        let body_comment = alertNotificationDict?["body"] as? String
        let pushType = userInfo["push_type"] as? Int
        let mcClassid = userInfo["mcClass_id"] as? Int
//        let mcCurriculumid = userInfo["mcCurriculum_id"] as? Int
        let mcCommentid = userInfo["mcComment_id"] as? Int
        let friendId = userInfo["friend_id"] as? Int
        let appnotifyId = userInfo["appnotify_id"] as? Int
        let readStatus = userInfo["read_status"] as? String
        let createdAt = userInfo["created_at"] as? String
        let shortName = userInfo["short_name"] as? String
        let friendName = userInfo["friend_name"] as? String
        let pushUrl = userInfo["push_url"] as? String
        let timeSpilled = userInfo["time_spilled"] as? String
        let photoUrl = userInfo["photo"] as? String
        let chatCount = userInfo["chat_count"] as? Int
        let alarmCount = userInfo["alarm_count"] as? Int
        let profileUrl = userInfo["profile_url"] as? String
        
        var class_id = 0
        var curriculum_cnt = 0
        var week_mission_cnt = 0
        var class_photo = ""
        var class_name = ""
        var category = ""
        var class_short_name = ""

        if let class_infoNotificationDict = userInfo["class_info"] as? String,
            let jsonData = class_infoNotificationDict.data(using: .utf8),
            let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary {
            class_id = dict["class_id"] as? Int ?? 0
            curriculum_cnt = dict["curriculum_cnt"] as? Int ?? 0
            week_mission_cnt = dict["week_mission_cnt"] as? Int ?? 0
            class_photo = dict["class_photo"] as? String ?? ""
            class_name = dict["class_name"] as? String ?? ""
            category = dict["category"] as? String ?? ""
            class_short_name = dict["class_short_name"] as? String ?? ""
            print("APS PAYLOAD DICTIONARY \(dict)")
        }
        
        self.push_type = pushType ?? 99
        self.push_url = pushUrl ?? ""
        self.mcClass_id = mcClassid ?? 0
//        self.mcCurriculum_id = mcCurriculumid ?? 0
        self.mcComment_id = mcCommentid ?? 0
        self.friend_id = friendId ?? 0
        self.appnotify_id = appnotifyId ?? 0
        self.body = body_comment ?? ""
        self.photo = photoUrl ?? ""
        self.read_status = readStatus ?? "N"
        self.created_at = createdAt ?? ""
        self.time_spilled = timeSpilled ?? "0분전"
        self.short_name = shortName ?? ""
        self.friend_name = friendName ?? ""
        self.chat_count = chatCount ?? 0
        self.alarm_count = alarmCount ?? 0
        self.profile_url = profileUrl ?? ""
        UserDefaultSetting.setUserDefaultsInteger(chatCount ?? 0, forKey: chattingBadgeValue)
        UserDefaultSetting.setUserDefaultsInteger(alarmCount ?? 0, forKey: alarmBadgeValue)
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0//badge ?? 0
            if state == UIApplication.State.active {
                self.firstExecPushType = 100
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                UISelectionFeedbackGenerator().selectionChanged()
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, nil)
                
                if self.push_type == 8{
                    if self.topMostViewController()?.isKind(of: ChattingFriendWebViewViewController.self) == true{
                        let viewcontroller:ChattingFriendWebViewViewController = self.topMostViewController() as! ChattingFriendWebViewViewController
                        if viewcontroller.url != pushUrl! {
                            Toast.showButtonNotification(message: "\(body_comment ?? "")", url: self.push_url, controller: self.topMostViewController()!)
                        }
                    }else{
                        Toast.showButtonNotification(message: "\(body_comment ?? "")", url: self.push_url, controller: self.topMostViewController()!)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "home2MainChatBadgeChange"), object: chatCount)
                }else if self.push_type == 10{
                    let favorites_class = Favorites_class_pilot.init()
                    favorites_class.class_id = class_id
                    favorites_class.class_photo = class_photo
                    favorites_class.class_name = class_name
                    favorites_class.category = category
                    favorites_class.class_short_name = class_short_name
                    favorites_class.curriculum_cnt = curriculum_cnt
                    favorites_class.week_mission_cnt = week_mission_cnt
                    favorites_class.favorites_status = "Y"
                    var class_id_check = false
                    for i in 0..<(HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr.count ?? 0){
                        if HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr[i].class_id ?? 0 == class_id{
                            class_id_check = true
                        }
                    }
                    if class_id_check == false{
                        HomeMain2Manager.shared.pilotAppMain.results?.favorites_class_arr.insert(favorites_class, at: 0)
                    }
                }else{
                    Toast.showNotification(message: "\(body_comment ?? "")", controller: self.topMostViewController()!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "home2MainAlarmBadgeChange"), object: alarmCount)
                }
                
                
            }else if state==UIApplication.State.inactive || state==UIApplication.State.background{ //앱이 백그라운드에서 포그라운드로 올라올때 즉 -> 재시작되거나 앱이 시작되거나 잠시 내려놨다가 다시 시작할때
                self.alarm_read(alarm_id: self.appnotify_id)
//                Alert.With(self.topMostViewController()!, title: "\(self.topMostViewController())")
                if self.topMostViewController()?.isKind(of: LaunchViewController.self) != true{
                    self.firstExecPushType = 100
                }
                
                if self.topMostViewController()?.isKind(of: FeedDetailViewController.self) == true{
                    let viewcontroller:FeedDetailViewController = self.topMostViewController() as! FeedDetailViewController
                    viewcontroller.player?.pause()
                    UserDefaultSetting.setUserDefaultsDouble(Double((viewcontroller.player?.playerLayer?.player?.currentItem!.currentTime().seconds)!), forKey: videoPlayTime)
                    UserDefaultSetting.setUserDefaultsString(viewcontroller.loadUrl!, forKey: videoPlayUrl)
                }
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alarmNew"), object: nil)
                if self.push_type == 8{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "home2MainChatBadgeChange"), object: chatCount)
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "home2MainAlarmBadgeChange"), object: alarmCount)
                }
                if self.firstExecPushType == 0 {
                    return
                }else{
                    self.pushMoveView()
                }
                
                return
            }
//            }else if state==UIApplication.State.background{ //데이터 변경점을 체크하는 메소드로 사용
//
//            }
        }
    }
    
    /** **애플리케이션이 푸쉬 타입별로 움직이는 뷰 설정 */
    func pushMoveView(){
        if push_type == 0 {
            if self.topMostViewController()?.isKind(of: ChildHome2WebViewController.self) == true{
                let viewcontroller:ChildHome2WebViewController = self.topMostViewController() as! ChildHome2WebViewController
                viewcontroller.url = self.push_url
                viewcontroller.webViewReload()
            }else{
                let storyboard: UIStoryboard = UIStoryboard(name: "ChildWebView", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "ChildHome2WebViewController") as! ChildHome2WebViewController
                newViewController.url = self.push_url
                self.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: true)
            }
        }else if push_type == 1{//클래스 디테일 이동
            topMostViewController()?.navigationController?.popToRootViewController(animated: true)
            DispatchQueue.main.async {
                self.topMostViewController()?.navigationController?.popOrPushController(class_id: self.mcClass_id)
//                let storyboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
//                let newViewController = storyboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
//                newViewController.pushGubun = 1
//                newViewController.class_id = self.mcClass_id
//                self.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: false)
            }
        }else if push_type == 2{ // 클래스디테일 내 커뮤니티 이동
            topMostViewController()?.navigationController?.popToRootViewController(animated: true)
            DispatchQueue.main.async {
                self.topMostViewController()?.navigationController?.popOrPushController(class_id: self.mcClass_id)
                
//                let storyboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
//                let newViewController = storyboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
//                newViewController.pushGubun = 2
//                newViewController.class_id = self.mcClass_id
//                newViewController.comment_id = self.mcComment_id
//                self.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: false)
            }
        }else if push_type == 3{//댓글상세
            let storyboard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
            if self.topMostViewController()?.isKind(of: FeedDetailViewController.self) == true{
                let viewcontroller:FeedDetailViewController = self.topMostViewController() as! FeedDetailViewController
                viewcontroller.player?.pause()
            }
            let newViewController = storyboard.instantiateViewController(withIdentifier: "DetailReplyViewController") as! DetailReplyViewController
            if self.mcCurriculum_id == 0{
                newViewController.comment_id = self.mcComment_id
                newViewController.class_id = self.mcClass_id
                newViewController.commentType = "class"
            }else{
                newViewController.commentType = "curriculum"
                newViewController.comment_id = self.mcComment_id
                newViewController.class_id = self.mcClass_id
                newViewController.curriculum_id = self.mcCurriculum_id
            }
            self.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: false)
        }else if push_type == 4{//친구 프로필 이동
            let storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
            if UserManager.shared.userInfo.results?.user?.id == self.friend_id {
                newViewController.isMyProfile = true
            }else{
                newViewController.isMyProfile = false
            }
            newViewController.user_id = self.friend_id
            self.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: true)
        }else if push_type == 5{ //알림으로 이동
            topMostViewController()?.navigationController?.popToRootViewController(animated: true)
            let storyboard: UIStoryboard = UIStoryboard(name: "Alarm", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "AlarmViewController") as! AlarmViewController
            topMostViewController()?.navigationController?.pushViewController(newViewController, animated: true)
        }else if push_type == 6{//내 프로필
            let storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "ProfileV2NewViewController") as! ProfileV2NewViewController
            if UserManager.shared.userInfo.results?.user?.id == self.friend_id {
                newViewController.isMyProfile = true
            }else{
                newViewController.isMyProfile = false
            }
            newViewController.user_id = self.friend_id
            self.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: true)
        }else if push_type == 7{//알림
            topMostViewController()?.navigationController?.popToRootViewController(animated: true)
            let storyboard: UIStoryboard = UIStoryboard(name: "Alarm", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "AlarmViewController") as! AlarmViewController
            topMostViewController()?.navigationController?.pushViewController(newViewController, animated: true)
        }else if push_type == 8{//메세지
            if topMostViewController()?.isKind(of: ChattingFriendWebViewViewController.self) == true{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chattingWebViewReloadCheck"), object: self.push_url)
            }else{
                let time = DispatchTime.now() + .seconds(1)
                DispatchQueue.main.asyncAfter(deadline: time) {
                    let storyboard: UIStoryboard = UIStoryboard(name: "ChattingWebView", bundle: nil)
                    let newViewController = storyboard.instantiateViewController(withIdentifier: "ChattingFriendWebViewViewController") as! ChattingFriendWebViewViewController
                    newViewController.url = self.push_url
                    self.topMostViewController()?.navigationController?.pushViewController(newViewController, animated: false)
                }
            }
        }else{
            
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 알림 읽음 처리
     
     - Parameters:
        - alarm_id: 알림 아이디
     
     - Throws: `Error` 아이디값이 이상한 값으로 넘어올 경우 `Error`
     */
    func alarm_read(alarm_id:Int){
        AlarmApi.shared.alarmRead(id:alarm_id,success: { result in
        }) { error in
        }
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 현재 위치한 뷰 체크
     
     - Throws: `Error` 뷰컨트롤러가 아닐경우 `Error`
     
     - Returns: 현재 보고있는 뷰 컨트롤러
     */
    func topMostViewController() -> UIViewController? {
        return self.window?.rootViewController?.topMostViewController() 
    }

    /**
    **파라미터가 있고 반환값이 없는 메소드 > 루트 뷰 설정
     
     - Parameters:
        - StoryBoard: 스토리보드 파일명
        - StoryBoardName: 스토리보드 명
     
     - Throws: `Error` 스토리보드가 이상한 값으로 넘어올 경우 `Error`
     */
    func rootViewCheck(StoryBoard:String,StoryBoardName:String){
        let mainStoryboard : UIStoryboard = UIStoryboard(name: StoryBoard, bundle: nil)
        let initialViewController : UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: StoryBoardName) as! UINavigationController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 파이어베이스 리모트 버전 체크 후 업데이트 유무
     
     - Throws: `Error` 리모트값이 이상한 값으로 넘어올 경우 `Error`
     */
    func checkFirebaseRemote() {
        remoteConfig?.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            if status == .success {
                self.remoteConfig!.activate()//activateFetched()
                let newVersion = self.remoteConfig!["APP_VERSION"].stringValue
                let infoDictionary = Bundle.main.infoDictionary
                let currentVersion = infoDictionary?["CFBundleShortVersionString"] as? String
                // return 0 업데이트 불필요 1 강제 업데이트 2 업데이트 하고싶은 사람만 3: 파라미터 이상
                let overIdx: Int = self.over(withNewVersion: newVersion, fromVersion: currentVersion)
                UserDefaultSetting.setUserDefaultsInteger(overIdx, forKey: "updateGubun")
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 버전 체크 함수
     
     - Parameters:
        - newVersion: 새 버전
        - fromVersion: 현재 버전
     
     - Throws: `Error` 값이 이상한 값으로 넘어올 경우 `Error`
     
     - Returns:  0 - 업데이트 불필요 , 1 - 강제 업데이트 , 2 - 업데이트 하고싶은 사람만 , 3 - 파라미터 이상
     */
    func over(withNewVersion newVersion: String?, fromVersion: String?) -> Int {
        let arr1 = newVersion?.components(separatedBy: ".")
        let arr2 = fromVersion?.components(separatedBy: ".")
        
        let count1 = Int(arr1?.count ?? 0)
        let count2 = Int(arr2?.count ?? 0)
        
        if count1 > 0 && count2 > 0 {
            guard let v1 = Int(arr1![0]), let v2 = Int(arr2![0]) else {
                print("Some paremter is nil")
                return 3
            }
            if v1 > v2 {
                return 1
            } else if v1 < v2 {
                return 0
            }
        } else {
            return 0
        }
        
        if count1 > 1 && count2 > 1 {
            guard let v1 = Int(arr1![1]), let v2 = Int(arr2![1]) else {
                print("Some paremter is nil")
                return 3
            }
            if v1 > v2 {
                return 1
            } else if v1 < v2 {
                return 0
            }
        } else {
            return 0
        }
        
        if count1 > 2 && count2 > 2 {
            guard let v1 = Int(arr1![2]), let v2 = Int(arr2![2]) else {
                print("Some paremter is nil")
                return 3
            }
            if v1 > v2 {
                return 2
            } else if v1 < v2 {
                return 0
            }
        }
        return 0
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 디바이스 종류
     
     - Throws: `Error` 값이 이상한 값으로 넘어올 경우 `Error`
     
     - Returns:  Device_type - Int
     */
    func deviceType() -> Int{
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch Int(UIScreen.main.nativeBounds.size.height) {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                return DEVICE_IPHONE5
            case 1334:
                print("iPhone 6/6S/7/8")
                return DEVICE_IPHONE6
            case 1920,2208:
                print("iPhone 6+/6S+/7+/8+")
                return DEVICE_IPHONE6PLUS
            case 1704, 2436, 1164:
                print("iPhone X")
                return DEVICE_IPHONEX
            case 1792:
                print("iPhone XR")
                return DEVICE_IPHONEXR
           case 2688:
                print("iPhone XS Max")
                return DEVICE_IPHONEXSMAX
            case 2732:
                print("iPad Pro 12.9-inch (2nd generation) or iPad Pro (12.9-inch)")
                return DEVICE_IPAD
            case 1668:
                print("iPad Pro 10.5-inch")
                return DEVICE_IPAD
            case 2048:
                print("iPad Pro (9.7-inch) or iPad Air 2 or iPad Mini 4")
                return DEVICE_IPAD
            default:
                print("unknown")
                return DEVICE_ETC
            }
        }else{
            return DEVICE_ETC
        }
    }
}

