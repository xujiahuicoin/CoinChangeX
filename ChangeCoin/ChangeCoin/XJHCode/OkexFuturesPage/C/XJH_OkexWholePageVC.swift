//
//  XJH_OkexWholePageVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

///开仓---通知事件
let pageNotifaca_open = "pageNotifaca_open"
///平仓---通知事件
let pageNotifaca_close = "pageNotifaca_close"
///持仓---通知事件
let pageNotifaca_pending = "pageNotifaca_pending"

import UIKit
class XJH_OkexWholePageVC: XJHBaseViewController,LGScrollPageViewDelegate,XJH_OkexFuturesVCPushVCDelegate,XJHOkex_PendingVCPushVCDelegate {
    
    ///当前页面的index
    var indexPage : Int = 0
    
    let titleArray = ["开仓","平仓","持仓"]
    var chidlVCs  : Array<Any>! = nil
    var pageView : LGScrollPageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //发送当前页面的通知 计时器开始
        if indexPage == 0 {
               //开仓vc
               NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_open), object: true)
            
           }else if indexPage == 1 {
               //平仓vc
               NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_close), object: true)

           }else if indexPage == 2 {
               //持仓vc
               NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_pending), object: true)
      
           }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
               //开仓vc
               NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_open), object: false)
           
               //平仓vc
               NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_close), object:false)
           
               //持仓vc
               NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_pending), object: false)
           
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fuVc : XJH_OkexFuturesVC = XJH_OkexFuturesVC()
        fuVc.FuturesDelegate = self
        
        let pend : XJHOkex_PendingVC = XJHOkex_PendingVC()
        pend.FuturesDelegate = self
        
        let cutVC : XJH_Okex_CutFuturesVC = XJH_Okex_CutFuturesVC()
        cutVC.FuturesDelegate = self
        
        chidlVCs = [fuVc,cutVC,pend] as [Any]
        
        let style = LGScrollTitleViewStyle()
        style.isShowLine = true
        style.scrollLineColor = XJHButtonColor_Blue
        style.titleNormalColor = XJHSecondTextColor
        style.titleSelectedColor = XJHMainTextColor_dark
        style.titleBigScale = 1
        style.titleFont = Font(font: XJHFontNum_Second())
        pageView = LGScrollPageView(frame: self.view.bounds, style: style, backgroundColor: XJHBackgroundColor_dark)
        pageView.setTiltes(titleArray, childVcs: (chidlVCs as! [UIViewController]), parentViewController: self, delegate: self)
        
        pageView.generate()
        self.view.addSubview(pageView)
        
        ///开启ws
        Okex_linkWebSocket()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SRWebSocketDidReceiveMsg(note:)), name: NSNotification.Name(rawValue: kWebSocketdidReceiveMessageNote), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SRWebSocketDidOpen), name: NSNotification.Name(rawValue: kWebSocketDidOpenNote), object: nil)
        
    }
    
    @objc func  SRWebSocketDidOpen(){
        
        SocketRocketUtility.instance()?.sendData("{\"op\":\"subscribe\",\"args\":[\"futures/depth5:BTC-USD-200327\"]}")
    }
    
    @objc func SRWebSocketDidReceiveMsg(note:NSNotification){
        
        print(note.object)
        let dataRoot:Data = note.object as! Data
        
        let data = dataCompression().gzipInflate(dataRoot)
        
//        let str = data.dataToString()
            
        
    }
    
    ///给自控制器发送通知：在显示的时候viewwillApear 不执行 要进行通知触发
    func xjh_notifacationSubVCViewWillApear(index:Int){
        
        if index == 0 {
            //开仓vc
            NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_open), object: true)
            
            NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_pending), object: false)
            NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_close), object: false)
        }else if index == 1 {
            //平仓vc
            NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_close), object: true)
            
            NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_pending), object: false)
            NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_open), object: false)
        }else if index == 2 {
            //持仓vc
            NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_pending), object: true)
            
            NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_close), object: false)
            NotificationCenter.default.post(name: NSNotification.Name(pageNotifaca_open), object: false)
        }
    }
    
    func lgPageSendTitle(_ titleString: String!, index: Int) {
        
        //清理右上角的item
        self.navigationItem.rightBarButtonItems = []
        indexPage = index
        
        if index == 2 {
            //持仓vc
            self.xjh_createRightButtonItem(title: "全部仓位", target: self, action: #selector(XJH_Okex_AllFuturesOrderItem))
            
        }
        
        xjh_notifacationSubVCViewWillApear(index: index)
    }
    
    
    func XJH_OkexFuturesVCPushAction(vc: XJHBaseViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    ///合约全部订单
    @objc func XJH_Okex_AllFuturesOrderItem(){
        self.navigationController?.pushViewController(XJH_Okex_AllFuturesOrderVC(), animated: true)
    }
    
}
