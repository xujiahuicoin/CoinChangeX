//
//  XJH_Okex_AllFuturesOrderVC.swift
//  ChangeCoin
//
//  Created by xujiahui on 2019/11/30.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit


class XJH_Okex_AllFuturesOrderVC: XJHBaseViewController {

    var positionModelArray : [XJH_OkexfuturesPositionModel_1]!
    /// 当前期货mod XJH_OkexfuturesPositionModel_1
    var positionModel_1 : XJH_OkexfuturesPositionModel_1!
    
    ///交易弹出框
      var XJH_futuresCutView : XJH_OkexCutPriceView!
    var XJH_FuturesPosition : XJH_OkexFuturesPositionTV!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "全部仓位"
        
        XJH_PriCreatUI()
        //获取订单
        XJH_PriGetData()
        
        //注册监听 键盘下落
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDisHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    ///创建UI
    func XJH_PriCreatUI(){
        
        XJH_FuturesPosition = XJH_OkexFuturesPositionTV.view()
        XJH_FuturesPosition.delegate = self
        self.view.addSubview(XJH_FuturesPosition)
         
        XJH_FuturesPosition.snp.makeConstraints { (ma) in
            ma.edges.equalToSuperview()
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
    
    ///获取全部合约订单
    func XJH_PriGetData(){
        
        
        xjh_HUDShow()
        xjh_OkexApiFutures.okex_futuresStraregyOrderList(blockSuccess: { (mods) in
            self.xjh_hideHUD()
            
            let models = XJHFuturesTool.Okex_AllOrderListRemoveNone(mods: mods)
           
            if models.count > 0{
              self.XJH_FuturesPosition.tableView?.set(loadType: .normal)
                self.XJH_FuturesPosition.xjh_updateTableView(datas: models)
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
    
    //事件回调。 ///默认全仓
       override func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
           
           if eventObject.event_CodeType == xjh_PullDown {
               
               //获取订单
               self.XJH_PriGetData()
               
           }else if eventObject.event_CodeType == OkexPageAction.xjh_futuresChagneLeverageOrCutOrder.rawValue {
               
               
               let arr : Array<Any> = eventObject.params! as! Array<Any>
               
               let changeLeverage : Bool  = arr[0] as! Bool
               
               positionModel_1 = (arr[1] as! XJH_OkexfuturesPositionModel_1)
               
               if changeLeverage {
                   
                   let subVC = XJH_Okex_LeveragePickerVC.init()
                   subVC.currentLeverage = positionModel_1.leverage
                   subVC.underlying = okex_instrument_idGetFuturesNameStype(instrument_id: positionModel_1.instrument_id, typeName: false)
                   subVC.hidesBottomBarWhenPushed = true
                   
                self.navigationController?.pushViewController(subVC)
             
               }else{
                   ///升起平仓价格视图
    self.XJH_futuresCutView.XJH_Pub_UpViewWith(positionModel_1:positionModel_1)
               }
            
               
           }else if eventObject.event_CodeType == OkexPageAction.xjh_futuresSetPriceCut.rawValue {
              ///j价格
               let priceCount : cutViewStruck = eventObject.params as! cutViewStruck
               
               //提示
               BaseAlertController.showAlertTwoAction(message: "确定以\(self.XJH_futuresCutView.ok_PriceTextF.text!)进行平仓\( self.XJH_futuresCutView.ok_AccountTextF.text!)张吗", vc: self, FFActionOne: {
                   //quxiao
                self.view.endEditing(true)
               }) {
                   //提交
                   self.XJH_futuresCutView.XJH_PriUpCutView(upView: false)
                XJHFuturesTool.XJH_OkexFutureExChangeTransaction(positionModel_1:self.positionModel_1,instrument_id_root:self.positionModel_1.instrument_id,match_price: .price, price: priceCount.price, account: priceCount.account,blockAction:{
                       
                        //获取订单
                    self.XJH_PriGetData()
                    
                   })
               }
               
               
               
           }else if eventObject.event_CodeType == OkexPageAction.xjh_futuresCurrentPriceCut.rawValue{
               
                   //确定

               XJH_futuresCutView.XJH_Pub_OkexFutureExChangeTransaction(positionModel_1: self.positionModel_1, instrument_id_root: self.positionModel_1.instrument_id, match_price: .fastPrice, price: "",blockAction:{
                 

                    //获取订单
                self.XJH_PriGetData()
               })
               
           }
       }
       
       ///键盘降落
      @objc func handleKeyboardDisHide(){
       XJH_futuresCutView.XJH_PriUpCutView(upView: false)
       }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
