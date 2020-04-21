//
//  XJH_Okex_FuturesListView.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_FuturesListView: XJHBaseView,XJHViewEventsDelegate {

       var XJH_currencyListTab : XJH_Okex_CurrencyListTV!
       var XJH_currencyPairTab : XJH_Okex_CurrencyPairTV!
       ///当前的交易对
       var currentPairStr : String!
       ///交易对
       var transactionPair_Arr : Array<String>?
       
       //交易对列表
       var transactoinPair_List : Dictionary<String,Any>?
       
       override func initXJHView() {
           
           CreatUI()
           XJH_Pri_getTransactionPair()
       }
       func CreatUI(){
           

           
           XJH_currencyPairTab = XJH_Okex_CurrencyPairTV.view()
           XJH_currencyPairTab.delegate = self
           self.addSubview(XJH_currencyPairTab)
           
           XJH_currencyPairTab.snp.makeConstraints { (ma) in
               ma.top.left.bottom.equalToSuperview()
               ma.width.equalTo(110)
           }
           XJH_currencyListTab = XJH_Okex_CurrencyListTV.view(parmas:ViewDataObject.viewData(Okex_TransactionType.coinCoin))
           XJH_currencyListTab.delegate = self
           self.addSubview(XJH_currencyListTab)
           
           XJH_currencyListTab.snp.makeConstraints { (ma) in
               ma.left.equalTo(XJH_currencyPairTab.snp.right)
               ma.top.bottom.equalToSuperview()
               ma.right.equalToSuperview()
           }
           
           
       }
       
       
       ///获取交易对
       func XJH_Pri_getTransactionPair(){
           
           transactionPair_Arr = XJH_Okex_OtherData.XJH_getTransactionPairArray()
           currentPairStr = transactionPair_Arr![0]
           
           //刷新交易对
           XJH_currencyPairTab.xjh_updateTableView(datas: transactionPair_Arr!)
           
           XJH_getTransactionListData(market: currentPairStr)
       }
       
       ///获取交易列表
       func XJH_getTransactionListData(market: String){
           
           if transactoinPair_List == nil {
            
            
            self.transactoinPair_List = ["coin":XJH_UserModel.sharedInstance.futures]
         //刷新列表
           self.XJH_currencyListTab.xjh_updateTableView(datas: self.transactoinPair_List![market] as! Array<Any>)
            
            
           }else{
               
               self.XJH_currencyListTab.xjh_updateTableView(datas: self.transactoinPair_List?[market] as! Array<Any>)
           }
       }
       
        func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
           //点击事件
           
           if eventObject.event_CodeType == OkexPageAction.xjh_transactionPairTab.rawValue {
               //交易对 pair
               currentPairStr = (eventObject.params as! String)
               
               //刷新 期货列表
               self.XJH_getTransactionListData(market: currentPairStr)
               
           }
           
       }
   }



