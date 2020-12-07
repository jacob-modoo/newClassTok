//
//  AddInfoTagViewController.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/01.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class AddInfoTagInterestViewController: UIViewController {

    var interestList:InterestModel?
    
    @IBOutlet var interestTableView: UITableView!
    
    /** **돌아가기 버튼 */
    @IBOutlet var retrunBackBtn: UIButton!
    /** **제목 라벨 */
    @IBOutlet var titleLabel: UILabel!
    /** **설명 라벨 */
    @IBOutlet var titleDescLabel: UILabel!
    /** **다음 버튼 */
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet var progressBar: UIProgressView!
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    var nick = ""
    var gender = ""
    var birthYear = ""
    var checkSelect:Array<Int> = []
    var collectionHeightArr:Array<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)
        nextBtn.layer.borderWidth = 1
        
        var collectionViewWidth = 0
        let superViewWidth = Int(self.view.frame.width - 40)
        var lineCount = 0
        
        LoginApi.shared.interestList(success: { result in
            if result.code! == "200"{
                self.interestList = result
                
                for i in 0..<(self.interestList?.results?.all_list_arr.count ?? 0){
                    for j in 0..<(self.interestList?.results?.all_list_arr[i].interest_list_arr.count ?? 0){
                        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 21))
                        label.textAlignment = .natural
                        label.text = "  # \(self.interestList?.results?.interest_list_arr[j].name ?? "")  "
                        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12.5)
                        label.sizeToFit()
                        label.translatesAutoresizingMaskIntoConstraints = true
                        collectionViewWidth = collectionViewWidth + Int(label.frame.width + 10)
                    }
                    
                    if collectionViewWidth/superViewWidth > 0{
                        lineCount = lineCount + collectionViewWidth/superViewWidth
                        if collectionViewWidth%superViewWidth > 0{
                            lineCount = lineCount + 1
                        }
                    }else{
                        if collectionViewWidth%superViewWidth > 0{
                            lineCount = lineCount + 1
                        }
                    }
                    
                    self.collectionHeightArr.append(lineCount)
                    collectionViewWidth = 0
                    lineCount = 0
                }
                
                DispatchQueue.main.async {
                    self.interestTableView.reloadData()
                    self.nextBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
                    self.nextBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
                    self.nextBtn.isUserInteractionEnabled = false
                }
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                print("Add info tag interestVC line 86")
            })
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
        let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoTagJobViewController") as! AddInfoTagJobViewController
        newViewController.nick = self.nick
        newViewController.gender = self.gender
        newViewController.birthYear = self.birthYear
//        var interestArr:Array<Int> = []
        if checkSelect.count == 3{
//            for i in 0..<checkSelect.count {
//                if checkSelect[i] == true{
//                    interestArr.append(self.interestList?.results?.interest_list_arr[i].id ?? 0)
//                }
//            }
            newViewController.interestArr = checkSelect
            self.navigationController?.pushViewController(newViewController, animated: false)
        }else{
            Alert.With(self, title: "알림", content: "관심사 3개를 선택하지 않으셨습니다.", btn1Title: "확인", btn1Handler: {})
        }
    }
    
    @IBAction func skipBtnClicked(_ sender: UIButton) {
        let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoTagJobViewController") as! AddInfoTagJobViewController
        newViewController.nick = self.nick
        newViewController.gender = self.gender
        newViewController.birthYear = self.birthYear
        let interestArr:Array<Int> = []
        newViewController.interestArr = interestArr
        self.navigationController?.pushViewController(newViewController, animated: false)
    }
    func checkCount(sender:UIButton){
        let tag = sender.tag
        let collectionTagCheck = tag/1000000
        let rowCheck = (tag%1000000) / 10000
        if self.interestList?.results?.all_list_arr[collectionTagCheck].interest_list_arr[rowCheck].selectCheck == true{
            sender.backgroundColor = UIColor.white
            sender.setTitleColor(UIColor(named: "MainPoint_mainColor"), for: .normal)
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor(named: "MainPoint_mainColor")?.cgColor
            sender.tag = tag+1
        }else{
            sender.backgroundColor = UIColor(named: "BackColor_mainColor")
            sender.setTitleColor(UIColor(named: "FontColor_subColor2"), for: .normal)
            sender.layer.borderWidth = 0
            sender.tag = tag-1
        }
    }
    
    @IBAction func tagClicked(_ sender: UIButton) {
        let tag = sender.tag
        let collectionTagCheck = tag/1000000
        let rowCheck = (tag%1000000) / 10000
        
        var checkId = false
        var checkArrayNumber = 100
        
        for i in 0..<checkSelect.count{
            if checkSelect[i] == self.interestList?.results?.all_list_arr[collectionTagCheck].interest_list_arr[rowCheck].id ?? 0{
                checkId = true
                checkArrayNumber = i
            }
        }
        
        if checkId == true{
            self.interestList?.results?.all_list_arr[collectionTagCheck].interest_list_arr[rowCheck].selectCheck = false
            checkCount(sender: sender)
            checkSelect.remove(at: checkArrayNumber)
        }else{
            if checkSelect.count < 3{
                self.interestList?.results?.all_list_arr[collectionTagCheck].interest_list_arr[rowCheck].selectCheck = true
                checkSelect.append(self.interestList?.results?.all_list_arr[collectionTagCheck].interest_list_arr[rowCheck].id ?? 0)
                checkCount(sender: sender)
            }else{
                Alert.WithInterestCheck(self, btn1Title: "확인", btn1Handler: {})
            }
        }
        
        if checkSelect.count > 0 {
            nextBtn.layer.borderColor = UIColor(hexString: "#ff5a5f").cgColor
            nextBtn.setTitleColor(UIColor(named:"MainPoint_mainColor"), for: .normal)
            nextBtn.layer.borderWidth = 1
            nextBtn.isUserInteractionEnabled = true
        }else{
            nextBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
            nextBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
            nextBtn.layer.borderWidth = 1
            nextBtn.isUserInteractionEnabled = false
        }
    }
    
}

extension AddInfoTagInterestViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collectionHeightArr.count > 0{
            return (collectionHeightArr.count * 2)
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let layout = LeftAlignedFlowLayout()
        
        if row%2 == 0{
            let cell:AddInfoTagInterestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddInfoTagInterestTitleTableViewCell", for: indexPath) as! AddInfoTagInterestTableViewCell
            cell.interestTitle.text = self.interestList?.results?.all_list_arr[row/2].name ?? ""
            cell.selectionStyle = .none
            return cell
        }else{
            let cell:AddInfoTagInterestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddInfoTagInterestListTableViewCell", for: indexPath) as! AddInfoTagInterestTableViewCell
            cell.collectionTag = row/2
            cell.interestList = self.interestList
            cell.interestCollectionView.reloadData()
            layout.estimatedItemSize = CGSize(width: 50, height: 40)
            cell.interestCollectionView.collectionViewLayout = layout
            cell.interestCollectionView.reloadData()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if row%2 == 0{
            return UITableView.automaticDimension
        }else{
            return CGFloat(collectionHeightArr[row/2]*40)
        }
    }
    
}
