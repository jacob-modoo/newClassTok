//
//  JoinViewController.swift
//  modooClass
//
//  Created by 조현민 on 08/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

/**
 # JoinViewController.swift 클래스 설명
 
 ## BaseViewController , UITextFieldDelegate 상속 받음
 - 회원가입 화면 타는 뷰컨트롤러
 */
class JoinViewController: BaseViewController ,UITextFieldDelegate{

    /** **제목 라벨 */
    @IBOutlet var titleLabel: UILabel!
    /** **타이틀 설명 라벨 */
    @IBOutlet var titleDescLabel: UILabel!
    /** **텍스트 입력시 색 변화 뷰 */
    @IBOutlet var textInputChangeView: UIView!
    /** **정보입력 텍스트필드 */
    @IBOutlet var textField: UITextField!
    /** **에러 라벨 */
    @IBOutlet var errorLabel: UILabel!
    /** **패스워드 보기 버튼 */
    @IBOutlet var passwordSeeBtn: UIButton!
    /** **다음 버튼 */
    @IBOutlet var nextBtn: UIButton!
    /** **확인 버튼 */
    @IBOutlet var confirmBtn: UIButton!
    /** **돌아가기 버튼 */
    @IBOutlet var returnBackBtn: UIButton!
    /** **인증시간 라벨 */
    @IBOutlet var authTimeLabel: UILabel!
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
    /** **이름 */
    var name:String = ""
    /** **회원가입 유무 */
    var joinCheck = false
    /** **인증번호 */
    var authNumber = ""
    
    let home2Storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.delegate = self
        textField.tintColor = UIColor(hexString: "#7461F2")
        DispatchQueue.main.async {
            self.phoneConfirm()
        }
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
    
    /** **뷰가 나타나고 타는 메소드 */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //텍스트필드에 포커스
        self.textField.becomeFirstResponder()
    }
    
}

extension JoinViewController {
    
    /** **뒤로가기 버튼 클릭 > 회원가입 절차 전단계 돌아가기 */
    @IBAction func returnBackBtnClicked(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        if self.nextBtn.tag == 1{
            self.navigationController?.popViewController(animated: false)
            self.nextBtn.tag = 1
        }else if self.nextBtn.tag == 2{
            self.navigationController?.popViewController(animated: false)
            self.nextBtn.tag = 1
        }else if self.nextBtn.tag == 3{
            self.signLevelValue(KeyboardType: .default, TitleLabel: "비밀번호 설정", TitleDescLabel: "6글자이상으로 설정해주세요.",  PasswordSee: false, ConFirm: true, TextField: "", NextBtnTitle: "다음",ErrorLabel:" ",PasswordSecure:true,authTime:true)
            self.nextBtn.tag = 2
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
    
    /** **다음 버튼 클릭 > 회원가입 절차 다음단계 가기 */
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        if sender.tag == 1{
            if self.textField.text?.isBlank == false{
                self.authNumber = self.textField.text!
                LoginApi.shared.phoneVerification(phone: self.id, code: self.authNumber , success: { result in
                    if result.code! == "200"{
                        self.signLevelValue(KeyboardType: .default, TitleLabel: "비밀번호 설정", TitleDescLabel: "6글자이상으로 설정해주세요.", PasswordSee: false, ConFirm: true, TextField: "", NextBtnTitle: "다음",ErrorLabel:" ",PasswordSecure:true,authTime:true)
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
        }else if sender.tag == 2{
            if self.textField.text?.isBlank == false{
                if self.textField.text!.isValidPassword == true{
                    password = textField.text!
                    signLevelValue(KeyboardType: .default, TitleLabel: "이름을 입력하세요", TitleDescLabel: " ",  PasswordSee: true, ConFirm: true, TextField: "", NextBtnTitle: "완료",ErrorLabel:" ",PasswordSecure:false,authTime:true)
                    sender.tag = 3
                }else{
                    self.errorLabelChange(errorMessage: isNoPasswordString)
                }
            }else{
                self.errorLabelChange(errorMessage: isNoPasswordString)
            }
        }else{
            //가입완료~ 가보자
            if self.textField.text?.isBlank == false{
                //가입완료 ㄱ ㄱ
                name = textField.text!
                LoginApi.shared.memberJoin(phone: self.id, password: self.password, name: self.name, success: { result in
                    if result.code! == "200"{
                        //로그인 메소드 태울것
                        LoginApi.shared.auth(id: self.id, password: self.password, success: { result in
                            if result.code! == "200"{
                                UserDefaultSetting.setUserDefaultsString((result.results?.token)!, forKey: sessionToken)
                                
                                UserManager.shared.userInfo = result
                                header = ["Content-Type":"application/x-www-form-urlencoded","Authorization": "bearer \((result.results?.token)!)"]
                                multipartHeader = ["Content-Type":"multipart/form-data","Authorization": "bearer \((result.results?.token)!)"]
                                if UserManager.shared.userInfo.results?.user_info_yn == "N"{
                                    let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoNickViewController") as! AddInfoNickViewController
//                                    newViewController.textField.text = "Sherzodbek"
                                    UserDefaultSetting.setUserDefaultsString("P", forKey: loginGubun)
                                    UserDefaultSetting.setUserDefaultsString(self.id, forKey: tempUserId)
                                    UserDefaultSetting.setUserDefaultsString(self.password, forKey: tempUserPw)
                                    self.navigationController?.pushViewController(newViewController, animated: false)
                                }else{
                                    UserDefaultSetting.setUserDefaultsString(self.id, forKey: userId)
                                    UserDefaultSetting.setUserDefaultsString(self.password, forKey: userPw)
//                                    let nextView = self.mainStoryboard.instantiateViewController(withIdentifier: "MainNavController")
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
                        if result.message! == "Sentinel error"{
                            self.errorLabelChange(errorMessage: isNoAuthCheckString)
                        }else{
                            self.errorLabelChange(errorMessage: isYesMemberString)
                        }
                    }
                }) { error in
                    self.errorLabelChange(errorMessage: networkErrorString)
                    print("error : \(String(describing: error?.localizedDescription))")
                }
            }else{
                self.errorLabelChange(errorMessage: isNoNameString)
            }
        }
        self.view.isUserInteractionEnabled = true
    }
    
    /** **확인 버튼 클릭 > 인증번호 확인하기 */
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        LoginApi.shared.phoneAuth(phone: self.id, auth: "true", success: { result in
            if result.code! == "200"{
                if self.startTimer == false{
                    self.time = 180
                    self.startTimer = true
                    self.timeLimitStart()
                }else{
                    self.time = 180
                }
                self.errorLabelChange(errorMessage: isAuthReSendString)
            }else if result.code! == "101"{
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
        - KeyboardType: 키보드 타입
        - TitleLabel: 타이틀 문구
        - TitleDescLabel: 타이틀 설명 문구
        - PasswordSeeBtn: 패스워드 보기 유무
        - ConFirm: 확인버튼 숨김 유무
        - TextField: 정보입력 문구
        - NextBtnTitle: 다음버튼 타이틀 문구
        - ErrorLabel: 에러 문구
        - PasswordSecure: 텍스트 숨김 타입
        - authTime: 인증시간 문구
     
     - Throws: `Error` 값의 타입이 제대로 넘어오지 않을 경우 `Error`
     */
    func signLevelValue(KeyboardType:UIKeyboardType,TitleLabel:String,TitleDescLabel:String,PasswordSee:Bool,ConFirm:Bool,TextField:String,NextBtnTitle:String,ErrorLabel:String,PasswordSecure:Bool,authTime:Bool){
        self.textField.keyboardType = KeyboardType
        self.titleLabel.text = TitleLabel
        self.titleDescLabel.text = TitleDescLabel
        self.passwordSeeBtn.isHidden = PasswordSee
        self.confirmBtn.isHidden = ConFirm
        self.textField.text = TextField
        self.errorLabel.text = ErrorLabel
        self.nextBtn.setTitle(NextBtnTitle, for: .normal)
        self.textField.isSecureTextEntry = PasswordSecure
        self.authTimeLabel.isHidden = authTime
        self.textField.reloadInputViews()
        self.textInputChangeView.backgroundColor = UIColor(hexString: "#e0e0e0")
    }
    
    /**
    **파라미터가 없고 반환값이 없는 메소드 > 폰번호 확인 함수
     
     - Throws: `Error` 값의 타입이 제대로 넘어오지 않을 경우 `Error`
     */
    func phoneConfirm(){
        LoginApi.shared.phoneAuth(phone: self.id, auth: "true", success: { result in
            self.signLevelValue(KeyboardType: .numberPad, TitleLabel: "4자리 인증번호 입력", TitleDescLabel: "문자로 받은 인증번호를 입력해주세요.",  PasswordSee: true, ConFirm: false, TextField: "", NextBtnTitle: "다음",ErrorLabel:" ",PasswordSecure:false,authTime:false)
            self.nextBtn.tag = 1
            
            if result.code! == "200"{
                if self.startTimer == false{
                    self.time = 180
                    self.startTimer = true
                    self.timeLimitStart()
                }else{
                    self.time = 180
                }
            }else if result.code! == "101"{
                self.errorLabelChange(errorMessage: isAuthMinuteString)
            }
        }) { error in
            self.errorLabelChange(errorMessage: networkErrorString)
            print("error : \(String(describing: error?.localizedDescription))")
        }
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
            self.errorLabelChange(errorMessage: isAuthTimeOutString)
            timeLimitStop()
        }
    }
    
}
