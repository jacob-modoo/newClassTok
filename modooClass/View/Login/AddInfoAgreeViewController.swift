//
//  AddInfoAgreeViewController.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/01.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit


class AddInfoAgreeViewController: UIViewController {

    /** **돌아가기 버튼 */
    @IBOutlet var retrunBackBtn: UIButton!
    /** **제목 라벨 */
    @IBOutlet var titleLabel: UILabel!
    /** **설명 라벨 */
    @IBOutlet var titleDescLabel: UILabel!
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var completeView: UIView!
    @IBOutlet var agreeStage: UILabel!
    
    var nick = ""
    var gender = ""
    var birthYear = ""
    var interestArr:Array<Int> = []
    var jobArr:Array<Int> = []
    var photo1:UIImage = UIImage()
    var photo2:UIImage = UIImage()
    var photo3:UIImage = UIImage()
    var sampleNumbering:Array<Int> = [0,0,0]
    var introWord = ""
    var checkIndex = 1
    var checkBool:Array<Bool> = [true,false,false,false]
    
    let home2Storyboard: UIStoryboard = UIStoryboard(name: "Home2WebView", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)
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
    
    @IBAction func agreeCheckBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        let indexPath = IndexPath(row: 0, section: tag)
        let cell = tableView.cellForRow(at: indexPath) as! AddInfoAgreeTableViewCell
        
        if sender.tag == 0{
            progressBar.progress = 1
            cell.agreeCheckImg.image = UIImage(named: "agreeCheckActive")
            mainViewMove()
        }else{
            sender.isUserInteractionEnabled = false
            checkBool[checkIndex] = true
            tableView.reloadSections([tag-1], with: .automatic)
            checkIndex = checkIndex + 1
            cell.agreeCheckImg.image = UIImage(named: "agreeCheckActive")
            agreeStage.text = "\(checkIndex)/4"
        }
        
    }
    
    func mainViewMove(){
        var url_1 = ""
        var url_2 = ""
        var url_3 = ""
        if sampleNumbering[0] != 0{
            url_1 = "\(sampleNumbering[0])"
        }
        if sampleNumbering[1] != 0{
            url_2 = "\(sampleNumbering[1])"
        }
        if sampleNumbering[2] != 0{
            url_3 = "\(sampleNumbering[2])"
        }
        self.completeView.isHidden = true
        Indicator.showActivityIndicator(uiView: self.view)
        LoginApi.shared.profileAddSave(nickname: self.nick, gender: self.gender, birthday_year: self.birthYear, mcInterest_id: self.interestArr, mcJob_id: self.jobArr, url_1: url_1, url_2: url_2, url_3: url_3, file_1: self.photo1, file_2: self.photo2, file_3: self.photo3,profile_comment: introWord, success: { result in
            if result.code! == "200"{
                self.loginCheck()
            }else{
                Alert.With(self, title: "네트워크 오류가 발생하였습니다.", btn1Title: "확인", btn1Handler: {
                    self.completeView.isHidden = true
                    Indicator.hideActivityIndicator(uiView: self.view)
                })
            }
        }) { error in
            Indicator.hideActivityIndicator(uiView: self.view)
            Alert.With(self, title: "네트워크 오류가 발생하였습니다.", btn1Title: "확인", btn1Handler: {
                self.completeView.isHidden = true

            })
            print("error : \(String(describing: error?.localizedDescription))")
        }
    }
    
    func loginCheck(){
        let idCheck = "\(UserDefaultSetting.getUserDefaultsString(forKey: tempUserId) ?? "")"
        let providerCheck = "\(UserDefaultSetting.getUserDefaultsString(forKey: tempUserProvider) ?? "")"
        let pwCheck = "\(UserDefaultSetting.getUserDefaultsString(forKey: tempUserPw) ?? "")"
        let nameCheck = "\(UserDefaultSetting.getUserDefaultsString(forKey: tempUserName) ?? "")"
        let loginGubunCheck = UserDefaultSetting.getUserDefaultsString(forKey: loginGubun) ?? ""
//        let loginSort = "\(UserDefaultSetting.getUserDefaultsString(forKey: loginGubun) ?? "")"
        UserDefaultSetting.setUserDefaultsString(idCheck, forKey: userId)
        UserDefaultSetting.setUserDefaultsString(nameCheck, forKey: userName)
        if  loginGubunCheck as? String == "S"{
            UserDefaultSetting.setUserDefaultsString(providerCheck, forKey: userProvider)
        }
        UserDefaultSetting.setUserDefaultsString(pwCheck, forKey: userPw)
        
        UserManager.shared.userInfo.results?.user?.nickname = self.nick
        UserManager.shared.userInfo.results?.user?.birthday_year = self.birthYear
        
        let time = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: time) {
            UserDefaultSetting.setUserDefaultsBool(true, forKey: lodingViewCheck)
            Indicator.hideActivityIndicator(uiView: self.view)
            UserManager.shared.userInfo.results?.user?.nickname = self.nick
//            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let nextView = storyboard.instantiateViewController(withIdentifier: "MainNavController")
            let nextView = self.home2Storyboard.instantiateViewController(withIdentifier: "HomeMainViewNavController")
            launchViewHide = true
            nextView.modalPresentationStyle = .fullScreen
            self.present(nextView, animated:false,completion: nil)
        }
        
    }
}

extension AddInfoAgreeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 0
        switch section {
        case 0:
            if checkBool[3] == true{
                numberOfRow = 1
            }else{
                numberOfRow = 0
            }
        case 1:
            if checkBool[2] == true{
                numberOfRow = 1
            }else{
                numberOfRow = 0
            }
        case 2:
            if checkBool[1] == true{
                numberOfRow = 1
            }else{
                numberOfRow = 0
            }
        case 3:
            if checkBool[0] == true{
                numberOfRow = 1
            }else{
                numberOfRow = 0
            }
        default:
            numberOfRow = 0
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell:AddInfoAgreeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddInfoAgreeTableViewCell", for: indexPath) as! AddInfoAgreeTableViewCell
        cell.agreeView.layer.borderColor = UIColor(named: "FontColor_subColor3")?.cgColor
        cell.agreeView.layer.borderWidth = 0.5
        cell.agreeView.layer.cornerRadius = 10
        if section == 0{
            cell.agreeTitle.text = "넷. 당신이 있어 감사합니다. "
            cell.agreeContent.text = "혼자보다는 둘, 둘보다는 우리가 함께하기에 성장할 수 있습니다. 클래스톡과 함께할 당신을 환영합니다. 지금 바로 시작해보세요."
            cell.agreeCheckBtn.tag = 0
        }else if section == 1{
            cell.agreeTitle.text = "셋. 우리는 포기하지 않습니다. "
            cell.agreeContent.text = "뛰다가 넘어질 수 도있고 뛰다가 지치면 걸을 수도 있습니다. 오늘이 아닌 내일로 미루더라도 결코 포기하지 않으며, 서로를 응원합니다."
            cell.agreeCheckBtn.tag = 1
        }else if section == 2{
            cell.agreeTitle.text = "둘. 우리는 다름을 인정하고 존중합니다. "
            cell.agreeContent.text = "클래스의 목적은 같지만 시작하게된 계기, 삶의 환경, 재능의 특별함이 다릅니다. 활동 과정에서 보이는 서로의 특별함을 인정하고 존중합니다."
            cell.agreeCheckBtn.tag = 2
        }else{
            cell.agreeTitle.text = "하나. 우리는 서로를 응원하고 격려합니다."
            cell.agreeContent.text = "클래스 활동은 단순히 습득하고 익히는 자기계발 과정을 넘어 삶의 성장에 있습니다. 혼자라서 지치고 약해질때 우리는 서로를 응원하고 격려합니다. "
            cell.agreeCheckBtn.tag = 3
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
}
