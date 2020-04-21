//
//  XJH_Okex_FuturesListTV.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit
struct FutureListPairRuturn {
    var futuresName : String = ""
    ///默认季度
    var aliasType : ok_FuturesAliasType = ok_FuturesAliasType.quarter
}
class XJH_Okex_FuturesListTV: XJHBaseTableView,XJH_Okex_FuturesTVC_Delegate {


    override func initXJHView() {
        
        self.tableView?.register(UINib(nibName: "XJH_Okex_FuturesTVC", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView?.backgroundColor = XJHSpaceColor
    }
    
    ///刷新列表
    func updateTableViewData(){
        
        let listmods: Array<Any> = XJH_UserModel.sharedInstance.futures
        self.xjh_updateTableView(datas: listmods)
              
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : XJH_Okex_FuturesTVC = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! XJH_Okex_FuturesTVC
        cell.selectionStyle = .blue
        cell.futureDelegate = self
        cell.updateCellData(futuresName: datas[indexPath.row] as! String)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return XJHGetHeght(height: 150)
    }
    
    func XJH_Okex_FuturesTVC_Action(futuresName: String, aliasType: ok_FuturesAliasType) {
       
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_transactionListTab.rawValue, params: FutureListPairRuturn(futuresName: futuresName, aliasType: aliasType)))
               
    }
    
    //创建 弹窗菜单
    func XJH_futuresOperatorTabHide(show: Bool){
        
        if show{
            
            self.updateTableViewData()
            
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.alpha = 0
            }
            
        }
    }
    
}
