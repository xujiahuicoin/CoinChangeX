//
//  JWAdjustablePositionButton.swift
//  JWAdjustablePositionButton
//
//  Created by LjwMac on 2019/4/8.
//

import UIKit

/// 可调整按钮位置
@objc public enum JWAdjustableButtonPosition: Int {
    /// 图片左、文字右
    case leftImageRightText
    /// 图片右、文字左
    case leftTextRightImage
    /// 图片顶、文字底
    case topImageBottomText
    /// 图片底、文字顶
    case topTextBottomImage
}

extension JWAdjustableButtonPosition: CustomStringConvertible {
    public var description: String {
        switch self {
        case .leftImageRightText:
            return "左图右字"
        case .leftTextRightImage:
            return "左字右图"
        case .topImageBottomText:
            return "上图下字"
        case .topTextBottomImage:
            return "上字下图"
        }
    }
}


/// 可调整位置的按钮
@objc public class JWAdjustablePositionButton: UIButton {

    /// 位置
    @IBInspectable @objc public var position: JWAdjustableButtonPosition = .leftImageRightText {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    /// 图片与文本间距
    @IBInspectable @objc public var contentSpace: CGFloat = 5 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    /// 自定义图片大小
    @IBInspectable @objc public var imageSize: CGSize = .zero {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
   
    /// 重写isEnabled
    override public var isEnabled: Bool {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    /// 重写isSelected
    override public var isSelected: Bool {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    /// 重写isHighlighted
    override public var isHighlighted: Bool {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    /// 重写contentVerticalAlignment
    override public var contentVerticalAlignment: UIControl.ContentVerticalAlignment {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    /// 重写contentHorizontalAlignment
    override public var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    /// 重写setTitle(_ title: String?, for state: UIControlState)
    override public func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    /// 重写setAttributedTitle(_ title: NSAttributedString?, for state: UIControlState)
    override public func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
        super.setAttributedTitle(title, for: state)
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    /// 重写setImage(_ image: UIImage?, for state: UIControlState)
    override public func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
    }
    
    /// 重写contentEdgeInsets
    override public var contentEdgeInsets: UIEdgeInsets {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    /// Fits大小
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        return intrinsicContentSize
    }
    
    /// 内在内容大小
    override public var intrinsicContentSize: CGSize {
        
        /// 当前内容间距
        let theContentInsets = contentEdgeInsets
        /// 文字大小
        let textSize = calculateTextSize()
        /// 图片大小
        let imageSize = calculateImageSize()
        /// 图片与文字间距
        let margin = (textSize.equalTo(.zero) || imageSize.equalTo(.zero)) ? 0 : contentSpace
        
        /// 算出按钮的最大size
        switch position {
        case .topImageBottomText, .topTextBottomImage:
            let size = CGSize(width: max(textSize.width, imageSize.width) + theContentInsets.left + theContentInsets.right,
                              height: textSize.height + imageSize.height + margin + theContentInsets.top + theContentInsets.bottom)
            return CGRect(origin: .zero, size: size).integral.size
        case .leftImageRightText, .leftTextRightImage:
            let size = CGSize(width: textSize.width + imageSize.width + margin + theContentInsets.left + theContentInsets.right,
                              height: max(textSize.height, imageSize.height) + theContentInsets.top + theContentInsets.bottom)
            return CGRect(origin: .zero, size: size).integral.size
        }
    }

    override public func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        /// 文字大小
        var size = super.titleRect(forContentRect: CGRect(x: 0, y: 0,
                                                          width: contentRect.size.width,
                                                          height: contentRect.size.height)).size
        if contentVerticalAlignment == .fill {
            size.height = min(size.height, contentRect.height)
        }
        if contentHorizontalAlignment == .fill {
            size.width = min(size.width, contentRect.width)
        }
        
        /// 图片大小
        let imageSize = calculateImageSize()
        let iconSize = imageSize
        /// 图片与文字间距
        let margin = (imageSize.equalTo(.zero)) ? 0 : contentSpace
        
        let totalWidth = size.width + imageSize.width + margin
        let totalHeight = size.height + imageSize.height + margin
        
        var rect = CGRect(origin: .zero, size: size)
        
        switch (contentHorizontalAlignment) {
        case .left:
            switch position {
            case .leftTextRightImage:
                rect.origin.x = contentRect.minX
                break
            case .leftImageRightText:
                rect.origin.x = contentRect.minX + totalWidth - size.width
                break
            default:
                rect.origin.x = contentRect.minX
                break
            }
            break
        case .right:
            switch position {
            case .leftTextRightImage:
                rect.origin.x = contentRect.maxX - totalWidth
                break
            case .leftImageRightText:
                rect.origin.x = contentRect.maxX - size.width
                break
            default:
                rect.origin.x = contentRect.maxX - size.width
                break
            }
            break
        case .fill:
            switch position {
            case .leftTextRightImage:
                rect.origin.x = contentRect.minX
                rect.size.width = min(size.width, contentRect.width - iconSize.width - margin)
                break
            case .leftImageRightText:
                rect.size.width = min(size.width, contentRect.width - iconSize.width - margin)
                rect.origin.x = contentRect.maxX - rect.size.width
                break
            default:
                rect.origin.x = contentRect.minX + (contentRect.width - size.width) / 2
                break
            }
            break
        default:
            switch position {
            case .leftTextRightImage:
                rect.origin.x = contentRect.minX + (contentRect.width - totalWidth) / 2
                break
            case .leftImageRightText:
                rect.origin.x = contentRect.minX + contentRect.width - (contentRect.width - totalWidth) / 2 - size.width
                break
            default:
                rect.origin.x = contentRect.minX + (contentRect.width - size.width) / 2
                break
            }
            break
        }
        
        switch (self.contentVerticalAlignment) {
        case .top:
            switch position {
            case .topImageBottomText:
                rect.origin.y = contentRect.minY + totalHeight - size.height
                break
            case .topTextBottomImage:
                rect.origin.y = contentRect.minY
                break
            default:
                rect.origin.y = contentRect.minY
                break
            }
            break
        case .bottom:
            switch position {
            case .topImageBottomText:
                rect.origin.y = contentRect.maxY - size.height
                break
            case .topTextBottomImage:
                rect.origin.y = contentRect.maxY - totalHeight
                break
            default:
                rect.origin.y = contentRect.maxY - size.height
                break
            }
            break
        case .fill:
            switch position {
            case .topImageBottomText:
                rect.size.height = min(size.height, contentRect.height - iconSize.height - margin)
                rect.origin.y = contentRect.maxY - rect.size.height
                break
            case .topTextBottomImage:
                rect.origin.y = contentRect.minY
                rect.size.height = min(size.height, contentRect.height - iconSize.height - margin)
                break
            default:
                rect.origin.y = contentRect.minY + (contentRect.height - size.height) / 2
                break
            }
            break
        default:
            switch position {
            case .topImageBottomText:
                rect.origin.y = contentRect.maxY - (contentRect.height - totalHeight) / 2 - size.height
                break
            case .topTextBottomImage:
                rect.origin.y = contentRect.minY + (contentRect.height - totalHeight) / 2
                break
            default:
                rect.origin.y = contentRect.minY + (contentRect.height - size.height) / 2
                break
            }
            break
        }
        
        return rect.integral
    }
    
    override public func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        /// 图片大小
        var size = calculateImageSize()
        if contentVerticalAlignment == .fill {
            size.height = min(size.height, contentRect.height)
        }
        if contentHorizontalAlignment == .fill {
            size.width = min(size.width, contentRect.width)
        }
        
        /// 文字大小
        let titleSize = calculateTextSize()
        /// 图片与文字间距
        let margin = (titleSize.equalTo(.zero)) ? 0 : contentSpace
        
        switch position {
            case .topImageBottomText, .topTextBottomImage:
                size.height = max(min(contentRect.height - margin - titleSize.height, size.height), size.height)
                break
            default:
                size.width = max(min(contentRect.width - margin - titleSize.width, size.width), size.width)
                break
        }
        
        
        let totalWidth = size.width + titleSize.width + margin
        let totalHeight = size.height + titleSize.height + margin
        
        var rect = CGRect(origin: .zero, size: size)
        
        switch contentHorizontalAlignment {
        case .left:
            switch position {
                case .leftTextRightImage:
                    rect.origin.x = contentRect.minX + totalWidth - size.width
                    break
                default:
                    rect.origin.x = contentRect.minX
                    break
            }
            break
        case .right:
            switch (position) {
                case .leftTextRightImage:
                    rect.origin.x = contentRect.maxX - size.width
                    break
                case .leftImageRightText:
                    rect.origin.x = contentRect.maxX - totalWidth
                    break
                default:
                    rect.origin.x = contentRect.maxX - size.width
                    break
            }
            break
        case .fill:
            switch position {
                case .leftTextRightImage:
                    rect.origin.x = contentRect.maxX - size.width
                    break
                case .leftImageRightText:
                    rect.origin.x = contentRect.minX
                    break
                default:
                    rect.size.width = contentRect.width
                    rect.origin.x = contentRect.minX + (contentRect.width - rect.size.width) / 2
                    break
            }
            break
        default:
            switch position {
                case .leftTextRightImage:
                    rect.origin.x = contentRect.minX + contentRect.width - (contentRect.width - totalWidth) / 2 - size.width
                    break
                case .leftImageRightText:
                    rect.origin.x = contentRect.minX + (contentRect.width - totalWidth) / 2
                    break
                default:
                    rect.origin.x = contentRect.minX + (contentRect.width - size.width) / 2
                    break
            }
            break
        }
        
        switch (self.contentVerticalAlignment) {
        case .top:
            switch position {
                case .topImageBottomText:
                    rect.origin.y = contentRect.minY
                    break
                case .topTextBottomImage:
                    rect.origin.y = contentRect.minY + totalHeight - size.height
                    break
                default:
                    rect.origin.y = contentRect.minY
                    break
            }
            break
        case .bottom:
            switch position {
                case .topImageBottomText:
                    rect.origin.y = contentRect.maxY - totalHeight
                    break
                case .topTextBottomImage:
                    rect.origin.y = contentRect.maxY - size.height
                    break
                default:
                    rect.origin.y = contentRect.maxY - size.height
                    break
            }
            break
        case .fill:
            switch position {
                case .topImageBottomText:
                    rect.origin.y = contentRect.minY
                    break
                case .topTextBottomImage:
                    rect.origin.y = contentRect.maxY - size.height
                    break
                default:
                    rect.size.height = contentRect.height
                    rect.origin.y = contentRect.minY + (contentRect.height - rect.size.height) / 2
                    break
            }
            break
        default:
            switch position {
                case .topImageBottomText:
                    rect.origin.y = contentRect.minY + (contentRect.height - totalHeight) / 2
                    break
                case .topTextBottomImage:
                    rect.origin.y = contentRect.maxY - (contentRect.height - totalHeight) / 2 - size.height
                    break
                default:
                    rect.origin.y = contentRect.minY + (contentRect.height - size.height) / 2
                    break
            }
            break
        }
        
        return rect
    }
    
}

fileprivate extension JWAdjustablePositionButton {
    
    func setupUI() {
        autoresizesSubviews = false
    }
    
    /// 计算文本大小
    func calculateTextSize() -> CGSize {
        
        var size = CGSize.zero
        
        if let currentAttributedTitle = currentAttributedTitle {
            size = currentAttributedTitle.size()
        } else if let currentTitle = currentTitle {
            size = (currentTitle as NSString).size(withAttributes: [.font : titleLabel?.font as Any])
        }
        
        return size
        
    }
    
    /// 获取图片大小
    func calculateImageSize() -> CGSize {
        
        var size = CGSize.zero
        if imageSize.equalTo(.zero) {
            size = currentImage?.size ?? .zero
        } else if currentImage != nil {
            size = imageSize
        }
        
        return size
        
    }
    
}
