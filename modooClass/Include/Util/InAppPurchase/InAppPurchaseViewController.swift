//
//  InAppPurchaseViewController.swift
//  modooClass
//
//  Created by 조현민 on 31/10/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class InAppPurchaseViewController: UIViewController {

    var class_id = 0
    var package_id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    /** **뷰가 나타나기 시작 할 때 타는 메소드 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /** **뷰가 사라지기 시작 할 때 타는 메소드 */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /** **뷰가 나타나고 타는 메소드 */
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
    @IBAction func purchaseBtnClicked(_ sender: UIButton) {
        let tag = sender.tag
        var iap_id = "0_won_modoo"
        if tag == 0{
            iap_id = "4900_won_modoo"
        }else if tag == 1{
            iap_id = "9900_won_modoo"
        }else if tag == 2{
            iap_id = "29000_won_modoo"
        }else if tag == 3{
            iap_id = "49000_won_modoo"
        }else if tag == 4{
            iap_id = "99000_won_modoo"
        }else{
            iap_id = "0_won_modoo"
        }
        
        if iap_id != "0_won_modoo"{
            Indicator.showActivityIndicator(uiView: self.view)
            InAppPurchase.sharedInstance.buyUnlockTestInAppPurchase1(productId:iap_id,class_id:class_id,package_id:package_id)
        }else{
            Alert.With(self, title: "잘못된 경로 입니다.", btn1Title: "확인", btn1Handler: {
                
            })
        }
    }
}

extension InAppPurchaseViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            let cell:InAppPurchaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InAppPurchaseTitleCell", for: indexPath) as! InAppPurchaseTableViewCell
            
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell:InAppPurchaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InAppPurchaseContentCell", for: indexPath) as! InAppPurchaseTableViewCell
            if row == 0{
                cell.purchasePointLbl.text = "4,900 포인트"
                cell.purchaseBtn.tag = 0
            }else if row == 1{
                cell.purchasePointLbl.text = "9,900 포인트"
                cell.purchaseBtn.tag = 1
            }else if row == 2{
                cell.purchasePointLbl.text = "29,000 포인트"
                cell.purchaseBtn.tag = 2
            }else if row == 3{
                cell.purchasePointLbl.text = "49,000 포인트"
                cell.purchaseBtn.tag = 3
            }else if row == 4{
                cell.purchasePointLbl.text = "99,000 포인트"
                cell.purchaseBtn.tag = 4
            }else{
                cell.purchasePointLbl.text = "0 포인트"
                cell.purchaseBtn.tag = 100000
            }
            cell.selectionStyle = .none
            return cell
        default:
            let cell:InAppPurchaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "InAppPurchaseTitleCell", for: indexPath) as! InAppPurchaseTableViewCell
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}
