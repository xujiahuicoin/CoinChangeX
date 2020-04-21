//
//  BaseTableView.swift
//  Project
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit

class XJHBaseTableView: XJHBaseView,UITableViewDelegate,UITableViewDataSource {

    var datas = [Any]()
    var tableView : UITableView?
  
    
//    重写父类初始化方法
    override class func view() -> Self! {
        
        let instance = self.init()
        instance.makeTableView(frame: CGRect.zero, style: .plain)
        instance.initXJHView()
        
        return instance
    }
    
    override class func view(parmas : ViewDataObject) -> Self! {
        
        let instance = self.init()
        instance.makeTableView(frame: CGRect.zero, style: .plain)
        instance.initXJHView(parmas: parmas)
        return instance
    }
    
  

//    初始化方法
    class func view(style : UITableView.Style) -> XJHBaseTableView {
        
        let instance = self.init()
        instance.makeTableView(frame: CGRect.zero, style: style)
        instance.initXJHView()
        return instance
    }
    
    class func view(parmas : ViewDataObject, style : UITableView.Style) -> XJHBaseTableView {
        
        let instance = self.init()
        instance.makeTableView(frame: CGRect.zero, style: style)
        instance.initXJHView(parmas: parmas)
        return instance
    }
    
    func tCreateErrorView(_ error: XJHError, showErrorMessage: Bool = true, errorMessage: String? = nil) {
        
        if self.datas.count == 0 {
            super.createErrorView(error, showErrorMessage: showErrorMessage)
        }else {
            
            if showErrorMessage == true {
                if errorMessage == nil {
                    XJHProgressHUD.showError(message: error.localizedDescription)
                }else {
                    XJHProgressHUD.showError(message: errorMessage!)
                }
            }
        }
        
        self.endRefresh()
    }

//    创建tableView
    func makeTableView(frame : CGRect, style : UITableView.Style) {
        
        self.tableView = UITableView(frame: frame, style: style)
        self.tableView?.backgroundColor = XJHBackgroundColor_dark
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.keyboardDismissMode = .onDrag
        self.tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tableView?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.addSubview(self.tableView!)
        
       
//        if #available(iOS 11.0, *){
//            self.tableView?.contentInsetAdjustmentBehavior = .never
//        }
        
        self.tableView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
//    默认更新tableView方法
    func xjh_updateTableView(datas : Array<Any>) {
        
        self.datas = datas
        
        DispatchQueue.main.async {
            self.xjh_hiddenHud()
            self.tableView?.reloadData()
        }
        
        self.endRefresh()
    }
    
    func xjh_addDownPullToRefresh() {
        
        self.tableView?.es.addPullToRefresh {
            
            self.sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: xjh_PullDown, params: nil, uiView: self))
        }
    }
    
    func xjh_addUpPullToRefresh() {
        
        self.tableView?.es.addInfiniteScrolling {
            
            self.sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: xjh_PullUp, params: nil, uiView: self))
        }
    }
    
    func endRefresh() {
        
        if self.tableView?.header?.isRefreshing == true {
            self.tableView?.header?.stopRefreshing()
        }
        
        if self.tableView?.footer?.isRefreshing == true {
            self.tableView?.footer?.stopRefreshing()
        }
    }
    
//    UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = XJHBaseTableViewCell()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
    }
}
