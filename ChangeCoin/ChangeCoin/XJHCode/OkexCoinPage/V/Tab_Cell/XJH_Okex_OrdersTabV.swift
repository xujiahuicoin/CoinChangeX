//
//  XJH_Okex_OrdersTabV.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_OrdersTabV: XJHBaseTableView,XJH_Okex_OrdersTVC_cancelBtnDelegate {
    
    ///策略委托 默认-限价
    var XJH_StrategyType :Okex_StrategyOrderType = .type_normal
    ///是不是当前订单Or历史
    var currentOrderBool : Bool = true
    
    var selectArray : [XJH_OkexFuturesOldOrderModel] = []
    
    override func initXJHView(){
        
         self.xjh_addDownPullToRefresh()
        
        self.tableView?.register(UINib(nibName: "XJH_Okex_OrdersTVC", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.tableView?.backgroundColor = XJHMainColor
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: XJH_Okex_OrdersTVC = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! XJH_Okex_OrdersTVC
        cell.btnDelegate = self
        
        cell.XJH_Pub_updateOrderModel(mod: datas[indexPath.row],isCoinCoin: isCoinCoin,XJH_StrategyType:XJH_StrategyType,currentOrderBool:currentOrderBool)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return iPhoneWidth(w: 190)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            let select = self.datas[indexPath.row]
            self.selectArray.append(select as! XJH_OkexFuturesOldOrderModel)
        }
        
        ///点击了点单cell
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_TransactionOrdersCell.rawValue, params: indexPath.row))  
    }
    
    
    ///撤销订单
    func XJH_Okex_OrdersTVC_cancelBtnAction(thisModel: Any) {
        
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_ListCancelSingleOrder.rawValue, params: thisModel))
    }
    
    
    ///tableview 滑动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_TableViewScrollViewWillBeginDragging.rawValue))
        
    }
    
    //编辑事件
    internal func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //这里非常关键！
        return UITableViewCell.EditingStyle(rawValue: UITableViewCell.EditingStyle.delete.rawValue | UITableViewCell.EditingStyle.insert.rawValue)!
    }
    
}
