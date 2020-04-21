//
//  XJH_Okex_CutFuturesVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_CutFuturesVC: XJH_OkexFuturesVC {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reSetViewUI()
        //false为平仓
        XJH_FuturescurrencyInfoView.openOrCutOrder = false
        
        //添加-期货交易对变化 通知
        //        NotificationCenter.default.addObserver(self, selector: #selector(XJH_OkexUpdateLoadDataChangeName), name: NSNotification.Name(rawValue: Okex_NotificationAction.ChangeFutureName.rawValue), object: nil)
        //杠杆倍数发生了变化
        //        NotificationCenter.default.addObserver(self, selector: #selector(XJH_OkexGetFuturesLeverage), name: NSNotification.Name(rawValue: Okex_NotificationAction.ChangeFuturesLeverage.rawValue), object: nil)
        
        //给viewWillDisappear 挂通知
        NotificationCenter.default.addObserver(self, selector: #selector(xjh_viewTimerContinueIsTrue(note:)), name: NSNotification.Name(rawValue: pageNotifaca_close), object: nil)
    }
    
 
    ///重新设置需要修改的UI
    func reSetViewUI(){
        
        //b关闭 杠杆点击事件
        //        XJH_FuturescurrencyInfoView.ok_FuturesParam_View.ok_leverageBtn.isUserInteractionEnabled = false
        //修改买卖按钮文字
        XJH_FuturescurrencyInfoView.ok_FuturesParam_View.ok_TrasactionBuy_Btn.setTitle("买入平空", for: .normal)
        XJH_FuturescurrencyInfoView.ok_FuturesParam_View.ok_TrasactionSell_Btn.setTitle("卖出平多", for: .normal)
        
        //修改 可买卖 数量多 背景
        XJH_FuturescurrencyInfoView.ok_FuturesParam_View.availabelLab_one.backgroundColor = XJHBackgroundColor_dark
        XJH_FuturescurrencyInfoView.ok_FuturesParam_View.availabelLab_Two.backgroundColor = XJHBackgroundColor_dark
        XJH_FuturescurrencyInfoView.ok_FuturesParam_View.canBytBuy_lab.backgroundColor = XJHBackgroundColor_dark
        XJH_FuturescurrencyInfoView.ok_FuturesParam_View.canBytSell_lab.backgroundColor = XJHBackgroundColor_dark
        
        
    }
    
    //传递事件
    override func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
        
        if eventObject.event_CodeType == xjh_PullDown {
            
            //
            self.XJH_Pri_FuturesgetPendingOrders()
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_currencyNameAction.rawValue {
            //期货名字点击事件\
            self.XJH_FuturesCurrencyListView.XJH_futuresOperatorTabHide(show: true)
        }else if eventObject.event_CodeType == OkexPageAction.xjh_transactionListTab.rawValue {
            
            ///货币列表点击事件
            let listReturn :FutureListPairRuturn = eventObject.params as! FutureListPairRuturn
            let mod :XJH_OkexFuturesListInstrumentsModel = XJH_OkexFuturesListInstrumentsModel().getInfoFromArray(array: XJH_OkexFuturesInstrumentsArray, listStruct: listReturn)
            
            ///判断mod 是否值
            if mod.instrument_id.count < 1 {return}
            
            self.XJH_FuturescurrencyInfoView.instrument_id_root = mod.instrument_id;
            
            self.XJH_FuturescurrencyInfoView.XJH_FuturesCurrentCurrencyModel = mod
            self.XJH_FuturescurrencyInfoView.ok_currencyName_Btn.setTitle(XJH_Okex_FuturesreturnFuturesNameFormatStr(mod: mod), for: .normal)
            
            UserDefaults.standard.set(mod.instrument_id, forKey: okex_futures_key)
            //更换币种 刷新
            self.XJH_OkexUpdateLoadDataChangeName()
            
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(Okex_NotificationAction.noti_ChangeFutureName.rawValue), object: nil)
            
            //            ///隐藏交易对列表
            self.XJH_FuturesCurrencyListView.XJH_futuresOperatorTabHide(show: false)
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_ListCancelSingleOrder.rawValue {
            let mod : XJH_OkexFuturesOldOrderModel = eventObject.params as! XJH_OkexFuturesOldOrderModel
            
            xjh_OkexApiFutures.okex_FututresCancel_Order(order_id: mod.order_id, instrument_id: mod.instrument_id, blockSuccess: { (mod) in
                
                DispatchQueue.main.async(execute: {
                    self.xjh_showSuccess_Text(text: "撤单成功", view: self.view)
                })
            }) { (err) in
                
                DispatchQueue.main.async(execute: {
                    self.xjh_showError_Text(text: err.message, view: self.view)
                })
            }
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_AllComissionAction.rawValue{
            //跳转全部委托列表
            let subVC = XJH_Okex_CommissionVC.init()
            subVC.hidesBottomBarWhenPushed = true
            subVC.instrument_id_root = XJH_FuturescurrencyInfoView.instrument_id_root
            self.FuturesDelegate.XJH_OkexFuturesVCPushAction(vc: subVC)
            
        }
        
    }
    
}
