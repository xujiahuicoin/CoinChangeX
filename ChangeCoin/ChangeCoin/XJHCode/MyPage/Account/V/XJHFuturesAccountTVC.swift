//
//  XJHFuturesAccountTVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJHFuturesAccountTVC: UITableViewCell {
    ///账户权益
    @IBOutlet weak var equityFutures: UILabel!
    ///已实现b盈亏
    @IBOutlet weak var realized_pnl_lab: UILabel!
    ///未实现盈亏
    @IBOutlet weak var unrealized_pnl_Lab: UILabel!
    
    ///可用保证金
    @IBOutlet weak var margin_Lab: UILabel!
    
    ///已用保证金
    @IBOutlet weak var margin_frozen_Lab: UILabel!
    
    ///冻结保证金
    @IBOutlet weak var margin_for_unfilled_Lab: UILabel!
    
    ///保证金率
    @IBOutlet weak var margin_ratio_Lab: UILabel!
    
    ///维持保证金率
    @IBOutlet weak var maint_margin_ratio_Lab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         self.backgroundColor = XJHMainColor
    }

    func xjh_updateThisModel(model:XJH_OkexFuturesAllBlanceModel){
        
        equityFutures.text = model.currency + " 账户权益 " +  xjh_AutoRoundToString(model.equity)
        
        realized_pnl_lab.text = xjh_AutoRoundToString(model.realized_pnl)
        unrealized_pnl_Lab.text = xjh_AutoRoundToString(model.unrealized_pnl)
        margin_Lab.text = dataCalculationAndAfter(beforeStr: model.equity, theWay: .type_subtraction, afterStr: model.margin_frozen)
            xjh_AutoRoundToString(model.can_withdraw)
        margin_frozen_Lab.text = xjh_AutoRoundToString(model.margin_frozen)
        margin_for_unfilled_Lab.text = xjh_AutoRoundToString(model.margin_for_unfilled)
        
        let margin_ratio = Double(model.margin_ratio)! * 100.0
        margin_ratio_Lab.text = "\(margin_ratio.xjh_roundToDouble(places: 2))%"

        let maint_margin_ratio = Double(model.maint_margin_ratio)! * 100.0
        maint_margin_ratio_Lab.text = "\(maint_margin_ratio.xjh_roundToDouble(places: 2) )%"
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
