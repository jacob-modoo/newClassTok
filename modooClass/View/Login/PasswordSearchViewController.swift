//
//  PasswordSearchViewController.swift
//  modooClass
//
//  Created by 조현민 on 16/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

/**
# PasswordSearchViewController.swift 클래스 설명

## UIViewController , UITextFieldDelegate 상속 받음
- 비밀번호찾기 화면 타는 뷰컨트롤러
*/
class PasswordSearchViewController: UIViewController ,UITextFieldDelegate{

    /** **돌아가기 버튼 */
    @IBOutlet var returnBackBtn: UIButton!
    /** **제목 라벨 */
    @IBOutlet var titleLabel: UILabel!
    /** **타이틀 설명 라벨 */
    @IBOutlet var titleDescLabel: UILabel!
    /** **정보입력 텍스트필드 */
    @IBOutlet var textField: UITextField!
    /** **에러 라벨 */
    @IBOutlet var errorLabel: UILabel!
    /** **패스워드 보기 버튼 */
    @IBOutlet var passwordSeeBtn: UIButton!
    /** **텍스트 입력시 색 변화 뷰 */
    @IBOutlet var textInputChangeView: UIView!
    /** **다음 버튼 */
    @IBOutlet var nextBtn: UIButton!
    /** **확인 버튼 */
    @IBOutlet var confirmBtn: UIButton!
    /** **인증시간 라벨 */
    @IBOutlet var authTimeLabel: UILabel!
    /** **나가기 버튼 */
    @IBOutlet var exitBtn: UIButton!
    /** **인증 제한 시간 */
    var time = 180
    /** **인증 제한 시간 타이머 */
    var timer = Timer()
    /** **타이머 시작 유무 */
    var startTimer = false
    /** **아이디 */
    var id:String = ""
    /** **비밀번호 */
    var password:String = ""
    /** **인증번호 */
    var authNumber:String = ""
    
    let home2Storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
//    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.delegate = self
        textField.tintColor = UIColor(hexString: "#7461F2")
        textField.text = id
    }
    
    /** **뷰가 나타나고 타는 메소드 */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //텍스트필드에 포커스
        self.textField.becomeFirstResponder()
    }
    
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /** **뷰가 사라지기 시작 할 때 타는 메소드 */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        alamofireNetCheck()
    }
    
}

extension PasswordSearchViewController{
    
    /** **뒤로가기 버튼 클릭 > 패스워드 찾기 절차 전단계 돌아가기 */
    @IBAction func returnBackBtnClicked(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        if nextBtn.tag == 0{
            self.navigationController?.popViewController(animated: false)
        }else if nextBtn.tag == 1{
            self.passwordParam(TitleLabel: "비밀번호 재설정 시작", TitleDescLabel: "휴대폰번호(아이디)를 입력하세요.", PasswordSeeBtn: true, IsSecureTextEntry: false, KeyboardType: .numberPad, ErrorLabel: " ", TextField: "", ConfirmBtn: true,exitBtnBool:true,backBtnBool:false,authTime:false,nextBtnText:"다음")
            nextBtn.tag = 0
        }
        self.view.isUserInteractionEnabled = true
    }
    
    /** **패스워드 보기 버튼 클릭 > 자신이 입력한 패스워드를 보거나 안보거나 분기 */
    @IBAction func passwordSeeBtnClicked(_ sender: UIButton) {
        if sender.tag == 0{
            sender.tag = 1
            sender.setImage(UIImage(named: "none_eye"), for: .normal)
            self.textField.isSecureTextEntry = false
        }else{
            sender.tag = 0
            sender.setImage(UIImage(named: "on_eye"), for: .normal)
            self.textField.isSecureTextEntry = true
        }
    }
    
    /** **패스워드 뷰 나가긱 버튼 클릭 > 패스워드 찾기 창 닫기 */
    @IBAction func exitBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    /** **다음 버튼 클릭 > 패스워드 찾기 절차 다음단계 가기 */
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        if sender.tag == 0{
            if self.textField.text?.isBlank == false{
                if self.textField.text!.isPhoneNumber == true{
                    id = textField.text!
                    LoginApi.shared.phoneAuth(phone: self.id, auth: "false", success: { result in
                        if result.code! == "200"{
                            LoginApi.shared.phoneAuth(phone: self.id, auth: "true", success: { result in
                                self.passwordParam(TitleLabel: "4자리 인증번호 입력", TitleDescLabel: "문자로 받은 인증번호를 입력해주세요", PasswordSeeBtn: true, IsSecureTextEntry: false, KeyboardType: .numberPad, ErrorLabel: " ", TextField: "", ConfirmBtn: false,exitBtnBool:true,backBtnBool:false,authTime:false,nextBtnText:"다음")
                                sender.tag = 1
                                if self.startTimer == false{
                                    self.startTimer = true
                                    self.timeLimitStart()
                                }
                            }) { error in
                                self.errorLabelChange(errorMessage: networkErrorString)
                                print("error : \(String(describing: error?.localizedDescription))")
                            }
                        }else{
                            self.errorLabelChange(errorMessage: isNoMemberString)
                        }
                    }) { error in
                        self.errorLabelChange(errorMessage: networkErrorString)
                        print("error : \(String(describing: error?.localizedDescription))")
                    }
                }else{
                    self.errorLabelChange(errorMessage: isNoIdString)
                }
            }else{
                self.errorLabelChange(errorMessage: isNoIdString)
            }
        }else if sender.tag == 1{
            
            if self.textField.text?.isBlank == false{
                
                self.authNumber = self.textField.text!
                
                LoginApi.shared.phoneVerification(phone: self.id, code: self.textField.text! , success: { result in
                    if result.code! == "200"{
                        self.passwordParam(TitleLabel: "비밀번호 재설정", TitleDescLabel: "6글자이상으로 설정해주세요. 완료하면 자동 로그인됩니다." , PasswordSeeBtn: false, IsSecureTextEntry: true, KeyboardType: .default, ErrorLabel: " ", TextField: "", ConfirmBtn: true,exitBtnBool:false,backBtnBool:true,authTime:true,nextBtnText:"완료")
                        sender.tag = 2
                        self.timeLimitStop()
                    }else{
                        if result.message! == "auth error"{
                            self.errorLabelChange(errorMessage: isNoAuthString)
                        }else{
                            self.errorLabelChange(errorMessage: isAuthTimeOutString)
                        }
                    }
                }) { error in
                    self.errorLabelChange(errorMessage: networkErrorString)
                    print("error : \(String(describing: error?.localizedDescription))")
                }
                
            }else{
                self.errorLabelChange(errorMessage: isNoAuthString)
            }
        }else{
            
            if self.textField.text?.isBlank == false{
                if self.textField.text!.isValidPassword == true{
                    self.password = self.textField.text!
                    LoginApi.shared.passworReset(phone: self.id , password: self.password, auth: self.authNumber, success: { result in
                        if result.code! == "200"{
                            LoginApi.shared.auth(id: self.id, password: self.password, success: { result in
                                if result.code! == "200"{
                                    UserDefaultSetting.setUserDefaultsString((result.results?.token)!, forKey: sessionToken)
                                    
                                    UserManager.shared.userInfo = result
                                    header = ["Content-Type":"application/x-www-form-urlencoded","Authorization": "bearer \((result.results?.token)!)"]
                                    multipartHeader = ["Content-Type":"multipart/form-data","Authorization": "bearer \((result.results?.token)!)"]
                                    if UserManager.shared.userInfo.results?.user_info_yn == "N"{
                                        let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoNickViewController") as! AddInfoNickViewController
                                        newViewController.nickname = result.results?.user?.nickname ?? ""
                                        if result.results?.user?.photo ?? "" != "" {
                                            newViewController.profile_photo = result.results?.user?.photo ?? ""
                                        }
                                        UserDefaultSetting.setUserDefaultsString("P", forKey: loginGubun)
                                        UserDefaultSetting.setUserDefaultsString(self.id, forKey: tempUserId)
                                        UserDefaultSetting.setUserDefaultsString(self.password, forKey: tempUserPw)
                                        self.navigationController?.pushViewController(newViewController, animated: false)
                                    }else{
                                        UserDefaultSetting.setUserDefaultsString(self.id, forKey: userId)
                                        UserDefaultSetting.setUserDefaultsString(self.password, forKey: userPw)
//                                        let nextView = self.mainStoryboard.instantiateViewController(withIdentifier: "MainNavController")
                                        let nextView = self.home2Storyboard.instantiateViewController(withIdentifier: "HomeMainViewNavController")
                                        launchViewHide = true
                                        nextView.modalPresentationStyle = .fullScreen
                                        self.present(nextView, animated:false,completion: nil)
                                    }
                                    
                                }else if result.code! == "101"{
                                    self.errorLabelChange(errorMessage: isYesMemberString)
                                }else{
                                    self.errorLabelChange(errorMessage: isNoLoginString)
                                }
                            }) { error in
                                self.errorLabelChange(errorMessage: networkErrorString)
                                print("error : \(String(describing: error?.localizedDescription))")
                            }
                        }else{
                            self.errorLabelChange(errorMessage: isPwResetFailString)
                        }
                    }) { error in
                        self.errorLabelChange(errorMessage: networkErrorString)
                        print("error : \(String(describing: error?.localizedDescription))")
                    }
                }else{
                    self.errorLabelChange(errorMessage: isNoPasswordString)
                }
            }else{
                self.errorLabelChange(errorMessage: isNoPasswordString)
            }
            
        }
        self.view.isUserInteractionEnabled = true
    }
    
    /** **확인 버튼 클릭 > 인증번호 확인하기 */
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        LoginApi.shared.phoneAuth(phone: self.id, auth: "true", success: { result in
            if result.code! == "200"{
                self.errorLabelChange(errorMessage: isYesMemberString)
            }else if result.code! == "101"{
                self.errorLabelChange(errorMessage: isAuthReSendString)
            }else{
                self.errorLabelChange(errorMessage: isAuthMinuteString)
            }
        }) { error in
            self.errorLabelChange(errorMessage: networkErrorString)
            print("error : \(String(describing: error?.localizedDescription))")
        }
    }
    
    /** **텍스트필드 변경 > 텍스트 필드에 변경이 일어남 처리 */
    @IBAction func textFieldChange(_ sender: UITextField) {
        if textField.text?.isEmpty == true{
            textInputChangeView.backgroundColor = UIColor(hexString: "#e0e0e0")
            errorLabel.text = " "
        }else{
            textInputChangeView.backgroundColor = UIColor(hexString: "#212121")
            errorLabel.text = " "
        }
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 패스워드 뷰 값 바뀜 처리
     
    - Parameters:
        - TitleLabel: 타이틀 문구
        - TitleDescLabel: 타이틀 설명 문구
        - PasswordSeeBtn: 패스워드 보기 유무
        - IsSecureTextEntry: 텍스트 가림 타입
        - KeyboardType: 키보드 타입
        - ErrorLabel: 에러 문구
        - TextField: 정보입력 문구
        - ConfirmBtn: 확인버튼 숨김 유무
        - exitBtnBool: 나가기 버튼 숨김 유무
        - backBtnBool: 뒤로가기 버튼 숨김 유무
        - authTime: 인증시간 문구
        - nextBtnText: 버튼 타이틀 문구
     
    - Throws: `Error` 값의 타입이 제대로 넘어오지 않을 경우 `Error`
    */
    func passwordParam(TitleLabel:String,TitleDescLabel:String,PasswordSeeBtn:Bool,IsSecureTextEntry:Bool,KeyboardType:UIKeyboardType,ErrorLabel:String,TextField:String,ConfirmBtn:Bool,exitBtnBool:Bool,backBtnBool:Bool,authTime:Bool,nextBtnText:String){
        self.titleLabel.text = TitleLabel
        self.titleDescLabel.text = TitleDescLabel
        self.passwordSeeBtn.isHidden = PasswordSeeBtn
        self.textField.isSecureTextEntry = IsSecureTextEntry
        self.textField.keyboardType = KeyboardType
        self.authTimeLabel.isHidden = authTime
        self.errorLabel.text = ErrorLabel
        self.textField.text = TextField
        self.confirmBtn.isHidden = ConfirmBtn
        self.textField.reloadInputViews()
        self.exitBtn.isHidden = exitBtnBool
        self.returnBackBtn.isHidden = backBtnBool
        self.nextBtn.setTitle(nextBtnText, for: .normal)
        self.textInputChangeView.backgroundColor = UIColor(hexString: "#e0e0e0")
    }
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 에러 라벨 출력
     
    - Parameters:
        - errorMessage: 에러 내용
        - errorColor: 에러 글자 색깔
     
    - Throws: `Error` 값이 제대로 넘어오지 않을 경우 `Error`
    */
    func errorLabelChange(errorMessage:String){
        errorLabel.text = errorMessage
        textInputChangeView.backgroundColor = UIColor(named: "MainPoint_mainColor")//UIColor(hexString: errorColor)
        
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 타이머 시작 함수
     
     - Throws: `Error` 타이머가 없을 경우 `Error`
     */
    func timeLimitStart(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeLimit), userInfo: nil, repeats: true)
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 타이머 중지 함수
     
     - Throws: `Error` 타이머가 없을 경우 `Error`
     */
    func timeLimitStop(){
        startTimer = false
        timer.invalidate()
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 타이머 시간 적용 함수
     
     - Throws: `Error` 타이머가 없을 경우 `Error`
     */
    @objc func timeLimit(){
        if time > 0 {
            time -= 1
            authTimeLabel.text = "\(time/60)분 \(time%60)초"
        }else{
            timeLimitStop()
        }
    }
    
}
