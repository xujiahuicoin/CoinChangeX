//
//  XJH_TrandingPairView.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/9.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_TrandingPairView: XJHBaseView {
    
    var XJH_futuresListTab : XJH_Okex_FuturesListTV!
    ///期货列表数组
    var futuresListArr : [String] = []
    override func initXJHView() {
        
        XJH_CreatUiAddLoadData()
    }
    
    
    func XJH_CreatUiAddLoadData(){
        futuresListArr = XJH_UserModel.sharedInstance.futures
        //期货列表
        XJH_futuresListTab = XJH_Okex_FuturesListTV.view()
        self.addSubview(XJH_futuresListTab)
        XJH_futuresListTab.snp.makeConstraints { (ma) in
            ma.top.equalToSuperview()
            ma.width.equalToSuperview()
            ma.bottom.equalToSuperview()
        }
        XJH_futuresListTab.alpha = 0
        
        //更新期货列表弹窗
        let listmods: Array<Any> = XJH_UserModel.sharedInstance.futures
        XJH_Okex_SetAllFuturesAccountModel(futures: listmods as! Array<String>)
        self.XJH_futuresListTab.xjh_updateTableView(datas: listmods)
    }
    
    ///设置可交易类型 账户模式
    func XJH_Okex_SetAllFuturesAccountModel(futures:Array<String>){
        
        XJHFuturesTool.Okex_SetAllFuturesMargin_mode(futures:futures)
    }
    
}
