

import Foundation
import UIKit
public extension UILabel {
    
    convenience init(Xframe: CGRect = CGRect.zero,text: String = "", font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black, backgroundColor: UIColor = .white, cornerRadius: CGFloat = 0, borderColor: UIColor = .white, alignment:NSTextAlignment = .left, borderWidth: CGFloat = 0, line: Int = 1) {
        
        self.init(frame: Xframe)
        
        self.text = text
        self.font = font
        
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        
        //可选的默认
        self.textAlignment = alignment
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.numberOfLines = line
        
        
    }
    
}
