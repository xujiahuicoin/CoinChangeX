//
//  BaseView.swift
//  Project
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

@objc protocol XJHViewEventsDelegate : NSObjectProtocol {
    
    @objc optional func xjh_UIViewCollectEvent(eventObject : ViewEventObject)
}

class XJHBaseView: UIView,NVActivityIndicatorViewable {

    var loadingView : NVActivityIndicatorView?
    let loadingViewWidth : CGFloat = 50.0
    let loadingViewHeight : CGFloat  = 50.0
    var isShowLoanding : Bool = false
    var isCoinCoin : Bool = true
    var _tipsBacView : UIView?
    var tipsBacView : UIView? {
        
        get {
            
            if _tipsBacView == nil {
                
                let tipsBacView = UIView.init()
                self.addSubview(tipsBacView)
                
                tipsBacView.snp.makeConstraints({ (make) in
                    make.edges.equalTo(self)
                })
                _tipsBacView = tipsBacView
                
                return tipsBacView
                
            }else {
                return _tipsBacView
            }
        }
        
        set {
            _tipsBacView = newValue
        }
    }

    weak var delegate : XJHViewEventsDelegate? {
        
        didSet{
            
            self.initConfig()
        }
    }
    
//    初始化
    class func view() -> Self! {
        
        let instance = self.init()
        instance.initXJHView()
        return instance
    }
    
    class func view(parmas : ViewDataObject) -> Self! {
        
        let instance = self.init()
        instance.initXJHView(parmas: parmas)
        return instance
    }

//    子类重写
    func initXJHView() {}
    func initXJHView(parmas : ViewDataObject) {
        
        ////走这一步带参数的 挂代理 会要放在最后 不然报错
        
    }
    /**
     赋值代理（当父View的代理被赋值后，会调用initConfig方法。）
     */
    func initConfig() {}
    
//    更新view
    func updateView(datas : ViewDataObject) {}
    
//    发送代理方法
    func sendViewDelegateEvent(eventObject : ViewEventObject) {
        
        if self.delegate != nil {
            self.delegate!.xjh_UIViewCollectEvent?(eventObject: eventObject)
        }
    }
    
//    弹出指示器
    func xjh_showHUD(_ loadingType : NVActivityIndicatorType = .ballSpinFadeLoader, color : UIColor = XJHMainColor, padding : CGFloat = 50.0) {
        
        self.isShowLoanding = true
        
        if self.loadingView != nil {
            self.loadingView?.stopAnimating()
        }
        
        self.loadingView = NVActivityIndicatorView(frame: CGRect(x: (self.frame.size.width - self.loadingViewWidth) / 2, y: (self.frame.size.height - self.loadingViewHeight) / 2, width: self.loadingViewWidth, height: self.loadingViewHeight), type: loadingType, color: color, padding: padding)
        self.addSubview(self.loadingView!)
        
        self.loadingView?.startAnimating()
    }
    
//    关闭指示器
    func xjh_hiddenHud() {
        
        if self.loadingView != nil {
            self.loadingView?.stopAnimating()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.loadingView != nil {
            
            self.loadingView?.frame = CGRect(x: (self.frame.size.width - self.loadingViewWidth) / 2, y: (self.frame.size.height - self.loadingViewHeight) / 2, width: self.loadingViewWidth, height: self.loadingViewHeight)
        }
    }


}
