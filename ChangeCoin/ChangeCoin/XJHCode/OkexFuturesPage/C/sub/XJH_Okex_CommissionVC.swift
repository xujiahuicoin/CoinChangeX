//
//  XJH_Okex_CommissionVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_CommissionVC: XJHBaseViewController,XJHPageViewDelegate {
    
    ///加载int操作手--okex_header_number。是自己的单子
    var loadIntIndex = okex_header_number
    
    var titlePage = "全部委托"
    ///获取 当前 、历史 挂单的状态
    var state  = Okex_OrderState.NoSuccess
    var straregyState = ok_futuresOrderStatus.type_loding
    ///合约信息
    var XJH_OkexFuturesInstrumentsArray : [XJH_OkexFuturesListInstrumentsModel] = []
    ///futures 当前期货
    var instrument_id_root : String = "BTC-USDT"
    var futuresOrderModels : Array<Any> = []
    ///期货列表数组
    var futuresListArr : [String] = []
    ///期货列表
    var XJH_futuresListTab : XJH_Okex_FuturesListTV!
    ///策略委托 默认-限价
    var XJH_StrategyType :Okex_StrategyOrderType = .type_normal
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titlePage
        futuresListArr = XJH_UserModel.sharedInstance.futures
        
        xjh_PriCrreatUI()
        
        xjh_priGetUserList()
        XJH_OkexUpdateLoadDataChangeName()
        
        if loadIntIndex == okex_header_number {
        self.xjh_createRightButtonItem(title: "批量撤单", target: self, action: #selector(editAction))
        }
            //获取期货信息列表
            XJH_Pri_GetOnceData()
        
        
    }
    ///刷新 期货列表数据
    func xjh_priGetUserList(){
        
        XJH_futuresListTab.xjh_updateTableView(datas: futuresListArr)
        
        
    }
    ///批量撤单事件
    @objc func editAction(){
        
        if straregyState != .type_loding {
            //是历史
            xjh_showError_Text(text: "历史委托，不可进行此操作")
            return
        }
        
        if futuresOrderModels.count < 1{
            xjh_showError_Text(text: "没有数据")
            
            return
        }
        
        self .XJH_Pri_ItemNotifacationAction(editingBool: true)
        self.xjh_createRightButtonItem(title: "取消", target: self, action: #selector(editCancelAction))
        
    }
    
    ///取消
    @objc func editCancelAction(){
        self .XJH_Pri_ItemNotifacationAction(editingBool: false)
        self.xjh_createRightButtonItem(title: "批量撤单", target: self, action: #selector(editAction))
    }
    
    @objc func XJH_OkexUpdateLoadDataChangeName(){
        
        //加载数据
       let instrument_id_new = UserDefaults.standard.object(forKey: okex_futures_key)
        
        if (instrument_id_new != nil) {
            instrument_id_root = instrument_id_new as! String
        }
        
        //定时 刷新交易订单
        self.perform(#selector(XJH_Pri_FuturesgetPendingOrders), with: self, afterDelay: 2)
        XJH_Pri_FuturesgetPendingOrders()
        
        if (xjh_futuresNameBtn != nil) {
            xjh_futuresNameBtn.setTitle( XJH_Pri_FutureaNameDetail(name: instrument_id_root), for: .normal)
        }
    }
    
    
    func xjh_PriCrreatUI(){
        
        XJH_topPageView = XJHPageView(frame: .zero)
        XJH_topPageView.delegate = self
        XJH_topPageView.buttonNormalColor = XJHSecondTextColor
        XJH_topPageView.buttonSelectedColor = XJHButtonColor_Blue
        XJH_topPageView.xjh_LineColor = XJHButtonColor_Blue
        XJH_topPageView.updatePageView(titles: ["当前委托","历史委托"],currentIndex: 0)
        self.view.addSubview(XJH_topPageView)
        
        XJH_topPageView.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.width.equalToSuperview()
            ma.top.equalToSuperview()
            ma.height.equalTo(40)
        }
        
        
        let leftjian:CGFloat = 10.0
        let widBtn = (SCREEN_WIDTH - leftjian*4.0)/3
        let heiBtn = 30
        xjh_futuresNameBtn = UIButton(Xframe: .zero, title:XJH_Pri_FutureaNameDetail(name: instrument_id_root), titleColor: XJHButtonColor_Blue, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHBackgroundColor_dark, cornerRadius: 4, borderWidth: 0.5, borderColor: XJHButtonColor_Blue)
        xjh_futuresNameBtn.isSelected = true
        xjh_futuresNameBtn.tag = 100
        xjh_futuresNameBtn.addTarget(self, action: #selector(xjh_PributtonAction), for: .touchUpInside)
        self.view.addSubview(xjh_futuresNameBtn)
        xjh_futuresNameBtn.snp.makeConstraints { (ma) in
            ma.left.equalTo(leftjian)
            ma.top.equalTo(XJH_topPageView.snp.bottom).offset(10)
            ma.width.equalTo(widBtn)
            ma.height.equalTo(heiBtn)
        }
        
        xjh_futuresOrderStraregyBtn = UIButton(Xframe: .zero, title: "限价交易", titleColor: XJHMainTextColor_dark, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHButtonColor_Blue, cornerRadius: 4, borderWidth: 0.5, borderColor: XJHMainTextColor_dark)
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
        
        
        self.view.addSubview(editView)
        editView.snp.makeConstraints { (ma) in
            ma.top.equalToSuperview()
            ma.left.equalToSuperview()
            ma.width.equalToSuperview()
            ma.bottom.equalTo(xjh_futuresOrderListBtn.snp.bottom)
        }
        
        editView.addSubviews([selectBtn,cancennOrderBtn])
        selectBtn.snp.makeConstraints { (ma) in
            ma.left.equalTo(30)
            ma.right.equalTo(self.editView.snp.centerX).offset(-20)
            ma.height.equalTo(35)
            ma.centerY.equalToSuperview()
        }
        
        cancennOrderBtn.snp.makeConstraints { (ma) in
            ma.right.equalTo(-30)
            ma.left.equalTo(self.editView.snp.centerX).offset(20)
            ma.height.equalTo(35)
            ma.centerY.equalToSuperview()
        }
        
        XJH_FuturesOrderTabView = XJH_Okex_OrdersTabV.view()
        XJH_FuturesOrderTabView.delegate = self
        XJH_FuturesOrderTabView.isCoinCoin = false
        self.view.addSubview(XJH_FuturesOrderTabView)
        
        XJH_FuturesOrderTabView.snp.makeConstraints { (ma) in
            ma.left.width.equalToSuperview()
            ma.top.equalTo(xjh_futuresOrderStraregyBtn.snp.bottom).offset(6)
            ma.bottom.equalToSuperview()
        }
        
        
        //期货列表
        XJH_futuresListTab = XJH_Okex_FuturesListTV.view()
        XJH_futuresListTab.delegate = self
        self.view.addSubview(XJH_futuresListTab)
        XJH_futuresListTab.snp.makeConstraints { (ma) in
            ma.top.equalTo(xjh_futuresNameBtn.snp.bottom)
            ma.width.equalToSuperview()
            ma.bottom.equalToSuperview()
        }
        XJH_futuresListTab.alpha = 0
    }
    
    ///button action
    @objc func xjh_PributtonAction(btn:UIButton){
        
        if btn.tag == 100{
            //name
            //显示 bi种列表
            if xjh_futuresNameBtn.isSelected{
                self.XJH_futuresListTab.XJH_futuresOperatorTabHide(show: true)
                self.xjh_futuresNameBtn.isSelected = true
            }else{
                self.XJH_futuresListTab.XJH_futuresOperatorTabHide(show: false)
                self.xjh_futuresNameBtn.isSelected = false
            }
            
            return
            
        }else if btn.tag == 101 {
            //限价
            XJH_StrategyType = .type_normal
            
            xjh_futuresOrderStraregyBtn.backgroundColor = XJHButtonColor_Blue
            xjh_futuresOrderListBtn.backgroundColor = XJHMainColor
        }else{
            XJH_StrategyType = .type_TakeProfitStopLoss
            xjh_futuresOrderStraregyBtn.backgroundColor = XJHMainColor
            xjh_futuresOrderListBtn.backgroundColor = XJHButtonColor_Blue
        }
        
        //刷新交易订单
        XJH_Pri_FuturesgetPendingOrders()
        
    }
    
    ///当前 和 历史交替
    func pageView(_ pageView: XJHPageView, didSelectIndexAt index: Int) {
        
        if index == 0 {
            //当前
            XJH_FuturesOrderTabView.currentOrderBool = true
            
            state = .NoSuccess
            straregyState = .type_loding
        }else if index == 1 {
            //历史
            XJH_FuturesOrderTabView.currentOrderBool = false
            
            state = .allDeal
            straregyState = .type_success
        }
        
        //刷新列表
        XJH_Pri_FuturesgetPendingOrders()
    }
    
    //////获取未成交的委托---
    @objc func XJH_Pri_FuturesgetPendingOrders(){
        
        if futuresOrderModels.count > 0 {
            futuresOrderModels.removeAll()
        }
        
        xjh_HUDShow()
        
        self.XJH_FuturesOrderTabView.XJH_StrategyType = XJH_StrategyType
        
        if XJH_StrategyType == .type_normal {
            
            xjh_OkexApiFutures.okex_FuturesOrdersWithState(intIndex:loadIntIndex, instrument_id: changeValueToUSD(value: instrument_id_root), state: state, blockSuccess: { (mods) in
                
                DispatchQueue.main.async(execute: {
                    self.xjh_hideHUD()
                    self.XJH_FuturesOrderTabView.endRefresh()
                    if mods.count > 0{
                        self.futuresOrderModels = mods
                        self.XJH_FuturesOrderTabView.tableView?.set(loadType: .normal)
                        self.XJH_FuturesOrderTabView.xjh_updateTableView(datas: mods)
                    }else{
                        self.XJH_FuturesOrderTabView.tableView?.set(loadType: .noData)
                        self.XJH_FuturesOrderTabView.xjh_updateTableView(datas: [])
                    }
                })
                
            }, blackError: { (err) in
                DispatchQueue.main.async(execute: {
                    self.xjh_hideHUD()
                    self.xjh_showError_Text(text: err.message, view: self.view)
                    self.XJH_FuturesOrderTabView.tableView?.set(loadType: .noData)
                    self.XJH_FuturesOrderTabView.endRefresh()
                    self.XJH_FuturesOrderTabView.xjh_updateTableView(datas: [])
                    
                })
                
            })
            
        }else {
            ///策略--z订单
            
            xjh_OkexApiFutures.okex_futuresStraregyOrderList(intIndex: loadIntIndex, instrument_id: changeValueToUSD(value: instrument_id_root),order_type: XJH_StrategyType, status: straregyState, blockSuccess: { (mods) in
                
                DispatchQueue.main.async(execute: {
                    self.XJH_FuturesOrderTabView.endRefresh()
                    
                    self.xjh_hideHUD()
                    if mods.count > 0 {
                        self.futuresOrderModels = mods
                        self.XJH_FuturesOrderTabView.tableView?.set(loadType: .normal)
                        self.XJH_FuturesOrderTabView.xjh_updateTableView(datas: mods)
                    }else {
                        self.XJH_FuturesOrderTabView.tableView?.set(loadType: .noData)
                        self.XJH_FuturesOrderTabView.xjh_updateTableView(datas: [])
                    }
                })
                
            }) { (err) in
                
                DispatchQueue.main.async(execute: {
                    self.XJH_FuturesOrderTabView.endRefresh()
                    
                    self.xjh_hideHUD()
                    self.xjh_showError_Text(text: err.message, view: self.view)
                    self.XJH_FuturesOrderTabView.tableView?.set(loadType: .noData)
                    self.XJH_FuturesOrderTabView.xjh_updateTableView(datas: [])
                })
            }
        }
        
    }
    
    //点击事件回传
    override func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
        
        if eventObject.event_CodeType == xjh_PullDown {
            
            //刷新列表
            XJH_Pri_FuturesgetPendingOrders()
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_ListCancelSingleOrder.rawValue {
            
            
            let mod : XJH_OkexFuturesOldOrderModel = eventObject.params as! XJH_OkexFuturesOldOrderModel
            xjh_HUDShow()
            
            if XJH_StrategyType == .type_normal {
                
                XJH_Pri_CancellOrderNormalAction(instrument_id: mod.instrument_id, order_ids: [mod.order_id])
            }else {
                

                self.XJH_Pri_CancellOrderFuturesAction(instrument_id:mod.instrument_id,algo_ids: [mod.algo_ids])
            }
        }else if eventObject.event_CodeType == OkexPageAction.xjh_transactionListTab.rawValue {
        
            
            self.XJH_futuresListTab.XJH_futuresOperatorTabHide(show: false)
        ///货币列表点击事件
        let listReturn :FutureListPairRuturn = eventObject.params as! FutureListPairRuturn
        let mod :XJH_OkexFuturesListInstrumentsModel = XJH_OkexFuturesListInstrumentsModel().getInfoFromArray(array: XJH_OkexFuturesInstrumentsArray, listStruct: listReturn)
        
        ///判断mod 是否值
        if mod.instrument_id.count < 1 {return}
        
        self.instrument_id_root = mod.instrument_id
    xjh_futuresNameBtn.setTitle(XJH_Pri_FutureaNameDetail(name: instrument_id_root), for: .normal)
            //刷新交易订单
            XJH_Pri_FuturesgetPendingOrders()
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_TransactionOrdersCell.rawValue{
            let row: Int = eventObject.params as! Int
            //加载请求当前的收益
           let model =  futuresListArr[row]
            
            
        }
    }
    
    ///批量撤单--限价
    @objc func XJH_Pri_CancellOrderNormalAction(instrument_id:String,order_ids:Array<String>){
        
        xjh_OkexApiFutures.okex_FututresCancel_MoreOrder(order_ids: order_ids, instrument_id: instrument_id, blockSuccess: { (mod) in
            
            DispatchQueue.main.async(execute: {
                self.xjh_hideHUD()
                self.xjh_showSuccess_Text(text: "撤单成功", view: self.view)
                //刷新交易订单
                self.XJH_Pri_FuturesgetPendingOrders()
            })
        }) { (err) in
            
            DispatchQueue.main.async(execute: {
                self.xjh_hideHUD()
                self.xjh_showError_Text(text: err.message, view: self.view)
            })
        }
        
    }
    ///批量撤单-策略-事件
    @objc func XJH_Pri_CancellOrderFuturesAction(instrument_id:String,algo_ids:Array<String>){
        
        //委托策略撤单
        xjh_OkexApiFutures.okex_FuturesStraregyCancelOrder(instrument_id: instrument_id, order_type: XJH_StrategyType, algo_ids: algo_ids, blockSuccess: { (mod) in
            
            DispatchQueue.main.async(execute: {
                self.xjh_hideHUD()
                self.xjh_showSuccess_Text(text: "撤单成功")
                //刷新交易订单
                self.XJH_Pri_FuturesgetPendingOrders()
            })
            
        }) { (err) in
            
            DispatchQueue.main.async(execute: {
                self.xjh_hideHUD()
                self.xjh_showError_Text(text: err.message, view: self.view)
            })
        }
        
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

               })
               
           }) { (err) in
               self.xjh_showError_Text(text: err.message , view: self.view)
           }
       }
    
    
    ///编辑事件的通知
    @objc func XJH_Pri_ItemNotifacationAction(editingBool:Bool){
        
        if XJH_FuturesOrderTabView.selectArray.count > 0{
            XJH_FuturesOrderTabView.selectArray.removeAll()
        }
        if editingBool {
            ///编辑中 展示 视图
            XJH_PriShowEditViewYesOrNo(show: true)
            //设置myTableView为可编辑状态
            XJH_FuturesOrderTabView.tableView!.setEditing(true, animated: true)
        }else{
            ///取消编辑 隐藏视图
            
            XJH_PriShowEditViewYesOrNo(show: false)
            
            //tableview 取消编辑状态
            XJH_FuturesOrderTabView.tableView!.setEditing(false, animated: true)
        }
        
    }
    
    func XJH_PriShowEditViewYesOrNo(show:Bool){
        
        if show {
            UIView.animate(withDuration: 0.2) {
                //选择视图
                self.editView.isHidden = false
                
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                
                self.editView.isHidden = true
                self.selectBtn.isSelected = false
            }
        }
        
    }
    
    ///选择视图------全选按钮事件
    @objc func XJH_Pri_SelectBtnAction(btn:UIButton){
        
        if btn.isSelected {
            //取消全选
            let count = self.futuresOrderModels.count
            if XJH_FuturesOrderTabView.selectArray.count > 0{
                XJH_FuturesOrderTabView.selectArray.removeAll()
            }
            for index in 0..<count {
                // 选中所有的数组
                XJH_FuturesOrderTabView.tableView!.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
            }
            
        }else{
            
            let count = self.futuresOrderModels.count
            
            for index in 0..<count {
                // 选中所有的数组
                XJH_FuturesOrderTabView.tableView!.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.none)
            }
            XJH_FuturesOrderTabView.selectArray = futuresOrderModels as! [XJH_OkexFuturesOldOrderModel]
            
        }
        
        btn.isSelected = !btn.isSelected
        
    }
    
    ///将 USD USDT 剔除
    func XJH_Pri_FutureaNameDetail(name:String)->String{
        
        let names = name.replacingOccurrences(of: "-USD-", with: "-")
        return names.replacingOccurrences(of: "-USDT-", with: "-")
        
    }
    
    ///选择视图----批量撤单事件
    @objc func XJH_Pri_moroOrderCancelAcrion(){
        
        
        BaseAlertController.showAlertTwoAction(message: "确定批量撤销选中订单", vc: self, FFActionOne: {
            
        }) {
            var orderIdArr : Array<String> = []
            var instrumentId: String = ""
            //确定执行
            for model: XJH_OkexFuturesOldOrderModel in self.XJH_FuturesOrderTabView.selectArray{
                instrumentId = model.instrument_id
                if self.XJH_StrategyType == .type_normal {
                    //限价
                    orderIdArr.append(model.order_id)
                }else{
                    orderIdArr.append(model.algo_ids)
                }
            }
            
            ///执行 撤单
            if self.XJH_StrategyType == .type_normal {
                //限价
                self.XJH_Pri_CancellOrderNormalAction(instrument_id: instrumentId, order_ids: orderIdArr)
            }else{
                self.XJH_Pri_CancellOrderFuturesAction(instrument_id: instrumentId, algo_ids: orderIdArr)
            }
        }
        
    }
    
    ///订单tableview
    var XJH_FuturesOrderTabView : XJH_Okex_OrdersTabV!
    var XJH_topPageView: XJHPageView!
    var xjh_futuresNameBtn : UIButton!
    var xjh_futuresOrderStraregyBtn : UIButton!
    var xjh_futuresOrderListBtn : UIButton!
    
    ///编辑View
    lazy var editView : UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = XJHMainColor
        view.isHidden = true
        return view
    }()
    
    ///选择按钮
    lazy var selectBtn : UIButton = {
        let btn = UIButton(Xframe: .zero,font: Font(font: XJHFontNum_Main()), cornerRadius: 4)
        btn.setTitle("全选", for: .normal)
        btn.setTitle("取消选择", for: .selected)
        
        btn.setBackgroundImage(UIImage(color: XJHButtonColor_Blue), for: .normal)
        btn.setBackgroundImage(UIImage(color: XJHSecondTextColor), for: .selected)
        
        btn.addTarget(self, action: #selector(XJH_Pri_SelectBtnAction), for: .touchUpInside)
        
        return btn
    }()
    
    ///批量撤单d按钮
    lazy var cancennOrderBtn: UIButton = {
        let btn = UIButton(Xframe: .zero, title: "批量撤单", titleColor: .white, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHButtonColor_Blue, cornerRadius: 4)
        btn.addTarget(self, action: #selector(XJH_Pri_moroOrderCancelAcrion), for: .touchUpInside)
        return btn
    }()
    
}
