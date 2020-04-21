//
//  BaseViewExtension.swift
//  Pro
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019 hhl. All rights reserved.
//

import Foundation
import UIKit

extension XJHBaseView {
    
    func createErrorView(_ error : XJHError, showErrorMessage : Bool = true, errorMessage : String? = nil) {
        
        self.xjh_hiddenHud()

        if showErrorMessage == true {
            if errorMessage == nil {
                XJHProgressHUD.showError(message: error.message)
            }else {
                XJHProgressHUD.showError(message: errorMessage!)
            }
        }
        
        if self.tipsBacView != nil {
            self.tipsBacView!.removeFromSuperview()
            self.tipsBacView = nil
        }
        
        let button = UIButton.init(type: .system)
        button.setTitleColor(XJHSecondTextColor, for: .normal)
        button.titleLabel?.font = Font(font: XJHFontNum_Max())
        button.addTarget(self, action: #selector(xjh_buttonClick), for: .touchUpInside)
        self.tipsBacView?.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.tipsBacView!)
        }
        
        var buttonTitle : String = ""
        
        switch error.code {
        case 404,500,503,-1001,-1005:
            buttonTitle = "服务器开小差了，轻触重试"
            break
        case -1004,-1009,-1011:
            buttonTitle = "网络不翼而飞，轻触重试"
            break
        default:
            buttonTitle = "请求失败，轻触重试"
            break
        }
        button.setTitle(buttonTitle, for: .normal)
    }
    
    @objc func xjh_buttonClick() {
        
        if self.isShowLoanding == true {
            self.xjh_showHUD()
        }
        
        self.tipsBacView!.removeFromSuperview()
        self.tipsBacView = nil
        
        self.sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: xjh_Reload_Data))
    }
}
