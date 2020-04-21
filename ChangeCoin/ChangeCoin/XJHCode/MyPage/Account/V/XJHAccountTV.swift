//
//  XJHAccountTV.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJHAccountTV: XJHBaseTableView {

    var index = 0
    
 override func initXJHView(){
     
//      self.xjh_addDownPullToRefresh()
     
     self.tableView?.register(UINib(nibName: "XJHAccountTVC", bundle: nil), forCellReuseIdentifier: "cell")
    
      self.tableView?.register(UINib(nibName: "XJHFuturesAccountTVC", bundle: nil), forCellReuseIdentifier: "XJHFuturesAccountTVC")
    
     
     self.tableView?.backgroundColor = XJHMainColor
 }

    func xjh_updateTableView(datas : Array<Any>,index:Int) {
         
         self.datas = datas
        self.index = index
         DispatchQueue.main.async {
             self.xjh_hiddenHud()
             self.tableView?.reloadData()
         }
         
         self.endRefresh()
     }
     
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.index == 0 {
            
            let cell: XJHAccountTVC = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! XJHAccountTVC
            cell.xjh_updateThisModel(model: datas[indexPath.row] as! xjh_Okex_FundAcountModel)
            cell.selectionStyle = .none
            return cell
        }  

        let cell: XJHFuturesAccountTVC = tableView.dequeueReusableCell(withIdentifier: "XJHFuturesAccountTVC", for: indexPath) as! XJHFuturesAccountTVC
        cell.xjh_updateThisModel(model: datas[indexPath.row] as! XJH_OkexFuturesAllBlanceModel)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if self.index == 0 {
        return XJHGetHeght(height: 70)
        }
        return XJHGetHeght(height: 560)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()
        if self.index == 0 {
            header.isHidden = false
        }else{
            header.isHidden = true
        }
    header.backgroundColor = XJHSpaceColor

        let wide = (SCREEN_WIDTH-20*5)/4
        let textArr = ["币种","总量","可用","锁定"]
        for i in 0...3 {
            let lab = UILabel(Xframe: CGRect(x: 20 + CGFloat(i) * (20 + wide), y: 8, width: wide, height: 20), text: textArr[i], font: Font(font: XJHFontNum_Main()), textColor: XJHMainTextColor_dark, backgroundColor:XJHSpaceColor, alignment: .center)
            header.addSubview(lab)
        }
    return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         if self.index == 0 {
        return XJHGetHeght(height: 70)
        }
        
        return 0.01
    }
}
