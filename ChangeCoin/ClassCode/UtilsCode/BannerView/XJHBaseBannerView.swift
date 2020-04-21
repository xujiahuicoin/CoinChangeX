//
//  BaseBannerView.swift
//  Project
//
//  Created by mac on 2019/6/14.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit

typealias TouchBlock = (_ index: Int)->()

class XJHBaseBannerView: XJHBaseView,UIScrollViewDelegate {

    var touchBlock: TouchBlock?
    
    lazy var control: UIPageControl = {
        
        let control: UIPageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: 0, width: 100.0, height: 30.0))
        return control
    }()
    
    lazy var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView.init()
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.addSubview(scrollView)
        return scrollView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
        self.addSubview(self.control)
        
        self.control.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-10.0)
            make.size.equalTo(CGSize.init(width: 100.0, height: 30.0))
        }
    }
    
    lazy var bannerDatas : [String] = []
    ///1 本地数据。 2 网络数据
    var bannerDatasType: Int = 1
    var timer : Timer?
    
    //    创建bannerView
    class func bannerView () -> XJHBaseBannerView {
        
        let bannerView = XJHBaseBannerView.init()
        return bannerView
    }
    
    //    更新bannerView
    func updateBannerView(_ imageUrls : [String]) {
        self.xjh_showHUD()
        
        self.scrollView.subviews.forEach({$0.removeFromSuperview()})
        
        self.timer?.invalidate()
        self.timer = nil
        
        self.formatDataSource(imageUrls: imageUrls)
        
        self.control.numberOfPages = imageUrls.count
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            
            self.layoutIfNeeded()
            
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(self.bannerDatas.count), height: self.scrollView.frame.size.height)
            
            if self.bannerDatas.count > 1 {
                
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width, y: 0)
                self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.startScroll(tap:)), userInfo: nil, repeats: true)
            }
            
            for index in 0..<self.bannerDatas.count {
                
                let imageView = UIImageView.init()
                imageView.backgroundColor = UIColor.white
                imageView.frame = CGRect(x: self.scrollView.frame.size.width * CGFloat(index), y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
                imageView.tag = 100 + index
//                imageView.kf.setImage(with: URL(string: self.bannerDatas[index]))
                
                if self.bannerDatasType == 1{
                    
                    imageView.image =  UIImage(named: self.bannerDatas[index])
                    
                }else{
                
                imageView.kf.setImage(with: URL(string: self.bannerDatas[index]), placeholder: UIImage.init(named: "zhanweitu"), options: nil, progressBlock: nil, completionHandler: { (Result) in
                    self.xjh_hiddenHud()
                })
                }
                
                imageView.contentMode = .scaleAspectFill
                imageView.layer.masksToBounds = true
                self.scrollView.addSubview(imageView)
                imageView.isUserInteractionEnabled = true
                let imageViewTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.imageViewTapClick(tap:)))
                imageView.addGestureRecognizer(imageViewTap)
            }
        }
    }
    
    //    定时器事件
    @objc func startScroll(tap : UIGestureRecognizer) {
        
        
    }
    
    //    banner图点击事件
    @objc func imageViewTapClick(tap : UIGestureRecognizer) {
        
        if self.touchBlock != nil {
            self.touchBlock!(((tap.view?.tag ?? 100)  - 100))
        }
    }
    
    //    数据源处理
    func formatDataSource(imageUrls : [String]) {
        
        self.bannerDatas.removeAll()
        if imageUrls.count > 1 {
            self.bannerDatas = self.bannerDatas + [imageUrls.last!]
            self.bannerDatas = self.bannerDatas + imageUrls
            self.bannerDatas = self.bannerDatas + [imageUrls.first!]
        }else {
            self.bannerDatas = self.bannerDatas + imageUrls
        }
    }
    
    //    UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.bannerDatas.count <= 1 {
            return
        }
        
        if self.scrollView.contentOffset.x <= 0 {
            
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width * CGFloat(self.bannerDatas.count - 2), y: 0)
            
        }else if self.scrollView.contentOffset.x >= self.scrollView.frame.size.width * CGFloat((self.bannerDatas.count - 1)) {
            
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width, y: 0)
            
        }
        
        var index : Int =  Int(self.scrollView.contentOffset.x / SCREEN_WIDTH)
        
        index = (index - 1) > 0 ? (index - 1) : 0
        
        if index != self.control.currentPage {
            self.control.currentPage = index
        }
        
        print("offsetX: \(self.scrollView.contentOffset.x)")
    }
}
