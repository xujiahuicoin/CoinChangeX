//
//  func_Expantion.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/6.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import Foundation

//----------------扩展--------------------

extension String {
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
     
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    
    // base64编码
    func toBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }

    // base64解码
    func fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

extension Double {
    
    ///四舍五入 到小数点后某一位
    func roundTo(places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
    }
    ///截断 到小数点后某一位
    func truncate(places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return Double(Int(self * divisor)) / divisor
    }

    
    ///保留x位小数的,默认 截断--or--四舍五入
    func xjh_roundToDouble(places:Int,truncate_true:Bool = true) -> Double {
        
        if truncate_true {
           return truncate(places: places)
        }else{
            return roundTo(places: places)
        }

        
    }
    ///保留x位小数的,默认 截断--or--四舍五入
    func xjh_roundToString(places:Int,truncate_true:Bool = true) -> String {
        
        if truncate_true {
           return "\(truncate(places: places))"
        }else{
            return "\(roundTo(places: places))"
        }
    }
    
}

///自动取位数--大于1w==10k ,默认 截断--or--四舍五入
/// - Parameter doubleStr: 数字字符串/科学计数法转化
/// - Parameter doubleDou: 小数
/// - Parameter truncate_true: 默认 切断
func xjh_AutoRoundToString(_ doubleStr:String = "0",doubleDou:Double = 0, truncate_true:Bool = true) -> String {

    var double : Double = Double(doubleStr) ?? 0
    
    // if doubleDou == 0，bug  可能为负数
    if doubleStr ==  "0" {
        double = doubleDou
    }else{
        //传进来的是字符串
        //科学计数法转化
        if doubleStr.contains("E-"){
            let strArr = doubleStr.components(separatedBy: "E-")
            
            //得到小数位
            let intPoint = Int(strArr[1]) ?? 0
            let doubleS = Double(strArr[0]) ?? 0
            
            if intPoint == 4{
                return xjh_AutoRoundToString(doubleDou: doubleS * 0.0001)
            }else if intPoint == 5{
                return xjh_AutoRoundToString(doubleDou: doubleS * 0.00001)
            }else if intPoint == 6{
                return xjh_AutoRoundToString(doubleDou: doubleS * 0.000001)
            }else if intPoint == 7{
                return xjh_AutoRoundToString(doubleDou: doubleS * 0.0000001)
            }else if intPoint == 8{
                return xjh_AutoRoundToString(doubleDou: doubleS * 0.00000001)
            }
            
        }
        
    }
    
    //取绝对值  盈利 有-负数
    let fabsDou:Double = fabs(double)
    
    
       if fabsDou < 0.0001 {
           //返回原值
        return doubleStr
       }

     var places:Int = 4
    
       if fabsDou > 0.001 {

           places = 4

       }
    
    if fabsDou > 0.01 {

        places = 3

    }

       if fabsDou  > 10{
           places = 2
       }

       if fabsDou  > 100{
           places = 1
       }

       if fabsDou > 10000{

        return "\((double/1000).xjh_roundToString(places: 2))k"

       }else {

        var double = double.truncate(places: places)

           if !truncate_true {

            double = double.roundTo(places: places)
           }
           
           return "\(double)"
       }


   }
   


///修改小数的位数限制
//func XJH_fixNumDouble(double: String, minLimit:NSInteger = 1, maxLimit:NSInteger = 8) -> String{
//    
//    let doubleNum : Double = Double(double) ?? 0
//     if doubleNum > 10000{
//        return "\(doubleNum/1000)k"
//    }
//    
//    let tempNum = NSNumber() //NSDecimalNumber(string: double, locale: Locale(identifier: "zh-Hans_CN"))
//    let formatter = NumberFormatter()
//    formatter.locale = Locale(identifier: "zh-Hans_CN")
//    //设置小数样式位小数
//    formatter.numberStyle = .none
//    //设置小数位数1
//    formatter.minimumIntegerDigits = 1
//    //设置进位模式
//    formatter.roundingMode = .down
//    //设置最小位数限制
//    if minLimit >= 0 {
//        formatter.minimumIntegerDigits = minLimit
//    }
//    //设置最大位数限制
//    if maxLimit >= 0 {
//        formatter.maximumIntegerDigits = maxLimit
//    }
//    
//    //上述格式输出字符串
//    return formatter.string(from: tempNum) ?? ""
//    
//}


extension Date {
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    var timeStringStamp : String {
           let timeInterval: TimeInterval = self.timeIntervalSince1970
           let timeStamp = Int(timeInterval)
           return "\(timeStamp)"
       }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return Int(millisecond)
    }
}


//---------------常用方法---------------------
///label高度自适应
func getLabelHegit(str: String, font: UIFont, width: CGFloat)-> CGFloat {
    
    let statusLabelText: String = str as String
    
    let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
    
    let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
    
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : AnyObject], context: nil).size
    
    return strSize.height
}

///切圆角
func AddRadius (_ RView:UIView,rabF:CGFloat){
    RView.layer.cornerRadius = rabF
    RView.layer.masksToBounds = true
}

///边框
func AddBorder(bordV:UIView , bordColor:UIColor ,bordWidth:CGFloat) -> Void {
    bordV.layer.borderColor = bordColor.cgColor
    bordV.layer.borderWidth = bordWidth
}

///阴影
func AddShadow(shadowView:UIView, shadowColor:UIColor, shadowOpacity:CGFloat, shadowRadius:CGFloat, shadowOffset:CGSize){
    shadowView.layer.shadowColor = shadowColor.cgColor
    shadowView.layer.shadowOffset = shadowOffset
    shadowView.layer.shadowRadius = shadowRadius
    shadowView.layer.shadowOpacity = Float(shadowOpacity)
}

///获取本地图片
func getImage(imageName:String) -> UIImage? {
    return UIImage.init(named: imageName)
}
func timeStampToString(timeStamp:String)->String {
    
    let string = NSString(string: timeStamp)
    
    let timeSta:TimeInterval = string.doubleValue
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="MM-dd HH:mm"
    
    let date = NSDate(timeIntervalSince1970: timeSta)
    
    print(dfmatter.string(from: date as Date))
    return dfmatter.string(from: date as Date)
}
///------------登录判断------------------------
func xjh_loginISOk(){
    UserDefaults.standard.set(true, forKey: "login")
    ///登录成功
     NotificationCenter.default.post(name: NSNotification.Name("loginIn"), object: nil)
}

func xjh_loginISNil(){
    UserDefaults.standard.set(false, forKey: "login")
    ///退出成功
    NotificationCenter.default.post(name: NSNotification.Name("loginOut"), object: nil)
}

func xjh_isLoginIs() -> Bool {
    
    let loginBool:Bool = UserDefaults.standard.bool(forKey: "login")
    
    return loginBool
}

 // 获取顶层控制器 根据window
func xjh_getTopVC() -> (UIViewController?) {
    var window = UIApplication.shared.keyWindow
    //是否为当前显示的window
   if window?.windowLevel != UIWindow.Level.normal{
      let windows = UIApplication.shared.windows
      for  windowTemp in windows{
       if windowTemp.windowLevel == UIWindow.Level.normal{
          window = windowTemp
          break
      }
    }
  }
  let vc = window?.rootViewController
  return getTopVC(withCurrentVC: vc)
 }

  ///根据控制器获取 顶层控制器
func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
 if VC == nil {
    print("🌶： 找不到顶层控制器")
    return nil
}
 if let presentVC = VC?.presentedViewController {
    //modal出来的 控制器
    return getTopVC(withCurrentVC: presentVC)
}else if let tabVC = VC as? UITabBarController {
  // tabBar 的跟控制器
    if let selectVC = tabVC.selectedViewController {
      return getTopVC(withCurrentVC: selectVC)
    }
    return nil
} else if let naiVC = VC as? UINavigationController {
  // 控制器是 nav
    return getTopVC(withCurrentVC:naiVC.visibleViewController)
  } else {
  // 返回顶控制器
  return VC
  }
}


///控件边线设置
func setBorderWithView(bordView:UIView , top:Bool , left:Bool , bottom:Bool , right:Bool , bordColor:UIColor , bordWidth:CGFloat) -> Void {
    if top {
        let topLayer = CALayer.init()
        topLayer.frame = CGRect(x: 0, y: 0, width: bordView.frame.size.width, height: bordWidth)
        topLayer.backgroundColor = bordColor.cgColor;
        bordView.layer.addSublayer(topLayer)
    }
    
    if left {
        let leftLayer = CALayer.init()
        leftLayer.frame = CGRect(x: 0, y: 0, width: bordWidth, height: bordView.frame.size.height)
        leftLayer.backgroundColor = bordColor.cgColor;
        bordView.layer.addSublayer(leftLayer)
    }
    
    if  bottom{
        let bottomLayer = CALayer.init()
        bottomLayer.frame = CGRect(x: 0, y: bordView.frame.size.height - bordWidth, width: bordView.frame.size.width, height: bordWidth)
        bottomLayer.backgroundColor = bordColor.cgColor;
        bordView.layer.addSublayer(bottomLayer)
    }
    
    if right {
        let rightLayer = CALayer.init()
        rightLayer.frame = CGRect(x: bordView.frame.size.width - bordWidth, y: 0, width: bordWidth, height: bordView.frame.size.height)
        rightLayer.backgroundColor = bordColor.cgColor;
        bordView.layer.addSublayer(rightLayer)
    }
    
    
   
}

///--------------链接网络----------------------

func networkingGoNoing(){
   
}

extension UIDevice {

public class func isPad() -> Bool {

return UIDevice.current.userInterfaceIdiom == .pad

}

public class func isPhone() -> Bool {

return UIDevice.current.userInterfaceIdiom == .phone

}

}
