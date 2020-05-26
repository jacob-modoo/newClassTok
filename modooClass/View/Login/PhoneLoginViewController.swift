//
//  PhoneLoginViewController.swift
//  modooClass
//
//  Created by 조현민 on 08/05/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

/**
# PhoneLoginViewController.swift 클래스 설명
 
## BaseViewController , UITextFieldDelegate 상속 받음
- 핸드폰로그인 화면 타는 뷰컨트롤러
*/
class PhoneLoginViewController: BaseViewController ,UITextFieldDelegate{

    /** **돌아가기 버튼 */
    @IBOutlet var retrunBackBtn: UIButton!
    /** **제목 라벨 */
    @IBOutlet var titleLabel: UILabel!
    /** **설명 라벨 */
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
    /** **패스워드 찾기 버튼 */
    @IBOutlet var passwordSearchBtn: UIButton!
    
    let home2Storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
//    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    /** **아이디 */
    var id:String = ""
    /** **패스워드 */
    var password:String = ""
    /** **회원가입 유무 */
    var joinCheck:Bool = true
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.delegate = self
        textField.tintColor = UIColor(hexString: "#7461F2")
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

extension PhoneLoginViewController{
    
    /** **뒤로가기 버튼 클릭 > 로그인 절차 전단계 돌아가기 */
    @IBAction func returnBackBtnClicked(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        if nextBtn.tag == 0{
            self.navigationController?.popViewController(animated: false)
        }else{
            self.titleDescLabel.text = "가입했던 번호는 로그인으로\n새로운 번호는 회원가입으로 진행됩니다."
            self.nextBtn.setTitle("다음", for: .normal)
            self.passwordSeeBtn.isHidden = true
            self.passwordSearchBtn.isHidden = true
            self.textField.keyboardType = .numberPad
            self.errorLabel.text = " "
            self.titleLabel.text = "휴대폰번호 입력"
            self.textField.isSecureTextEntry = false
            self.textField.text = id
            self.textField.reloadInputViews()
            self.nextBtn.setTitle("다음", for: .normal)
            self.textInputChangeView.backgroundColor = UIColor(hexString: "#e0e0e0")
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
    
    /** **다음 버튼 클릭 > 로그인 절차 다음단계 가기 */
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        if sender.tag == 0{
            
            if self.textField.text?.isBlank == false{
                if self.textField.text!.isPhoneNumber == true{
                    id = textField.text!
                    LoginApi.shared.phoneAuth(phone: self.id, auth: "false", success: { result in
                        if result.code! == "200"{
                            //이미 가입한 회원
                            self.titleLabel.text = "로그인"
                            self.titleDescLabel.text = "비밀번호를 입력하세요"
                            self.passwordSeeBtn.isHidden = false
                            self.passwordSearchBtn.isHidden = false
                            self.textField.keyboardType = .default
                            self.errorLabel.text = " "
                            self.textField.isSecureTextEntry = true
                            self.nextBtn.setTitle("로그인", for: .normal)
                            self.textField.text = ""
                            self.textField.reloadInputViews()
                            self.textInputChangeView.backgroundColor = UIColor(hexString: "#e0e0e0")
                            sender.tag = 1
                        }else if result.code! == "100"{
                            //가입하지 않은 회원
                            let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "JoinViewController") as! JoinViewController
                            newViewController.id = self.id
                            self.navigationController?.pushViewController(newViewController, animated: false)
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
        }else{
            if self.textField.text?.isBlank == false{
                if self.textField.text!.isValidPassword == true{
                    //로그인 절차
                    self.password = textField.text!
                    LoginApi.shared.auth(id: self.id, password: self.password, success: { result in
                        if result.code! == "200"{
                            
                            header = ["Content-Type":"application/x-www-form-urlencoded","Authorization": "bearer \((result.results?.token)!)"]
                            multipartHeader = ["Content-Type":"multipart/form-data","Authorization": "bearer \((result.results?.token)!)"]
                            UserDefaultSetting.setUserDefaultsString((result.results?.token)!, forKey: sessionToken)
                            UserManager.shared.userInfo = result
                            if UserManager.shared.userInfo.results?.user_info_yn == "N"{
                                UserDefaultSetting.setUserDefaultsString(self.id, forKey: tempUserId)
                                UserDefaultSetting.setUserDefaultsString(self.password, forKey: tempUserPw)
                                let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoNickViewController") as! AddInfoNickViewController
                                UserDefaultSetting.setUserDefaultsString("P", forKey: loginGubun)
                                self.navigationController?.pushViewController(newViewController, animated: false)
                            }else{
                                UserDefaultSetting.setUserDefaultsString(self.id, forKey: userId)
                                UserDefaultSetting.setUserDefaultsString(self.password, forKey: userPw)
//                                let nextView = self.mainStoryboard.instantiateViewController(withIdentifier: "MainNavController")
                                let nextView = self.home2Storyboard.instantiateViewController(withIdentifier: "HomeMainViewNavController")
                                nextView.modalPresentationStyle = .fullScreen
                                launchViewHide = true
                                self.present(nextView, animated:false,completion: nil)
                            }
                        }else if result.code! == "102"{
                            self.errorLabelChange(errorMessage: isNoLoginPasswordString)
                        }else{
                            self.errorLabelChange(errorMessage: isNoLoginString)
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
    
    /** **비밀번호 찾기 버튼 클릭 > 뷰 이동 ( PasswordSearchViewController ) */
    @IBAction func passwordSearchBtnClicked(_ sender: UIButton) {
        let nextView = loginStoryboard.instantiateViewController(withIdentifier: "PasswordSearchViewController") as! PasswordSearchViewController
        nextView.id = self.id 
        self.navigationController?.pushViewController(nextView, animated: false)
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
    **파라미터가 있고 반환값이 없는 메소드 > 에러 라벨 출력
     
    - Parameters:
        - errorMessage: 에러 내용
        - errorColor: 에러 글자 색깔
     
    - Throws: `Error` 제스처가 아닌 경우 `Error`
    */
    func errorLabelChange(errorMessage:String){
        errorLabel.text = errorMessage
        textInputChangeView.backgroundColor = UIColor(named: "MainPoint_mainColor")//UIColor(hexString: errorColor)
    }
    
}
