//
//  XJHBasePageViewController.swift
//  ChangeCoin
//
//  Created by mac on 2019/10/24.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit
var okex_isoTime : String = ""
class XJH_OkexPageVC: XJHBaseViewController {
    
    var index :Int = 0
    ///当前页面的定时器
    var pageTimer : Timer!
    ///定时循环次数累计执行
    var addNumWorking: Int = 0
    ///实时获取服务器时间 成功与否
    var timeBool : Bool = false
    
    ///当前显示的交易对
    var xjh_currentCurrencyCode : String = "BTC-USDT"
    ///当前交易对的model
    var XJH_CurrentCurrencyModel : XJH_Okex_CoinCoinModel!
    //------------------------------------
    ///数据列表
    var XJH_orderTabView : XJH_Okex_OrdersTabV!
    ///头视图
    var currencyInfoView : xjh_Okex_transactionTopView!
    /// 期货列表 弹框
    var XJH_CurrencyListView : XJH_Okex_CurrencyListView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if okex_isoTime.count > 0{
            //刷新资金总量
            xjh_GetWalletAccount()
        }
        
        //继续定时器
        if (pageTimer != nil) {
            self.xjh_continueTimer()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //暂停定时器
        self.xjh_puseTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //获取上一次的交易对
        let coincoin = UserDefaults.standard.object(forKey: "coincoin")
        if coincoin != nil {
            xjh_currentCurrencyCode = coincoin as! String
        }
        
        //设置UI
        xjh_Pri_creatUI()
        
        //循环获取 okex时间格式
        okex_StarGetTimereRuning()
        
        //监听获取崩溃通知
        NotificationCenter.default.addObserver(self, selector: #selector(dealwithCrashMessage(none:)), name: NSNotification.Name(rawValue: AvoidCrashNotification), object: nil)
        
        //账户资金
        xjh_createRightButtonItem(title: "账户资金", target: self, action: #selector(xjh_jumpBlancePage))
        
        
        ///当前用户
        xjh_createLeftButtonItem(title: XJH_UserModel.sharedInstance.userName, target: self, action: #selector(self.xjh_PriClickUserName))
        
    }
    
    ///点击了用户名
    @objc func xjh_PriClickUserName(){
        
        BaseAlertController.showAlertSheet(actions: ["账户设置","退出账户","取消"], vc: self, redtypeShow: 1) { (str, tag) in
            if tag == 0 {
                //设置
                self.navigationController?.pushViewController(XJHSetingVC())
                
            }else if tag == 1{
                
                BaseAlertController.showAlertTwoAction(message: "确定要退出该账户吗？", vc: self, FFActionOne: {
                    
                }) {
                    //回到登录页
                    accountIsFreezeToLogined()
                }
                
            }
        }
        
        
    }
    
    //循环访问更新数据，冻结状态。冻结了就切换啊
    @objc func IsFreezeToLogined(){
        
        if addNumWorking == 3 {
            XJH_UserDataTool.XJH_updateUserData()
            addNumWorking = 0
        }else{
            addNumWorking += 1
        }
        
    }
    
    ///每次显示当前页面 开始刷新 资金
    @objc func xjh_GetWalletAccount(){
        
        XJH_AccountLogic.xjh_GetWalletAccount { (wallet) in
            
            if wallet.count > 0 {
                self.xjh_createRightButtonItem(title:"\(XJHSetingShareModel.shareModel.baseCurrency):" + wallet, target: self, action: #selector(self.xjh_jumpBlancePage))
            }else{
                self.xjh_createRightButtonItem(title: "账户资金", target: self, action: #selector(self.xjh_jumpBlancePage))
            }
        }
    }
    ///跳转资金管理页面
    @objc func xjh_jumpBlancePage(){
        self.navigationController?.pushViewController(XJHAccountVC())
        
    }
    
    @objc func dealwithCrashMessage(none:NSNotification){
        //不论在哪个线程中导致的crash，这里都是在主线程
        
        //注意:所有的信息都在userInfo中
        //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
        print("-----------⚠️崩溃---警告⚠️-----------------------------")
        print(none.userInfo as Any)
        
    }
    
    //1s 刷新本页数据
    @objc func XJH_Pri_getDataThisPage(){
        //获取基本数据-
        XJH_Pri_UpdateCurrencyInfo(currencyName:self.xjh_currentCurrencyCode)
        //        ///交易深度
        //        self.XJH_Pri_UpdateCurrencyDepth()
        ///获取当前币种资产
        currencyInfoView.xjh_Pri_GetCurreSingleAccount()
        
        //获取当前币种的未完全成交的e委托XJH_PrigetPendingOrders
        XJH_PrigetPendingOrders(before: "")
    }
    
    func xjh_Pri_creatUI(){
        self.view.backgroundColor = .black
        
        
        XJH_orderTabView = XJH_Okex_OrdersTabV.view()
        XJH_orderTabView.delegate = self
        self.view.addSubview(XJH_orderTabView)
        
        XJH_orderTabView.snp.makeConstraints { (ma) in
            ma.edges.equalToSuperview()
        }
        
        
        currencyInfoView = xjh_Okex_transactionTopView.view(parmas: ViewDataObject.viewData(Okex_TransactionType.coinCoin))
        currencyInfoView.delegate = self
        XJH_orderTabView.tableView?.tableHeaderView = currencyInfoView
        
        currencyInfoView.snp.makeConstraints { (ma) in
            ma.left.width.right.top.equalToSuperview()
            ma.bottom.equalTo(currencyInfoView.ok_allComissionBtn.snp.bottom)
        }
        
        XJH_CurrencyListView = XJH_Okex_CurrencyListView.view()
        XJH_CurrencyListView.XJH_currencyListTab.delegate = self
        self.view.addSubview(XJH_CurrencyListView)
        XJH_CurrencyListView.snp.makeConstraints { (ma) in
            ma.top.equalTo(45)
            ma.left.right.equalToSuperview()
            ma.bottom.equalToSuperview()
        }
        XJH_CurrencyListView.isHidden = true
        
        
    }
    
    
    //---------------处理点击事件---------------------
    
    override func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
        
        if eventObject.event_CodeType == xjh_PullDown {
            //刷新列表
            XJH_Pri_getDataThisPage()
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_currencyNameAction.rawValue {
            //期货名字点击事件\
            XJH_CurrencyListView.xjh_PriShowOrhideCurrencyList(showV: true)
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_transactionListTab.rawValue {
            
            ///货币列表点击事件
            self.xjh_currentCurrencyCode = eventObject.params as! String
            //保存
            UserDefaults.standard.set(self.xjh_currentCurrencyCode, forKey: "coincoin")
            
            ///刷新当前交易对
            XJH_Pri_UpdateCurrencyInfo(currencyName: self.xjh_currentCurrencyCode)
            ///隐藏交易对列表
            XJH_CurrencyListView.xjh_PriShowOrhideCurrencyList(showV: false)
            //获取单个币种账户信息
            self.currencyInfoView.xjh_Pri_GetCurreSingleAccount()
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_ListCancelSingleOrder.rawValue {
            let mod = eventObject.params as! XJH_Okex_CoinCoinOrdersModel
            
            xjh_OkexApiCoinCoin.okex_CoinCoinCancel_Order(order_id: mod.order_id, instrument_id: mod.instrument_id, blockSuccess: { (cancelMod) in
                
                if cancelMod.result {
                    
                    self.xjh_showSuccess_Text(text: "撤单成功", view: self.view)
                }else{
                    self.xjh_showError_Text(text: cancelMod.error_code + cancelMod.error_message , view: self.view)
                }
                
                
            }) { (err) in
                self.xjh_showError_Text(text: err.message , view: self.view)
            }
            
        }else  if eventObject.event_CodeType == OkexPageAction.xjh_AllComissionAction.rawValue{
            
            //跳转全部委托列表
            let subVC = XJH_OkexCoinStraregyOrderVC.init()
            subVC.hidesBottomBarWhenPushed = true
            subVC.xjh_currentCurrencyCode = xjh_currentCurrencyCode
            self.navigationController?.pushViewController(subVC, animated: true)
            
            
        }else  if eventObject.event_CodeType == OkexPageAction.xjh_OrdersSuccessUpListAction.rawValue{
            
            //下单成功刷新列表
            self.XJH_PrigetPendingOrders(before:"")
        }
        
        
        
    }
    /// //------------------------------更新数据
    /////mark ------------------------------获取数据
    
    //////获取未成交的委托
    func XJH_PrigetPendingOrders(before:String){
        
        xjh_OkexApiCoinCoin.okex_CoinCoinGetOrders_Get(state: .pending, instrument_id: xjh_currentCurrencyCode, limit: "200", blockSuccess: { (mds) in
            
            //            if mds.count > 0{
            //                self.XJH_orderTabView.tableView?.set(loadType: .normal)
            //            }else{
            //                self.XJH_orderTabView.tableView?.set(loadType: .noData)
            //            }
            
            self.XJH_orderTabView.xjh_updateTableView(datas: mds)
            
        }) { (err) in
            
            self.XJH_orderTabView.endRefresh()
            //            self.XJH_orderTabView.tableView?.set(loadType: .noData)
        }
        
    }
    
    //获取交易币的 信息
    func XJH_Pri_UpdateCurrencyInfo(currencyName : String){
        
        xjh_OkexApiCoinCoin.okex_Pub_GerInstrumentsTicker(currencyName: xjh_currentCurrencyCode, blockSuccess: { (mod) in
            
            self.XJH_CurrentCurrencyModel = mod
            //更新基本信息
            self.currencyInfoView.updateCurrencyData(model:self.XJH_CurrentCurrencyModel)
        }) { (err) in
            
            //            self.xjh_showErrorWithText(text: err.message , view: self.view)
            
        }
    }
    ///及时刷新交易币 的深度 ----短-循环♻️
    @objc func XJH_Pri_UpdateCurrencyDepth(){
        
        print("----=--短循环--币币-交易深度")
        
        xjh_OkexApiCoinCoin.okex_Pub_GerInstrumentsDepthData(currencyName: xjh_currentCurrencyCode, blockSuccess: { (dict) in
            
            let mod = XJH_Okex_CoinTransactionDepthModel.deserialize(from: dict)
            
            //更新交易深度信息
            self.currencyInfoView.ok_TransactionDepth_View.xjh_updateTableView(datas: [mod as Any])
            
        }) { (err) in
            //            self.xjh_showErrorWithText(text: err.message , view: self.view)
        }
        
        
    }
    
    ///循环获取 okex时间格式--ISO8601标准的时间格式
    func okex_StarGetTimereRuning(){
        xjh_HUDShow()
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
        
        ///0.3循环请求交易深度 ///交易深度
        pageTimer = Timer.scheduledTimer(timeInterval: getShortTime, target: self, selector: #selector(XJH_Pri_UpdateCurrencyDepth), userInfo: nil, repeats: true)
        
        //开始计时器
        pageTimer.fire()
        
        //1s 循环请求 服务器时间、、本页数据
        TimereRuning()
    }
    ///暂停定时器
    func xjh_puseTimer(){
        pageTimer.fireDate = Date.distantFuture
    }
    ///继续执行定时器
    func xjh_continueTimer(){
        pageTimer.fireDate = Date.init()
        pageTimer.fireDate = Date.distantPast
    }
    
    ///长循环♻️
    @objc func TimereRuning(){
        
        ///获取本页数据
        self.XJH_Pri_getDataThisPage()
        
        //循环访问冻结状态。冻结了就切换啊
        IsFreezeToLogined()
        
        XJH_OkExTool().okex_getGeneralTime(blockSuccess: { (str) in
            
            print("----=-----------------------长循环-获取服务器时间--本页数据")
            
            self.xjh_hideHUD()
            okex_isoTime = str
            self.perform(#selector(self.TimereRuning), with: nil, afterDelay: getLongTime)
            
            if !self.timeBool {
                //首次成功/ 上一次是失败的。执行
                //                self.xjh_showSuccessWithText(text: "获取时间成功", view: self.view)
                self.xjh_GetWalletAccount()
                
                self.timeBool = true
            }
            
        }) { (err) in
            
            self.timeBool = false
            self.xjh_showError_Text(text: err.message , view: self.view)
            
            self.perform(#selector(self.TimereRuning), with: nil, afterDelay: getLongTime)
        }
        
    }
    
}
