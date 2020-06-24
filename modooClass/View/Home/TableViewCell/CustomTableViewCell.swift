//
//  CustomTableViewCell.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/05/19.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        return view
    }()
    
    lazy var settingImage: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var eventLbl: UILabel = {
        let eventLbl = UILabel(frame: CGRect(x: 20, y: self.frame.height/2, width: 180, height: 26))
        eventLbl.textColor = UIColor(hexString: "#707070")
        eventLbl.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        
        return eventLbl
    }()
    
    lazy var pointLbl: UILabel = {
        let pointLbl = UILabel(frame: CGRect(x: self.frame.width-75, y: self.frame.height/2, width: 120, height: 23))
        pointLbl.textColor = UIColor(hexString: "#FF5A5F")
        pointLbl.font = UIFont(name: "Apple SD Gothic Neo", size: 12)
        pointLbl.textAlignment = .center
    
        return pointLbl
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(settingImage)
        
        settingImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        settingImage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        settingImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        settingImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(eventLbl)
        
        eventLbl.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eventLbl.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        eventLbl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        eventLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(pointLbl)
        
        pointLbl.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        pointLbl.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        pointLbl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        pointLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        addSubview(backView)
//        backView.addSubview(settingImage)
//        backView.addSubview(eventLbl)
//        backView.addSubview(pointLbl)
//        // Configure the view for the selected state
//    }

}
