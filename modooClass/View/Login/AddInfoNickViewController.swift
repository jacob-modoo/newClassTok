//
//  AddInformationViewController.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/01.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class AddInfoNickViewController: UIViewController ,UITextFieldDelegate, UIGestureRecognizerDelegate{

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
    /** **텍스트 입력시 색 변화 뷰 */
    @IBOutlet var textInputChangeView: UIView!
    /** **다음 버튼 */
    @IBOutlet var nextBtn: UIButton!
    
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet var progressBar: UIProgressView!
    
    var nickname = ""
    
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)
        retrunBackBtn.isHidden = true

        textField.text = UserManager.shared.userInfo.results?.user?.nickname ?? ""
        checkTextField()
        Alert.WithInfoWriteStart(self, btn1Title: "", btn1Handler: {
            self.textField.becomeFirstResponder()
        })
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
    }
    
    /** **뷰가 나타나고 타는 메소드 */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @IBAction func returnBackBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    /** **다음 버튼 클릭 > 로그인 절차 다음단계 가기 */
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        if textField.isValid(name: textField.text!){
            let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoGenderViewController") as! AddInfoGenderViewController
            newViewController.nick = textField.text ?? ""
            self.navigationController?.pushViewController(newViewController, animated: false)
        }else{
            Alert.With(self, title: "이모지가 포함되어있습니다.", btn1Title: "확인", btn1Handler: {})
        }
    }
    
    @IBAction func skipBtnClicked(_ sender: UIButton) {
        let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoGenderViewController") as! AddInfoGenderViewController
        newViewController.nick = self.nickname
        self.navigationController?.pushViewController(newViewController, animated: false)
    }
    
    
    /** **텍스트필드 변경 > 텍스트 필드에 변경이 일어남 처리 */
    @IBAction func textFieldChange(_ sender: UITextField) {
        checkTextField()
    }
    
    func checkTextField() {
        if textField.text?.isEmpty == true{
            textInputChangeView.backgroundColor = UIColor(hexString: "#e0e0e0")
            errorLabel.text = " "
            nextBtn.layer.borderWidth = 1
            nextBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
            nextBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
            nextBtn.isUserInteractionEnabled = false
        }else{
            nextBtn.layer.borderWidth = 1
            nextBtn.layer.borderColor = UIColor(hexString: "#ff5a5f").cgColor
            nextBtn.setTitleColor(UIColor(named:"MainPoint_mainColor"), for: .normal)
            nextBtn.isUserInteractionEnabled = true
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
