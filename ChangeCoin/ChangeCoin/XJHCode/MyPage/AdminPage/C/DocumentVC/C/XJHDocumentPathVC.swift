//
//  XJHDocumentPathVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/18.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJHDocumentPathVC: XJHBaseViewController {
 
    
    var titleStr : String = "文档目录"
    var documentPath : String = XJH_GitServerPathRoot()
    ///是否为根目录：有管理员文档-只能做修改操作
    var rootPage : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = titleStr
        
        xjh_CreatUI()
        xjh_LoadDocumentPathData()
        
        if !rootPage {
            xjh_createRightButtonItem(title: "添加用户", target: self, action: #selector(xjh_CreatNewUserFile))
        }
        
        //加载所支持的交易对信息
//        XJH_UserDataTool.XJH_LoadWholeChangeCoinsData()
    }
    
    
    func xjh_LoadDocumentPathData(){
        
        xjh_HUDShow()
        XJH_GitHub.GitHubProjectPathdict(pathUrl: documentPath, blockSuccess: { (mods) in
            self.xjh_hideHUD()
            if mods.count > 0 {
                self.documentPathTV.tableView?.set(loadType: .normal)
            }else{
                self.documentPathTV.tableView?.set(loadType: .noData)
            }
            
            self.documentPathTV.xjh_updateTableView(datas: mods)
            
        }) { (errs) in
            self.xjh_hideHUD()
            self.xjh_showProgress_Text(text: errs.message, view: self.view)
            self.documentPathTV.tableView?.set(loadType: .noData)
            self.documentPathTV.endRefresh()
        }
        
    }
    
    //--------------点击事件----------------------
    //新创建用户文件
    @objc func xjh_CreatNewUserFile(){
        
        //         let sub:XJHFileViewController = XJHFileViewController()
        //         sub.fileRootPage = self.rootPage
        //         sub.creatFile = true
        //          self.navigationController?.pushViewController(sub, animated: true)
        let sub:XJHXJHFileFormVC = XJHXJHFileFormVC()
        sub.creatform = true
        self.navigationController?.pushViewController(sub, animated: true)
    }
    
    override func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
       
        if eventObject.event_CodeType == xjh_PullDown {
                   //刷新列表
                   xjh_LoadDocumentPathData()
                   
               }else if eventObject.event_CodeType == OkexPageAction.xjh_documentPathClick.rawValue {
            let mod:XJh_GithubProjectContentsModel = eventObject.params as! XJh_GithubProjectContentsModel
            
            //判断是文件还是文本
            if mod.type == "file" {
                //
                //                let sub:XJHFileViewController = XJHFileViewController()
                //                sub.fileRootPage = self.rootPage
                //                sub.mod = mod
                //                self.navigationController?.pushViewController(sub, animated: true)
                
                if  rootPage && mod.name.contains("admin") {
                    //管理用户文件
                    let sub = XJHUserListVC()
                    
                    self.navigationController?.pushViewController(sub, animated: true)

                }else{
                    let sub:XJHXJHFileFormVC = XJHXJHFileFormVC()
                    sub.titleStr = mod.name
                    sub.fileModel = mod
                    
                    self.navigationController?.pushViewController(sub, animated: true)
                }
                
            }else if mod.type == "dir"{
                //文件
                let sub:XJHDocumentPathVC = XJHDocumentPathVC()
                sub.rootPage = false
                sub.titleStr = mod.name
                sub.documentPath = mod.url
                self.navigationController?.pushViewController(sub, animated: true)
                
            }
        }
    }
    
    
    func xjh_CreatUI(){
        
        self.view.addSubview(self.documentPathTV)
        self.documentPathTV.snp.makeConstraints { (ma) in
            ma.edges.equalToSuperview()
        }
    }
    
    @objc func XJH_GetSupervisionUserInfoMode(){
        XJH_UserDataTool.XJH_GetSupervisionUserInfoMode()
    }
     
    
    lazy var documentPathTV : XJH_DocumentTab = {
        let lab = XJH_DocumentTab.view()
        lab!.delegate = self
        
        return lab!
    }()
    
    
    //解析文本 mod
    
}
