//
//  XJH_Okex_CurrencyListTV.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_CurrencyListTV: XJHBaseTableView {
    
    
    override func initXJHView() {
        
        
        
        self.tableView?.register(UINib(nibName: "XJH_Okex_CurrencyListTVC", bundle: nil), forCellReuseIdentifier: "cell")
        //XJH_Okex_FuturesTVC
         self.tableView?.register(UINib(nibName: "XJH_Okex_FuturesTVC", bundle: nil), forCellReuseIdentifier: "XJH_Okex_FuturesTVC")
        self.tableView?.backgroundColor = XJHMainColor
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : XJH_Okex_CurrencyListTVC = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! XJH_Okex_CurrencyListTVC
        cell.XJH_currencyPrice_Lab.text = datas[indexPath.row] as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = XJHSpaceColor
        
        let leftLab = UILabel(Xframe: CGRect.zero, text: "交易币对", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHSpaceColor)
        
        let centerLab = UILabel(Xframe: CGRect.zero, text: "最新价", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHSpaceColor)
        centerLab.textAlignment = .center
        
        let rightLab = UILabel(Xframe: CGRect.zero, text: "涨跌幅", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHSpaceColor)
        rightLab.textAlignment = .right
        
        header.addSubview(leftLab)
        header.addSubview(centerLab)
        header.addSubview(rightLab)
        
        leftLab.snp.makeConstraints { (ma) in
            ma.left.equalTo(30)
            ma.centerY.equalToSuperview()
            ma.width.equalTo(80)
        }
        
        centerLab.snp.makeConstraints { (ma) in
            ma.center.equalToSuperview()
            ma.width.equalTo(80)
        }
        
        
        rightLab.snp.makeConstraints { (ma) in
            ma.right.equalTo(-20)
            ma.centerY.equalToSuperview()
            ma.width.equalTo(80)
        }
        
        return header
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return iPhoneWidth(w: 40)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_transactionListTab.rawValue, params: datas[indexPath.row]))
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return iPhoneWidth(w: 80)
    }
    
    
}
