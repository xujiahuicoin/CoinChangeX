//
//  XJHSetingVC.swift
//  ChangeCoin
//
//  Created by xujiahui on 2020/1/5.
//  Copyright © 2020 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit
import XLForm
class XJHSetingVC: XLFormViewController {
    
    var titleStr : String = "用户设置"
    fileprivate struct Tags {
        
        static let baseCurrency = "BaseCurrency"
        static let currentWallet = "currentWallet"
        
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: titleStr)
       
        //资金基准
        section = XLFormSectionDescriptor.formSection(withTitle: "资产计算（资产刷新存在延迟，非实时刷新，设置后不会立刻更新）")
        form.addFormSection(section)
        
        //基准
        row = XLFormRowDescriptor(tag: Tags.baseCurrency, rowType: XLFormRowDescriptorTypeSelectorPush, title: "基础货币")
        row.selectorOptions = ["BTC","USD","CNY"]
        //点击进入的title
        row.selectorTitle = "选择基础货币"
        row.value = XJHSetingShareModel.shareModel.baseCurrency
        section.addFormRow(row)
        //资产
        /*
         ///   0.预估总资产
             case okex_walletAll = "0"
         ///    1.币币账户
             case okex_walletCoinCoin = "1"
         ///    3.交割账户
             case okex_walletFutures = "3"
         */
        row = XLFormRowDescriptor(tag: Tags.currentWallet, rowType: XLFormRowDescriptorTypeSelectorPush, title: "资产钱包")
        row.selectorOptions = ["预估总资产","币币账户","交割账户"]
        //点击进入的title
        row.selectorTitle = "资产钱包"
        row.value = XJHSetingShareModel.shareModel.currentWallet
        section.addFormRow(row)
        
        self.form = form
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = titleStr
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新设置", style: .plain, target: self, action: #selector(XJHSetingVC.savePressed(_:)))
        
        self.initializeForm()
    }
    
    @objc func savePressed(_ sender: UIBarButtonItem) {
      
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            
            XJHProgressHUD.showError(message: "数据不完整，请检查")
            
            return
        }
        self.tableView.endEditing(true)
        
        let value:Dictionary<String,Any> = self.formValues() as! Dictionary<String, Any>
        
        let basecurrent:String = value[Tags.baseCurrency] as! String
        
        XJHSetingShareModel.shareModel.baseCurrency = basecurrent
        let currentWallet:String = value[Tags.currentWallet] as! String
        XJHSetingShareModel.shareModel.currentWallet = currentWallet
      //保存记录
        XJHSetingLogic.Xjh_SetWriteData(mod: XJHSetingShareModel.shareModel)
        
        //刷新成功
        XJHProgressHUD.showSuccess(message: "刷新数据成功", view: self.view)
    }
    
}
