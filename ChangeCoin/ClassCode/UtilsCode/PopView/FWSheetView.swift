//
//  FWSheetView.swift
//  FWPopupView
//
//  Created by xfg on 2018/3/26.
//  Copyright © 2018年 xfg. All rights reserved.
//

import Foundation
import UIKit

@objc open class FWSheetView: FWPopupView {
    
    @objc public var property = FWSheetViewProperty()
    
    private var actionItemArray: [FWPopupItem] = []
    
    private var titleLabel: UILabel?
    
    private var commponenetArray: [UIView] = []
    
    /// 类初始化方法
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - itemTitles: 点击项标题
    ///   - itemBlock: 点击回调
    ///   - cancenlBlock: 取消按钮回调
    /// - Returns: self
    @objc open class func sheet(title: String?, itemTitles: [String], itemBlock:@escaping FWPopupItemHandler, cancenlBlock:@escaping FWPopupVoidBlock) -> FWSheetView {
        
        let sheetView = FWSheetView()
        sheetView.setupUI(title: title, itemTitles: itemTitles, itemBlock:itemBlock, cancenlBlock: cancenlBlock)
        return sheetView
    }
    
    /// 类初始化方法
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - itemTitles: 点击项标题
    ///   - itemBlock: 点击回调
    ///   - cancenlBlock: 取消按钮回调
    ///   - property: FWSheetView的相关属性
    /// - Returns: self
    @objc open class func sheet(title: String?, itemTitles: [String], itemBlock:@escaping FWPopupItemHandler, cancenlBlock:@escaping FWPopupVoidBlock, property: FWSheetViewProperty?) -> FWSheetView {
        
        let sheetView = FWSheetView()
        if property != nil {
            sheetView.property = property!
        }
        sheetView.setupUI(title: title, itemTitles: itemTitles, itemBlock:itemBlock, cancenlBlock: cancenlBlock)
        return sheetView
    }
}

extension FWSheetView {
    
    private func setupUI(title: String?, itemTitles: [String], itemBlock:@escaping FWPopupItemHandler, cancenlBlock:@escaping FWPopupVoidBlock) {
        
        if itemTitles.count == 0 {
            return
        }
        
        self.backgroundColor = self.property.vbackgroundColor
        self.clipsToBounds = true
        
        self.popupType = .sheet
        self.animationDuration = 0.3
        
        let itemClickBlock: FWPopupItemHandler = { (index) in
            itemBlock(index)
        }
        for title in itemTitles {
            self.actionItemArray.append(FWPopupItem(title: title, itemType: .normal, isCancel: true, handler: itemClickBlock))
        }
        
        self.clipsToBounds = true
        
        self.frame.origin.x = 0
        self.frame.origin.y = 100
        self.frame.size.width = UIScreen.main.bounds.width
        
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.fittingSizeLevel, for: .vertical)
        
        var currentMaxY:CGFloat = self.property.topBottomMargin
        
        if title != nil && !title!.isEmpty {
            self.titleLabel = UILabel(frame: CGRect(x: self.property.letfRigthMargin, y: currentMaxY, width: self.frame.width - self.property.letfRigthMargin * 2, height: CGFloat.greatestFiniteMagnitude))
            self.addSubview(self.titleLabel!)
            self.titleLabel?.text = title
            self.titleLabel?.textColor = self.property.titleColor
            self.titleLabel?.textAlignment = .center
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.property.titleFontSize)
            self.titleLabel?.numberOfLines = 5
            self.titleLabel?.backgroundColor = UIColor.clear
            
            self.titleLabel?.sizeToFit()
            
            self.titleLabel?.frame = CGRect(x: self.property.letfRigthMargin, y: currentMaxY, width: self.frame.width - self.property.letfRigthMargin * 2, height: self.titleLabel!.frame.height)
            
            currentMaxY = self.titleLabel!.frame.maxY
            
            self.commponenetArray.append(self.titleLabel!)
        }
        
        currentMaxY += self.property.topBottomMargin
        
        // 开始配置Item
        let _AnNiuButtonContrainerView = UIScrollView(frame: CGRect(x: 0, y: currentMaxY, width: self.frame.width, height: self.property.buttonHeight))
        _AnNiuButtonContrainerView.bounces = false
        _AnNiuButtonContrainerView.backgroundColor = UIColor.clear
        self.addSubview(_AnNiuButtonContrainerView)
        
        currentMaxY = _AnNiuButtonContrainerView.frame.maxY
        
        let block: FWPopupItemHandler = { (index) in
            cancenlBlock()
        }
        
        var tmpIndex = 0
        self.actionItemArray.append(FWPopupItem(title: "取消", itemType: .normal, isCancel: true, handler: block))
        
        var cancel_AnNiuButtonTopView: UIView?
        var cancel_AnNiuButton: UIButton?
        
        for popupItem: FWPopupItem in self.actionItemArray {
            
            let _AnNiuButton = UIButton(type: .custom)
            _AnNiuButton.addTarget(self, action: #selector(_AnNiuButtonAction(_:)), for: .touchUpInside)
            _AnNiuButton.tag = tmpIndex
            
            var _AnNiuButtonY: CGFloat = 0.0
            if tmpIndex < self.actionItemArray.count - 1 {
                _AnNiuButtonY = self.property.buttonHeight * CGFloat(tmpIndex)
                _AnNiuButtonContrainerView.addSubview(_AnNiuButton)
            } else {
                _AnNiuButtonY = self.property.buttonHeight * CGFloat(tmpIndex) + self.property.cancel_AnNiuButtonMarginTop
                
                cancel_AnNiuButtonTopView = UIView(frame: CGRect(x: 0, y: _AnNiuButtonY - self.property.cancel_AnNiuButtonMarginTop, width: self.frame.width, height: self.property.cancel_AnNiuButtonMarginTop))
                cancel_AnNiuButtonTopView?.backgroundColor = UIColor(white: 0.1, alpha: 0.1)
                self.addSubview(cancel_AnNiuButtonTopView!)
                
                cancel_AnNiuButton = _AnNiuButton
                self.addSubview(cancel_AnNiuButton!)
            }
            _AnNiuButton.frame = CGRect(x: -self.property.splitWidth, y: _AnNiuButtonY, width: _AnNiuButtonContrainerView.frame.width + self.property.splitWidth * 2, height: self.property.buttonHeight + self.property.splitWidth)
            
            if tmpIndex > 0 {
                currentMaxY += _AnNiuButton.frame.height
                if tmpIndex == self.actionItemArray.count - 1 {
                    if _AnNiuButton.frame.minY - self.property.cancel_AnNiuButtonMarginTop <= self.property._AnNiuButtonContrainerViewMaxHeight {
                        _AnNiuButtonContrainerView.frame.size.height = _AnNiuButton.frame.minY - self.property.cancel_AnNiuButtonMarginTop
                    } else {
                        _AnNiuButtonContrainerView.frame.size.height = self.property._AnNiuButtonContrainerViewMaxHeight
                        _AnNiuButtonContrainerView.contentSize = CGSize(width: self.frame.width, height: _AnNiuButton.frame.minY - self.property.cancel_AnNiuButtonMarginTop)
                    }
                    cancel_AnNiuButtonTopView?.frame.origin.y = _AnNiuButtonContrainerView.frame.maxY
                    cancel_AnNiuButton?.frame.origin.y = cancel_AnNiuButtonTopView!.frame.maxY
                }
            }
            
            _AnNiuButton.backgroundColor = self.property.vbackgroundColor
            _AnNiuButton.setTitle(popupItem.title, for: .normal)
            _AnNiuButton.setTitleColor(popupItem.highlight ? self.property.itemHighlightColor : self.property.itemNormalColor, for: .normal)
            _AnNiuButton.layer.borderWidth = self.property.splitWidth
            _AnNiuButton.layer.borderColor = self.property.splitColor.cgColor
            _AnNiuButton.setBackgroundImage(self.getImageWithColor(color: _AnNiuButton.backgroundColor!), for: .normal)
            _AnNiuButton.setBackgroundImage(self.getImageWithColor(color: self.property.itemPressedColor), for: .highlighted)
            _AnNiuButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: self.property.buttonFontSize)
            
            tmpIndex += 1
        }
        
        self.frame.size.height = _AnNiuButtonContrainerView.frame.maxY + self.property.buttonHeight + self.property.cancel_AnNiuButtonMarginTop
    }
}

extension FWSheetView {
    
    @objc private func _AnNiuButtonAction(_ sender: Any) {
        
        let _AnNiuButton = sender as! UIButton
        let item = self.actionItemArray[_AnNiuButton.tag]
        if item.disabled {
            return
        }
        
        self.hide()
        
        if item.itemHandler != nil {
            item.itemHandler!(_AnNiuButton.tag)
        }
    }
}

/// FWSheetView的相关属性
@objc open class FWSheetViewProperty: FWPopupViewProperty {
    
    // 取消按钮距离头部的距离
    @objc public var cancel_AnNiuButtonMarginTop: CGFloat = 6
    
    @objc public var _AnNiuButtonContrainerViewMaxHeight: CGFloat = UIScreen.main.bounds.height * CGFloat(0.6)
    
}
