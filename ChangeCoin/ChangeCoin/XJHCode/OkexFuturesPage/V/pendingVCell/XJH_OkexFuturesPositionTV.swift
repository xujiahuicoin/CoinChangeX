//
//  XJH_OkexFuturesPositionTV.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/13.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserv
import UIKit

class XJH_OkexFuturesPositionTV: XJHBaseTableView,XJH_Okec_PendingTVC_Delegate {

    var marginModel:ok_futuresMargin_Model = .crossed
    var showHeaderBool : Bool = false
///是否显示用户名
    var showUserName : Bool = false
    override func initXJHView() {
        
        self.xjh_addDownPullToRefresh()
        self.tableView?.separatorColor = .white
        
        self.tableView?.register(UINib(nibName: "XJH_Okec_PendingTVC", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    func xjh_updateTableView(datas : Array<Any>,marginMod:ok_futuresMargin_Model = .crossed) {
           
           self.datas = datas
           marginModel = marginMod
           DispatchQueue.main.async {
               self.xjh_hiddenHud()
               self.tableView?.reloadData()
           }
           
           self.endRefresh()
       }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : XJH_Okec_PendingTVC = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! XJH_Okec_PendingTVC
        cell.selectionStyle = .blue
        cell.delegate_Position = self
        cell.XJH_Pub_UpdateWithModel(model: datas[indexPath.row] , marginMod: marginModel,showUserName:showUserName)
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//   
//    }
//    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 290
    }
    func XJH_Okec_PendingTVCActions(model: Any, changeLeverage: Bool) {
        
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_futuresChagneLeverageOrCutOrder.rawValue, params: [changeLeverage,model]))
    }
    


}
