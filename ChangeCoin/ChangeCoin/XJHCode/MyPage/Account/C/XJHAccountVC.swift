//
//  XJHAccountVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit
//let walletAll = "wallet0"
//let walletCoin = "wallet1"
//let walletFutures = "wallet3"
class XJHAccountVC: XJHBaseViewController,XJHPageViewDelegate {
   
    ///判断第几个j用户
   var loadIntIndex:Int = okex_header_number
    ///coinModes
    var coinMods:[xjh_Okex_FundAcountModel] = []
    ///futuresMods
    var futuresMods:[XJH_OkexFuturesAllBlanceModel] = []
    
    ///0 现货、1合约
    var SelectIndex = 0
    
    var XJH_topPageView : XJHPageView!
    var xjh_AccountTab:XJHAccountTV!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "现货资金"
        
        xjh_creatUI()
        
        xjh_Pri_downloadDatathisPage()
        
//        xjh_GetWalletAccount()
    }
    
    func xjh_creatUI(){
        
        XJH_topPageView = XJHPageView(frame: .zero)
        XJH_topPageView.delegate = self
        XJH_topPageView.buttonNormalColor = XJHSecondTextColor
        XJH_topPageView.buttonSelectedColor = XJHButtonColor_Blue
        XJH_topPageView.xjh_LineColor = XJHButtonColor_Blue
        XJH_topPageView.updatePageView(titles: ["现货","合约"],currentIndex: 0)
        self.view.addSubview(XJH_topPageView)
        
        XJH_topPageView.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.width.equalToSuperview()
            ma.top.equalToSuperview()
            ma.height.equalTo(40)
        }
        
        xjh_AccountTab = XJHAccountTV.view()
        xjh_AccountTab.delegate = self
        self.view.addSubview(xjh_AccountTab)
        
        xjh_AccountTab.snp.makeConstraints { (ma) in
            ma.top.equalTo(XJH_topPageView.snp.bottom).offset(8)
            ma.width.left.bottom.equalToSuperview()
        }
        
    }
    
    ///每次显示当前页面 开始刷新 资金
//    func xjh_GetWalletAccount(){
//
//        if SelectIndex == 0{
//                let wallet:String = UserDefaults.standard.object(forKey: walletCoin) as? String ?? "资金"
//                self.xjh_createRightButtonItem(title: "现货:" + wallet, target: self, action: nil)
//
//        }else{
//
//                let wallet:String = UserDefaults.standard.object(forKey: walletFutures) as? String ?? "资金"
//                 self.xjh_createRightButtonItem(title: "合约:" + wallet, target: self, action: nil)
//        }
//
//    }
//
    ///当前 和 历史交替
    func pageView(_ pageView: XJHPageView, didSelectIndexAt index: Int) {
        
        SelectIndex = index
        if index == 0 {
            //现货
            self.title = "现货资金"
            
        }else if index == 1 {
            //合约
            self.title = "合约资金"
            
        }
//        xjh_GetWalletAccount()
        //刷新列表
        xjh_Pri_downloadDatathisPage()
    }
    
    //刷新列表
    func xjh_Pri_downloadDatathisPage(){
        if SelectIndex == 0
        {
           
            if coinMods.count < 1 {
                  xjh_HUDShow()
                xjh_OkexApiFundAcount.okex_getAccountWallet(loadIntIndex:loadIntIndex,blockSuccess: { (mods) in
                self.xjh_hideHUD()
                
                if mods.count > 0{
                    self.coinMods = mods
                    self.xjh_AccountTab.tableView?.set(loadType: .normal)
                    self.xjh_AccountTab.xjh_updateTableView(datas: mods,index:self.SelectIndex)
                }else{
                    self.xjh_AccountTab.tableView?.set(loadType: .noData)
                }
                
            }) { (err) in
                self.xjh_hideHUD()
                self.xjh_AccountTab.tableView?.set(loadType: .noData)
            }
            
                
            }else{
                
                self.xjh_AccountTab.tableView?.set(loadType: .normal)
                
                self.xjh_AccountTab.xjh_updateTableView(datas: coinMods,index:self.SelectIndex)
                
            }
            
        }else{
           
            
            if futuresMods.count < 1{
                 xjh_HUDShow()
                xjh_OkexApiFundAcount.okex_getFuturesAccountWallet(loadIntIndex:loadIntIndex, blockSuccess: { (mods) in
                   
                    if mods.count > 0{
                        self.futuresMods = mods
                        self.xjh_AccountTab.tableView?.set(loadType: .normal)
                        self.xjh_AccountTab.xjh_updateTableView(datas: mods,index:self.SelectIndex)
                    }else{
                        self.xjh_AccountTab.tableView?.set(loadType: .noData)
                    }
                }) { (err) in
                    self.xjh_hideHUD()
                    self.xjh_AccountTab.tableView?.set(loadType: .noData)
                }
                
            }else{
                self.xjh_AccountTab.tableView?.set(loadType: .normal)
                self.xjh_AccountTab.xjh_updateTableView(datas: futuresMods,index:self.SelectIndex)
            }
            
            
        }
        
    }
    
    //---------------处理点击事件---------------------
    
    override func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
        
        if eventObject.event_CodeType == xjh_PullDown {
            
            //刷新列表
            xjh_Pri_downloadDatathisPage()
            
        }
        
        
    }
    
}
