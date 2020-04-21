

import UIKit

extension UIColor {
    
    /// 动态颜色
    /// - Parameter lightColor: lightMode Color
    /// - Parameter darkColor: darkMode Color
    static func xjh_color(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        
        var color: UIColor = lightColor
        
        if #available(iOS 13.0, *) {
            color = UIColor.init { (trainCollection: UITraitCollection) -> UIColor in
                if trainCollection.userInterfaceStyle == UIUserInterfaceStyle.dark {
                    // 黑暗模式
                    return darkColor
                }else {
                    // 其他模式
                    return lightColor
                }
            }
        }
        
        return color
    }
    
    
    /// 动态颜色(16进制)
    /// - Parameter lightColor: lightMode Color
    /// - Parameter darkColor: darkMode Color
    static func xjh_color(lightColor: Int, darkColor: Int) -> UIColor {
        
        var color = UIColor.gl_hex(hex: lightColor)
        
        if #available(iOS 13.0, *) {
            color = UIColor.init { (trainCollection: UITraitCollection) -> UIColor in
                if trainCollection.userInterfaceStyle == UIUserInterfaceStyle.dark {
                    // 黑暗模式
                    return UIColor.gl_hex(hex: darkColor)
                }else {
                    // 其他模式
                    return UIColor.gl_hex(hex: lightColor)
                }
            }
        }
        
        return color
    }
    
    /// 16进制转UIColor
    /// - Parameter hex: 16进制值
    /// - Parameter alpha: 透明度
    static func gl_hex(hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        
        return self.init(red:CGFloat(((hex & 0xff0000) >> 16)) / 255.0, green: CGFloat(((hex & 0xFF00) >> 8)) / 255.0, blue: CGFloat((hex & 0xFF)) / 255.0, alpha: alpha)
    }
    
}
