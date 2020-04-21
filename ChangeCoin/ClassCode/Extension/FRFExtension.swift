
//
//  FRFExtension.swift
//  JinriFutures
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 HMC. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    class func label(text : String = "", font : UIFont, textColor : UIColor) -> UILabel {
        
        let label = UILabel.init()
        label.text = text
        label.font = font
        label.textColor = textColor
        return label
        
    }
}

/// 字体类型
///
/// - regular: 默认字体
/// - medium: 加粗字体
enum MVPFontType : String {
    
    case regular = "PingFang-SC-Regular"
    case medium = "PingFang-SC-Medium"
}

extension UIFont {
    
    class func font(type : MVPFontType = .regular, size : CGFloat) -> UIFont {
        
        return UIFont.init(name: type.rawValue, size: size)!
    }
}
