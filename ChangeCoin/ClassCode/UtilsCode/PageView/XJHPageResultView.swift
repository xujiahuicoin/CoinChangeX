//
//  PageResultView.swift
//  Pro
//
//  Created by mac on 2019/6/19.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit

@objc protocol XJHPageResultViewDelegate : NSObjectProtocol {
    
    @objc func pageResultView(_ pageView : XJHPageResultView, viewForPageAt page : Int) -> UIView
    
    @objc optional func pageResultView(_ pageView : XJHPageResultView, didEndScrolling page : Int)

}

class XJHPageResultView: UIView,UIScrollViewDelegate {

    weak var delegate : XJHPageResultViewDelegate?

    var currentPage : Int = 0
    var totalCount : Int = 0
    
    var scrollView : UIScrollView!
    var containerView : UIView!
    
    class func pageResultView(totalCount : Int) -> XJHPageResultView {
        
        let view = XJHPageResultView.init()
        view.totalCount = totalCount
        view.xjh_initView()
        return view
    }
    
    func xjh_initView() {
        
        self.scrollView = UIScrollView.init()
        self.scrollView.scrollsToTop = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.delegate = self
        self.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.containerView = UIView.init()
        self.scrollView.addSubview(self.containerView)
        
        self.containerView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.scrollView)
            make.height.equalTo(self.scrollView)
            make.width.equalTo(xjh_WidthScreen * CGFloat(self.totalCount))
        }
        
    }
    
    func setCurrentPage(currentPage : Int, animated : Bool = false) {
        
        self.currentPage = currentPage
        
        self.scrollView.setContentOffset(CGPoint(x: xjh_WidthScreen * CGFloat(currentPage), y: 0), animated: animated)
        
        self.addViewToContainerView(page: currentPage)
    }
    
    func addViewToContainerView(page : Int) {
        
//        如果代理为nil，直接return
        if self.delegate == nil {
            return
        }

        let view = self.delegate?.pageResultView(self, viewForPageAt: page)

//        如果代理方法返回的view为nil，直接return
        if view == nil {
            return
        }
    
//        如果返回的view已经有superview（已经添加到了containerView上），直接return
        if view?.superview != nil {
            return
        }

        self.containerView.addSubview(view!)
        
        view?.snp.makeConstraints({ (make) in
            
            make.left.equalTo(xjh_WidthScreen * CGFloat(page))
            make.top.bottom.equalTo(0)
            make.width.equalTo(xjh_WidthScreen)
        })
    }
    
//    UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        self.currentPage = page
        
        if self.delegate != nil {
            if self.delegate!.responds(to: Selector(("pageResultView:viewForPageAt:"))) {
                
                self.delegate?.pageResultView?(self, didEndScrolling: page)

            }
        }
    }
}
