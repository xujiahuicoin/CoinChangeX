//
//  XJHFuturesTool.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/9.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJHFuturesTool: NSObject {
    
    ///全部订单列表 进行筛选空仓位的单子删除数组
    class func Okex_AllOrderListRemoveNone(mods:[XJH_OkexfuturesPositionModel_1]) -> [XJH_OkexfuturesPositionModel_1] {
        
        var models:[XJH_OkexfuturesPositionModel_1] = mods
        
        for mod in mods {
            
            if mod.long_qty == "0" && mod.short_qty == "0" {
                models.remove(mod)
            }
            
        }
        
        return models
        
    }
    
    ///一次性设置全部币种的 合约币种账户模式
    class func Okex_SetAllFuturesMargin_mode(futures:Array<String>,margin_mode:ok_futuresMargin_Model = .crossed) {
        
        for future  in futures {
            
            xjh_OkexApiFutures.okex_FuturesSetAccountCoinModels(underlying: future + "-USD", margin_mode: ok_futuresMargin_Model(rawValue: margin_mode.rawValue)!, blockResults: { (bools) in
            }) { (err) in
                
            }
            
        }
        
    }
    
    ///平仓下单---交易
    class func XJH_OkexFutureExChangeTransaction(positionModel_1:XJH_OkexfuturesPositionModel_1,instrument_id_root: String,match_price:ok_futuresMatch_price,price:String,account:String,blockAction:@escaping()->()){
        
        //平多空 判断
        let type : ok_FuturesOpenOrderType = okex_getFuturesCutLongOrShor(long_qty: positionModel_1.long_qty)
        
        let instrument_id = changeValueToUSD(value:instrument_id_root)
        
        //由于张数 只能是整数，当平仓与可平仓差距小于2也就是等于1 的时候，将平仓所有可平仓位
        let sizeC = Okex_futuresActualCloseableAccount(price: price, numCoin: account, futuresName: instrument_id_root,positionModel_1: positionModel_1, match_price: match_price, type: type)
        
        
        xjh_OkexApiFutures.okex_FuturesOpenOrder(instrument_id: instrument_id, type: type, order_type: .limit, price: price, size: sizeC, match_price: match_price.rawValue, blockSuccess: { (mod) in
            
            DispatchQueue.main.async(execute: {
                
                XJHProgressHUD.showSuccess(message: "下单成功")
                
                //刷新订单列表
                blockAction()
                
            })
            
        }) { (err) in
            
            DispatchQueue.main.async(execute: {
                
                XJHProgressHUD.showError(message: err.message)
                //如果返回 32014 提示是否 取消所有限价平仓订单，并且继续操作
                if err.code == 32014 {
                    
                    BaseAlertController.showAlertTwoAction(message: "平仓之前，需要撤销该仓位的所有为成交状态的平仓委托单", title: "全部撤单", actionTextOne: "取消", actionTextTwo: "确定", vc: BaseAlertController.getRootVC(), FFActionOne: {
                        
                    }) {
                        //撤销所有 为成交平仓 委托---再继续平仓
                        self.xjh_Pri_CanCellAllPendingOrder(instrument_id: instrument_id, type: type)
                        
                    }
                    
                }
                
            })
            
        }
        
    }
    
    ///撤销所有平仓挂单
    class func xjh_Pri_CanCellAllPendingOrder(instrument_id:String ,type:ok_FuturesOpenOrderType){
        
        xjh_OkexApiFutures.okex_futuresCutAllPendingOrder(instrument_id: instrument_id, direction: type.ok_Returnok_FuturesTypeString(), blockSuccess: { (mod) in
            
            //成功。再次平仓操作
            XJHProgressHUD.showSuccess(message: "已经撤销所有平仓挂单")
            
        }) { (err) in
            XJHProgressHUD.showError(message: err.message)
        }
    }
    
    
}
