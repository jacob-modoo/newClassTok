//
//  FirstStartViewController.swift
//  modooClass
//
//  Created by 조현민 on 25/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

/**
# FirstStartViewController.swift 클래스 설명
 
## UIViewController 상속 받음
- 앱 처음 깔고 시작 했을시 타는 뷰컨트롤러
*/
class FirstStartViewController: UIViewController {
    /** **백그라운드 버튼 */
    @IBOutlet var backgroundStartBtn: UIButton!
    
    /** **제목 라벨 */
    @IBOutlet var titleLbl: UIFixedLabel!
    
    /** **뷰 로드 완료시 타는 메소드 */
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundStartBtn.isHidden = false
        let scale: CGFloat = DEF_WIDTH_375_SCALE
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        let text = titleLbl.text ?? ""
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "MainPoint_mainColor") ?? UIColor(hexString: "#FF5A5F"), range: (text as NSString).range(of:"."))
        titleLbl.attributedText = attributedString
    }
    
}

extension FirstStartViewController{
    
    /** **스타트 버튼 클릭 */
    @IBAction func backgroundStartBtnClicked(_ sender: UIButton) {
        viewMove(StoryBoard:"Login",StoryBoardName:"LoginNavViewController")
    }
    
    
    /**
    **파라미터가 있고 반환값이 없는 메소드 > 뷰 애니메이션을 하기 위한 함수
     
    - Parameters:
        - storyBoard: 스토리보드
        - storyBoardName: 스토리보드 명
     
    - Throws: `Error` 잘못된 스토리보드 이거나 이름이 정확하지 않을시 `Error`
    */
    func viewMove(StoryBoard:String,StoryBoardName:String){
        let storyboard: UIStoryboard = UIStoryboard(name: StoryBoard, bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: StoryBoardName)
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView, animated:false,completion: nil)
    }
    
}
