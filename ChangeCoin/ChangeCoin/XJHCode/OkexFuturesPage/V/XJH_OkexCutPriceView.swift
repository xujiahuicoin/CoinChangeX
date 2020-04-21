//
//  XJH_OkexCutPriceView.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/14.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

struct cutViewStruck {
    var price : String = ""
    var account : String = ""
}

class XJH_OkexCutPriceView: XJHBaseView,UITextFieldDelegate {
    
    ///价格
    var ok_PriceTextF : UITextField!
    ///数量
    var ok_AccountTextF : UITextField!
    ///市价。按钮
    var ok_currentPriceBtn : UIButton!
    ///平仓按钮
    var ok_cutActonPriceBtn : UIButton!
    
    
    override func initXJHView() {
        
        xjh_Pri_CreatUI()
        
        self.backgroundColor = XJHBackgroundColor_dark
    }
    
    func xjh_Pri_CreatUI(){
        
        ok_PriceTextF = UITextField(Xframe: .zero, font: Font(font: XJHFontNum_Main()), textColor: XJHMainTextColor_dark, backgroundColor: XJHMainColor, placeholder: "交易价格", cornerRadius: 4)
        ok_PriceTextF.keyboardType = .decimalPad
        ok_PriceTextF.textAlignment = .center
        self.addSubview(ok_PriceTextF)
        
        ok_AccountTextF = UITextField(Xframe: .zero, font: Font(font: XJHFontNum_Main()), textColor: XJHMainTextColor_dark, backgroundColor: XJHMainColor, placeholder: "交易数量(张)", cornerRadius: 4)
        ok_AccountTextF.keyboardType = .decimalPad
        ok_AccountTextF.textAlignment = .center
        self.addSubview(ok_AccountTextF)
        
        ok_currentPriceBtn = UIButton(Xframe: .zero, title: "市价全平", titleColor: XJHMainTextColor_dark, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHRedColor, cornerRadius: 4)
        ok_currentPriceBtn.addTarget(self, action: #selector(XJH_Pri_OkexCurrenPriceAction), for: .touchUpInside)
        self.addSubview(ok_currentPriceBtn)
        
        ok_cutActonPriceBtn = UIButton(Xframe: .zero, title: "平仓", titleColor: XJHMainTextColor_dark, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHRedColor, cornerRadius: 4)
        ok_cutActonPriceBtn.addTarget(self, action: #selector(XJH_Pri_OkexSetPriceAction), for: .touchUpInside)
        self.addSubview(ok_cutActonPriceBtn)
        
        
        let jianxi = leftMargin_CP * 2
        ok_PriceTextF.snp.makeConstraints { (ma) in
            ma.top.equalTo(15)
            ma.left.equalTo(jianxi)
            ma.right.equalTo(-jianxi)
            ma.height.equalTo(jianxi)
        }
        
        ok_AccountTextF.snp.makeConstraints { (ma) in
            ma.top.equalTo(ok_PriceTextF.snp.bottom).offset(15)
            ma.left.equalTo(jianxi)
            ma.right.equalTo(-jianxi)
            ma.height.equalTo(jianxi)
        }
        
        ok_currentPriceBtn.snp.makeConstraints { (ma) in
            ma.top.equalTo(ok_AccountTextF.snp.bottom).offset(15)
            ma.left.equalTo(jianxi)
            ma.width.equalTo((SCREEN_WIDTH-jianxi*3)/2)
            ma.height.equalTo(jianxi)
        }
        
        ok_cutActonPriceBtn.snp.makeConstraints { (ma) in
            ma.top.equalTo(ok_AccountTextF.snp.bottom).offset(15)
            ma.left.equalTo(ok_currentPriceBtn.snp.right).offset(jianxi)
            ma.width.equalTo((SCREEN_WIDTH-jianxi*3)/2)
            ma.height.equalTo(jianxi)
        }
        
    }
    
    
    @objc func XJH_Pri_OkexCurrenPriceAction(){
        
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_futuresCurrentPriceCut.rawValue))
    }
    
    @objc func XJH_Pri_OkexSetPriceAction(){
        
        //价格 数量
        let cutData : cutViewStruck = cutViewStruck(price: ok_PriceTextF.text!, account: ok_AccountTextF.text!)
        
        
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_futuresSetPriceCut.rawValue, params: cutData))
    }
    
    ///开始升起视图
    func XJH_Pub_UpViewWith(positionModel_1:XJH_OkexfuturesPositionModel_1){
        
        let longqty: Double = Double(positionModel_1.long_qty) ?? 0
        
        if longqty > 0 {
            //多仓 平多
            self.ok_AccountTextF.text = positionModel_1.long_avail_qty;
        }else{
            self.ok_AccountTextF.text = positionModel_1.short_avail_qty;
        }
        
        //修改价格
        self.ok_PriceTextF.text = positionModel_1.last
        
        //操作 弹出来
        self.XJH_PriUpCutView(upView: true)
        
    }
    
    ///底部视图弹出来 变化
    func XJH_PriUpCutView(upView:Bool){
        
        if upView{
            
            UIView.animate(withDuration: 0.5) {
                
                self.isHidden = false
                //进入编辑状态
                self.ok_PriceTextF.becomeFirstResponder()
            }
            
        }else{
            UIView.animate(withDuration: 1) {
                self.isHidden = true
                
                //关闭编辑状态
                self.endEditing(true)
            }
            
        }
        
    }
    
    ///市价平仓
    func XJH_Pub_OkexFutureExChangeTransaction(positionModel_1:XJH_OkexfuturesPositionModel_1,instrument_id_root: String,match_price:ok_futuresMatch_price,price:String,blockAction:@escaping()->()){
        
        //市价 平仓
        self.XJH_PriUpCutView(upView: false)
        
        var countNum = positionModel_1.short_avail_qty
        
        let longqty: Double = Double(positionModel_1.long_qty) ?? 0
        
        if longqty > 0 {
            //多仓 平多
            countNum = positionModel_1.long_avail_qty
        }
        
        BaseAlertController.showAlertTwoAction(message: "确定以市价全平吗", vc: BaseAlertController.getRootVC(), FFActionOne: {
            
        }) {
            XJHFuturesTool.XJH_OkexFutureExChangeTransaction(positionModel_1: positionModel_1, instrument_id_root: instrument_id_root, match_price: .fastPrice, price: "", account: countNum,blockAction:{
                ///撤单v成功 刷新列表
                blockAction()
            })
            
        }
        
    }
    
}
