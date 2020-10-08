//
//  AddInfoBirthViewController.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/01.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class AddInfoBirthViewController: UIViewController {

    /** **돌아가기 버튼 */
    @IBOutlet var retrunBackBtn: UIButton!
    /** **제목 라벨 */
    @IBOutlet var titleLabel: UILabel!
    /** **설명 라벨 */
    @IBOutlet var titleDescLabel: UILabel!
    /** **다음 버튼 */
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    /** **텍스트필드 */
    @IBOutlet var textField: UITextField!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var textInputChangeView:UIView!
    
    @IBOutlet var pickerView: UIPickerView!
    private var values: [String] = []
    
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    var nick = ""
    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        
        nextBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
        nextBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
        nextBtn.isUserInteractionEnabled = false
        nextBtn.layer.borderWidth = 1
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)
        DispatchQueue.main.async {
            self.pickerView?.selectRow(15, inComponent: 0, animated: true)
        }
        
    }
    
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        let date = Date()
        var formattedDate: String? = ""

        let format = DateFormatter()
        format.dateFormat = "yyyy"
        formattedDate = format.string(from: date)

        var yearsTillNow: [String] {
            var years = [String]()
            for i in (Int(formattedDate!)!-79..<Int(formattedDate!)!-13).reversed() {
                years.append("\(i)년")
            }
            return years
        }
        values = yearsTillNow
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
        let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoTagInterestViewController") as! AddInfoTagInterestViewController
        newViewController.nick = self.nick
        newViewController.gender = self.gender
        newViewController.birthYear = self.textField.text?.replace(target: "년", withString: "") ?? ""
        self.navigationController?.pushViewController(newViewController, animated: false)
    }
    
    @IBAction func skipBtnClicked(_ sender: UIButton) {
        let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoTagInterestViewController") as! AddInfoTagInterestViewController
        newViewController.nick = self.nick
        newViewController.gender = self.gender
        newViewController.birthYear = self.textField.text?.replace(target: "년", withString: "") ?? ""
        self.navigationController?.pushViewController(newViewController, animated: false)
    }
    
}

extension AddInfoBirthViewController : UIPickerViewDelegate, UIPickerViewDataSource ,UIScrollViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        nextBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
        nextBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
        nextBtn.layer.borderWidth = 1
        nextBtn.isUserInteractionEnabled = false
        return values[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = "\(values[row])"
        nextBtn.layer.borderColor = UIColor(hexString: "#ff5a5f").cgColor
        nextBtn.setTitleColor(UIColor(named:"MainPoint_mainColor"), for: .normal)
        nextBtn.layer.borderWidth = 1
        nextBtn.isUserInteractionEnabled = true
    }
    
}
