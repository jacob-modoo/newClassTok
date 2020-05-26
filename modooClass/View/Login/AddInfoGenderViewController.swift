//
//  AddInfoGenderViewController.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/01.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class AddInfoGenderViewController: UIViewController {

    /** **돌아가기 버튼 */
    @IBOutlet var retrunBackBtn: UIButton!
    /** **제목 라벨 */
    @IBOutlet var titleLabel: UILabel!
    /** **설명 라벨 */
    @IBOutlet var titleDescLabel: UILabel!
    /** **다음 버튼 */
    @IBOutlet var genderWomenBtn: UIButton!
    @IBOutlet var genderManBtn: UIButton!
    @IBOutlet var progressBar: UIProgressView!
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    var nick = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)
        // Do any additional setup after loading the view.
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
        let tag = sender.tag
        var gender = "M"
        
        if tag == 1{
            gender = "W"
            genderWomenBtn.layer.borderColor = UIColor(hexString: "#ff5a5f").cgColor
            
            genderWomenBtn.setTitleColor(UIColor(named:"MainPoint_mainColor"), for: .normal)
            genderManBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
            genderManBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
        }else{
            gender = "M"
            genderManBtn.layer.borderColor = UIColor(hexString: "#ff5a5f").cgColor
            genderManBtn.setTitleColor(UIColor(named:"MainPoint_mainColor"), for: .normal)
            genderWomenBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
            genderWomenBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
        }
        
        let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoBirthViewController") as! AddInfoBirthViewController
        newViewController.nick = self.nick
        newViewController.gender = gender
        self.navigationController?.pushViewController(newViewController, animated: false)
        
    }

}
