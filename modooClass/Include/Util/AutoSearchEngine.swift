//
//  AutoSearchEngine.swift
//  AutoSearchEngine
//
//  Created by John on 22/06/20.
//  Copyright © 2020 iOS|Dev. All rights reserved.
//

import UIKit

class AutoSearchEngine: UIView {

    // Data source for show DropDown.
    public var dataSource : [String] = [String]()
    // Textfield for DropDown to show.
    public var onTextField : UITextField!
    // Completion Block For Selection in DropDown.
    public var completionHandler: CompletionHandler?
    // TableView For DropDown.
    var tableView : UITableView?
    public var dropDownHeight : CGFloat?
    // Parents View for Show DropDown.
    public var onView : UIView!
//    public var indexPath : IndexPath?
    private var isMultiLine  = false
    // Cell Height for DropDown
    public var cellHeight : CGFloat!
    // Make Searched Text Bold Or Not.
    public var isSearchBig = true
    
    public var showAlwaysOnTop = false

    private var isOnTop = false
    
 
    // Completion BLock.
    typealias CompletionHandler = (_ text: String , _ index : Int) -> Void
    
    // Override Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        // SetUp View
        self.setUp()
        
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Show DropDown.(Add DropDown)
    /********** For Show DropDown for View And get selection in
     completion block.***********/
    public func show(completionHandler: @escaping CompletionHandler){

        self.tableView?.frame = CGRect(x: 0, y: 0, width: onTextField.frame.width, height: 150)
        self.frame = CGRect(x: 0, y: 0, width: onTextField.frame.width, height: 150)
        
        self.addSubview(tableView!)
        self.onView?.addSubview(self)
        
        self.alpha = 0
        self.isHidden = true
        
        self.tableView?.alpha = 0
        self.tableView?.isHidden = true
        
        
        if onTextField.text?.count != 0 {
            isShowView(is_show: true)
            self.tableView?.reloadData()
        } else {
            isShowView(is_show: false)
            self.tableView?.reloadData()
        }
        
        self.completionHandler = completionHandler
        
    }
    
    // MARK: - SetUp View
    
    private func setUp(){
        self.tableView = UITableView()
        self.tableView?.register(UINib(nibName: "AutoSearchEngineCell", bundle: nil), forCellReuseIdentifier: "AutoSearchEngineCell")
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        
        self.tableView?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.tableView?.layer.cornerRadius = 10
        self.tableView?.clipsToBounds = true

        self.clipsToBounds = true
        self.cellHeight = 44
        self.addShadow(customView: self)
    }
    
    // Shadow for DropDown
    public func addShadow(customView: UIView){
//        customView.clipsToBounds = true
        customView.layer.shadowColor = UIColor(hexString: "#efefef").cgColor // UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        customView.layer.shadowOffset = CGSize(width: 0.5, height: 2)
        customView.layer.shadowOpacity = 1.0
        customView.layer.shadowRadius = 2.0
        customView.layer.masksToBounds = false
    }
    
    func isShowView(is_show : Bool){

        if is_show {
            self.alpha = 0
            self.isHidden = false
            
            self.tableView?.alpha = 0
            self.tableView?.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
                self.tableView?.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView?.alpha = 0
                self.alpha = 0
            }) { finished in
                self.tableView?.isHidden = finished
                self.isHidden = finished
            }
        }
    }
    
    func changeHeightForCount(count: Int){
        if cellHeight == nil {
            return
        }
        var newFrame = UIScreen.main.bounds
        newFrame.size.height = cellHeight * CGFloat(count)
        if isOnTop {
            newFrame.origin.y = self.frame.maxY - newFrame.size.height
        }
        self.frame = newFrame
        self.tableView?.frame = CGRect(x: 0, y: 0, width: newFrame.width, height: newFrame.height)
        self.tableView?.separatorStyle = .none
        print("self frame :\(self.frame)")
        self.setNeedsLayout()
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#484848")]
        let range = (string as NSString).range(of: boldString, options: .caseInsensitive)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    /** the hitTest method is used to make likeCountBtn to be visible even out of bounds of its parent view***/
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view != self {
//            return view
            print("view is not onVIEW@@@!")
            return overlapHitTest(point: point, withEvent: event)
        } else {
            print("the view is onview---!")
            return view
        }
    }
}


// MARK: - TableView Delegate.

extension AutoSearchEngine : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !isMultiLine {
            return cellHeight
        }
        
        let selectedStr = dataSource[indexPath.row]
        return selectedStr.height(constraintedWidth: self.onTextField.frame.width, font: self.onTextField.font!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStr = dataSource[indexPath.row]
        let selectedIndex = indexPath.row
        self.completionHandler!(selectedStr, selectedIndex)
        self.isShowView(is_show: false)
    }
}

// MARK: - TableView DataSource.

extension AutoSearchEngine : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.changeHeightForCount(count:self.dataSource.count)
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoSearchEngineCell") as! AutoSearchEngineCell
        cell.selectionStyle = .none
        cell.lblTitle.text = dataSource[indexPath.row]
        
        if isSearchBig {
            let formattedString = self.attributedText(withString: cell.lblTitle.text!, boldString: onTextField.text!, font: onTextField.font!)
            cell.lblTitle.attributedText = formattedString
        }
        return cell
    }
}

extension AutoSearchEngine {
    
    func heightForLabel(text:String) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x:0, y: 0, width: self.onTextField.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.onTextField.font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height + 20
    }
}

// MARK: - Height for text.
extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height + 30
    }
}

