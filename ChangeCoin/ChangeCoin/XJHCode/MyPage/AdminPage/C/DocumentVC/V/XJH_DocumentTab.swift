//
//  XJH_DocumentTab.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/18.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_DocumentTab: XJHBaseTableView {
      
        
        override func initXJHView() {
            ///添加刷新
            self.xjh_addDownPullToRefresh()
            
            self.tableView?.register(UINib(nibName: "XJHDocumentTC", bundle: nil), forCellReuseIdentifier: "cell")
            ///禁用滚动属性
//            self.tableView?.isScrollEnabled = false
            
            //设置分割线
            self.tableView?.separatorStyle = .none
            
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
                return datas.count
           
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            
            return 1
            
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell : XJHDocumentTC = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! XJHDocumentTC
        
            let mod = datas[indexPath.row] as! XJh_GithubProjectContentsModel
            cell.updateCellData(mod: mod)
            return cell
            
        }
 
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            //tableview取消点击效果
            tableView.deselectRow(at: indexPath, animated: true)
            
            let mod = datas[indexPath.row] as! XJh_GithubProjectContentsModel
            
            sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_documentPathClick.rawValue, params: mod))
  
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return XJHGetHeght(height: 80)
        }
        
    }
