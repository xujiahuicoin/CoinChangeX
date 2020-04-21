//
//  XJH_OkexCoinStraregyOrderVC.swift
//  ChangeCoin
//
//  Created by xujiahui on 2019/11/23.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_OkexCoinStraregyOrderVC: XJHBaseViewController,XJHPageViewDelegate {
    
    ///加载int操作手--okex_header_number。是自己的单子
    var loadIntIndex = okex_header_number
     var titlePage = "全部委托"
    ///获取 当前 、历史 挂单的状态
    var state  = Okex_OrderState.NoSuccess
    var straregyState = ok_futuresOrderStatus.type_loding
    
    ///策略委托 默认-限价
    var XJH_StrategyType :Okex_StrategyOrderType = .type_normal
    ///当前显示的交易对
    var xjh_currentCurrencyCode : String = "BTC-USDT"
    ///当前交易对的model
    var XJH_CurrentCurrencyModel : XJH_Okex_CoinCoinModel!
    //------------------------------------
    /// 期货列表 弹框
    var XJH_CurrencyListView : XJH_Okex_CurrencyListView!
    ///数据列表
    var XJH_orderTabView : XJH_Okex_OrdersTabV!
    var XJH_topPageView: XJHPageView!
    var xjh_futuresNameBtn : UIButton!
    var xjh_futuresOrderStraregyBtn : UIButton!
    var xjh_futuresOrderListBtn : UIButton!
    
    /// 期货列表 弹框
    // var XJH_CurrencyListView : XJH_Okex_CurrencyListView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titlePage
        // Do any additional setup after loading the view.
        self .XJH_PriCreatUI()
        XJH_PrigetPendingOrders()
    }
    
    func XJH_PriCreatUI(){
        
        XJH_topPageView = XJHPageView(frame: .zero)
        XJH_topPageView.delegate = self
        XJH_topPageView.buttonNormalColor = XJHSecondTextColor
        XJH_topPageView.buttonSelectedColor = XJHButtonColor_Blue
        XJH_topPageView.xjh_LineColor = XJHButtonColor_Blue
        XJH_topPageView.updatePageView(titles: ["当前委托","历史委托"],currentIndex: 0)
        
        self.view.addSubview(XJH_topPageView)
        XJH_topPageView.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalToSuperview()
            ma.width.equalToSuperview()
            ma.height.equalTo(XJHHeight_ButMain())
        }
        
        
        let leftjian:CGFloat = 10.0
        let widBtn = (SCREEN_WIDTH - leftjian*4.0)/3
        let heiBtn = 30
        let topjian = 10
        xjh_futuresNameBtn = UIButton(Xframe: .zero, title: xjh_currentCurrencyCode.replacingOccurrences(of: "-USD-", with: "-"), titleColor: XJHMainTextColor_dark, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHBackgroundColor_dark, cornerRadius: 4, borderWidth: 0.5, borderColor: XJHButtonColor_Blue)
        
        
        xjh_futuresNameBtn.tag = 100
        xjh_futuresNameBtn.addTarget(self, action: #selector(xjh_PributtonAction), for: .touchUpInside)
        self.view.addSubview(xjh_futuresNameBtn)
        xjh_futuresNameBtn.snp.makeConstraints { (ma) in
            ma.left.equalTo(leftjian)
            ma.top.equalTo(XJH_topPageView.snp.bottom).offset(topjian)
            ma.width.equalTo(widBtn)
            ma.height.equalTo(heiBtn)
        }
        
        xjh_futuresOrderStraregyBtn = UIButton(Xframe: .zero, title: "限价交易", titleColor: XJHMainTextColor_dark, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHButtonColor_Blue, cornerRadius: 4, borderWidth: 0.5, borderColor: XJHMainTextColor_dark)
        //防止连续点击时间
        xjh_futuresOrderStraregyBtn.eventInterval = btnTimeInterval_long
        xjh_futuresOrderStraregyBtn.tag = 101
        xjh_futuresOrderStraregyBtn.addTarget(self, action: #selector(xjh_PributtonAction), for: .touchUpInside)
        self.view.addSubview(xjh_futuresOrderStraregyBtn)
        xjh_futuresOrderStraregyBtn.snp.makeConstraints { (ma) in
            ma.left.equalTo(xjh_futuresNameBtn.snp.right).offset(leftjian)
            ma.top.equalTo(xjh_futuresNameBtn.snp.top)
            ma.width.equalTo(widBtn)
            ma.height.equalTo(heiBtn)
        }
        
        xjh_futuresOrderListBtn = UIButton(Xframe: .zero, title: "止盈止损", titleColor: XJHMainTextColor_dark, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHMainColor, cornerRadius: 4, borderWidth: 0.5, borderColor: XJHMainTextColor_dark)
        xjh_futuresOrderListBtn.tag = 102
        xjh_futuresOrderListBtn.addTarget(self, action: #selector(xjh_PributtonAction), for: .touchUpInside)
        self.view.addSubview(xjh_futuresOrderListBtn)
        xjh_futuresOrderListBtn.snp.makeConstraints { (ma) in
            ma.left.equalTo(xjh_futuresOrderStraregyBtn.snp.right).offset(leftjian)
            ma.top.equalTo(xjh_futuresNameBtn.snp.top)
            ma.width.equalTo(widBtn)
            ma.height.equalTo(heiBtn)
        }
        
        
        XJH_orderTabView = XJH_Okex_OrdersTabV.view()
        XJH_orderTabView.delegate = self
        self.view.addSubview(XJH_orderTabView)
        
        XJH_orderTabView.snp.makeConstraints { (ma) in
            ma.top.equalTo(xjh_futuresOrderListBtn.snp.bottom).offset(10)
            ma.left.width.bottom.equalToSuperview()
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
    
    ///当前 和 历史交替
    func pageView(_ pageView: XJHPageView, didSelectIndexAt index: Int) {
        
        if index == 0 {
            //当前
            XJH_orderTabView.currentOrderBool = true
            
            state = .NoSuccess
            straregyState = .type_loding
        }else if index == 1 {
            //历史
            XJH_orderTabView.currentOrderBool = false
            
            state = .allDeal
            straregyState = .type_success
        }
        
        //刷新列表
        XJH_PrigetPendingOrders()
    }
    
    ///限价和策略交替
    @objc func xjh_PributtonAction(btn:UIButton){
        
        if btn.tag == 100{
            //name
            //显示 bi种列表
            XJH_CurrencyListView.xjh_PriShowOrhideCurrencyList(showV: true)
            return
            
        }else if btn.tag == 101 {
            //限价
            XJH_StrategyType = .type_normal
            xjh_futuresOrderStraregyBtn.backgroundColor = XJHButtonColor_Blue
            xjh_futuresOrderListBtn.backgroundColor = XJHMainColor
        }else{
            //止盈止损
            XJH_StrategyType = .type_TakeProfitStopLoss
            xjh_futuresOrderStraregyBtn.backgroundColor = XJHMainColor
            xjh_futuresOrderListBtn.backgroundColor = XJHButtonColor_Blue
        }
        
        XJH_orderTabView.XJH_StrategyType = XJH_StrategyType
        //刷新交易订单
        XJH_PrigetPendingOrders()
        
    }
    
    /////mark ------------------------------获取数据
    
    //////获取未成交的委托
    func XJH_PrigetPendingOrders(){
        
        xjh_HUDShow()
        
        if XJH_StrategyType == .type_normal {
            //限价
            xjh_OkexApiCoinCoin.okex_CoinCoinGetOrders_Get(state: state, instrument_id: xjh_currentCurrencyCode, limit: "200", blockSuccess: { (mds) in
                self.xjh_hideHUD()
                
                if mds.count < 1{
                    self.XJH_orderTabView.tableView?.set(loadType: .noData)
                    self.XJH_orderTabView.endRefresh()
                }else{
                    self.XJH_orderTabView.xjh_updateTableView(datas: mds)
                    self.XJH_orderTabView.tableView?.set(loadType: .normal)
                }
                
                
                
            }) { (err) in
                self.xjh_hideHUD()
                self.xjh_showError_Text(text: err.message , view: self.view)
                self.XJH_orderTabView.tableView?.set(loadType: .noData)
                self.XJH_orderTabView.endRefresh()
            }
        }else{
            //策略---待生效
            xjh_OkexApiCoinCoin.okex_coinCoinStraregyOrderList(instrument_id: xjh_currentCurrencyCode, order_type: XJH_StrategyType, status: straregyState, blockSuccess: { (mods) in
                self.xjh_hideHUD()
                if mods.count < 1{
                    self.XJH_orderTabView.tableView?.set(loadType: .noData)
                    self.XJH_orderTabView.endRefresh()
                }else{
                    
                    self.XJH_orderTabView.xjh_updateTableView(datas: mods)
                    self.XJH_orderTabView.tableView?.set(loadType: .normal)
                }
                
            }) { (err) in
                self.xjh_hideHUD()
                self.xjh_showError_Text(text: err.message , view: self.view)
                self.XJH_orderTabView.tableView?.set(loadType: .noData)
                self.XJH_orderTabView.endRefresh()
            }
            
            
        }
        
        
        
    }
    
    
    //---------------事件处理---------------------
    override func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
        
        if eventObject.event_CodeType == xjh_PullDown {
            
            //刷新列表
            XJH_PrigetPendingOrders()
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_ListCancelSingleOrder.rawValue {
            
            xjh_HUDShow()
            //撤销订单
            let mod = eventObject.params as! XJH_Okex_CoinCoinOrdersModel
            
            //判断是不是策略
            if XJH_StrategyType == .type_normal {
                
                xjh_OkexApiCoinCoin.okex_CoinCoinCancel_Order(order_id: mod.order_id, instrument_id: mod.instrument_id, blockSuccess: { (cancelMod) in
                    
                    self.xjh_hideHUD()
                    if cancelMod.result {
                        self.xjh_showSuccess_Text(text: "撤单成功", view: self.view)
                        //刷新列表
                        self.XJH_PrigetPendingOrders()
                    }else{
                        self.xjh_showError_Text(text: cancelMod.error_code + cancelMod.error_message , view: self.view)
                    }
                    
                    
                }) { (err) in
                    self.xjh_hideHUD()
                    self.xjh_showError_Text(text: err.message , view: self.view)
                }
                
            }else{
                xjh_OkexApiCoinCoin.okex_CoinCoinCancel_StraregyOrder(instrument_id: mod.instrument_id, order_type: .type_TakeProfitStopLoss, algo_ids: [mod.algo_id], blockSuccess: { (cancelMod) in
                    
                    self.xjh_hideHUD()
                    if cancelMod.result {
                        self.xjh_showSuccess_Text(text: "撤单成功", view: self.view)
                        //刷新列表
                        self.XJH_PrigetPendingOrders()
                    }else{
                        self.xjh_showError_Text(text: cancelMod.error_code + cancelMod.error_message , view: self.view)
                    }
                    
                }) { (err) in
                    self.xjh_hideHUD()
                    self.xjh_showError_Text(text: err.message , view: self.view)
                    
                }
            }
            
            
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_transactionListTab.rawValue {
            
            ///货币列表点击事件
            self.xjh_currentCurrencyCode = eventObject.params as! String
            xjh_futuresNameBtn.setTitle(xjh_currentCurrencyCode.replacingOccurrences(of: "-USD-", with: "-"), for: .normal)
            ///隐藏交易对列表
            XJH_CurrencyListView.xjh_PriShowOrhideCurrencyList(showV: false)
            //刷新列表
            XJH_PrigetPendingOrders()
            
        }
    }
    
    
}
