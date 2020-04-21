//
//  XJH_CoinTools.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//


//---------------创建视图UI 控件---------------------

import UIKit
class XJH_viewsTools: NSObject {
    
    
    /// 创建 带有TextField  左右视图的，没有wid = 0.01
    /// - Parameter placeHold: 若提示文字
    /// - Parameter text: 文字
    /// - Parameter keyType: 键盘类型，默认数字
    /// - Parameter letftBtnOr: 左 默认button
    /// - Parameter leftText: 左：文字
    /// - Parameter rightBtnOr: 右：默认button
    /// - Parameter rightText: 右 文字
    /// - Parameter textWid: 左右view 宽度
    /// - Parameter buttonAction: 点击事件 tag值
    class func xjh_Pub_TextFieldAndLeftViewRightView(frame: CGRect = .zero, placeHold: String = "",text: String = "",keyType:UIKeyboardType = .decimalPad ,letftBtnOr:Bool = true,leftText:String = "-",rightBtnOr:Bool = true,rightText:String = "+",textWid:CGFloat = 35.0,buttonAction: @escaping (_ btn:UIButton)->()) -> UITextField {
        
        let textField = UITextField(Xframe: frame, font: Font(font: XJHFontNum_Main()), textColor: XJHMainTextColor_dark, backgroundColor: XJHBackgroundColor_dark, placeholder: placeHold.count > 1 ? placeHold : "", cornerRadius: 3)
        textField.textAlignment = .center
        textField.keyboardType = keyType
        
        if text.count > 1 {
            textField.text = text
        }
        
        //------------------------------------
        let leftFrame = CGRect(x: 8, y: 0, width: iPhoneWidth(w: textWid), height: frame.height)
        
        if letftBtnOr {
            let xjh_subtractBtn = myButton(type: .system, frame: leftFrame, title: leftText, colors: XJHButtonColor_Blue, andBackground: XJHBackgroundColor_dark, tag: 10) { (btn) in
                
                buttonAction(btn!)
            }
            xjh_subtractBtn?.titleLabel?.font = Font(font: XJHFontNum_Main())
            textField.leftView = xjh_subtractBtn
            
        }else{
            //
            let leftLab = UILabel(Xframe: leftFrame , text: leftText, font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: .clear,alignment: .center)
            textField.leftView = leftLab
        }
        textField.leftViewMode = .always
        
        
        //------------------------------------
        let rightFrame = CGRect(x: frame.width-textWid, y: 0, width: textWid, height: frame.height)
        
        if rightBtnOr {
            let xjh_AddBtn = myButton(type: .system, frame: rightFrame, title: rightText, colors: XJHButtonColor_Blue, andBackground: XJHBackgroundColor_dark, tag: 11) { (btn) in
                
                buttonAction(btn!)
            }
            xjh_AddBtn?.titleLabel?.font = Font(font: XJHFontNum_Main())
            textField.rightView = xjh_AddBtn
        }else{
            let rightLab = UILabel(Xframe: rightFrame, text: rightText, font: Font(font: XJHFontNum_Second()), textColor: XJHSecondTextColor, backgroundColor: .clear,alignment: .center)
            textField.rightView = rightLab
        }
        textField.rightViewMode = .always
        
        
        return textField
    }
    
    ///返回获取的百分比 按钮
    class func xjh_Pub_getPercentageView(frame: CGRect = .zero, arrText:Array<String> = ["25%","50%","75%","100%"],height:CGFloat = 25 ,tagAcion:@escaping (_ btnText:String)->()) -> UIView {
        
        let numBtn = CGFloat(arrText.count)
        let view = UIView(frame: frame, backgroundColor: XJHMainColor)
        let wid = (half_cp - 5.0 * numBtn)/numBtn

        for (index,intNum) in arrText.enumerated() {
            
            let bttn = myButton(type: .system, frame: CGRect(x: CGFloat(index) * (wid + 5.0), y: 0, width: wid, height: height), title: intNum, colors: XJHMainTextColor_dark, andBackground: XJHBackgroundColor_dark, tag: 1+index) { (btn) in
                
                tagAcion(btn!.titleLabel!.text!)
            }
            AddRadius(bttn!, rabF: 3)
            bttn!.titleLabel?.font = Font(font: XJHFontNum_Second())
            view.addSubview(bttn!)
        }
        return view
        
    }
    
  
}
