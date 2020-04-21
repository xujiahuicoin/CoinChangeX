//
//  MFPageTitleView.swift
//  MFPagingViewExample
//  GitHub: https://github.com/wwx1991/MFPagingView
//  Created by iOS on 2018/6/12.
//  Copyright © 2018年 GM. All rights reserved.
//

protocol MFPageTitleViewDelegate: NSObjectProtocol {
    func selectedIndexInPageTitleView(pageTitleView: MFPageTitleView, selectedIndex: Int)
}

import UIKit

class MFPageTitleView: UIView {
    
    var config: MFPageTitleViewConfig?
    
    //选中标题按钮下标，默认为 0
    var selectedIndex: Int = 0 {
        didSet {
            self._AnNiuButtonDidClick(sender: _AnNiuButtonArr[selectedIndex])
        }
    }
    
    //scrollView
    private lazy var scrollView: UIScrollView = {
        let scrollV = UIScrollView(frame: self.bounds)
        scrollV.showsHorizontalScrollIndicator = false
        return scrollV
    }()
    //底部分隔线
    private lazy var line: UIView = {
        let lineV = UIView(frame: CGRect(x: 0, y: self.height-1, width: self.width, height: 1))
        lineV.backgroundColor = colorWithRGB(r: 244, g: 244, b: 244)
        return lineV
    }()
    //指示器
    private lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: 0, y: scrollView.height-3, width: 0, height: 2))
        indicatorView.backgroundColor = self.config?.indicatorColor
        return indicatorView
    }()
    //标题数组
    private var titles = [String]()
    //存储标题按钮的数组
    private var _AnNiuButtonArr = [UIButton]()
    //标记按钮下标
    private var sign_AnNiuButtonIndex: Int = 0
    //按钮的总宽度
    private var all_AnNiuButtonWidth: CGFloat = 0
    private var last_AnNiuButton: UIButton?
    private var totalExtraWidth: CGFloat = 0
    
    weak var pageTitleViewDelegate: MFPageTitleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, titles: [String], config: MFPageTitleViewConfig) {
        self.init()
        self.backgroundColor = UIColor.white
        self.frame = frame
        if titles.count < 1 {
            NSException(name: NSExceptionName(rawValue: "MFPagingView"), reason: "标题数组元素不能为0", userInfo: nil).raise()
        }
        self.titles = titles        
        self.config = config
        setupUI()
    }
    
    deinit {
        print("deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        //处理偏移量
        let tempView = UIView(frame: CGRect.zero)
        self.addSubview(tempView)
        self.addSubview(scrollView)
        if let showBottomSeparator = self.config?.showBottomSeparator {
            if showBottomSeparator {
                self.addSubview(line)
            }
        }
        scrollView.insertSubview(indicatorView, at: 0)
        
        setupButtons()
    }
    
    private func setupButtons() {
        var totalTextWidth: CGFloat = 0

        for title in self.titles {
            // 计算所有按钮的文字宽度
            if let titleFont = self.config?.titleFont {
                let tempWidth = title.MF_widthWithString(font: titleFont, size: CGSize(width: 0, height: 0))
                totalTextWidth += tempWidth
            }
        }
        
        // 所有按钮文字宽度 ＋ 按钮之间的间隔
        self.all_AnNiuButtonWidth = (self.config?.spacingBetweenButtons)! * (CGFloat)(self.titles.count + 1) + totalTextWidth
        
        let count: CGFloat = CGFloat(self.titles.count)
        if self.all_AnNiuButtonWidth <= self.bounds.width {
            var _AnNiuButtonX: CGFloat = 0
            let _AnNiuButtonY: CGFloat = 0
            let _AnNiuButtonH: CGFloat = self.bounds.height
            
            for (index, title) in self.titles.enumerated() {
                var _AnNiuButtonW: CGFloat = self.bounds.width / count
                let tempWidth = title.MF_widthWithString(font: (self.config?.titleFont)!, size: CGSize(width: 0, height: 0)) + (self.config?.spacingBetweenButtons)!
                if tempWidth > _AnNiuButtonW {
                    let extraWidth = tempWidth - _AnNiuButtonW
                    _AnNiuButtonW = tempWidth
                    totalExtraWidth += extraWidth
                }
                
                let _AnNiuButton = UIButton(type: .custom)
                _AnNiuButton.frame = CGRect(x: _AnNiuButtonX, y: _AnNiuButtonY, width: _AnNiuButtonW, height: _AnNiuButtonH)
                _AnNiuButtonX += _AnNiuButtonW
                _AnNiuButton.tag = index
                _AnNiuButton.setTitle(title, for: .normal)
                _AnNiuButton.setTitleColor(self.config?.titleColor, for: .normal)
                _AnNiuButton.setTitleColor(self.config?.titleSelectedColor, for: .selected)
                _AnNiuButton.titleLabel?.font = self.config?.titleFont
                _AnNiuButton.addTarget(self, action: #selector(_AnNiuButtonDidClick(sender:)), for: .touchUpInside)
                scrollView.addSubview(_AnNiuButton)
                _AnNiuButtonArr.append(_AnNiuButton)
            }
        
            scrollView.contentSize = CGSize(width: self.bounds.width + totalExtraWidth, height: 0)
            
        }else {
            
            var _AnNiuButtonX: CGFloat = 0
            let _AnNiuButtonY: CGFloat = 0
            let _AnNiuButtonH: CGFloat = self.bounds.height
            
            for (index, title) in self.titles.enumerated() {
                let _AnNiuButtonW = title.MF_widthWithString(font: (self.config?.titleFont)!, size: CGSize(width: 0, height: 0)) + (self.config?.spacingBetweenButtons)!
                let _AnNiuButton = UIButton(type: .custom)
                _AnNiuButton.frame = CGRect(x: _AnNiuButtonX, y: _AnNiuButtonY, width: _AnNiuButtonW, height: _AnNiuButtonH)
                _AnNiuButtonX += _AnNiuButtonW
                _AnNiuButton.tag = index
                _AnNiuButton.setTitle(title, for: .normal)
                _AnNiuButton.setTitleColor(self.config?.titleColor, for: .normal)
                _AnNiuButton.setTitleColor(self.config?.titleSelectedColor, for: .selected)
                _AnNiuButton.titleLabel?.font = self.config?.titleFont
                _AnNiuButton.addTarget(self, action: #selector(_AnNiuButtonDidClick(sender:)), for: .touchUpInside)
                scrollView.addSubview(_AnNiuButton)
                _AnNiuButtonArr.append(_AnNiuButton)
            }
            let scrollViewWidth = scrollView.subviews.last?.frame.maxX
            scrollView.contentSize = CGSize(width: scrollViewWidth!, height: 0)
        }
        
    }
    
    //滚动标题选中按钮居中
    private func scrollCenter(selected_AnNiuButton: UIButton) {
        var offsetX = selected_AnNiuButton.centerX - self.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffsetX = scrollView.contentSize.width - self.width
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    //改变按钮的选择状态
    private func changeSelectedButton(button: UIButton) {
        if self.last_AnNiuButton == nil {
            button.isSelected = true
            self.last_AnNiuButton = button
        } else if self.last_AnNiuButton != nil && self.last_AnNiuButton == button {
            button.isSelected = true
        } else if self.last_AnNiuButton != button && self.last_AnNiuButton != nil {
            self.last_AnNiuButton?.isSelected = false
            button.isSelected = true
            self.last_AnNiuButton = button
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //选中按钮下标初始值
        let last_AnNiuButton: UIButton = self._AnNiuButtonArr.last!
        if last_AnNiuButton.tag >= selectedIndex && selectedIndex >= 0 {
            _AnNiuButtonDidClick(sender: self._AnNiuButtonArr[selectedIndex])
        }else {
            return
        }
    }

}

extension MFPageTitleView {
    @objc func _AnNiuButtonDidClick(sender:UIButton) {
        
        self.changeSelectedButton(button: sender)
        
        scrollCenter(selected_AnNiuButton: sender)
        
        if self.all_AnNiuButtonWidth > self.width || totalExtraWidth > 0 {
            scrollCenter(selected_AnNiuButton: sender)
        }
        
        UIView.animate(withDuration: 0.1) {
            self.indicatorView.width = sender.currentTitle!.MF_widthWithString(font: (self.config?.titleFont)!, size: CGSize(width: 0, height: 0))
            self.indicatorView.center.x = sender.centerX
        }
        
        pageTitleViewDelegate?.selectedIndexInPageTitleView(pageTitleView: self, selectedIndex: sender.tag)
        
        self.sign_AnNiuButtonIndex = sender.tag
    }
}

extension MFPageTitleView {
    //给外界提供的方法
    func setPageTitleView(progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        let original_AnNiuButton: UIButton = self._AnNiuButtonArr[originalIndex]
        let target_AnNiuButton: UIButton = self._AnNiuButtonArr[targetIndex]
        self.sign_AnNiuButtonIndex = target_AnNiuButton.tag
        
        scrollCenter(selected_AnNiuButton: target_AnNiuButton)
        //处理指示器的逻辑
        if self.all_AnNiuButtonWidth <= self.bounds.width {
            if totalExtraWidth > 0 {
                indicatorScrollAtScroll(progress: progress, original_AnNiuButton: original_AnNiuButton, target_AnNiuButton: target_AnNiuButton)
            }else {
                indicatorScrollAtStatic(progress: progress, original_AnNiuButton: original_AnNiuButton, target_AnNiuButton: target_AnNiuButton)
            }
        }else {
            indicatorScrollAtScroll(progress: progress, original_AnNiuButton: original_AnNiuButton, target_AnNiuButton: target_AnNiuButton)
        }
    }
    
    private func indicatorScrollAtStatic(progress: CGFloat, original_AnNiuButton: UIButton, target_AnNiuButton: UIButton) {
        if (progress >= 0.8) {
            changeSelectedButton(button: target_AnNiuButton)
        }
        
        /// 计算 indicatorView 偏移量
        
        let target_AnNiuButtonTextWidth: CGFloat = (target_AnNiuButton.currentTitle?.MF_widthWithString(font: (self.config?.titleFont)!, size: CGSize.zero))!
        let target_AnNiuButtonIndicatorX: CGFloat = target_AnNiuButton.frame.maxX - target_AnNiuButtonTextWidth - 0.5 * (self.width / CGFloat(self.titles.count) - target_AnNiuButtonTextWidth)
        let original_AnNiuButtonTextWidth: CGFloat = (original_AnNiuButton.currentTitle?.MF_widthWithString(font: (self.config?.titleFont)!, size: CGSize.zero))!
        let original_AnNiuButtonIndicatorX: CGFloat = original_AnNiuButton.frame.maxX - original_AnNiuButtonTextWidth - 0.5 * (self.width / CGFloat(self.titles.count) - original_AnNiuButtonTextWidth)
        
        let totalOffsetX: CGFloat = target_AnNiuButtonIndicatorX - original_AnNiuButtonIndicatorX
        
        let _AnNiuButtonWidth: CGFloat = self.width / CGFloat(self.titles.count)
        let target_AnNiuButtonRightTextX: CGFloat = target_AnNiuButton.frame.maxX - 0.5 * (_AnNiuButtonWidth - target_AnNiuButtonTextWidth)
        let original_AnNiuButtonRightTextX: CGFloat = original_AnNiuButton.frame.maxX - 0.5 * (_AnNiuButtonWidth - original_AnNiuButtonTextWidth)
        let totalRightTextDistance: CGFloat = target_AnNiuButtonRightTextX - original_AnNiuButtonRightTextX
        
        let offsetX: CGFloat = totalOffsetX * progress
        let distance: CGFloat = progress * (totalRightTextDistance - totalOffsetX)
        
        self.indicatorView.x = original_AnNiuButtonIndicatorX + offsetX
        
        let tempIndicatorWidth: CGFloat = original_AnNiuButtonTextWidth + distance
        if tempIndicatorWidth >= target_AnNiuButton.width {
            let moveTotalX: CGFloat = target_AnNiuButton.x - original_AnNiuButton.x
            let moveX: CGFloat = moveTotalX * progress
            self.indicatorView.center.x = original_AnNiuButton.centerX + moveX
        } else {
            self.indicatorView.width = tempIndicatorWidth
        }
    }
    
    
    private func indicatorScrollAtScroll(progress: CGFloat, original_AnNiuButton: UIButton, target_AnNiuButton: UIButton) {
        if (progress >= 0.8) {
            changeSelectedButton(button: target_AnNiuButton)
        }
        
        let totalOffsetX: CGFloat = target_AnNiuButton.x - original_AnNiuButton.x
        let totalDistance: CGFloat = target_AnNiuButton.frame.maxX - original_AnNiuButton.frame.maxX
        var offsetX: CGFloat = 0
        var distance: CGFloat = 0
        
        let target_AnNiuButtonTextWidth: CGFloat = (target_AnNiuButton.currentTitle?.MF_widthWithString(font: (self.config?.titleFont)!, size: CGSize.zero))!
        let tempIndicatorWidth: CGFloat = target_AnNiuButtonTextWidth
        
        if tempIndicatorWidth >= target_AnNiuButton.width {
            offsetX = totalOffsetX * progress
            distance = progress * totalDistance - totalOffsetX
            self.indicatorView.x = original_AnNiuButton.x + offsetX
            self.indicatorView.width = original_AnNiuButton.width + distance
            
        } else {
            offsetX = totalOffsetX * progress + 0.5 * (self.config?.spacingBetweenButtons)!
            distance = progress * (totalDistance - totalOffsetX) - (self.config?.spacingBetweenButtons)!
            self.indicatorView.x = original_AnNiuButton.x + offsetX;
            self.indicatorView.width = original_AnNiuButton.width + distance
        }
    }
}

extension String {
    
    func MF_widthWithString(font: UIFont, size: CGSize) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: size.width, height: size.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
}
