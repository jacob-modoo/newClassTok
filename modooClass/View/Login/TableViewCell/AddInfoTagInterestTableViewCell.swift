//
//  AddInfoTagInterestTableViewCell.swift
//  modooClass
//
//  Created by 조현민 on 2019/12/06.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class AddInfoTagInterestTableViewCell: UITableViewCell {
    
    @IBOutlet var interestTitle: UIFixedLabel!
    @IBOutlet var interestCollectionView: UICollectionView!
    var interestList:InterestModel?
    var interest_list_arr:Array = Array<Interest_list>()
    var collectionTag = 100
    var checkSelect:Array<Int> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension AddInfoTagInterestTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        checkSelect = Array(repeating: false, count: interestList?.results?.interest_list_arr.count ?? 0)
        return (interestList?.results?.all_list_arr[collectionTag].interest_list_arr.count ?? 0)!
//        return interest_list_arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row
        let cell:AddInfoTagInterestCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddInfoTagInterestCollectionViewCell", for: indexPath) as! AddInfoTagInterestCollectionViewCell
        
        cell.tagNameLbl.isHidden = true
        
        cell.tagBtn.setTitle("  # \(interestList?.results?.all_list_arr[collectionTag].interest_list_arr[row].name ?? "")  ", for: .normal)
        cell.tagBtn.backgroundColor = UIColor(named: "BackColor_mainColor")
        cell.tagBtn.tag = (collectionTag * 1000000) + (row * 10000) + 1
        
        if interestList?.results?.all_list_arr[collectionTag].interest_list_arr[row].selectCheck == true{
            cell.tagBtn.backgroundColor = UIColor.white
            cell.tagBtn.setTitleColor(UIColor(named: "MainPoint_mainColor"), for: .normal)
            cell.tagBtn.layer.borderWidth = 1
            cell.tagBtn.layer.borderColor = UIColor(named: "MainPoint_mainColor")?.cgColor
        }else{
            cell.tagBtn.backgroundColor = UIColor(named: "BackColor_mainColor")
            cell.tagBtn.setTitleColor(UIColor(named: "FontColor_subColor2"), for: .normal)
            
            cell.tagBtn.layer.borderWidth = 0
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension AddInfoTagInterestTableViewCell :UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0 , bottom: 0.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
