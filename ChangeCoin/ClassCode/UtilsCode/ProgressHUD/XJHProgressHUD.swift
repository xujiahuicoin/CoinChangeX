//
//  ProgressHUD.swift
//  Project
//
//  Created by mac on 2019/6/17.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit
import PKHUD

class XJHProgressHUD: NSObject {

    
    class func showSuccess(message : String, view : UIView) {
        
        HUD.flash(.label(message), onView: view, delay: showtime, completion: nil)
    }
    
    class func showSuccess(message : String) {
        
        HUD.flash(.label(message), delay: showtime, completion: nil)
    }
    
    class func showError(message : String, view : UIView) {
        
        HUD.flash(.label(message), onView: view, delay: showtime, completion: nil)
        
    }
    
    class func showError(message : String) {
        
        HUD.flash(.label(message), delay: showtime, completion: nil)
    }
    
    class func show(view : UIView) {
        
        HUD.show(.progress, onView: view)
    }
    class func show() {
        
        HUD.show(.progress)
    }
    
    class func hide() {
        
        HUD.hide()
    }
    
    
}
