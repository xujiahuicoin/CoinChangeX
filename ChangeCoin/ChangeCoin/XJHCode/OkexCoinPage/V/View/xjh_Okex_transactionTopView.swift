//
//  xjh_Okex_transactionTopView.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class xjh_Okex_transactionTopView: XJHBaseView,XJHViewEventsDelegate {
    //----------------Futures--------------------
    ///ture：开仓--f：平仓
    var openOrCutOrder : Bool = true
    ///futures 当前期货
    var instrument_id_root : String = "BTC-USDT"
    ///当前杠杆倍数
    var XJH_FuturesLeverageModel : XJH_OkexFuturesSetOrGetLeverageModel!
    ///当前显示的交易对
    var XJH_FuturesCurrentCurrencyModel : XJH_OkexFuturesListInstrumentsModel!
    ///平仓数据
    var positionModel_1 : XJH_OkexfuturesPositionModel_1!
    //-------------Coin-----------------------
    ///策略委托 默认-限价
    var XJH_StrategyType :Okex_StrategyOrderType = .type_normal
    ///委托策略tab高度
    var XJH_strategyOrderTabV_H = 96
    ///货币name
    var ok_currencyName_Btn : UIButton!
    ///货币价格¥
    var ok_currencyPrice_Lab : UILabel!
    ///交易对
    var ok_TransactionPair_Lab : UILabel!
    ///top line
    var ok_topline : UIView!
    ///bibi交易参数view
    var ok_CoinTransactionParam_View : XJH_Okex_CoinCoinParamView!
    ///futures交易参数
    var ok_FuturesParam_View : XJH_Okex_FuturesParamView!
    ///交易深度 VIew
    var ok_TransactionDepth_View : XJH_Okex_TransactionDepth!
    ///当前委托
    var ok_ComissionLab : UILabel!
    ///全部委托
    var ok_allComissionBtn : UIButton!
    ///委托策略 列表
    var XJH_strategyOrderTabV : XJH_Okex_CurrencyPairTV!
    
    //
    var mark  = Okex_TransactionType.coinCoin
    
    func markIsCoinCoin()->Bool {
        if mark == .coinCoin {
            return true
        }
        return false
    }
    
    override func initXJHView(parmas: ViewDataObject) {
        
        self.backgroundColor = XJHMainColor
        
        mark = parmas.datas as! Okex_TransactionType
        
        ///创建UI
        xjh_pri_CreatUI()
        ///添加约束
        xjh_Pri_addConstraint()
        
    }
    
    func xjh_Pri_addConstraint(){
        
        let wid_2 = SCREEN_WIDTH/2
        
        ok_currencyName_Btn.snp.makeConstraints { (ma) in
            ma.left.equalTo(leftMargin_CP)
            ma.top.equalTo(8)
            ma.height.equalTo(XJHHeight_ButSecond())
        }
        
        ok_currencyPrice_Lab.snp.makeConstraints { (ma) in
            ma.right.equalTo(-leftMargin_CP)
            ma.top.equalTo(ok_currencyName_Btn.snp.top)
            ma.height.equalTo(ok_currencyName_Btn)
        }
        
        ok_TransactionPair_Lab.snp.makeConstraints { (ma) in
            ma.right.equalTo(ok_currencyPrice_Lab.snp.left).offset(-6)
            ma.top.equalTo(ok_currencyName_Btn.snp.top)
            ma.height.equalTo(ok_currencyName_Btn)
        }
        
        
        ok_topline.snp.makeConstraints { (ma) in
            ma.left.right.equalToSuperview()
            ma.height.equalTo(1)
            ma.top.equalTo(ok_currencyName_Btn.snp.bottom).offset(8)
        }
        
        //分隔栏view
        let lineView = UIView()
        lineView.backgroundColor = XJHBackgroundColor_dark
        self.addSubview(lineView)
        
        
        
        if markIsCoinCoin() {
            
            ok_CoinTransactionParam_View.snp.makeConstraints { (ma) in
                ma.left.equalTo(leftMargin_CP)
                ma.top.equalTo(ok_topline.snp.bottom).offset(xjhHeight_MarginMin())
                ma.width.equalTo(wid_2)
                ma.bottom.equalTo(ok_CoinTransactionParam_View.ok_Trasaction_Btn.snp.bottom).offset(xjhHeight_MarginMin())
            }
            
            lineView.snp.makeConstraints { (ma) in
                ma.left.right.equalToSuperview()
                ma.height.equalTo(xjhHeight_MarginMin())
                ma.top.equalTo(ok_CoinTransactionParam_View.snp.bottom).offset(xjhHeight_MarginMin())
            }
            
        }else{
            
            ok_FuturesParam_View.snp.makeConstraints { (ma) in
                ma.left.equalTo(leftMargin_CP)
                ma.top.equalTo(ok_topline.snp.bottom).offset(xjhHeight_MarginMin())
                ma.width.equalTo(wid_2 - leftMargin_CP)
                ma.bottom.equalTo(ok_FuturesParam_View.canBytSell_lab.snp.bottom).offset(xjhHeight_MarginMin())
            }
            
            lineView.snp.makeConstraints { (ma) in
                ma.left.right.equalToSuperview()
                ma.height.equalTo(xjhHeight_MarginMin())
                ma.top.equalTo(ok_FuturesParam_View.snp.bottom).offset(xjhHeight_MarginMin())
            }
        }
        
        ok_ComissionLab.snp.makeConstraints { (ma) in
            ma.left.equalTo(leftMargin_CP)
            ma.top.equalTo(lineView.snp.bottom)
            ma.height.equalTo(xjhHeight_Lable())
        }
        
        ok_allComissionBtn.snp.makeConstraints { (ma) in
            ma.right.equalTo(-rightMargin_CP)
            ma.top.height.equalTo(ok_ComissionLab)
        }
        
        ok_TransactionDepth_View.snp.makeConstraints { (ma) in
            ma.left.equalTo(wid_2 + leftMargin_CP)
            ma.top.equalTo(ok_topline.snp.bottom).offset(xjhHeight_MarginMin())
            ma.right.equalToSuperview()
            ma.bottom.equalTo(self.ok_allComissionBtn.snp.top)
        }
        
        
        XJH_strategyOrderTabV.snp.makeConstraints { (ma) in
            ma.top.equalTo(ok_currencyName_Btn.snp.bottom).offset(80)
            ma.left.equalTo(leftMargin_CP)
            ma.width.equalTo(wid_2-2*leftMargin_CP)
            ma.height.equalTo(0.001)
        }
        
        self.snp.updateConstraints { (ma) in
            ma.bottom.equalTo(ok_allComissionBtn)
        }
        
    }
    
    func xjh_pri_CreatUI(){
        //----------------------
        ok_currencyName_Btn = UIButton(Xframe: .zero, title: "---", titleColor: XJHButtonColor_Blue, font: FontBold(font: XJHFontNum_Main() + 4.0), backgroundColor: .clear)
        
        ok_currencyName_Btn.addTarget(self, action: #selector(xjh_currencyNameAction), for: .touchUpInside)
        
        self.addSubview(ok_currencyName_Btn)
        //----------------------
        ok_currencyPrice_Lab = UILabel(Xframe: .zero, text: "---", font: Font(font: XJHFontNum_Max()), textColor: XJHMainTextColor_dark)
        ok_currencyPrice_Lab.backgroundColor = .clear
        self.addSubview(ok_currencyPrice_Lab)
        //----------------------
        ok_TransactionPair_Lab = UILabel(Xframe: .zero, text: "---", font: Font(font: XJHFontNum_Main()), textColor: XJHRedColor)
        ok_TransactionPair_Lab.backgroundColor = .clear
        self.addSubview(ok_TransactionPair_Lab)
        //----------------------
        ok_topline = UIView(frame: .zero)
        ok_topline.backgroundColor = XJHBackgroundColor_dark
        self.addSubview(ok_topline)
        
        
        //----------------------
        if markIsCoinCoin(){
            
            ok_CoinTransactionParam_View = XJH_Okex_CoinCoinParamView.view()
            ok_CoinTransactionParam_View.delegate = self
            self.addSubview(ok_CoinTransactionParam_View)
            
        }else{
            
            ok_FuturesParam_View = XJH_Okex_FuturesParamView.view()
            ok_FuturesParam_View.delegate = self
            self.addSubview(ok_FuturesParam_View)
            
        }
        
        //----------交易深度------------
        ok_TransactionDepth_View = XJH_Okex_TransactionDepth.view()
        ok_TransactionDepth_View.delegate = self
        self.addSubview(ok_TransactionDepth_View)
        
        ok_ComissionLab = UILabel(Xframe: .zero, text: "当前委托", font: Font(font: XJHFontNum_Second()), textColor: XJHMainTextColor_dark, backgroundColor: .clear)
        self.addSubview(ok_ComissionLab)
        
        ok_allComissionBtn = UIButton(Xframe: .zero, title: "全部委托", titleColor: XJHButtonColor_Blue, font: Font(font: XJHFontNum_Main()) )
        ok_allComissionBtn.addTarget(self, action: #selector(XJH_ComissionAction), for: .touchUpInside)
        self.addSubview(ok_allComissionBtn)
        
        //委托策略
        XJH_strategyOrderTabV = XJH_Okex_CurrencyPairTV.view()
        XJH_strategyOrderTabV.delegate = self
        XJH_strategyOrderTabV.xjh_cellHeaderH = 0
        XJH_strategyOrderTabV.backgroundColor = .red
        self.addSubview(XJH_strategyOrderTabV)
        
        XJH_strategyOrderTabV.xjh_updateTableView(datas: ["限价委托","止盈止损"])
        
    }
    
    
    
    ///隐藏显示 委托交易类型
    func xjh_PriShowStraregyTypeTabLisHide(hideBool : Bool){
        
        if hideBool {
            //交易规则点击了。收起来
            UIView.animate(withDuration: 0.3) {
                self.XJH_strategyOrderTabV.snp.updateConstraints { (ma) in
                    ma.height.equalTo(0.001)
                }
                
            }
            
        }else{
            UIView.animate(withDuration: 0.3) {
                self.XJH_strategyOrderTabV.snp.updateConstraints { (ma) in
                    ma.height.equalTo(self.XJH_strategyOrderTabV_H)
                }
            }
        }
        
    }
    
    ///改变策略委托--UI变化
    /// - Parameter isTakeProfit: 是不是止盈止损UI
    func xjh_PubChangeUIWithStraregyIsTakeProfitStopLoss(isTakeProfit : Bool,titleBtn:String){
        
        if mark == .coinCoin {
            
            if isTakeProfit {
                self.ok_CoinTransactionParam_View.StraregyTakePrifileView.isHidden = false
                
                
            }else{
                self.ok_CoinTransactionParam_View.StraregyTakePrifileView.isHidden = true
            }
            self.ok_CoinTransactionParam_View.ok_TradingRules_Btn.setTitle(titleBtn + xjh_down_jian, for: .normal)
            
        }else{
            
            if isTakeProfit {
                self.ok_FuturesParam_View.StraregyTakePrifileView.isHidden = false
                
            }else{
                self.ok_FuturesParam_View.StraregyTakePrifileView.isHidden = true
                
            }
            
            self.ok_FuturesParam_View.ok_TradingRules_Btn.setTitle(titleBtn + xjh_down_jian, for: .normal)
        }
        
    }
    
    //--------------点击事件处理----------------------
    func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
        
        
        if eventObject.event_CodeType == OkexPageAction.xjh_transactionPairTab.rawValue{
            //判断限价 还是止盈止损
            let itemStr : String = eventObject.params as! String
            if itemStr == "止盈止损" {
                ///info 变为 止盈止损
                print("/info 变为 止盈止损")
                XJH_StrategyType = .type_TakeProfitStopLoss
                self.xjh_PubChangeUIWithStraregyIsTakeProfitStopLoss(isTakeProfit: true, titleBtn: itemStr)
            }else {
                print("info 变为 正常限价交易")
                XJH_StrategyType = .type_normal
                self.xjh_PubChangeUIWithStraregyIsTakeProfitStopLoss(isTakeProfit: false, titleBtn: itemStr)
            }
            //隐藏列表
            self.xjh_PriShowStraregyTypeTabLisHide(hideBool: true)
            
        }else  if eventObject.event_CodeType == OkexPageAction.xjh_TableViewScrollViewWillBeginDragging.rawValue{
            ///tableView 滑动了
            //隐藏列表
            self.xjh_PriShowStraregyTypeTabLisHide(hideBool: true)
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_TradingRulesBtnAction.rawValue {
            //点击交易规则按钮
            self.xjh_PriShowStraregyTypeTabLisHide(hideBool: false)
            
        }
        
        
        //-------------CoinCoin
        if mark == .coinCoin  {
            if eventObject.event_CodeType == OkexPageAction.xjh_coinCoinBuySellChange.rawValue {
                
                if ok_CoinTransactionParam_View.ok_buy_Btn.isSelected{
                    //买
                    ok_CoinTransactionParam_View.ok_Trasaction_Btn.setTitle("买入", for: .normal)
                }else{
                    ok_CoinTransactionParam_View.ok_Trasaction_Btn.setTitle("卖出", for: .normal)
                }
                
                xjh_Pri_GetCurreSingleAccount()
            }else if eventObject.event_CodeType == OkexPageAction.xjh_TransactionBeginAction.rawValue{
                //触发交易
                XJH_CoinCoinExChangeTransaction()
            }else if eventObject.event_CodeType == OkexPageAction.xjh_TransactionDepthTab.rawValue {
                ///交易深度列表点击
                let array = eventObject.params as! Array<String>
                //设置交易价格 可买卖
                ok_CoinTransactionParam_View.XJH_Pri_canMaiMaiChange(text: array[0])
                
            }
            
            
        }else{
            //-------------Futures
            if eventObject.event_CodeType == OkexPageAction.xjh_TransactionDepthTab.rawValue {
                ///交易深度列表点击
                let array: Array<String> = eventObject.params as! Array<String>
                //设置交易价格 可买卖
                //打开用户交互
                ok_FuturesParam_View.CurrencyPrice_textF.isUserInteractionEnabled = true
                ok_FuturesParam_View.CurrencyPrice_textF.text = array[0]
                
            }else if eventObject.event_CodeType == OkexPageAction.xjh_futuresButtonClick.rawValue{
                
                var openOrder :ok_FuturesOpenOrderType = eventObject.params as! ok_FuturesOpenOrderType
                ///如果是平仓 了
                if !openOrCutOrder {
                    if openOrder == .openLong {
                        openOrder = .stopLong
                    }else{
                        openOrder = .stopShort
                    }
                }
                
                //  触发交易
                XJH_FuturesExChangeTransaction(openOrder:openOrder)
                
            }else if eventObject.event_CodeType == OkexPageAction.xjh_TransactionDepthTab.rawValue {
                ///交易深度列表点击
                let array = eventObject.params as! Array<String>
                //设置交易价格 可买卖
                ok_FuturesParam_View.CurrencyPrice_textF.text = array[0]
                
            }else if eventObject.event_CodeType == OkexPageAction.xjh_futuresLeverageClick.rawValue {
                
                //设置杠杆倍数
                let subVC = XJH_Okex_LeveragePickerVC.init()
                subVC.currentLeverage = (eventObject.params as! String)
                subVC.underlying =  changeValueToUSD(value:XJH_FuturesCurrentCurrencyModel.underlying)
                subVC.hidesBottomBarWhenPushed = true
                xjh_getTopVC()?.navigationController?.pushViewController(subVC, animated: true)
                
            }
            
        }
    }
    
    //全部委托
    @objc func XJH_ComissionAction(){
        
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_AllComissionAction.rawValue))
        
    }
    ///货币name点击事件
    @objc func xjh_currencyNameAction(){
        
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_currencyNameAction.rawValue))
        
    }
    
    //----------------------------------------------数据处理--------------------
    
    //--------------CoinCOin----------------------
    //刷新基本数据
    func updateCurrencyData(model:XJH_Okex_CoinCoinModel){
        
        ok_currencyName_Btn.setTitle(model.instrument_id, for: .normal)
        ok_TransactionPair_Lab.text = model.last
        ok_CoinTransactionParam_View.CurrencyPrice = model.last
        
    }
    ///获取当前币种的资产
    func xjh_Pri_GetCurreSingleAccount(){
        let arr:Array<String> = ok_currencyName_Btn.titleLabel!.text!.components(separatedBy: "-")
        if arr.count < 1 {
            return
        }
        
        //判断 是买入还是卖出
        //默认卖出
        var currencyStr:String = arr[0]
        
        if ok_CoinTransactionParam_View.ok_buy_Btn.isSelected {
            //买入 查看基础币
            currencyStr = arr[1]
        }
        
        xjh_OkexApiFundAcount.okex_getAccountSingleWallet(currencyPair: currencyStr, blockSuccess: { (mod) in
            ///更新z币种 余额
            self.ok_CoinTransactionParam_View.xjh_Pub_updateData(model: mod)
            
            //
        }) { (err) in
            //            self.xjh_showErrorWithText(text: err.message , view: self.view)
        }
    }
    
    
    ///出发 bibi 交易  --- 限价交易
    func XJH_CoinCoinExChangeTransaction(){
        
        //判断是不是止盈止损交易了
        if XJH_StrategyType == .type_TakeProfitStopLoss{
            //止盈止损交易
            XJH_CoinCoinExChangeStrategyOrders()
            return
        }
        
        ///普通限价交易
        
        let side_buy: Bool = ok_CoinTransactionParam_View.ok_buy_Btn.isSelected
        let price: String = ok_CoinTransactionParam_View.CurrencyPrice_textF.text!
        
        let size: String = ok_CoinTransactionParam_View.TransactuonCount_textF.text!
        
        let instrument_id : String = ok_currencyName_Btn.titleLabel!.text!
        
        xjh_OkexApiCoinCoin.okex_CoinCoinOrders(type_limit: true, price: price, size: size, market_notional: "", side_buy: side_buy, instrument_id: instrument_id, order_type: .limit, blockSuccess: { (mod) in
            
            XJHProgressHUD.showSuccess(message: "下单成功")
            //刷新列表
            self.sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_OrdersSuccessUpListAction.rawValue))
            
        }) { (err) in
            
            XJHProgressHUD.showError(message: err.message)
        }
        
    }
    
    /// 止盈止损 交易
    func XJH_CoinCoinExChangeStrategyOrders(){
        
        let side_buy: Bool = ok_CoinTransactionParam_View.ok_buy_Btn.isSelected
        //触发 价格
        let triggerPrice: String = ok_CoinTransactionParam_View.StraregytriggerPrice_textF.text!
        //委托价格
        let StraregyPrice: String = ok_CoinTransactionParam_View.StraregyPrice_textF.text!
        //交易量
        let size: String = ok_CoinTransactionParam_View.StraregyCount_textF.text!
        
        let instrument_id : String = ok_currencyName_Btn.titleLabel!.text!
        
        xjh_OkexApiCoinCoin.okex_CoinCoinStrategyOrders(order_type:XJH_StrategyType,instrument_id: instrument_id, sideBuy: side_buy, size: size, trigger_price: triggerPrice, algo_price: StraregyPrice, blockSuccess: { (mod) in
            XJHProgressHUD.showSuccess(message: "下单成功")
            
        }) { (err) in
            
            XJHProgressHUD.showError(message: err.message)
            
        }
    }
    
    //--------------Futures----------------------
    ///判断杠杆倍数是否越界了
    func XJH_FuturesLeverageIsHigh() ->ObjCBool{
        
        //判断设定杠杆倍数 与 管理倍数
        let lecerageNum:Int = self.ok_FuturesParam_View.ok_leverageNum
        
        if lecerageNum > Int(XJH_UserModel.sharedInstance.leverageMax){
            
            BaseAlertController.showAlertOneAction(message: "当前杠杆倍数大于管理设定上限，必须调节杠杆倍数", vc: xjh_getTopVC()!) {
                
                let subVC = XJH_Okex_LeveragePickerVC.init()
                subVC.currentLeverage = "\(lecerageNum)"
                subVC.underlying =  changeValueToUSD(value:self.XJH_FuturesCurrentCurrencyModel.underlying)
                subVC.hidesBottomBarWhenPushed = true
                xjh_getTopVC()?.navigationController?.pushViewController(subVC)
            }
            
            return true
        }
        
        return false
    }
    
    ///出发 Futures交易
    func XJH_FuturesExChangeTransaction(openOrder:ok_FuturesOpenOrderType){
        
        //对比杠杆倍数 和管理的
        if XJH_FuturesLeverageIsHigh().boolValue {
            return
        }
        
        //判断是不是止盈止损交易了
        if XJH_StrategyType == .type_TakeProfitStopLoss{
            //止盈止损交易
            XJH_CoinCoinExChangeStrategyOrders(openOrder: openOrder)
            return
        }
        
        //市价交易 用户没有给出价格的情况下 默认 当前价格 计算张数
        var price: String = ok_FuturesParam_View.CurrencyPrice_textF.text!
        
        if ok_FuturesParam_View.match_price == "1" {
            price =  ok_TransactionPair_Lab.text!
        }
        
        let size: String = ok_FuturesParam_View.TransactuonCount_textF.text!
        
        //转变张数
        let sizeC = Okex_FuturesCoinNumToSheet(price: price, numCoin: size, futuresName: instrument_id_root)
        
        xjh_OkexApiFutures.okex_FuturesOpenOrder(instrument_id: changeValueToUSD(value:instrument_id_root), type: openOrder, order_type: .limit, price: price, size: sizeC, match_price: ok_FuturesParam_View.match_price, blockSuccess: { (mod) in
            
            DispatchQueue.main.async(execute: {
                
                XJHProgressHUD.showSuccess(message: "下单成功")
                //刷新可开仓数
                self.XJH_Pri_FuturesGetCurreSingleAccount()
            })
            
        }) { (err) in
            
            XJHProgressHUD.showError(message: err.message)
            
        }
        
    }
    
    //止盈止损交易
    func XJH_CoinCoinExChangeStrategyOrders(openOrder:ok_FuturesOpenOrderType){
        
        //触发价格
        let trigger_price: String = ok_FuturesParam_View.StraregytriggerPrice_textF.text!
        //委托价格
        let algo_price: String = ok_FuturesParam_View.StraregyPrice_textF.text!
        
        let size: String = ok_FuturesParam_View.StraregyCount_textF.text!
        
        let sizeC = Okex_FuturesCoinNumToSheet(price: algo_price, numCoin: size, futuresName: instrument_id_root)
        
        xjh_OkexApiFutures.okex_FuturesOrderStraregy(instrument_id: changeValueToUSD(value:instrument_id_root), type: openOrder, order_type: XJH_StrategyType, trigger_price: trigger_price, algo_price: algo_price, size: sizeC, blockSuccess: { (mod) in
            
            DispatchQueue.main.async(execute: {
                
                XJHProgressHUD.showSuccess(message: "下单成功")
                
            })
            
        }) { (err) in
            XJHProgressHUD.showError(message: err.message)
        }
        
    }
    ///更新交易对。价格
    func XJH_FuturesUpdateCurrencyData(model:XJH_OkexFuturesTicker){
        
        ok_TransactionPair_Lab.text = model.last
    }
    ///获取当前币种的资产
    func XJH_Pri_FuturesGetCurreSingleAccount(){
        
        if openOrCutOrder {
            //开仓
            xjh_OkexApiFundAcount.okex_getFuturesAccountSingleWallet(currencyPair: changeValueToUSD(value:XJH_FuturesCurrentCurrencyModel.underlying), blockSuccess: { (mod) in
                //更新z币种 余额
                DispatchQueue.main.async(execute: {
                    self.ok_FuturesParam_View.xjh_Pub_updateData(model: mod, canByBuySell_num:dataCalculationAndAfter(beforeStr: mod.equity, theWay: .type_subtraction, afterStr: mod.margin_frozen) ,leverage:self.XJH_FuturesLeverageModel.leverage)
                })
                
            }, blockError: { (err) in
                DispatchQueue.main.async(execute: {
                    XJHProgressHUD.showError(message: "当前币种的资产"+err.message)
                    
                })
            })
            
        }else{
            
            //平仓
            xjh_OkexApiFutures.okex_FuturesePosition(instrument_id: instrument_id_root, blockSuccess: { (mod) in
                
                DispatchQueue.main.async(execute: {
                    
                    if mod.holding.count < 1 {
                        ///🈳️：持仓  可平仓
                        self.ok_FuturesParam_View.availabelLab_one.text = " 可平\n 0 "
                        self.ok_FuturesParam_View.canBytBuy_lab.text = " 持仓\n 0 "
                        
                        ///多： 持仓。可平
                        self.ok_FuturesParam_View.availabelLab_Two.text = " 可平\n 0 "
                        self.ok_FuturesParam_View.canBytSell_lab.text = " 持仓\n 0 "
                        return
                    }
                    
                    self.positionModel_1 = mod.holding.first!
                    let coinStr = self.positionModel_1.instrument_id
                    ///🈳️：持仓  可平仓
                    self.ok_FuturesParam_View.availabelLab_one.text = " 可平\n\(Okex_FuturesSheetsToCoinNums(price: self.positionModel_1.last, sheets: self.positionModel_1.short_avail_qty, futuresName: coinStr)) "
                    self.ok_FuturesParam_View.canBytBuy_lab.text = " 持仓\n\(Okex_FuturesSheetsToCoinNums(price: self.positionModel_1.last, sheets: self.positionModel_1.short_qty, futuresName: coinStr)) "
                    
                    ///多： 持仓。可平
                    self.ok_FuturesParam_View.availabelLab_Two.text = " 可平\n\(Okex_FuturesSheetsToCoinNums(price: self.positionModel_1.last, sheets: self.positionModel_1.long_avail_qty, futuresName: coinStr)) "
                    self.ok_FuturesParam_View.canBytSell_lab.text = " 持仓\n\(Okex_FuturesSheetsToCoinNums(price: self.positionModel_1.last, sheets: self.positionModel_1.long_qty, futuresName: coinStr)) "
                    
                })
                
            }) { (err) in
                
                XJHProgressHUD.showError(message: "当前币种的资产"+err.message)
                
            }
            
            
        }
        
    }
    
    
    ///获取杠杆倍数
    @objc func XJH_OkexGetFuturesLeverage(){
        
        xjh_OkexApiFutures.okex_FuturesGetOrSetFuturesLeverage(underlying: changeValueToUSD(value:XJH_FuturesCurrentCurrencyModel.underlying), getYes: true, blockSuccess: { (mod) in
            
            ///更新币种交易对 杠杆
            DispatchQueue.main.async(execute: {
                self.XJH_FuturesLeverageModel = mod
                self.XJH_Pri_FuturesGetCurreSingleAccount()
                //设置杠杆倍数
                self.ok_FuturesParam_View.ok_leverageBtn.setTitle(mod.leverage, for: .normal)
            })
            
        }) { (err) in
            XJHProgressHUD.showError(message: "获取杠杆倍数"+err.message)
        }
    }
    
    ///获取刷新交易币 的深度
    func XJH_Pri_FuturesUpdateCurrencyDepth(){
        
        xjh_OkexApiFutures.okex_FuturesDepthDict_Get(currencyName: changeValueToUSD(value:XJH_FuturesCurrentCurrencyModel.instrument_id),size: 5, blockSuccess: { (dictMod) in
            
            //更新交易深度信息
            DispatchQueue.main.async(execute: {
                
                self.ok_TransactionDepth_View.xjh_StrategyupdateTableView(datas: [dictMod as Any],instrument_id:self.instrument_id_root)
            })
            
        }) { (err) in
            
            XJHProgressHUD.showError(message: "交易币的深度"+err.message)
        }
        
        
    }
    
}
