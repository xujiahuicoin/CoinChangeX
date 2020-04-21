///
///  ConstHeader.swift
///  xujiahuiCoin
///
///  Created by mac on 2019/10/14.
///  Copyright © 2019 www.xujiahuiCoin.cn. All rights reserved.
///
import UIKit
import Foundation
import SnapKit
import ESPullToRefresh
import Kingfisher
import BFKit
import SCLAlertView
import Alamofire
import XLForm
import GZIP
import GZIP.NSData_GZIP

//--------------项目的数值----------------------
///是否测试
let appTesting = true

///请求长循环
let getLongTime = 3.5
///请求短循环
let getShortTime = 0.25
///hud 展示时间
let showtime = 1.5
///-1.5s-防止连续点击 延迟
let btnTimeInterval_long = 1.5
///-0.5s-防止连续点击 延迟
let btnTimeInterval_short = 1.0

//---------------项目固定字符串---------------------
let basePrice = "USD"
let xjh_PullDown = "xjh_PullDown"
let xjh_PullUp = "xjh_PullUp"
let xjh_Reload_Data = "xjh_Reload_Data"
let xjh_down_jian = "▼"

//---------------三方Key---------------------
//百度翻译API
///百度翻译API ID
let Baidu_APPID = "20190528000302544"
let Baidu_pass = "HJVizU6ZtPwyJgUm6gZw"

//腾讯Buyly
let Tencent_APPID = "d7631f951b"
let Tencent_AppKey = "d9436467-ae1d-4210-ba66-543d5989c060"

//-------------项目 宽高值-----------------------
/// 屏幕的宽
let xjh_WidthScreen = UIScreen.main.bounds.size.width
/// 屏幕的高
let xjh_heightScreen = UIScreen.main.bounds.size.height

//-------------控件的高度

//---------------iPhone 下的适配---------------------

///获取高度 iphone为准  适应 IiPad
func XJHGetHeght(height:CGFloat) ->CGFloat{
    
    if UIDevice.isPad(){
        return iPhoneWidth(w: height) * 0.7
    }
    
    return iPhoneWidth(w: height)
    
}

///字体大小  Max Text font --16
func XJHFontNum_Max() -> CGFloat {
    
    if UIDevice.isPad(){
        return 22
    }
    
   return 32
}
///main Text font --15
func XJHFontNum_Main() -> CGFloat {
    
    if UIDevice.isPad(){
        return 17
    }
    
   return 28
}
///Second Text font --13
func XJHFontNum_Second() -> CGFloat {
    
    if UIDevice.isPad(){
        return 15
    }
    
   return 26
}

///按钮高度--主要
func XJHHeight_ButMain() -> Int {
    
    if UIDevice.isPad(){
        return iPhoneWidth(w:45)
    }
    
   return iPhoneWidth(w:70)
}
///按钮高度--次要
func XJHHeight_ButSecond() -> Int {
    
    if UIDevice.isPad(){
        return iPhoneWidth(w:30)
    }
    
   return iPhoneWidth(w:55)
}
///输入框的高度
func xjhHeight_fieldText()-> Int {
    
    if UIDevice.isPad(){
        return iPhoneWidth(w:40)
    }
    
   return iPhoneWidth(w:60)
}
///正常的布局上下间距
func xjhHeight_MarginSmall()-> Int {
    
    if UIDevice.isPad(){
        return iPhoneWidth(w:4)
    }
    
   return iPhoneWidth(w:8)
}
///正常的布局上下间距
func xjhHeight_MarginMin() -> Int {
    
    if UIDevice.isPad(){
        return iPhoneWidth(w:6)
    }
    
   return iPhoneWidth(w:10)
}
func xjhHeight_MarginMax() -> Int {
    
    if UIDevice.isPad(){
        return iPhoneWidth(w:16)
    }
    
   return iPhoneWidth(w:20)
}
///正常下的Label
func xjhHeight_Lable() -> Int {
    
    if UIDevice.isPad(){
        return iPhoneWidth(w:30)
    }
    
   return iPhoneWidth(w:45)
}
///单行tableView的高度
func xjhHeight_TabCell() -> CGFloat {
    
    if UIDevice.isPad(){
        return iPhoneWidth(w:65.0)
    }
    
   return iPhoneWidth(w:90.0)
}



//-------------
///正常左右间距
let leftMargin_CP : CGFloat = 20
///正常左右间距
let rightMargin_CP : CGFloat = 18

//-------------
///比例尺适配----宽
func iPhoneWidth(w:CGFloat)->CGFloat {
    return UIScreen.main.bounds.size.width * (w/750.0)
}
///比例尺适配----宽
func iPhoneWidth(w:Int)->Int {
    return Int(UIScreen.main.bounds.size.width * (CGFloat(w)/750.0))
}
/////比例尺适配----高
//func iPhoneHeight(h:CGFloat)->CGFloat {
//    return UIScreen.main.bounds.size.height * (h/1334.0)
//}
/////比例尺适配----高
//func iPhoneHeight(h:Int)->Int {
//    return Int(UIScreen.main.bounds.size.height * (CGFloat(h) / 1334.0))
//}

//---------------屏幕固定要求---------------------
/// 导航栏高度
let xjh_HeightNav : CGFloat = 44
///x安全底部距离
let xjh_TabMustAddSafe : CGFloat = (isIphoneX ? 34:0)
///状态栏高度
let xjh_Status_H : CGFloat = (isIphoneX ? 44:20)
///顶部状态栏+导航高度
let xjh_HeightNav_top : CGFloat = (isIphoneX ? 88:64)
///底部安全区域的高度
let xjh_TabHeight : CGFloat = (isIphoneX ? 83:49)

//-------------机型适配-----------------------
let XJHIsiPhoneX = __CGSizeEqualToSize(CGSize.init(width: 1125/3, height: 2436/3), UIScreen.main.bounds.size)

let XJHIsiPhoneXr = __CGSizeEqualToSize(CGSize.init(width: 828/2, height: 1792/2), UIScreen.main.bounds.size)

let XJHIsiPhoneXs = __CGSizeEqualToSize(CGSize.init(width: 1125/3, height: 2436/3), UIScreen.main.bounds.size)

let XJHIsiPhoneXs_Max = __CGSizeEqualToSize(CGSize.init(width: 1242/3, height: 2688/3), UIScreen.main.bounds.size)

let isIphoneX = (XJHIsiPhoneX || XJHIsiPhoneXr || XJHIsiPhoneXs||XJHIsiPhoneXs_Max)


//---------------颜色---------------------
/// 十六进制设置颜色
func ABCHexColor(_ rgbValue:Int) -> UIColor {
    
    return UIColor.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: 1.0)
}

///不透明
func RGB (_ r:CGFloat,g:CGFloat,b:CGFloat)-> UIColor{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}
///自定义透明
func RGBA (_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)-> UIColor{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
///随机色
var ABCRandomColor: UIColor {
    get {
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

/// 主色
let XJHMainColor : UIColor          = RGB(33,g: 38, b: 56)
/// 背景色
///let XJHBackgroundColor :UIColor     = UIColor.white
let XJHBackgroundColor_dark :UIColor = RGB(23,g: 27, b: 48)
/// 间隔块颜色
let XJHSpaceColor : UIColor         = RGB(23,g: 28, b: 48)
/// 分割线颜色
let XJHLineColor : UIColor          = XJHSpaceColor
/// 一级字体颜色
///let XJHMainTextColor : UIColor      = UIColor.black
let XJHMainTextColor_dark : UIColor = RGB(236,g: 236, b: 236)

let XJHMainTextColor_White : UIColor      = UIColor.white
let XJHMainTextColor_White_Dark : UIColor = RGB(201,g: 201, b: 201)
/// 次级字体颜色
let XJHSecondTextColor : UIColor    = RGB(163,g: 167, b: 161)
///浅蓝色
let XJHButtonColor_Blue: UIColor        = RGB(48,g: 117, b: 234)

/// 红色
let XJHRedColor: UIColor        = RGB(169,g: 21, b: 23)
///浅红色
let XJHRedColor_light: UIColor        = RGB(253,g: 177, b: 171)
/// 绿色
let XJHGreenColor: UIColor      = RGB(48,g:127,b:64)
///浅绿色
let XJHGreenColor_light: UIColor        = RGB(203,g: 245, b: 227)


///加粗字体
func FontBold(font: CGFloat) -> (UIFont) {
    return UIFont.boldSystemFont(ofSize: iPhoneWidth(w: font))
}

///正常
func Font(font: CGFloat) -> (UIFont) {
    return UIFont.systemFont(ofSize: iPhoneWidth(w: font))
}

///自定义字体
func NameFont(nameT:String ,font:CGFloat)-> (UIFont){
    return UIFont(name:nameT , size:font)!
}
///字体名称
let light = "PingFangSC-Light"///苹方细体
let regular = "PingFangSC-Regular"///苹方体

