//
//  XJH_Okex_CurrencyPair_TVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_CurrencyPair_TVC: UITableViewCell {

    @IBOutlet weak var XJH_CurrencyPair_Lab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = XJHMainColor
        
        XJH_CurrencyPair_Lab.font = Font(font: XJHFontNum_Second())
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
