//
//  AppDelegate.swift
//  xujiahuiCoin
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 www.xujiahuiCoin.cn. All rights reserved.

import UIKit
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController =  XJH_LoginVC() //XJHBaseTabBarController.init()//
        self.window?.makeKeyAndVisible()
        
        ///启动APP需要处理的事件
        XJH_StarAppAction()
        
        return true
    }
    
}

///正常登录
func isChangeLoginedToVC(type:XJH_TabType = .type_user){
    
    let app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let vc = app.window?.rootViewController
    let tab = XJHBaseTabBarController.init()
    tab.XJH_PubCreatTabWith(type: type)
    app.window?.rootViewController = tab
    vc?.removeFromParent()

}

func accountIsFreezeToLogined(){
    
    let app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let vc = app.window?.rootViewController
    app.window?.rootViewController = XJH_LoginVC.init()
    vc?.removeFromParent()
}


///启动APP需要处理的事件
func XJH_StarAppAction(){
    
    //启用控制键盘功能
    IQKeyboardManager.shared.enable = true
    
    //点击空白 键盘收回
    IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    //bug管理
    Bugly.start(withAppId: Tencent_APPID)
    //防止崩溃
    XJH_starThePreventCrash()
    
    
    //用户设置读取
    XJHSetingLogic.Xjh_SetReadData()
    
    
}

///防止崩溃
func XJH_starThePreventCrash(){
    
    AvoidCrash.makeAllEffective()
    //    AvoidCrash.setupNoneSelClassStringsArr(["NSString"])
    //若需要防止某个前缀的类的unrecognized selector sent to instance
    //比如AvoidCrashPerson
    //你可以调用如下方法
    AvoidCrash.setupNoneSelClassStringsArr(["AvoidCrash"])
    
}

