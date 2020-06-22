//
//  FeedbackSearchTextField.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/06/05.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

class FeedbackSearchTextField: UITextField {
    
    var tableView: UITableView?
    var autoSearchList:AutoSearchModel?
    var autoSearchList_arr:Array = Array<DataList>()
    
//    Connecting the new element to the parent view
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.addTarget(self, action: #selector(FeedbackSearchTextField.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(FeedbackSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(FeedbackSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(FeedbackSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTableView()
    }
    
//    TextField related methods
    @objc open func textFieldDidChange(){
        print("Text changed ...")
        tableView?.isHidden = false
        getSuggestion(key: self.text ?? "")
        updateSearchTableView()
        
    }
    
    @objc open func textFieldDidBeginEditing() {
        print("Begin Editing")
    }
    
    @objc open func textFieldDidEndEditing() {
        print("End editing")

    }
    
    @objc open func textFieldDidEndEditingOnExit() {
        print("End on Exit")
    }
    
//    API post method to get suggestions
    func getSuggestion(key: String){
        FeedApi.shared.autoCompleteSearch(keyword: key, success: { [unowned self] result in
            if result.code! == "200"{
                print("API posting success!")
                self.autoSearchList = result
                for addArray in 0..<(self.autoSearchList?.results?.data_list_arr.count ?? 0)! {
                    self.autoSearchList_arr.append((self.autoSearchList?.results?.data_list_arr[addArray])!)
                }
                DispatchQueue.main.async {
                    self.tableView?.isHidden = false
                    
//                    tableSearchView.lbl.text =   // api dan keladigon javobga
//                    self.endOfWork()
//                    Indicator.hideActivityIndicator(uiView: self.view)
                    print("dispatch success")
                    self.tableView?.reloadData()
                }
            }else{
                
            }
        }) { error in
            print(error ?? "Error occured in calling AutoSearch API")
        }
    }
    
    
}

// MARK: TableView related methods

extension FeedbackSearchTextField: UITableViewDelegate, UITableViewDataSource {
    
//    Implementing SearchTableView
    func buildSearchTableView() {
//        if let tableView = tableView {
        let tableView = UITableView(frame: CGRect(x: 0, y: 44, width: 320, height: 120))
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
//        window?.addSubview(tableView)
//        } else {
//            tableView = UITableView(frame: .zero)
//        }
        updateSearchTableView()
    }
    
//    Updating SearchTableView
    func updateSearchTableView() {
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            
            tableView.reloadData()
        }
    }
    
//  MARK: TableViewDataSource methods
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.autoSearchList_arr.count)
        return self.autoSearchList_arr.count
    }
    
//  MARK: TableViewDelegate methods
    
    //Adding rows in the tableview with the data from dataList

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        cell.textLabel?.text = self.autoSearchList?.results?.data_list_arr[indexPath.row].key
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row")
        self.text = self.autoSearchList?.results?.data_list_arr[indexPath.row].key
        tableView.isHidden = true
        self.endEditing(true)
    }
  
}
