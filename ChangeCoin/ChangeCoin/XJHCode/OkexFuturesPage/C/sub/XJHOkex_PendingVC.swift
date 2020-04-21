//
//  XJHOkex_PendingVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit
protocol XJHOkex_PendingVCPushVCDelegate {
    func XJH_OkexFuturesVCPushAction(vc:XJHBaseViewController)
}

class XJHOkex_PendingVC: XJHBaseViewController{
    
    var XJH_FuturesPosition : XJH_OkexFuturesPositionTV!
    ///定时刷新
    var  pendingTimer : Timer!
    var XJH_selectBtn : UIButton!
    ///futures 当前期货
    var instrument_id_root : String = ""
    
    var FuturesDelegate : XJHOkex_PendingVCPushVCDelegate!
    var positionModel_1 : XJH_OkexfuturesPositionModel_1!
    ///交易弹出框
    var XJH_futuresCutView : XJH_OkexCutPriceView!
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        XJH_OkexUpdateLoadDataChangeName()
        XJH_Pri_CreatUI()
        xjh_HUDShow()
        okex_StarGetPendingTimerRuning()
        //添加-期货交易对变化 通知
        NotificationCenter.default.addObserver(self, selector: #selector(XJH_OkexUpdateLoadDataChangeName), name: NSNotification.Name(rawValue: Okex_NotificationAction.noti_ChangeFutureName.rawValue), object: nil)
        
        //注册监听 键盘下落
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDisHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //给viewWillDisappear 挂通知
        NotificationCenter.default.addObserver(self, selector: #selector(xjh_viewTimerContinueIsTrue(note:)), name: NSNotification.Name(rawValue: pageNotifaca_pending), object: nil)
        
    }
    
    @objc func XJH_OkexUpdateLoadDataChangeName(){
        
        //加载数据
        instrument_id_root = UserDefaults.standard.object(forKey: okex_futures_key) as! String
        
        XJH_Pri_OkLoadDatasPaeView()
        
        if (XJH_selectBtn != nil) {
            XJH_selectBtn.setTitle(instrument_id_root, for: .normal)
        }
        
        
    }
    
    
    @objc func XJH_Pri_OkLoadDatasPaeView(){
        
        print("----=------------------------长循环--合约-持--仓======")
        xjh_OkexApiFutures.okex_FuturesePosition(instrument_id: instrument_id_root, blockSuccess: { (mod) in
            
            DispatchQueue.main.async(execute: {
                self.XJH_FuturesPosition.endRefresh()
                
                if mod.holding.count < 1 {
                    self.XJH_FuturesPosition.tableView?.set(loadType: .noData)
                    return
                }
                
                self.positionModel_1 = mod.holding.first!
                self.xjh_hideHUD()
                if (Double(self.positionModel_1.long_qty) ?? 0) > 0 ||  (Double(self.positionModel_1.short_qty) ?? 0) > 0 {
                    self.XJH_FuturesPosition.tableView?.set(loadType: .normal)
                    self.XJH_FuturesPosition.xjh_updateTableView(datas: mod.holding,marginMod:ok_futuresMargin_Model(rawValue: mod.margin_mode)!)
                }else{
                    //
                    //
                    self.XJH_FuturesPosition.tableView?.set(loadType: .noData)
                    print("没有数据")
                }
                
            })
            
        }) { (err) in
            
            DispatchQueue.main.async(execute: {
                self.xjh_hideHUD()
                self.xjh_showError_Text(text: err.message, view: self.view)
                self.XJH_FuturesPosition.tableView?.set(loadType: .noData)
                self.XJH_FuturesPosition.endRefresh()
                
            })
        }
        
        
    }
    
    
    func XJH_Pri_CreatUI(){
        
        XJH_selectBtn = UIButton(Xframe: .zero, title: self.instrument_id_root, titleColor: XJHMainTextColor_dark, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHBackgroundColor_dark)
        
        XJH_selectBtn.addTarget(self, action: #selector(XJH_Pri_TopButtoACtion), for: .touchUpInside)
        self.view.addSubview(XJH_selectBtn)
        
        XJH_selectBtn.snp.makeConstraints { (ma) in
            ma.top.width.equalToSuperview()
            ma.height.equalTo(25)
        }
        
        XJH_FuturesPosition = XJH_OkexFuturesPositionTV.view()
        XJH_FuturesPosition.delegate = self
        self.view.addSubview(XJH_FuturesPosition)
        
        XJH_FuturesPosition.snp.makeConstraints { (ma) in
            ma.top.equalTo(XJH_selectBtn.snp.bottom).offset(15)
            ma.width.equalToSuperview()
            ma.bottom.equalToSuperview().offset(-xjh_TabHeight)
        }
        
        
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
    
    //顶部btn事件
    @objc func XJH_Pri_TopButtoACtion(btn:UIButton){
        
    }
    
    //事件回调。 ///默认全仓
    override func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
        
        if eventObject.event_CodeType == xjh_PullDown {
            
            //刷新列表
            XJH_Pri_OkLoadDatasPaeView()
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_futuresChagneLeverageOrCutOrder.rawValue {
            
            
            let arr : Array<Any> = eventObject.params! as! Array<Any>
            
            let changeLeverage : Bool  = arr[0] as! Bool
            
            positionModel_1 = (arr[1] as! XJH_OkexfuturesPositionModel_1)
            
            if changeLeverage {
                
                let subVC = XJH_Okex_LeveragePickerVC.init()
                subVC.currentLeverage = positionModel_1.leverage
                subVC.underlying = okex_instrument_idGetFuturesNameStype(instrument_id: positionModel_1.instrument_id, typeName: false)
                subVC.hidesBottomBarWhenPushed = true
                
                self.FuturesDelegate.XJH_OkexFuturesVCPushAction(vc: subVC)
                
            }else{
                ///升起平仓价格视图
                self.XJH_futuresCutView.XJH_Pub_UpViewWith(positionModel_1:positionModel_1)
            }
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_futuresSetPriceCut.rawValue {
            ///j价格
            let priceCount : cutViewStruck = eventObject.params as! cutViewStruck
            
            //提示
            BaseAlertController.showAlertTwoAction(message: "确定以\(self.XJH_futuresCutView.ok_PriceTextF.text!)进行平仓\( self.XJH_futuresCutView.ok_AccountTextF.text!)个吗", vc: self, FFActionOne: {
                //quxiao
                self.view.endEditing(true)
            }) {
                //提交
                self.XJH_futuresCutView.XJH_PriUpCutView(upView: false)
                XJHFuturesTool.XJH_OkexFutureExChangeTransaction(positionModel_1:self.positionModel_1,instrument_id_root:self.instrument_id_root,match_price: .price, price: priceCount.price, account: priceCount.account,blockAction:{
                    
                    self.XJH_Pri_OkLoadDatasPaeView()
                })
            }
            
            
            
        }else if eventObject.event_CodeType == OkexPageAction.xjh_futuresCurrentPriceCut.rawValue{
            
            //确定
            XJH_futuresCutView.XJH_Pub_OkexFutureExChangeTransaction(positionModel_1: self.positionModel_1, instrument_id_root: self.instrument_id_root, match_price: .fastPrice, price: "",blockAction:{
                ///撤单v成功 刷新列表
                self.XJH_Pri_OkLoadDatasPaeView()
            })
            
        }
    }
    
    ///键盘降落
    @objc func handleKeyboardDisHide(){
        XJH_futuresCutView.XJH_PriUpCutView(upView: false)
    }
    
    ///
    func okex_StarGetPendingTimerRuning(){
        pendingTimer = Timer.scheduledTimer(timeInterval: getLongTime, target: self, selector: #selector(XJH_Pri_OkLoadDatasPaeView), userInfo: nil, repeats: true)
        
        //开始计时器
        pendingTimer.fire()
    }
    
    ///暂停/开始定时器
    func xjh_puseOrCOintinueTimer(timerContinue:Bool){
        
        if (pendingTimer != nil){
            if timerContinue {
                pendingTimer.fireDate = Date.init()
                pendingTimer.fireDate = Date.distantPast
            }else{
                pendingTimer.fireDate = Date.distantFuture
            }
        }
        
    }
    ///继续执行定时器
    @objc func xjh_viewTimerContinueIsTrue(note:Notification){
        
        let timerContinue: Bool = note.object as! Bool
        xjh_puseOrCOintinueTimer(timerContinue: timerContinue)
        
    }
}
