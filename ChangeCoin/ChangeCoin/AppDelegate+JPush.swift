////
////  AppDelegate+JPush.swift
////  SwiftJPush
////
////  Created by Bingo on 2019/6/25.
////  Copyright © 2019 Bingo. All rights reserved.
////
//
//import Foundation
//import UIKit
//extension  AppDelegate:JPUSHRegisterDelegate{
//    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
//
//    }
//
//
//    open func regiestJPush(key:String,launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
//
//        //推送代码
//        let entity = JPUSHRegisterEntity()
//        entity.types = 1 << 0 | 1 << 1 | 1 << 2
//        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
//
//        JPUSHService.setup(withOption: launchOptions, appKey: key, channel: "App Store", apsForProduction: false, advertisingIdentifier: nil)
//
//
//
//    }
//    //MARK:--推送代理
//    @available(iOS 10.0, *)
//    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
//
////        let userInfo = notification.request.content.userInfo
////        if notification.request.trigger is UNPushNotificationTrigger {
////            JPUSHService.handleRemoteNotification(userInfo)
////        }
//        // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
////        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
//    }
//
//    @available(iOS 10.0, *)
//    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
//        let userInfo = response.notification.request.content.userInfo
//        if response.notification.request.trigger is UNPushNotificationTrigger {
//            JPUSHService.handleRemoteNotification(userInfo)
//        }
//        // 系统要求执行这个方法
//        completionHandler()
//    }
//
//    //点推送进来执行这个方法
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        JPUSHService.handleRemoteNotification(userInfo)
//        completionHandler(UIBackgroundFetchResult.newData)
//
//    }
//    //系统获取Token
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        JPUSHService.registerDeviceToken(deviceToken)
//    }
//    //获取token 失败
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //可选
//        print("did Fail To Register For Remote Notifications With Error: \(error)")
//    }
//
//    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
//
//    }
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        //销毁通知红点
//        UIApplication.shared.applicationIconBadgeNumber = 0
//        JPUSHService.setBadge(0)
//        UIApplication.shared.cancelAllLocalNotifications()
//    }
//
//}
