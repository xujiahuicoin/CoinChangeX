

import Foundation
import UIKit
public extension UIButton {
    
    convenience  init(Xframe: CGRect = CGRect.zero, title: String = "", titleColor: UIColor = .black, font: UIFont = UIFont.systemFont(ofSize: 14), backgroundColor: UIColor =  .clear, imageName: String = "", cornerRadius: CGFloat = 0, borderWidth: CGFloat = 0, borderColor: UIColor = .white) {
        
        self.init(frame:Xframe)
        
    if !title.isEmpty {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal) }
        
        if !imageName.isEmpty
        {
            self.setImage( UIImage(named: imageName), for: .normal)
            self.imageView?.contentMode = .scaleAspectFill
        }
        
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
       
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        
    }
    
}


///返回google 三原色的 btn
func returnBtnGoogleColor(title: String,imageName:String?, color1R2Y3G: Int) -> UIButton {
    
   
    let btn = UIButton(Xframe: CGRect.zero, title: title, titleColor: .white, font: .boldSystemFont(ofSize: 15), backgroundColor: color1R2Y3G == 1 ? RGB(193, g: 81, b: 71) : (color1R2Y3G == 2 ? RGB( 242, g: 204, b: 79) : RGB( 92, g: 159, b: 97))  , imageName: "", cornerRadius: 8)
    if imageName != nil {
        btn.setImage( UIImage(named: imageName!), for: .normal)
        btn.setTitle("", for: .normal)
    }
    AddShadow(shadowView: btn, shadowColor: .gray, shadowOpacity: 0.8, shadowRadius: 3, shadowOffset: CGSize(width: 0, height: 0))
    
    return btn
    
}
