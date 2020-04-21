//
//  BaseCollectionView.swift
//  Project
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit

class XJHBaseCollectionView: XJHBaseView,UICollectionViewDelegate,UICollectionViewDataSource {

    var datas = [Any]()
    var collectionView : UICollectionView?
    
//    重写父类初始化方法
    override class func view() -> Self! {
        
        let instance = self.init()
        instance.makeCollectionView()
        instance.initXJHView()
        return instance
    }
    
    override class func view(parmas : ViewDataObject) -> Self! {
        
        let instance = self.init()
        instance.makeCollectionView()
        instance.initXJHView(parmas: parmas)
        return instance
    }
    
    func cCreateErrorView(_ error: XJHError, showErrorMessage: Bool = true, errorMessage: String? = nil) {
                
        if self.datas.count == 0 {
            super.createErrorView(error, showErrorMessage: showErrorMessage)
        }else {
            if showErrorMessage == true {
                if errorMessage == nil {
                    XJHProgressHUD.showError(message: error.localizedDescription)
                }else {
                    XJHProgressHUD.showError(message: errorMessage!)
                }
            }
        }
        
        self.endRefresh()
    }

    func makeCollectionView() {
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        self.collectionView?.backgroundColor = XJHLineColor
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.autoresizesSubviews = true
        self.collectionView?.autoresizingMask = .flexibleHeight
        self.collectionView?.keyboardDismissMode = .onDrag
        self.addSubview(self.collectionView!)
        
        if #available(iOS 11.0, *){
            self.collectionView?.contentInsetAdjustmentBehavior = .never
        }
        
        self.collectionView?.snp.makeConstraints({ (make) in
            
            make.edges.equalTo(0)
        })
    }

//    默认更新collectionView方法
    func xjh_updateCollecDataToView(datas : Array<Any>) {
        
        self.datas = datas
        
        DispatchQueue.main.async {
            self.xjh_hiddenHud()
            self.collectionView?.reloadData()
        }
    }

    func xjh_addDownPullToRefresh() {
        
        self.collectionView?.es.addPullToRefresh {
            
            self.sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: xjh_PullDown, params: nil, uiView: self))
        }
    }
    
    func xjh_addUpPullToRefresh() {
        
        self.collectionView?.es.addInfiniteScrolling {
            
            self.sendViewDelegateEvent(eventObject: ViewEventObject.xjh_viewEventObject(eventType: xjh_PullUp, params: nil, uiView: self))
        }
    }
    
    func endRefresh() {
        
        if self.collectionView?.header?.isRefreshing == true {
            self.collectionView?.header?.stopRefreshing()
        }
        
        if self.collectionView?.footer?.isRefreshing == true {
            self.collectionView?.footer?.stopRefreshing()
        }
    }

//    UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = XJHBaseCollectionViewCell.init()
        return cell
    }
}
