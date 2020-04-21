

import Foundation
import UIKit
public extension UITextView {
    
    convenience  init(Xframe: CGRect = CGRect.zero, text: String = "", font: UIFont, textAlignment: NSTextAlignment, textColor: UIColor, backgroundColor: UIColor,cornerRadius: CGFloat = 0, borderColor: UIColor = .white, borderWidth: CGFloat = 0, editable: Bool = true, userInteractionEnabled: Bool = true, scrollEnabled: Bool = true, returnKeyType: UIReturnKeyType = UIReturnKeyType.default, keyboardType: UIKeyboardType = UIKeyboardType.default) {
        self.init(frame:Xframe)
        
        self.text = text
        //字体
        self.font = font
        //对齐
        self.textAlignment = textAlignment
        //字体颜色
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor =  borderColor.cgColor
        self.layer.borderWidth =  borderWidth
        
        //允许编辑
        self.isEditable = editable
        //用户交互     ///////若想有滚动条 不能交互 上为No，下为Yes
        self.isUserInteractionEnabled = userInteractionEnabled
      
        //滑动
        self.isScrollEnabled = scrollEnabled
        //返回键盘类型
        self.returnKeyType = returnKeyType
        //键盘类型
        self.keyboardType = keyboardType

    }
    
}
