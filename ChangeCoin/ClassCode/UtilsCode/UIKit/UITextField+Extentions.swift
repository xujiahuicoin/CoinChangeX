
import Foundation
import UIKit
public extension UITextField
{
    convenience init(Xframe: CGRect = CGRect.zero, font: UIFont, textColor: UIColor, backgroundColor: UIColor,placeholder: String = "", cornerRadius: CGFloat = 0, borderColor: UIColor = .white, borderWidth: CGFloat = 0) {
        
        self.init(frame:Xframe)
        self.font = font
        self.textColor =  textColor
        
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        
        
    }
    
}
