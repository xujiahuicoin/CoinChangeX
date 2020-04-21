//
//  XJH_Okex_CurrencyListTVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_CurrencyListTVC: UITableViewCell {

    @IBOutlet weak var XJH_currencyPair_Lab: UILabel!
    @IBOutlet weak var XJH_currencyPrice_Lab: UILabel!
    
    @IBOutlet weak var XJH_currencyChange_Lab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = XJHMainColor
        
        
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
