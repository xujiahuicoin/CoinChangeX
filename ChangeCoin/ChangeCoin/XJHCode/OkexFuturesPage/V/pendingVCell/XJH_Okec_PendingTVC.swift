//
//  XJH_Okec_PendingTVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

protocol XJH_Okec_PendingTVC_Delegate {
    ///是不是调整杠杆 ，false ：平仓
    func XJH_Okec_PendingTVCActions(model : Any,changeLeverage:Bool)
}

class XJH_Okec_PendingTVC: UITableViewCell {
    
    @IBOutlet weak var futuresOrderId: UILabel!
    
    ///期货名称
    @IBOutlet weak var futuresName_lab: UILabel!
    ///期货杠杆倍数
    @IBOutlet weak var leverete_lab: UILabel!
    ///开仓价格
    @IBOutlet weak var openPrice_lab: UILabel!
    ///收益
    @IBOutlet weak var income_lab: UILabel!
    ///强平价格
    @IBOutlet weak var forcePing_Lab: UILabel!
    ///收益率
    @IBOutlet weak var incomePercentage_lab: UILabel!
    ///未实现盈亏
    @IBOutlet weak var notImplmentIncome_lab: UILabel!
    ///持仓量
    @IBOutlet weak var holdingAcount_lab: UILabel!
    ///可平仓
    @IBOutlet weak var canCut_lab: UILabel!
    ///保证金
    @IBOutlet weak var margin_lab: UILabel!
    ///保证金率
    @IBOutlet weak var marginPercentage_lab: UILabel!
    ///维持保证金率
    @IBOutlet weak var maintainMarginPer_lab: UILabel!
    
    var delegate_Position : XJH_Okec_PendingTVC_Delegate!
    
   var  currentModel:Any!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = XJHMainColor
    }
    
    func XJH_Pub_UpdateWithModel(model:Any,marginMod:ok_futuresMargin_Model = .crossed,showUserName:Bool){
        currentModel = model
        
        if marginMod == ok_futuresMargin_Model.crossed {
            
            //全仓
            let mod : XJH_OkexfuturesPositionModel_1 = model as! XJH_OkexfuturesPositionModel_1
            
            if showUserName {
                futuresOrderId.text = mod.instrument_id
                futuresOrderId.isHidden = false
                  }
                  
            
            futuresName_lab.text = mod.instrument_id
            
            var levereteName = "空仓"
            var color = XJHRedColor
            if (Double(mod.long_qty) ?? 0) > 0{
                //多仓
                levereteName = "多仓"
                color = XJHGreenColor
                
                openPrice_lab.text = xjh_AutoRoundToString(mod.long_avg_cost)
                
                income_lab.text = xjh_AutoRoundToString(mod.long_pnl)
                incomePercentage_lab.text = "\(((Double( mod.long_pnl_ratio) ?? 0) * 100.0).xjh_roundToString(places: 2))%"
                
                marginPercentage_lab.text = "\(((Double( mod.long_margin_ratio) ?? 0) * 100.0).xjh_roundToString(places: 2))%"
                
                maintainMarginPer_lab.text = "\(((Double( mod.long_maint_margin_ratio) ?? 0) * 100.0).xjh_roundToString(places: 2))%"
                
                notImplmentIncome_lab.text = xjh_AutoRoundToString(mod.long_unrealised_pnl)
                
                holdingAcount_lab.text = Okex_FuturesSheetsToCoinNums(price: mod.last, sheets: mod.long_qty,futuresName:mod.instrument_id)
                
                canCut_lab.text = Okex_FuturesSheetsToCoinNums(price: mod.last, sheets: mod.long_avail_qty,futuresName:mod.instrument_id)
                
                margin_lab.text = xjh_AutoRoundToString(mod.long_margin)
            }else{
                openPrice_lab.text = xjh_AutoRoundToString(mod.short_avg_cost)
                
                income_lab.text = xjh_AutoRoundToString(mod.short_pnl)
                
                incomePercentage_lab.text = "\(((Double( mod.short_pnl_ratio) ?? 0) * 100.0).xjh_roundToString(places: 2))%"
                
                notImplmentIncome_lab.text = xjh_AutoRoundToString(mod.short_unrealised_pnl)
                
                holdingAcount_lab.text = Okex_FuturesSheetsToCoinNums(price: mod.last, sheets: mod.short_qty,futuresName:mod.instrument_id)
                
                canCut_lab.text = Okex_FuturesSheetsToCoinNums(price: mod.last, sheets: mod.short_avail_qty,futuresName:mod.instrument_id) 
                
                margin_lab.text = xjh_AutoRoundToString(mod.short_margin)
                
                marginPercentage_lab.text = "\(((Double( mod.short_margin_ratio) ?? 0) * 100.0).xjh_roundToString(places: 2))%"
                
                maintainMarginPer_lab.text = "\(((Double( mod.short_maint_margin_ratio) ?? 0) * 100.0).xjh_roundToString(places: 2))%"
            }
            
            
            leverete_lab.text = " \(levereteName) · \(mod.leverage) "
//            leverete_lab.textColor = .white
            leverete_lab.backgroundColor = color
            forcePing_Lab.text = mod.liquidation_price
            
            
        }
        
        
        
        
    }
    
///调整杠杆
    @IBAction func changeLeverageAction(_ sender: Any) {
        
        delegate_Position.XJH_Okec_PendingTVCActions(model: currentModel as Any, changeLeverage: true)
    }
    
    ///平仓操作
    @IBAction func cutFuturesAction(_ sender: Any) {
        
        delegate_Position.XJH_Okec_PendingTVCActions(model: currentModel as Any, changeLeverage: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
