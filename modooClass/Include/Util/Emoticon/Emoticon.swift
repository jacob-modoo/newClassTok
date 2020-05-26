//
//  Emoticon.swift
//  modooClass
//
//  Created by 조현민 on 28/08/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation

class EmoticonView : UIView, UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    var items = ["emti1.png", "emti2.png", "emti3.png", "emti4.png", "emti5.png", "emti6.png", "emti7.png", "emti8.png", "emti9.png", "emti10.png", "emti11.png", "emti12.png","emti13.png", "emti14.png", "emti15.png", "emti16.png", "emti17.png", "emti18.png", "emti19.png", "emti20.png", "emti21.png", "emti22.png", "emti23.png", "emti24.png"]
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        //If you set it false, you have to add constraints.
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        if let flowLayout = cv.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        let nib = UINib(nibName: "EmoticonCollectionViewCell", bundle: nil)
        cv.register(nib, forCellWithReuseIdentifier: "EmoticonCollectionViewCell")
        cv.backgroundColor = .white
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor(hexString: "#bdbdbd")
        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "#FF5A5F")
        return cv
    }()
    
    var pageControl: UIPageControl = UIPageControl()
    
    var emoticonBtnClick: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        addSubview(pageControl)
        
        //Add constraint
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        // perform the deinitialization
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {

        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if items.count % 12 == 0{
            pageControl.numberOfPages = items.count / 12
            return items.count / 12
        }else{
            pageControl.numberOfPages = (items.count / 12) + 1
            return (items.count / 12) + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:EmoticonCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmoticonCollectionViewCell", for: indexPath) as! EmoticonCollectionViewCell
        let section = indexPath.section
        if section == 0{
            cell.emoticonBtn.tag = indexPath.item
            cell.emoticonImg.image = UIImage(named: "\(items[indexPath.item])")
            cell.emoticonBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            cell.backgroundColor = .white
        }else{
            cell.emoticonBtn.tag = indexPath.item+(section*12)
            cell.emoticonImg.image = UIImage(named: "\(items[indexPath.item+(section*12)])")
            cell.emoticonBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width/4, height: self.collectionView.frame.size.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0 , bottom: 0.0, right: 0.0)
    }
    
    //위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //옆 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if self.emoticonBtnClick != nil {
            self.emoticonBtnClick!(sender.tag)
        }
    }
    
    func WithEmoticon(btn1Handler: @escaping (Int) -> Void) {
        self.emoticonBtnClick = btn1Handler
    }
    
}
