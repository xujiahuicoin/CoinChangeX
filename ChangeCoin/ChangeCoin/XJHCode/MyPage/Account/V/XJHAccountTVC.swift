//
//  XJHAccountTVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJHAccountTVC: UITableViewCell {
///名字
    @IBOutlet weak var coinName: UILabel!
    ///持有
    
    @IBOutlet weak var coinBlance: UILabel!
    
    ///可用
    @IBOutlet weak var coinAvailable: UILabel!
    ///冻结
    @IBOutlet weak var coinHold: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = XJHMainColor
    }
    
    func xjh_updateThisModel(model:xjh_Okex_FundAcountModel){
        
        
        coinName.text = xjh_AutoRoundToString(model.currency)
        coinBlance.text = xjh_AutoRoundToString(model.balance)
        coinAvailable.text = xjh_AutoRoundToString(model.available)
        coinHold.text = xjh_AutoRoundToString(model.hold)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
