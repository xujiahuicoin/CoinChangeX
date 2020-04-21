//
//  XJH_Okex_FuturesTVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

protocol XJH_Okex_FuturesTVC_Delegate {
    ///0-1-2
    func XJH_Okex_FuturesTVC_Action(futuresName:String,aliasType:ok_FuturesAliasType)
}

class XJH_Okex_FuturesTVC: UITableViewCell {
    
    @IBOutlet weak var futures_name: UILabel!
    
    @IBOutlet weak var left_btn: UIButton!
    
    @IBOutlet weak var center_btn: UIButton!
    
    @IBOutlet weak var right_btn: UIButton!
    
    var futureDelegate : XJH_Okex_FuturesTVC_Delegate!
    var futurescelllName:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = XJHMainColor
        
        futures_name.font = Font(font: XJHFontNum_Second())
        left_btn.titleLabel!.font = Font(font: XJHFontNum_Second())
        center_btn.titleLabel!.font = Font(font: XJHFontNum_Second())
        right_btn.titleLabel!.font = Font(font: XJHFontNum_Second())
    }
    
    @IBAction func leftBtnAction(_ sender: Any) {
        futureDelegate.XJH_Okex_FuturesTVC_Action(futuresName: futurescelllName, aliasType: .this_week)
    }
    
    @IBAction func centerBtnAction(_ sender: Any) {
        futureDelegate.XJH_Okex_FuturesTVC_Action(futuresName: futurescelllName, aliasType: .next_week)
    }
    @IBAction func rightBtnAction(_ sender: Any) {
        futureDelegate.XJH_Okex_FuturesTVC_Action(futuresName: futurescelllName, aliasType: .quarter)
    }
    
    func updateCellData(futuresName:String){
        futurescelllName = futuresName
        futures_name.text = futuresName
        left_btn.setTitle(futuresName +  "·本周", for: .normal)
        center_btn.setTitle(futuresName +  "·次周", for: .normal)
        right_btn.setTitle(futuresName +  "·季度", for: .normal)
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
