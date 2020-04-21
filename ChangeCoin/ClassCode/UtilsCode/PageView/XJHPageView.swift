//
//  PageView.swift
//  Pro
//
//  Created by mac on 2019/6/19.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit

@objc protocol XJHPageViewDelegate : NSObjectProtocol {
    
    @objc optional func pageView(_ pageView : XJHPageView, didSelectIndexAt index : Int)
}

class XJHPageView: UIView {

    weak var delegate : XJHPageViewDelegate?
    
    var buttonNormalColor : UIColor!
    var buttonSelectedColor : UIColor!
    var xjh_LineColor : UIColor!
    
    var lastButton : UIButton?
    lazy var lineView : UIView = {
        
        let view = UIView.init()
        view.backgroundColor = self.xjh_LineColor
        self.addSubview(view)
        return view
        
    }()
    
    class func pageView() -> XJHPageView {
        
        let pageView = XJHPageView.init()
        pageView.initProperty()
        return pageView
    }
    
//    初始化
    func initProperty() {
        
        self.xjh_LineColor = .red
        self.buttonNormalColor = .gray
        self.buttonSelectedColor = .red
    }
    
    func updatePageView(titles : [String], currentIndex : Int = 0) {
        
        for (index, value) in titles.enumerated() {
            
            let button = UIButton.init(type: .custom)
            button.setTitle(value, for: .normal)
            button.setTitleColor(self.buttonNormalColor, for: .normal)
            button.setTitleColor(self.buttonSelectedColor, for: .selected)
            button.titleLabel?.font = FontBold(font: XJHFontNum_Max())
            button.addTarget(self, action: #selector(self.onButtonClick(button:)), for: .touchUpInside)
            button.tag = 100 + index
            self.addSubview(button)
            
            button.snp.makeConstraints { (make) in
                
                make.left.equalTo(xjh_WidthScreen / CGFloat(titles.count) * CGFloat(index))
                make.top.bottom.equalTo(0)
                make.width.equalTo(xjh_WidthScreen / CGFloat(titles.count))
            }

            if index == currentIndex {
               
                button.isSelected = true
                self.lastButton = button

            }
        }
        
        self.lineView.snp.makeConstraints({ (make) in
            
            make.centerX.equalTo(self.lastButton!)
            make.bottom.equalTo(0)
            make.size.equalTo(CGSize(width: 40, height: 4))
        })
    }
    
    @objc func onButtonClick(button : UIButton) {
        
        self.lastButton?.isSelected = false
        button.isSelected = true
        self.lastButton = button
        
        self.lineView.snp.remakeConstraints { (make) in
            
            make.centerX.equalTo(self.lastButton!)
            make.bottom.equalTo(0)
            make.size.equalTo(CGSize(width: 30, height: 4))
        }
        
        UIView.animate(withDuration: 0.4) {
            
            self.lineView.superview?.layoutIfNeeded()
        }
        
        if self.delegate != nil {
            
            self.delegate?.pageView?(self, didSelectIndexAt: self.lastButton!.tag - 100)
        }
    }
}
