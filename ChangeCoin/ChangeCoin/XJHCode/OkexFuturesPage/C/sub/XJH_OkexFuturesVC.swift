//
//  XJH_OkexFuturesVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit


protocol XJH_OkexFuturesVCPushVCDelegate {
    func XJH_OkexFuturesVCPushAction(vc:XJHBaseViewController)
}

class XJH_OkexFuturesVC: XJHBaseViewController {
    
    ///当前交易对的model
    var XJH_FuturesCurrencyModel : XJH_OkexFuturesTicker!
    ///合约信息
    var XJH_OkexFuturesInstrumentsArray : [XJH_OkexFuturesListInstrumentsModel] = []
    ///定时刷新
    var  FuturesTimer : Timer!
    var FuturesDelegate : XJH_OkexFuturesVCPushVCDelegate!
    ///订单tableview
    var XJH_FuturesOrderTabView : XJH_Okex_OrdersTabV!
    ///header 信息数据
    var XJH_FuturescurrencyInfoView : xjh_Okex_transactionTopView!
    /// 期货列表 弹框 XJH_Okex_FuturesListView
    var XJH_FuturesCurrencyListView : XJH_Okex_FuturesListTV!
    ///
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        xjh_Pri_creatUI()
        ///前台 后台
        ///获取合约信息---启动第一次 获取一次就可以
        XJH_Pri_GetOnceData()
        
        ///交易信息 修改为 期货
        XJH_FuturescurrencyInfoView.mark = .futures
        
        //添加-期货交易对变化 通知
        NotificationCenter.default.addObserver(self, selector: #selector(XJH_OkexUpdateLoadDataChangeName), name: NSNotification.Name(rawValue: Okex_NotificationAction.noti_ChangeFutureName.rawValue), object: nil)
        
        //杠杆倍数发生了变化
        NotificationCenter.default.addObserver(self, selector: #selector(XJH_OkexGetFuturesLeverage), name: NSNotification.Name(rawValue: Okex_NotificationAction.noti_ChangeFuturesLeverage.rawValue), object: nil)
        
    }
    
    @objc func XJH_OkexGetFuturesLeverage(){
        XJH_FuturescurrencyInfoView.XJH_OkexGetFuturesLeverage()
    }
    //一次性获取
    @objc func XJH_Pri_GetOnceData(){
        
        ///获取期货信息
        xjh_OkexApiFutures.okex_Pub_GerFuturesInstrumentsList(blockSuccess: { (mods) in
            
            DispatchQueue.main.async(execute: {
                
                if mods.count < 1 {
                    self.perform(#selector(self.XJH_Pri_GetOnceData), with: nil, afterDelay: 0.2)
                    return
                }
                self.XJH_OkexFuturesInstrumentsArray = mods
                //首次选择数组第一个 进行name 赋值
                self.XJH_Pri_FuturesUpdatTabListAndNameData()
                
                ///不放在最后会造成提前请求 崩溃
                if self.XJH_FuturescurrencyInfoView.openOrCutOrder {
                    //当前是开仓页面
                    //给viewWillDisappear 挂通知
                    NotificationCenter.default.addObserver(self, selector: #selector(self.xjh_viewTimerContinueIsTrue(note:)), name: NSNotification.Name(rawValue: pageNotifaca_open), object: nil)
                }
                
            })
            
        }) { (err) in
            self.xjh_showError_Text(text: err.message , view: self.view)
        }
        
        //--------------获取杠杆倍数----------------------
        
    }
    
    ///设置可交易类型 账户模式
    func XJH_Okex_SetAllFuturesAccountModel(futures:Array<String>){
        
        XJHFuturesTool.Okex_SetAllFuturesMargin_mode(futures:futures)
    }
    
    //刷新 弹窗和 name
    func XJH_Pri_FuturesUpdatTabListAndNameData(){
        
        //更新期货列表弹窗
        let listmods: Array<Any> = XJH_UserModel.sharedInstance.futures
        
        XJH_Okex_SetAllFuturesAccountModel(futures: listmods as! Array<String>)
        self.XJH_FuturesCurrencyListView.xjh_updateTableView(datas: listmods)
        
        
        //选定 期货种类
        //1判断原来保存的是否有值
        XJH_FuturescurrencyInfoView.instrument_id_root = UserDefaults.standard.object(forKey: okex_futures_key) as? String ?? ""
        
        if XJH_FuturescurrencyInfoView.instrument_id_root.count > 0 {
            //有值用之前选定的
            XJH_FuturescurrencyInfoView.XJH_FuturesCurrentCurrencyModel = XJH_Okex_FuturesNameReturnFuturesInfoModel(instrument_id: XJH_FuturescurrencyInfoView.instrument_id_root, modArr: XJH_OkexFuturesInstrumentsArray)
            
        }else{
            //没有保存。第一次启动了就 默认第一个
            ///修改name
            XJH_FuturescurrencyInfoView.XJH_FuturesCurrentCurrencyModel = XJH_OkexFuturesInstrumentsArray[0]
            
            UserDefaults.standard.set(XJH_FuturescurrencyInfoView.XJH_FuturesCurrentCurrencyModel.instrument_id, forKey: okex_futures_key)
        }
        
        ///刷新交易对信息
        XJH_OkexUpdateLoadDataChangeName()
        ///j开始计时器
        okex_StarGetFuturesRuning()
        ///
        
    }
    
    //添加-期货交易对变化 通知
    @objc func XJH_OkexUpdateLoadDataChangeName(){
        XJH_FuturescurrencyInfoView.ok_currencyName_Btn.setTitle(XJH_Okex_FuturesreturnFuturesNameFormatStr(mod: XJH_FuturescurrencyInfoView.XJH_FuturesCurrentCurrencyModel), for: .normal)
        
        ///刷新当前交易对
        XJH_Pri_FuturesgetDataThisPage()
        
        //刷新杠杆g倍数---》//持仓数变化
        XJH_FuturescurrencyInfoView.XJH_OkexGetFuturesLeverage()
        
        if XJH_FuturescurrencyInfoView.openOrCutOrder {
            print("======开- 交易对变化 -仓======")
        }else{
            print("======平- 交易对变化 -仓======")
        }
    }
    
    ///短循环♻️--
    @objc func XJH_Pri_ShortTimeGetWorking(){
        ///交易深度
        self.XJH_FuturescurrencyInfoView.XJH_Pri_FuturesUpdateCurrencyDepth()
        print("----=--短循环--合约-交易深度")
    }
    
    ///长循环♻️循环刷新本页数据
    @objc func XJH_Pri_FuturesgetDataThisPage(){
        
        //获取基本数据-
        XJH_Pri_FuturesUpdateCurrencyInfo(currencyName:changeValueToUSD(value:self.XJH_FuturescurrencyInfoView.XJH_FuturesCurrentCurrencyModel.instrument_id))
        
        //获取当前币种的未完全成交的e委托XJH_PrigetPendingOrders
        XJH_Pri_FuturesgetPendingOrders()
        
        self.perform(#selector(XJH_Pri_FuturesgetDataThisPage), with: self, afterDelay: getLongTime)
        
        print("----=------------------------长循环--合约-本页")
        if XJH_FuturescurrencyInfoView.openOrCutOrder {
            print("======开-  -仓======")
        }else{
            print("======---平-  -仓======")
        }
    }
    
    //传递事件
    override func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
        
        if eventObject.event_CodeType == xjh_PullDown {
            
            //刷新列表
            //获取当前币种的未完全成交的e委托XJH_PrigetPendingOrders
            self.XJH_Pri_FuturesgetDataThisPage()
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_currencyNameAction.rawValue {
            //期货名字点击事件\
            self.XJH_FuturesCurrencyListView.XJH_futuresOperatorTabHide(show: true)
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_transactionListTab.rawValue {
            
            ///货币列表点击事件
            let listReturn :FutureListPairRuturn = eventObject.params as! FutureListPairRuturn
            
            let mod :XJH_OkexFuturesListInstrumentsModel = XJH_OkexFuturesListInstrumentsModel().getInfoFromArray(array: XJH_OkexFuturesInstrumentsArray, listStruct: listReturn)
            
            ///判断mod 是否值
            if mod.instrument_id.count < 1 {return}
            
            self.XJH_FuturescurrencyInfoView.XJH_FuturesCurrentCurrencyModel = mod
            self.XJH_FuturescurrencyInfoView.instrument_id_root = mod.instrument_id
            self.XJH_FuturescurrencyInfoView.ok_currencyName_Btn.setTitle(XJH_Okex_FuturesreturnFuturesNameFormatStr(mod: mod), for: .normal)
            
            UserDefaults.standard.set(mod.instrument_id, forKey: okex_futures_key)
            //更换币种 刷新
            XJH_OkexUpdateLoadDataChangeName()
            
            //发送通知
            NotificationCenter.default.post(name: NSNotification.Name(Okex_NotificationAction.noti_ChangeFutureName.rawValue), object: nil)
            
            //            ///隐藏交易对列表
            self.XJH_FuturesCurrencyListView.XJH_futuresOperatorTabHide(show: false)
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_ListCancelSingleOrder.rawValue {
            let mod : XJH_OkexFuturesOldOrderModel = eventObject.params as! XJH_OkexFuturesOldOrderModel
            
            xjh_OkexApiFutures.okex_FututresCancel_Order(order_id: mod.order_id, instrument_id: mod.instrument_id, blockSuccess: { (mod) in
                
                DispatchQueue.main.async(execute: {
                    self.xjh_showSuccess_Text(text: "撤单成功", view: self.view)
                    //刷新币的持仓 可开数量
                    self.XJH_OkexUpdateLoadDataChangeName()
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
            subVC.XJH_OkexFuturesInstrumentsArray = XJH_OkexFuturesInstrumentsArray
            self.FuturesDelegate.XJH_OkexFuturesVCPushAction(vc: subVC)
            
        }
    }
    /// //-------------------------
    ///更新交易对
    func XJH_Pri_ChangeCoinTranslation(){
        
    }
    
    /////mark ------------------------------获取数据
    //////获取未成交的委托
    func XJH_Pri_FuturesgetPendingOrders(){
        
        xjh_OkexApiFutures.okex_FuturesOrdersWithState(instrument_id: changeValueToUSD(value:XJH_FuturescurrencyInfoView.XJH_FuturesCurrentCurrencyModel.instrument_id), state: .pending, blockSuccess: { (mods) in
            
            DispatchQueue.main.async(execute: {
                self.XJH_FuturesOrderTabView.xjh_updateTableView(datas: mods)
            })
            
        }, blackError: { (err) in
            self.XJH_FuturesOrderTabView.endRefresh()
            self.xjh_showError_Text(text: err.message, view: self.view)
        })
        
        
        
    }
    
    //获取交易币的 信息
    func XJH_Pri_FuturesUpdateCurrencyInfo(currencyName : String){
        
        xjh_OkexApiFutures.okex_Pub_GerFuturesTicker(instrument_id: currencyName, blockSuccess: { (mod) in
            DispatchQueue.main.async(execute: {
                self.XJH_FuturesCurrencyModel = mod
                //更新交易对。价格
                self.XJH_FuturescurrencyInfoView.XJH_FuturesUpdateCurrencyData(model:mod)
            })
        }) { (err) in
            self.xjh_showError_Text(text: err.message, view: self.view)
        }
    }
    
    //------------------------------------
    ///循环获取 okex时间格式--ISO8601标准的时间格式
    func okex_StarGetFuturesRuning(){
        
        //暂停
        //        timer.fireDate = Date.distantFuture
        //继续
        //        timer.fireDate = NSDate.init() as Date
        //        timer.fireDate = Date.distantPast
        //消除计时器（页面释放是必须调用这个方法，不让会让页面和定时器不会释放）
        //        timer.invalidate()
        //滑动timer失效是添加
        //        RunLoop.current.add(timer, forMode: .commonModes)
        
        //        }
        
        FuturesTimer = Timer.scheduledTimer(timeInterval: getShortTime, target: self, selector: #selector(XJH_Pri_ShortTimeGetWorking), userInfo: nil, repeats: true)
        
        //开始计时器
        FuturesTimer.fire()
    }
    
    ///暂停/开始定时器
    func xjh_puseOrCOintinueTimer(timerContinue:Bool){
        
        if (FuturesTimer != nil){
            if timerContinue {
                FuturesTimer.fireDate = Date.init()
                FuturesTimer.fireDate = Date.distantPast
            }else{
                FuturesTimer.fireDate = Date.distantFuture
            }
        }
        
    }
    ///继续执行定时器
    @objc func xjh_viewTimerContinueIsTrue(note:Notification){
        
        let timerContinue: Bool = note.object as! Bool
        
        if timerContinue {
            //刷新杠杆g倍数
            XJH_FuturescurrencyInfoView.XJH_OkexGetFuturesLeverage()
            
        }
        
        xjh_puseOrCOintinueTimer(timerContinue: timerContinue)
        
      
    }
    
    
    
    //---------------UIUI--Creat---------------------
    func xjh_Pri_creatUI(){
        self.view.backgroundColor = .black
        
        XJH_FuturesOrderTabView = XJH_Okex_OrdersTabV.view()
        XJH_FuturesOrderTabView.delegate = self
        XJH_FuturesOrderTabView.isCoinCoin = false
        XJH_FuturesOrderTabView.currentOrderBool = true
        self.view.addSubview(XJH_FuturesOrderTabView)
        
        XJH_FuturesOrderTabView.snp.makeConstraints { (ma) in
            ma.left.right.equalToSuperview()
            ma.top.equalToSuperview()
            ma.bottom.equalToSuperview().offset(-xjh_TabHeight-xjh_Status_H)
            
        }
        
        
        XJH_FuturescurrencyInfoView = xjh_Okex_transactionTopView.view(parmas: ViewDataObject.viewData(Okex_TransactionType.futures))
        XJH_FuturescurrencyInfoView.delegate = self
        XJH_FuturesOrderTabView.tableView?.tableHeaderView = XJH_FuturescurrencyInfoView
        
        XJH_FuturescurrencyInfoView.snp.makeConstraints { (ma) in
            ma.left.width.right.top.equalToSuperview()
            ma.bottom.equalTo(XJH_FuturescurrencyInfoView.ok_allComissionBtn.snp.bottom)
        }
        
        XJH_FuturesCurrencyListView = XJH_Okex_FuturesListTV.view()
        XJH_FuturesCurrencyListView.delegate = self
        self.view.addSubview(XJH_FuturesCurrencyListView)
        XJH_FuturesCurrencyListView.snp.makeConstraints { (ma) in
            ma.top.equalTo(XJH_FuturescurrencyInfoView.ok_currencyName_Btn.snp.bottom)
            ma.left.right.equalToSuperview()
            ma.bottom.equalToSuperview()
        }
        XJH_FuturesCurrencyListView.alpha = 0
        
    }
    
    
}

