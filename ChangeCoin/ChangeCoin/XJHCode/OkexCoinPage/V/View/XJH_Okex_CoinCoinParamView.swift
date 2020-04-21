//
//  XJH_Okex_TransactionParamView.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_CoinCoinParamView: XJHBaseView,UITextFieldDelegate {
    
   
    //----------------止盈止损 UI--------------------
    var StraregyTakePrifileView :UIView!
     /// 触发价格
    var StraregytriggerPrice_textF : UITextField!
    ///委托交易 止盈止损价格
    var StraregyPrice_textF : UITextField!
    ///委托数量
    var StraregyCount_textF : UITextField!
    //---------------限价UI---------------------
    ///买入 按钮
    var ok_buy_Btn : UIButton!
    ///卖出 按钮
    var ok_sell_btn : UIButton!
    ///交易规则按钮
    var ok_TradingRules_Btn : UIButton!
    
    ///Currency价格
    var CurrencyPrice_textF : UITextField!
    var CurrencyPrice : String!
    ///Transaction 数量t
    var TransactuonCount_textF : UITextField!
    
    //估值
    var valuation_Lab : UILabel!
    ///可用
    var availabel_lab: UILabel!
    ///可买 可卖
    var canByt_lab : UILabel!

    var availabel_num : Double = 0
    var canByt_num : Double = 0
    ///百分比View
    var percentage_View :UIView!
    
    ///交易按钮
    var ok_Trasaction_Btn : UIButton!
    
    override func initXJHView() {
        
        xjh_Pri_CreatUI()
        
        conentSizeUI()
    }
    
    
    ///更新币种资产数据
    func xjh_Pub_updateData(model: CJH_Okex_COinAccountsSingleModel){
        
        let strBool = model.currency
        if strBool.count < 1 {
            return
        }
        
        availabel_lab.text = "可用 \(xjh_AutoRoundToString(model.available)) " + model.currency
        availabel_num = Double(model.available) ?? 0
        
        XJH_Pri_canMaiMaiChange(text: "")
    }
    //可买 可卖 数量
       func XJH_Pri_canMaiMaiChange(text: String){
        
        if text.count > 0{
            CurrencyPrice_textF.text = text
        }
        
        if CurrencyPrice_textF.text!.count < 1{
            CurrencyPrice_textF.text = CurrencyPrice
        }
        
        let price : Double = Double(CurrencyPrice_textF.text!) ?? 0
        
        //卖出时 zil * price = usdt
        var canBuySell = "可卖"
        canByt_num = availabel_num * price
        
        if ok_buy_Btn.isSelected {
           //买入时 usdt/price = zil
        canBuySell = "可买"
        canByt_num = availabel_num/price
            
        }
        print(canByt_num)
        canByt_lab.text = canBuySell + canByt_num.xjh_roundToString(places: 3)
           
       }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //买入价格变化
        if textField != CurrencyPrice_textF {
            return
        }
        if textField.text!.count > 1 {
            
            XJH_Pri_canMaiMaiChange(text: CurrencyPrice_textF.text!)
            
        }
        
        
    }
 
   
    ///初始化UI
    func xjh_Pri_CreatUI(){
        
        //----------------------
        ok_buy_Btn = UIButton(Xframe: .zero, title: "买入", titleColor: XJHMainTextColor_dark, font: Font(font: XJHFontNum_Second()), backgroundColor: .clear, cornerRadius: 3)
        ok_buy_Btn.eventInterval = btnTimeInterval_long
        
        ok_buy_Btn.setBackgroundImage(UIImage(color: XJHGreenColor), for: .selected)
        ok_buy_Btn.setBackgroundImage(UIImage(color: XJHBackgroundColor_dark), for: .normal)
        
        ok_buy_Btn.setTitleColor(XJHMainTextColor_dark, for: .selected)
        ok_buy_Btn.setTitleColor(XJHGreenColor, for: .normal)
        
        ok_buy_Btn.addTarget(self, action: #selector(xjh_Pri_buySellAction), for: .touchUpInside)
        ok_buy_Btn.isSelected = true
        self.addSubview(ok_buy_Btn)
        
        //----------------------
        ok_sell_btn = UIButton(Xframe: .zero, title: "卖出", titleColor: XJHMainTextColor_dark, font: Font(font: XJHFontNum_Second()), backgroundColor: .clear, cornerRadius: 3)
        ok_sell_btn.eventInterval = btnTimeInterval_long
        ok_sell_btn.setBackgroundImage(UIImage(color: XJHRedColor), for: .selected)
        ok_sell_btn.setBackgroundImage(UIImage(color: XJHBackgroundColor_dark), for: .normal)
        
        ok_sell_btn.setTitleColor(XJHMainTextColor_dark, for: .selected)
        ok_sell_btn.setTitleColor(XJHRedColor, for: .normal)
        
        ok_sell_btn.addTarget(self, action: #selector(xjh_Pri_buySellAction), for: .touchUpInside)
        ok_sell_btn.isSelected = false
        self.addSubview(ok_sell_btn)
        
        //----------------------
        ok_TradingRules_Btn = UIButton(Xframe: .zero, title: "限价委托\(xjh_down_jian)", titleColor: XJHButtonColor_Blue, font: Font(font: XJHFontNum_Second()),backgroundColor: .clear)
        ok_TradingRules_Btn.addTarget(self, action: #selector(ok_TradingRules_BtnAction), for: .touchUpInside)
        self.addSubview(ok_TradingRules_Btn)
        
        
        //------------------------------------
        let wid = SCREEN_WIDTH/2 - leftMargin_CP
        CurrencyPrice_textF = XJH_viewsTools.xjh_Pub_TextFieldAndLeftViewRightView(buttonAction: { (btn) in
            
            if btn.tag == 10 {
                //减
                
            }else{
                //加
                
            }
            
        })
        CurrencyPrice_textF.delegate = self
        self.addSubview(CurrencyPrice_textF)
        
        //------------------------------------
        valuation_Lab = UILabel(Xframe: .zero, text: "估值 ¥0.00", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHMainColor)
        self.addSubview(valuation_Lab)
        
        //------------------------------------
        TransactuonCount_textF = XJH_viewsTools.xjh_Pub_TextFieldAndLeftViewRightView(placeHold: "数量", buttonAction: { (btn) in
            
            if btn.tag == 10 {
                //减
                
            }else{
                //加
                
            }
            
        })
        self.addSubview(TransactuonCount_textF)
        
        
        //---------百分比---------------------------
        percentage_View = XJH_viewsTools.xjh_Pub_getPercentageView(frame: .zero, tagAcion: { (tagStr) in
        //可以买 卖的总量 * 百分比
            
            let tags : Double = (Double(tagStr.replacingOccurrences(of: "%", with: "")) ?? 0) * 0.01
            
            if self.ok_buy_Btn.isSelected {
               
                self.TransactuonCount_textF.text = (self.canByt_num*tags).xjh_roundToString(places: 2)
            }else{
                
                self.TransactuonCount_textF.text = (self.availabel_num*tags).xjh_roundToString(places: 2)
                
            }
            
            
        })
        
        self.addSubview(percentage_View)
        //-------------可用-----------------------、
        availabel_lab = UILabel(Xframe: .zero, text: "可用0.0", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHMainColor)
        self.addSubview(availabel_lab)
        
        //  可买
        canByt_lab = UILabel(Xframe: .zero, text: "可买0.0", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHMainColor)
        self.addSubview(canByt_lab)
        
        //-----------交易按钮-----------
               ok_Trasaction_Btn = UIButton(Xframe: .zero, title: "买入", titleColor: XJHMainTextColor_dark, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHButtonColor_Blue, cornerRadius: 4)
               ok_Trasaction_Btn.addTarget(self, action: #selector(XJH_TransactionButtn), for: .touchUpInside)
        ok_Trasaction_Btn.eventInterval = btnTimeInterval_long
        
               self.addSubview(ok_Trasaction_Btn)
               
    }
   
    ///初始化UI布局
    func conentSizeUI(){
        
        let widc = (SCREEN_WIDTH/2 - leftMargin_CP)/2
        
        let wid_2 = SCREEN_WIDTH/2
        
        ok_buy_Btn.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalToSuperview()
            ma.height.equalTo(XJHHeight_ButSecond())
            ma.width.equalTo(widc)
        }
        
        ok_sell_btn.snp.makeConstraints { (ma) in
            ma.left.equalTo(ok_buy_Btn.snp.right)
            ma.height.top.width.equalTo(ok_buy_Btn)
            
        }
        
        ok_TradingRules_Btn.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(ok_sell_btn.snp.bottom).offset(xjhHeight_MarginMin())
            ma.height.equalTo(XJHHeight_ButMain())
            
        }
        
        CurrencyPrice_textF.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(ok_TradingRules_Btn.snp.bottom).offset(xjhHeight_MarginMin())
            ma.height.equalTo(xjhHeight_fieldText())
            ma.right.equalToSuperview()
        }
        
        valuation_Lab.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(CurrencyPrice_textF.snp.bottom).offset(xjhHeight_MarginMin())
            ma.height.equalTo(xjhHeight_fieldText())
        }
        
        TransactuonCount_textF.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(valuation_Lab.snp.bottom).offset(xjhHeight_MarginMin())
            ma.height.equalTo(xjhHeight_fieldText())
            ma.right.equalToSuperview()
        }
        
        percentage_View.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(TransactuonCount_textF.snp.bottom).offset(xjhHeight_MarginMin())
            ma.height.equalTo(XJHHeight_ButSecond())
            ma.right.equalToSuperview()
        }
        
        availabel_lab.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(percentage_View.snp.bottom).offset(xjhHeight_MarginMin())
            ma.height.equalTo(xjhHeight_Lable())
        }
        
        canByt_lab.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(availabel_lab.snp.bottom)
            ma.height.equalTo(xjhHeight_Lable())
        }
        
        ok_Trasaction_Btn.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(canByt_lab.snp.bottom).offset(xjhHeight_MarginMax())
            ma.width.equalTo(wid_2 - leftMargin_CP)
            ma.height.equalTo(XJHHeight_ButMain())
        }
        
        xjh_CreatStraregyUI()
        
    }
    ///点击交易按钮
    @objc func xjh_Pri_buySellAction(btn:UIButton){
        
        ok_buy_Btn.isSelected = !ok_buy_Btn.isSelected
        ok_sell_btn.isSelected = !ok_sell_btn.isSelected
        
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_coinCoinBuySellChange.rawValue))
    }
    ///交易按钮
     @objc func XJH_TransactionButtn(){
        self.endEditing(true)
         sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_TransactionBeginAction.rawValue))
     }
     
    ///交易规则
    @objc func ok_TradingRules_BtnAction(){
        
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_TradingRulesBtnAction.rawValue))
    }
    
    
    ///初始化 止盈止损 UI
       func xjh_CreatStraregyUI(){
        
        StraregyTakePrifileView = UIView(frame: .zero)
        StraregyTakePrifileView.backgroundColor = XJHMainColor
        self.addSubview(StraregyTakePrifileView)
        StraregyTakePrifileView.isHidden = true
        
        StraregyTakePrifileView.snp.makeConstraints { (ma) in
            ma.left.right.equalToSuperview()
            ma.top.equalTo(ok_TradingRules_Btn.snp.bottom).offset(xjhHeight_MarginMin())
        }
        
        //触发价格
        StraregytriggerPrice_textF = XJH_viewsTools.xjh_Pub_TextFieldAndLeftViewRightView(placeHold:"" , text: "", letftBtnOr: false, leftText: "触发价格", rightBtnOr: false, rightText: "USDT", textWid: 60, buttonAction: { (btn) in
               
           })
        AddBorder(bordV: StraregytriggerPrice_textF, bordColor: XJHSecondTextColor, bordWidth: 0.5)
        AddRadius(StraregytriggerPrice_textF, rabF: 3)
        StraregyTakePrifileView.addSubview(StraregytriggerPrice_textF)
        StraregytriggerPrice_textF.snp.makeConstraints { (ma) in
            ma.top.left.width.equalToSuperview()
            ma.height.equalTo(xjhHeight_fieldText())
        }
           //策略委托价格
           StraregyPrice_textF = XJH_viewsTools.xjh_Pub_TextFieldAndLeftViewRightView(placeHold:"" , text: "", letftBtnOr: false, leftText: "委托价格", rightBtnOr: false, rightText: "USDT", textWid: 60, buttonAction: { (btn) in
               
           })
        AddBorder(bordV: StraregyPrice_textF, bordColor: XJHSecondTextColor, bordWidth: 0.5)
        AddRadius(StraregyPrice_textF, rabF: 3)
        StraregyTakePrifileView.addSubview(StraregyPrice_textF)
        StraregyPrice_textF.snp.makeConstraints { (ma) in
            ma.top.equalTo(StraregytriggerPrice_textF.snp.bottom).offset(xjhHeight_MarginMin())
            ma.left.width.equalToSuperview()
            ma.height.equalTo(xjhHeight_fieldText())
        }
        //委托数量
        StraregyCount_textF = XJH_viewsTools.xjh_Pub_TextFieldAndLeftViewRightView(placeHold:"" , text: "", letftBtnOr: false, leftText: "委托数量", rightBtnOr: false, rightText: "Coin", textWid: 60, buttonAction: { (btn) in
               
           })
        AddBorder(bordV: StraregyCount_textF, bordColor: XJHSecondTextColor, bordWidth: 0.5)
        AddRadius(StraregyCount_textF, rabF: 3)
        StraregyTakePrifileView.addSubview(StraregyCount_textF)
        StraregyCount_textF.snp.makeConstraints { (ma) in
            ma.top.equalTo(StraregyPrice_textF.snp.bottom).offset(xjhHeight_MarginMin())
            ma.left.width.equalToSuperview()
            ma.height.equalTo(xjhHeight_fieldText())
        }
        
        StraregyTakePrifileView.snp.makeConstraints { (ma) in
            ma.bottom.equalTo(StraregyCount_textF.snp.bottom)
        }
        
        
       }
    
    
}
