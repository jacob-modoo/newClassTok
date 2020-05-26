//
//  AddInfoTagJobViewController.swift
//  modooClass
//
//  Created by 조현민 on 2019/11/04.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class AddInfoTagJobViewController: UIViewController {

    var jobList:JobModel?
    @IBOutlet var jobCollectionView: UICollectionView!
    
    /** **돌아가기 버튼 */
    @IBOutlet var retrunBackBtn: UIButton!
    /** **제목 라벨 */
    @IBOutlet var titleLabel: UILabel!
    /** **설명 라벨 */
    @IBOutlet var titleDescLabel: UILabel!
    /** **다음 버튼 */
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var progressBar: UIProgressView!
    
    let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    var nick = ""
    var gender = ""
    var birthYear = ""
    var interestArr:Array<Int> = []
    var checkSelect:Array<Bool> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        jobCollectionView.collectionViewLayout = layout
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)

        nextBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
        nextBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
        nextBtn.layer.borderWidth = 1
//        nextBtn.isUserInteractionEnabled = false
        LoginApi.shared.jobList(success: { result in
            
            if result.code! == "200"{
                self.jobList = result
                DispatchQueue.main.async {
                    self.jobCollectionView.reloadData()
                }
            }
        }) { error in
            Alert.With(self, title: "네트워크 오류가 발생했습니다.\n인터넷을 확인해주세요.", btn1Title: "확인", btn1Handler: {
                
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
        let newViewController = self.loginStoryboard.instantiateViewController(withIdentifier: "AddInfoPhotoViewController") as! AddInfoPhotoViewController
        newViewController.nick = self.nick
        newViewController.gender = self.gender
        newViewController.birthYear = self.birthYear
        newViewController.interestArr = self.interestArr
        var jobArr:Array<Int> = []
        for i in 0..<checkSelect.count {
            if checkSelect[i] == true{
                jobArr.append(self.jobList?.results?.job_list_arr[i].id ?? 0)
            }
        }
        newViewController.jobArr = jobArr
        if jobArr.count > 0{
            self.navigationController?.pushViewController(newViewController, animated: false)
        }else{
            Alert.With(self, title: "알림", content: "직업을 선택하지 않으셨습니다.", btn1Title: "확인", btn1Handler: {})
        }
    }
    
    @IBAction func tagClicked(_ sender: UIButton) {
        let tag = sender.tag
        
        let indexPath = IndexPath(item: tag, section: 0)
        let cell = jobCollectionView.cellForItem(at: indexPath) as! AddInfoTagJobCollectionViewCell
        
        if checkSelect[tag] == false{
            for i in 0..<checkSelect.count{
                if checkSelect[i] == true{
                    let indexPath = IndexPath(item: i, section: 0)
                    let cell = jobCollectionView.cellForItem(at: indexPath) as! AddInfoTagJobCollectionViewCell
                    cell.tagNameLbl.textColor = UIColor(named: "FontColor_subColor3")
                    checkSelect[i] = false
                }
            }
            checkSelect[tag] = true
            cell.tagNameLbl.textColor = UIColor(named: "FontColor_subColor1")
        }else{
            checkSelect[tag] = false
            cell.tagNameLbl.textColor = UIColor(named: "FontColor_subColor3")
        }
        
        var checkIndex = 0
        for i in 0..<checkSelect.count {
            if checkSelect[i] == true{
                checkIndex = checkIndex + 1
            }
        }
        if checkIndex > 0 {
            
            nextBtn.layer.borderColor = UIColor(hexString: "#ff5a5f").cgColor
            nextBtn.setTitleColor(UIColor(named:"MainPoint_mainColor"), for: .normal)
            nextBtn.layer.borderWidth = 1
//            nextBtn.isUserInteractionEnabled = true
        }else{
            nextBtn.layer.borderColor = UIColor(hexString: "#b4b4b4").cgColor
            nextBtn.setTitleColor(UIColor(named:"FontColor_subColor3"), for: .normal)
            nextBtn.layer.borderWidth = 1
//            nextBtn.isUserInteractionEnabled = false
        }
    }
}

extension AddInfoTagJobViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        checkSelect = Array(repeating: false, count: jobList?.results?.job_list_arr.count ?? 0)
        return jobList?.results?.job_list_arr.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row
        let cell:AddInfoTagJobCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddInfoTagJobCollectionViewCell", for: indexPath) as! AddInfoTagJobCollectionViewCell
        cell.tagNameLbl.text = "#\(jobList?.results?.job_list_arr[row].name ?? "")"
        cell.tagBtn.tag = row
        if checkSelect[row] == true{
            cell.tagNameLbl.textColor = UIColor(named: "FontColor_subColor1")
        }else{
            cell.tagNameLbl.textColor = UIColor(named: "FontColor_subColor3")
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension AddInfoTagJobViewController :UICollectionViewDelegateFlowLayout {
    
}
