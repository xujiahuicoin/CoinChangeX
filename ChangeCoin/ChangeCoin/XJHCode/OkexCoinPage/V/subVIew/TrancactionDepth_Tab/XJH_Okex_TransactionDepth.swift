//
//  XJH_Okex_TransactionDepth.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_TransactionDepth: XJHBaseTableView {
    
    var instrument_id: String = ""
    
    override func initXJHView() {
        
        self.tableView?.register(UINib(nibName: "XJH_Okex_TransactionDeepTCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView?.backgroundColor = XJHMainColor
        ///禁用滚动属性
        self.tableView?.isScrollEnabled = false
        
        //设置分割线
        self.tableView?.separatorStyle = .none
        
    }
    func xjh_StrategyupdateTableView(datas : Array<Any>,instrument_id: String) {
        self.instrument_id = instrument_id
         self.datas = datas
         
         DispatchQueue.main.async {
             self.xjh_hiddenHud()
             self.tableView?.reloadData()
         }
         
         self.endRefresh()
     }
     
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if datas.count < 1 {
            return datas.count
        }
        
        let mod = datas[0] as! XJH_Okex_CoinTransactionDepthModel
        
        if section == 0 {
          
            return mod.asks!.count
        }
        
        return mod.bids!.count
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : XJH_Okex_TransactionDeepTCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! XJH_Okex_TransactionDeepTCell
        
        var color = XJHGreenColor
         let mod = datas[0] as! XJH_Okex_CoinTransactionDepthModel
        
        if indexPath.section == 0 {
            color = XJHRedColor
            let array = mod.asks![4-indexPath.row]
            
            cell.updateCellData(price: array[0], num: array[1] , color: color, instrument_id: instrument_id)
            cell.selectedBackgroundView = UIView(frame: cell.frame)
            cell.selectedBackgroundView?.backgroundColor = .gray
            return cell
        }
        
        let array = mod.bids![4-indexPath.row]
        
        cell.updateCellData(price: array[0], num: array[1] , color: color, instrument_id: instrument_id)
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = XJHMainColor
        
        if section == 0 {
            
            let leftLab = UILabel(Xframe: CGRect.zero, text: "价格", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHMainColor)
            leftLab.textAlignment = .left
            let rightLab = UILabel(Xframe: CGRect.zero, text: "数量", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHMainColor)
            rightLab.textAlignment = .right
            header.addSubview(leftLab)
            header.addSubview(rightLab)
            
            leftLab.snp.makeConstraints { (ma) in
                ma.left.equalTo(20)
                ma.centerY.equalToSuperview()
            }
            rightLab.snp.makeConstraints { (ma) in
                ma.right.equalTo(-20)
                ma.centerY.equalToSuperview()
                ma.width.equalTo(60)
            }
            
            return header
            
        }
        let centerLab = UILabel(Xframe: CGRect.zero, text: "", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHSecondTextColor)
        header.addSubview(centerLab)
        centerLab.snp.makeConstraints { (ma) in
            ma.left.right.equalToSuperview()
            ma.centerY.equalToSuperview()
            ma.height.equalTo(0.5)
        }
        
        return header
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return iPhoneWidth(w: 30)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableview取消点击效果
        tableView.deselectRow(at: indexPath, animated: true)
        
        let mod = datas[0] as! XJH_Okex_CoinTransactionDepthModel
        var arr = mod.asks![indexPath.row]
        
        if indexPath.section == 1 {
           arr = mod.bids![indexPath.row]
        }
        
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_TransactionDepthTab.rawValue, params: arr))
        
//        if indexPath.section == 0 {
//            //卖出
//            sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.transactionListTab.rawValue, params: ["asks",mod.asks![indexPath.row]]))
//
//        }else{
//            //mai
//            sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.transactionListTab.rawValue, params: ["bids",mod.bids?[indexPath.row] as Any]))
//        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return XJHGetHeght(height: 50)
    }
    
}
