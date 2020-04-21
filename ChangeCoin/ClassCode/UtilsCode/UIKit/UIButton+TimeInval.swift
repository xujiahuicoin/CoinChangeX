
/*
 
 // 由于在swift4中 initialize() 已经被废弃 所以自己写一个方法，并在Appdelegate中调用
 UIButton.initializeMethod()
 
 设置时间（默认2s）
 but.eventInterval = 2

*/


import Foundation
import UIKit
// 防止按钮连点
public extension UIButton {
    
    private struct AssociatedKeys {
        static var eventInterval = "eventInterval"
        static var eventUnavailable = "eventUnavailable"
    }
    
    /// 重复点击的时间 属性设置
    var eventInterval: TimeInterval {
        get {
            if let interval = objc_getAssociatedObject(self, &AssociatedKeys.eventInterval) as? TimeInterval {
                return interval
            }
            return 2
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.eventInterval, newValue as TimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 按钮不可点 属性设置
    private var eventUnavailable : Bool {
        get {
            if let unavailable = objc_getAssociatedObject(self, &AssociatedKeys.eventUnavailable) as? Bool {
                return unavailable
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.eventUnavailable, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 新建初始化方法,在这个方法中实现在运行时方法替换
    class func initializeMethod() {
        let selector = #selector(UIButton.sendAction(_:to:for:))
        let newSelector = #selector(new_sendAction(_:to:for:))
        
        let method: Method = class_getInstanceMethod(UIButton.self, selector)!
        let newMethod: Method = class_getInstanceMethod(UIButton.self, newSelector)!
        
        if class_addMethod(UIButton.self, selector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) {
            class_replaceMethod(UIButton.self, newSelector, method_getImplementation(method), method_getTypeEncoding(method))
        } else {
            method_exchangeImplementations(method, newMethod)
        }
    }
    
    /// 在这个方法中
    @objc private func new_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if eventUnavailable == false {
            eventUnavailable = true
            new_sendAction(action, to: target, for: event)
            // 延时
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + eventInterval, execute: {
                self.eventUnavailable = false
            })
        }
    }
}

