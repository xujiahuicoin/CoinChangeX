//
//  XJH_Okex_CurrencyPairTV.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_CurrencyPairTV: XJHBaseTableView {

    ///当前高亮的cell
    var xjh_CurrentCell : Int = 0
    var xjh_cellHeaderH : CGFloat = XJHGetHeght(height: 90)
    var xjh_cellHeaderStr : String = "交易区"
        
    override func initXJHView() {
        
        self.tableView?.register(UINib(nibName: "XJH_Okex_CurrencyPair_TVC", bundle: nil), forCellReuseIdentifier: "cell")
               self.tableView?.backgroundColor = XJHSpaceColor
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : XJH_Okex_CurrencyPair_TVC = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! XJH_Okex_CurrencyPair_TVC
        
        if indexPath.row == xjh_CurrentCell {
            cell.XJH_CurrencyPair_Lab.textColor = XJHButtonColor_Blue
        }else{
            cell.XJH_CurrencyPair_Lab.textColor = XJHMainTextColor_dark
        }
        
        cell.XJH_CurrencyPair_Lab.text = (datas[indexPath.row] as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()
    header.backgroundColor = XJHSpaceColor
    let centerLab = UILabel(Xframe: CGRect.zero, text: xjh_cellHeaderStr , font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHMainColor)
        centerLab.textAlignment = .center
        header.addSubview(centerLab)
        centerLab.snp.makeConstraints { (ma) in
            ma.center.equalToSuperview()
        }
    return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return iPhoneWidth(w: xjh_cellHeaderH)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        xjh_CurrentCell = indexPath.row
        
        self.tableView?.reloadData()
        
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_transactionPairTab.rawValue, params: datas[indexPath.row]))
        
        
     sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_transactionPairTabRow.rawValue, params: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return xjhHeight_TabCell()
    }

    
    ///是否展示 列表 true==展示
    func XJH_futuresOperatorTabHide(show:Bool){
        
        if show{
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.alpha = 0
            }
            
        }
    }
    
}
