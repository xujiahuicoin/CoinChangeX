//
//  XJH_Okex_TransactionDeepTCell.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_TransactionDeepTCell: UITableViewCell {

    
    @IBOutlet weak var xjh_TransactionPrince_Lab: UILabel!
    
    @IBOutlet weak var xjh_Transaction_countLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = XJHMainColor
        xjh_TransactionPrince_Lab.font = Font(font: XJHFontNum_Second())
        xjh_Transaction_countLab.font = Font(font: XJHFontNum_Second())
    }

    func updateCellData(price:String,num:String,color:UIColor,instrument_id: String){
        xjh_TransactionPrince_Lab.text = price//Double(price)?.xjh_AutoRoundToString()
        xjh_TransactionPrince_Lab.textColor = color
        if instrument_id.count > 0 {
             xjh_Transaction_countLab.text = Okex_FuturesSheetsToCoinNums(price: price, sheets: num, futuresName: instrument_id)
        }else{
            xjh_Transaction_countLab.text = xjh_AutoRoundToString(num)
        }
       
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
