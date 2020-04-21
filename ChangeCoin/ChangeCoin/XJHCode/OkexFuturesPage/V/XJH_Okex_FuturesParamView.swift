//
//  XJH_Okex_FuturesParamView.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit
let half_cp = SCREEN_WIDTH/2 - leftMargin_CP
class XJH_Okex_FuturesParamView: XJHBaseView,UITextFieldDelegate {
    
     //----------------止盈止损 UI--------------------
     var StraregyTakePrifileView :UIView!
      /// 触发价格
     var StraregytriggerPrice_textF : UITextField!
     ///委托交易 止盈止损价格
     var StraregyPrice_textF : UITextField!
     ///委托数量
     var StraregyCount_textF : UITextField!
     //---------------限价UI---------------------
    
    // 当前价格
    var cuurentPrice : String = "0"
    ///交易规则按钮
    var ok_TradingRules_Btn : UIButton!
    ///杠杆倍数按钮
    var ok_leverageTextF : UITextField!
    var ok_leverageBtn : UIButton!
    var ok_leverageNum : Int = 0
    ///CurrencyPrice
    var CurrencyPrice_textF : UITextField!
    var CurrencyPrice : String!
    ///对手  买一  卖一
    var priceType_View :UIView!
    ///是否以对手价下单(0:不是; 1:是)
    var match_price : String = "0"
    ///交易数量
    var TransactuonCount_textF : UITextField!
    
    ///交易按钮-买
    var ok_TrasactionBuy_Btn : UIButton!
    ///可用
    var availabelLab_one: UILabel!
    ///可买 可卖
    var canBytBuy_lab : UILabel!
    
    ///交易按钮-卖
    var ok_TrasactionSell_Btn : UIButton!
    ///可用
    var availabelLab_Two: UILabel!
    ///可卖
    var canBytSell_lab : UILabel!
    
    ///可用
    var availabel_num : String = "0"

    override func initXJHView() {
        
        xjh_Pri_CreatUI()
        
        conentSizeUI()
    }
    
    
    ///更新币种资产数据
    func xjh_Pub_updateData(model: XJH_OkexFuturesSingleWallte,canByBuySell_num:String,leverage:String){
        
        if model.equity.count < 1 {
            return
        }
        
        ok_leverageBtn.setTitle(leverage, for: .normal)
        ok_leverageNum = (Int(leverage) ?? 0)
        
        availabel_num = dataCalculationAndAfter(beforeStr: model.equity, theWay: .type_subtraction, afterStr: model.margin_frozen)
        
        let availabelStr : String = "可用\n \(availabel_num) "
        
        availabelLab_one.text = availabelStr
        availabelLab_Two.text = availabelStr
        
        XJH_Pri_canMaiMaiChange(canByBuySell_num:"\(Float(canByBuySell_num)! * Float(ok_leverageNum))")
    }
    //可买 可卖 数量,,更新了杠杆会单独调用
    func XJH_Pri_canMaiMaiChange(leverage:String="",canByBuySell_num:String){

        if leverage.count > 1 {
            //更新了杠杆倍数
            ok_leverageNum = Int((Double(leverage) ?? 0))
            ok_leverageBtn.setTitle(leverage, for: .normal)
            
        }
        
        //卖出时 zil * price = usdt Double(numCoin)!*Double(price)!/leverage
        
        canBytBuy_lab.text = "可开多\n\(xjh_AutoRoundToString(canByBuySell_num))"
        canBytSell_lab.text = "可开空\n\(xjh_AutoRoundToString(canByBuySell_num))"
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //买入价格变化
//        if textField != CurrencyPrice_textF {
//            return
//        }
//        if textField.text!.count > 1 {
//
//            XJH_Pri_canMaiMaiChange(text: CurrencyPrice_textF.text)
//
//        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //开始编辑
        //如果是杠杆的 就不允许编辑
        if textField == ok_leverageTextF{
            return false
        }
        
        return true
    }
    
    
    
    func xjh_Pri_CreatUI(){
        
        //----------------------
        ok_TradingRules_Btn = UIButton(Xframe: .zero, title: "限价委托\(xjh_down_jian)", titleColor: XJHButtonColor_Blue, font: Font(font: XJHFontNum_Second()),backgroundColor: .clear)
        ok_TradingRules_Btn.addTarget(self, action: #selector(XJH_PubTradingRulesAction), for: .touchUpInside)
        
        self.addSubview(ok_TradingRules_Btn)
        
        
        //-----杠杆按钮
        ok_leverageTextF = XJH_viewsTools.xjh_Pub_TextFieldAndLeftViewRightView(letftBtnOr: false, leftText: "杠杆", rightBtnOr: true, rightText: "20.00X", textWid: 60, buttonAction: { (btn) in

        })
        ok_leverageTextF.delegate = self
        self.addSubview(ok_leverageTextF)
        
        ok_leverageBtn = myButton(type: .system, frame: CGRect(x: 0, y: 0, width: 80, height: 20), title: "0.0", colors: XJHButtonColor_Blue, andBackground: XJHBackgroundColor_dark, tag: 11) { (btn) in
            //杠杆倍数
            self.sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_futuresLeverageClick.rawValue,params: btn?.titleLabel!.text))
        }
        ok_leverageBtn?.titleLabel?.font = Font(font: XJHFontNum_Main())
        ok_leverageTextF.rightView = ok_leverageBtn
        
        //-------------交易 价格-----------------------
        CurrencyPrice_textF = XJH_viewsTools.xjh_Pub_TextFieldAndLeftViewRightView(letftBtnOr: false, leftText: "价格", rightBtnOr: false, rightText: basePrice, textWid: 60, buttonAction: { (btn) in
            
        })
        CurrencyPrice_textF.delegate = self
        self.addSubview(CurrencyPrice_textF)
        
        //---------------交易方式---------------------
        priceType_View = XJH_viewsTools.xjh_Pub_getPercentageView( arrText: ["对手价","自定义价"], height: CGFloat(xjhHeight_Lable()), tagAcion: { (strType) in
            ///
            if strType == "对手价"{
                self.match_price = "1"
                self.CurrencyPrice_textF.text = strType
                self.CurrencyPrice_textF.isUserInteractionEnabled = false
            }else{
                self.match_price = "0"
                self.CurrencyPrice_textF.text = ""
                self.CurrencyPrice_textF.isUserInteractionEnabled = true
            }
        })
        self.addSubview(priceType_View)
        //------------数量------------------------
        TransactuonCount_textF = XJH_viewsTools.xjh_Pub_TextFieldAndLeftViewRightView(placeHold: " 个数 ",letftBtnOr: false, leftText: " 数量 ", rightBtnOr: false, rightText: " 个  ", textWid: 60, buttonAction: { (btn) in
        })
        self.addSubview(TransactuonCount_textF)
        
        //-----------交易按钮-----------
        ok_TrasactionBuy_Btn = UIButton(Xframe: .zero, title: "买入开多(看涨)", titleColor: XJHMainTextColor_dark, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHGreenColor, cornerRadius: 4)
        ok_TrasactionBuy_Btn.eventInterval = btnTimeInterval_long
        ok_TrasactionBuy_Btn.addTarget(self, action: #selector(XJH_TransactionButtn), for: .touchUpInside)
        ok_TrasactionBuy_Btn.tag = 1110
        self.addSubview(ok_TrasactionBuy_Btn)
        
        ok_TrasactionSell_Btn =  UIButton(Xframe: .zero, title: "卖出开空(看跌)", titleColor: XJHMainTextColor_dark, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHRedColor, cornerRadius: 4)
        ok_TrasactionSell_Btn.eventInterval = btnTimeInterval_long
        ok_TrasactionSell_Btn.addTarget(self, action: #selector(XJH_TransactionButtn), for: .touchUpInside)
        ok_TrasactionSell_Btn.tag = 1111
        self.addSubview(ok_TrasactionSell_Btn)
        //-------------可用-----------------------、
        availabelLab_one = UILabel(Xframe: .zero, text: "可用 0.00", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHMainColor,alignment:.left,line: 2)
        self.addSubview(availabelLab_one)
        
        //  可买
        canBytBuy_lab = UILabel(Xframe: .zero, text: "可开多 0.00", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHMainColor,alignment:.left,line: 2)
        canBytBuy_lab.textAlignment = .right
        self.addSubview(canBytBuy_lab)
        
        canBytSell_lab = UILabel(Xframe: .zero, text: "可开空 0.00", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHMainColor,alignment:.left,line: 2)
        canBytSell_lab.textAlignment = .right
        self.addSubview(canBytSell_lab)
        
        availabelLab_Two = UILabel(Xframe: .zero, text: "可用 0.00", font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: XJHMainColor,alignment:.left,line: 2)
        self.addSubview(availabelLab_Two)
        
        
        
    }
    
    
    func conentSizeUI(){
        
        ok_TradingRules_Btn.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalToSuperview().offset(xjhHeight_MarginMin())
            ma.height.equalTo(XJHHeight_ButSecond())
            
        }
        ok_leverageTextF.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(ok_TradingRules_Btn.snp.bottom).offset(xjhHeight_MarginMin())
            ma.height.equalTo(xjhHeight_fieldText())
            ma.right.equalToSuperview()
        }
        
        CurrencyPrice_textF.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(ok_leverageTextF.snp.bottom).offset(xjhHeight_MarginMin())
            ma.height.equalTo(xjhHeight_fieldText())
            ma.right.equalToSuperview()
        }
        
        priceType_View.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(CurrencyPrice_textF.snp.bottom).offset(xjhHeight_MarginMin())
            ma.height.equalTo(xjhHeight_Lable())
            ma.right.equalToSuperview()
        }
        
        TransactuonCount_textF.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(priceType_View.snp.bottom).offset(xjhHeight_MarginMin())
            
            ma.right.equalToSuperview()
            ma.height.equalTo(xjhHeight_fieldText())
            
        }
        
        ok_TrasactionBuy_Btn.snp.makeConstraints { (ma) in
            ma.left.right.equalToSuperview()
            ma.top.equalTo(TransactuonCount_textF.snp.bottom).offset(xjhHeight_MarginMin())
            ma.height.equalTo(XJHHeight_ButMain())
            
        }
        
        let widAvaiW = SCREEN_WIDTH/4 - 3
        let widAvaiH = xjhHeight_Lable() * 2
        availabelLab_one.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.width.equalTo(widAvaiW)
            ma.top.equalTo(ok_TrasactionBuy_Btn.snp.bottom)
            ma.height.equalTo(widAvaiH)
        }
        canBytBuy_lab.snp.makeConstraints { (ma) in
            ma.right.equalToSuperview()
            ma.width.equalTo(availabelLab_one)
            ma.top.equalTo(availabelLab_one)
            ma.height.equalTo(availabelLab_one)
        }

        ok_TrasactionSell_Btn.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.top.equalTo(availabelLab_one.snp.bottom).offset(xjhHeight_MarginMin())
            ma.height.equalTo(XJHHeight_ButMain())
            ma.right.equalToSuperview()
        }

        availabelLab_Two.snp.makeConstraints { (ma) in
            ma.left.equalToSuperview()
            ma.width.equalTo(availabelLab_one)
            ma.top.equalTo(ok_TrasactionSell_Btn.snp.bottom)
            ma.height.equalTo(availabelLab_one)
        }
        canBytSell_lab.snp.makeConstraints { (ma) in
            ma.right.equalToSuperview()
            ma.width.equalTo(availabelLab_one)
            ma.top.equalTo(availabelLab_Two)
            ma.height.equalTo(availabelLab_one)
        }
        
        xjh_CreatStraregyUI()
    }
    
    ///期货交易规则按钮
    @objc func XJH_PubTradingRulesAction(){
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_TradingRulesBtnAction.rawValue))
    }
    
    ///期货交易按钮
    @objc func XJH_TransactionButtn(btn:UIButton){
        
        var buyOrsell :ok_FuturesOpenOrderType = .openLong
        if btn.tag == 1111{
            buyOrsell = .openShort
        }
        ///结束编辑
        self.endEditing(true)
        
        sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: OkexPageAction.xjh_futuresButtonClick.rawValue,params: buyOrsell))
    }
    
    
    ///初始化 止盈止损 UI
       func xjh_CreatStraregyUI(){
        
        StraregyTakePrifileView = UIView(frame: .zero)
        StraregyTakePrifileView.backgroundColor = XJHMainColor
        self.addSubview(StraregyTakePrifileView)
        StraregyTakePrifileView.isHidden = true
        
        StraregyTakePrifileView.snp.makeConstraints { (ma) in
            ma.left.right.equalToSuperview()
            ma.top.equalTo(ok_leverageTextF.snp.bottom).offset(xjhHeight_MarginSmall())
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
            ma.height.equalTo(StraregytriggerPrice_textF)
        }
        
        //委托数量
        StraregyCount_textF = XJH_viewsTools.xjh_Pub_TextFieldAndLeftViewRightView(placeHold:"" , text: "", letftBtnOr: false, leftText: "委托数量", rightBtnOr: false, rightText: "个", textWid: 60, buttonAction: { (btn) in
               
           })
        AddBorder(bordV: StraregyCount_textF, bordColor: XJHSecondTextColor, bordWidth: 0.5)
        AddRadius(StraregyCount_textF, rabF: 3)
        StraregyTakePrifileView.addSubview(StraregyCount_textF)
        StraregyCount_textF.snp.makeConstraints { (ma) in
            ma.top.equalTo(StraregyPrice_textF.snp.bottom).offset(xjhHeight_MarginMin())
            ma.left.width.equalToSuperview()
            ma.height.equalTo(StraregytriggerPrice_textF )
        }
        
        StraregyTakePrifileView.snp.makeConstraints { (ma) in
            ma.bottom.equalTo(StraregyCount_textF.snp.bottom)
        }
        
        
       }
    
    
    
    
}
