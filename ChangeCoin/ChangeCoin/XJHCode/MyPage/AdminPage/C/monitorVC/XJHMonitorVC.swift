//
//  XJHMonitorVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJHMonitorVC: XJHBaseViewController {
    ///加载int操作手
    var loadIntIndex = 0
    ///订单数组
    var positionModelArray : [XJH_OkexfuturesPositionModel_1]!
    /// 当前期货mod XJH_OkexfuturesPositionModel_1
    var positionModel_1 : XJH_OkexfuturesPositionModel_1!
    ///操作手数组
    var modUserArr : [String]!
    ///操作手选择
    var XJH_OperatorTitleBtn : UIButton!
    ///现货历史
    var XJH_CoinHistoryBtn : UIButton!
    ///合约历史
    var XJH_FuturesHistoryBtn : UIButton!
    ///顶部视图
    var XJH_topView : UIView!
    ///操作员的列表名单
    var XJH_futuresOperatorTab : XJH_Okex_CurrencyPairTV!
    ///交易弹出框
    var XJH_futuresCutView : XJH_OkexCutPriceView!
    
    var XJH_FuturesPosition : XJH_OkexFuturesPositionTV!
    
    let models = XJH_UserModel.sharedInstance.adminUserModel
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //显示合约总资产
        xjh_GetWalletAccount()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "合约持仓"
        
        XJH_PriCreatUI()
        //获取订单
        XJH_PriGetData(intIndex: loadIntIndex)
        //获取用户列表
        xjh_priGetUserList()
        
        //获取资金总量
        xjh_GetWalletAccount()
        
        //注册监听 键盘下落
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDisHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //右侧的item
        self.xjh_createRightButtonItem(title: "账户资金", target: self, action: #selector(xjh_AccountCoinChange))
        
        if models.count < 1 {
            XJHProgressHUD.showError(message: "获取可管理用户的失败", view: self.view)
        }
    }
    ///每次显示当前页面 开始刷新 资金
     @objc func xjh_GetWalletAccount(){
         
         XJH_AccountLogic.xjh_GetWalletAccount(loadIntIndex: loadIntIndex, returnWallet:{ (wallet) in
             
             if wallet.count > 0 {
                 self.xjh_createRightButtonItem(title: "\(XJHSetingShareModel.shareModel.baseCurrency):" + wallet, target: self, action: #selector(self.xjh_AccountCoinChange))
            }else{
                self.xjh_createRightButtonItem(title: "账户资金", target: self, action: #selector(self.xjh_AccountCoinChange))
                
            }
         })
     }
    
    ///账户资金
    @objc func xjh_AccountCoinChange(){
        
        let subVc = XJHAccountVC()
        subVc.loadIntIndex = loadIntIndex
        self.navigationController?.pushViewController(subVc)
    }
    
    ///现货历史
    @objc func xjh_currentCoinOrders(){
        
        let subVC = XJH_OkexCoinStraregyOrderVC.init()
        subVC.loadIntIndex = loadIntIndex
        subVC.titlePage = "现货 - " + XJH_OperatorTitleBtn.titleLabel!.text!
        subVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(subVC, animated: true)
    }
    
    ///合约历史
    @objc func xjh_AllFuturesOrders(){
        let subVc = XJH_Okex_CommissionVC()
        subVc.loadIntIndex = loadIntIndex
        subVc.titlePage = "合约 - " + XJH_OperatorTitleBtn.titleLabel!.text!
        self.navigationController?.pushViewController(subVc)
        
    }
    ///刷新 操作用户列表
    func xjh_priGetUserList(){
        
        modUserArr = AdminLogic.Xjh_GetUserArraylist()
        
        if modUserArr.count < 1 {
            ///获取操作列表失败
            xjh_showProgress_Text(text: "获取操作列表失败", view: self.view)
            
            return
        }
        
        XJH_futuresOperatorTab.xjh_updateTableView(datas: modUserArr)
        
        XJH_OperatorTitleBtn.setTitle("操作手-" + modUserArr[0], for: .normal)
        
    }
    
    ///创建UI
    func XJH_PriCreatUI(){
        
        XJH_topView = UIView(frame: .zero)
        self.view.addSubview(XJH_topView)
        XJH_topView.snp.makeConstraints { (ma) in
            ma.top.width.equalToSuperview()
            ma.height.equalTo(50)
        }
        
        XJH_OperatorTitleBtn = UIButton(Xframe: .zero, title: "操作员", titleColor: XJHButtonColor_Blue, font: FontBold(font: XJHFontNum_Main()), backgroundColor: XJHBackgroundColor_dark, cornerRadius: 4, borderWidth: 0.5, borderColor: XJHButtonColor_Blue)
        XJH_OperatorTitleBtn.isSelected = true
        XJH_OperatorTitleBtn.addTarget(self, action: #selector(xjh_Pri_OperatorAction), for: .touchUpInside)
        XJH_topView.addSubview(XJH_OperatorTitleBtn)
        XJH_OperatorTitleBtn.snp.makeConstraints { (ma) in
            ma.center.equalToSuperview()
            ma.height.equalTo(30)
        }
        
        //现货按钮
        XJH_CoinHistoryBtn = UIButton(Xframe: .zero, title: "现货历史", titleColor: XJHButtonColor_Blue, font: FontBold(font: XJHFontNum_Main()), backgroundColor: XJHBackgroundColor_dark)
        XJH_CoinHistoryBtn.addTarget(self, action: #selector(xjh_currentCoinOrders), for: .touchUpInside)
        XJH_topView.addSubview(XJH_CoinHistoryBtn)
        XJH_CoinHistoryBtn.snp.makeConstraints { (ma) in
            ma.centerY.equalToSuperview()
            ma.right.equalTo(XJH_OperatorTitleBtn.snp.left)
            ma.left.equalTo(20)
            ma.height.equalTo(50)
        }
        
        //期货按钮
        XJH_FuturesHistoryBtn = UIButton(Xframe: .zero, title: "合约历史", titleColor: XJHButtonColor_Blue, font: FontBold(font: XJHFontNum_Main()), backgroundColor: XJHBackgroundColor_dark)
        XJH_FuturesHistoryBtn.addTarget(self, action: #selector(xjh_AllFuturesOrders), for: .touchUpInside)
        XJH_topView.addSubview(XJH_FuturesHistoryBtn)
        XJH_FuturesHistoryBtn.snp.makeConstraints { (ma) in
            ma.centerY.equalToSuperview()
            ma.left.equalTo(XJH_OperatorTitleBtn.snp.right)
            ma.right.equalTo(-20)
            ma.height.equalTo(50)
        }
        
        XJH_FuturesPosition = XJH_OkexFuturesPositionTV.view()
        XJH_FuturesPosition.delegate = self
        self.view.addSubview(XJH_FuturesPosition)
        
        XJH_FuturesPosition.snp.makeConstraints { (ma) in
            ma.top.equalTo(XJH_topView.snp.bottom)
            ma.left.width.bottom.equalToSuperview()
        }
        
        //操作员列表
        XJH_futuresOperatorTab = XJH_Okex_CurrencyPairTV.view()
        XJH_futuresOperatorTab.delegate = self
        XJH_futuresOperatorTab.xjh_cellHeaderH = 0
        //        XJH_futuresOperatorTab.xjh_cellHeaderStr = "操作员列表"
        self.view.addSubview(XJH_futuresOperatorTab)
        XJH_futuresOperatorTab.border(color: .gray, radius: 1, width: 1)
        XJH_futuresOperatorTab.cornerRadius(8)
        XJH_futuresOperatorTab.snp.makeConstraints { (ma) in
            ma.top.equalTo(XJH_OperatorTitleBtn.snp.bottom)
            ma.centerX.equalToSuperview()
            ma.width.equalTo(XJHGetHeght(height: 400))
            ma.height.equalTo(models.count < 6 ? models.count * Int(iPhoneWidth(w: 90)) : 6 * Int(iPhoneWidth(w: 90)))
        }
        XJH_futuresOperatorTab.alpha = 0
        
        //
        XJH_futuresCutView = XJH_OkexCutPriceView.view()
        XJH_futuresCutView.delegate = self
        XJH_futuresCutView.isHidden = true
        
        self.view.addSubview(XJH_futuresCutView)
        
        XJH_futuresCutView.snp.makeConstraints { (ma) in
            ma.centerY.equalTo(200)
            ma.width.equalToSuperview()
            ma.height.equalTo(200)
        }
    }
    
    ///获取全部合约订单
    func XJH_PriGetData(intIndex:Int){
        
        xjh_HUDShow()
        xjh_OkexApiFutures.okex_futuresStraregyOrderList(intIndex:intIndex,blockSuccess: { (mods) in
            self.xjh_hideHUD()
            
            let models = XJHFuturesTool.Okex_AllOrderListRemoveNone(mods: mods)
            
            self.positionModelArray = models
            
            if models.count > 0{
                self.XJH_FuturesPosition.tableView?.set(loadType: .normal)
                
                self.XJH_FuturesPosition.xjh_updateTableView(datas: self.positionModelArray)
            }else{
                
                self.XJH_FuturesPosition.xjh_updateTableView(datas: [])
                self.XJH_FuturesPosition.tableView?.set(loadType: .noData)
            }
            
        }) { (err) in
            self.xjh_hideHUD()
            self.xjh_showError_Text(text: err.message, view: self.view)
            
            self.XJH_FuturesPosition.xjh_updateTableView(datas: [])
            self.XJH_FuturesPosition.tableView?.set(loadType: .noData)
            self.XJH_FuturesPosition.endRefresh()
        }
    }
    
    ///操作列表
    @objc func xjh_Pri_OperatorAction(btn:UIButton){
        //显示管理人员list
        if btn.isSelected{
            self.XJH_futuresOperatorTab.XJH_futuresOperatorTabHide(show: true)
        }else{
            self.XJH_futuresOperatorTab.XJH_futuresOperatorTabHide(show: false)
        }
        
        btn.isSelected = !btn.isSelected
    }
    
    ///事件回调。 ///默认全仓
    override func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
        
        if eventObject.event_CodeType == xjh_PullDown {
            
            //刷新 获取订单
            XJH_PriGetData(intIndex: loadIntIndex)
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_transactionPairTabRow.rawValue{
            
            self.XJH_futuresOperatorTab.XJH_futuresOperatorTabHide(show: false)
            
            //选择了用户
            let row:Int = eventObject.params as! Int
            //获取订单
            loadIntIndex = row
            XJH_OperatorTitleBtn.setTitle("操作手-" + modUserArr[loadIntIndex], for: .normal)
            //刷新期货持仓列表
            XJH_PriGetData(intIndex: loadIntIndex)
            
            //获取资金总量
            xjh_GetWalletAccount()
        }
        
        
        /*else if eventObject.event_CodeType == OkexPageAction.xjh_futuresChagneLeverageOrCutOrder.rawValue {
         
         //            let arr : Array<Any> = eventObject.params! as! Array<Any>
         //
         //            let changeLeverage : Bool  = arr[0] as! Bool
         //
         //            positionModel_1 = (arr[1] as! XJH_OkexfuturesPositionModel_1)
         //
         //            if changeLeverage {
         //
         //                let subVC = XJH_Okex_LeveragePickerVC.init()
         //                subVC.currentLeverage = positionModel_1.leverage
         //                subVC.underlying = okex_instrument_idGetFuturesNameStype(instrument_id: positionModel_1.instrument_id, typeName: false)
         //                subVC.hidesBottomBarWhenPushed = true
         //
         //                self.navigationController?.pushViewController(subVC)
         //
         //            }else{
         //                ///升起平仓价格视图
         //                self.XJH_futuresCutView.XJH_Pub_UpViewWith(positionModel_1:positionModel_1)
         //            }
         
         
         }else if eventObject.event_CodeType == OkexPageAction.xjh_futuresSetPriceCut.rawValue {
         ///j价格
         //            let priceCount : cutViewStruck = eventObject.params as! cutViewStruck
         //
         //            //提示
         //            BaseAlertController.showAlertTwoAction(message: "确定以\(self.XJH_futuresCutView.ok_PriceTextF.text!)进行平仓\( self.XJH_futuresCutView.ok_AccountTextF.text!)张吗", vc: self, FFActionOne: {
         //                //quxiao
         //                self.view.endEditing(true)
         //            }) {
         //                //提交
         //                self.XJH_futuresCutView.XJH_PriUpCutView(upView: false)
         //                XJHFuturesTool.XJH_OkexFutureExChangeTransaction(positionModel_1:self.positionModel_1,instrument_id_root:self.positionModel_1.instrument_id,match_price: .price, price: priceCount.price, account: priceCount.account,blockAction:{
         //
         //                    //获取订单
         //                    self.XJH_PriGetData()
         //
         //                })
         //            }
         //
         
         
         }else if eventObject.event_CodeType == OkexPageAction.xjh_futuresCurrentPriceCut.rawValue{
         
         //确定
         
         //            XJH_futuresCutView.XJH_Pub_OkexFutureExChangeTransaction(positionModel_1: self.positionModel_1, instrument_id_root: self.positionModel_1.instrument_id, match_price: .fastPrice, price: "",blockAction:{
         //
         //
         //                //获取订单
         //                self.XJH_PriGetData()
         //            })
         
         }
         
         */
    }
    
    ///键盘降落
    @objc func handleKeyboardDisHide(){
        XJH_futuresCutView.XJH_PriUpCutView(upView: false)
    }
    
    ///添加管理人员--单独管理 不加入网络同步
//    @objc func XJH_AddUserInfo(){
//        
//        XjhAlertView().showDoubleButton(cancelTitle: "取消", rightTitle: "添加", message: "单独管理 不加入网络同步") {
//            //添加
//        }
//        
//    }
    
}
