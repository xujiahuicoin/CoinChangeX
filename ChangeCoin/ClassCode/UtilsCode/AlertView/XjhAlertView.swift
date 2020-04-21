////
////  XjhAlertView.swift
////  ChangeCoin
////
////  Created by mac on 2019/11/22.
////  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
///*
// 隐藏关闭按钮
//
// let appearance = SCLAlertView.SCLAppearance(
//    showCloseButton: false
//)
//
// //隐藏icon
// showCircularIcon: false
//
// */
//
//import Foundation
//import UIKit
//import SCLAlertView
//
//let kSuccessTitle = ""
//let kErrorTitle = ""
//let kNoticeTitle = ""
//let kWarningTitle = ""
//let kInfoTitle = ""
//let kWaitingTitle = ""
//let kDefaultAnimationDuration = 1.0
//
//let KCloseButtonTitle = "确定"
//
//class XjhAlertView{
//
//
//    ///HUD---成功
//    func showSuccessDismiss(message:String) {
//
//        let timeout = SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 2.0, timeoutAction: {})
//        SCLAlertView().showTitle("提示", subTitle: message, timeout: timeout, completeText: "", style: .success)
//    }
//    ///HUD---错误
//    func showErrorDismiss(message:String) {
//
//        let timeout = SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 2.0, timeoutAction: {})
//        SCLAlertView().showTitle("", subTitle: message, timeout: timeout, completeText: "", style: .warning)
//    }
//
//    /// 弹框---提示信息
//       func showInfo(message: String) {
//
//           SCLAlertView().showInfo(message, subTitle: "")
//       }
//
//    ///弹框---成功
//    func showSuccess(message:String) {
//
//        SCLAlertView().showSuccess(message, subTitle: "",closeButtonTitle: KCloseButtonTitle)
//    }
//    ///弹框--错误
//    func showError(message:String) {
//
//        SCLAlertView().showError(message, subTitle:"",closeButtonTitle: KCloseButtonTitle)
//    }
//    ///弹框---两个按钮提示--默认 确定--取消
//    func showDoubleButton(title:String = "",cancelTitle:String = "取消",rightTitle:String = "确定",message:String,rightAction:@escaping()->()){
//
//        let alertView = SCLAlertView()
//        alertView.addButton(rightTitle) {
//            rightAction()
//        }
//
//        alertView.showInfo(title, subTitle: message,closeButtonTitle:cancelTitle)
//    }
//
//
//    ///弹框--灰色的通知
//    func showNotice(message:String) {
//        let appearance = SCLAlertView.SCLAppearance(dynamicAnimatorActive:true)
//        SCLAlertView(appearance:appearance).showNotice(kNoticeTitle, subTitle: message)
//    }
//
//    ///弹框--警告提示
//    func showWarning(message:String) {
//        SCLAlertView().showWarning(kWarningTitle, subTitle: message)
//    }
//
//    ///弹框---有一个输入框
//    func showEdit(placeholder:String,message:String,btnTitle:String,blockAction:@escaping(_ text:String)->()) {
//
//        let appearanace = SCLAlertView.SCLAppearance(showCloseButton:false)
//        let alert = SCLAlertView(appearance: appearanace)
//       let textF = alert.addTextField(placeholder)
//        alert.addButton(btnTitle){
//            blockAction(textF.text!)
//        }
//        alert.showEdit(kInfoTitle, subTitle: message)
//    }
//
//    ///弹框---两个输入框
//    func showEditDouble(placeholder1:String,placeholder2:String,message:String,btnTitle:String,blockAction:@escaping(_ text1:String,_ text2:String)->()) {
//
//           let appearanace = SCLAlertView.SCLAppearance(showCloseButton:true)
//           let alert = SCLAlertView(appearance: appearanace)
//          let textF1 = alert.addTextField(placeholder1)
//        let textF2 = alert.addTextField(placeholder2)
//           alert.addButton(btnTitle){
//            blockAction(textF1.text!, textF2.text!)
//           }
//
//           alert.showEdit(kInfoTitle, subTitle: message)
//       }
//
//    ///弹框---loding
//    func showWait(message:String) {
//        let appearance = SCLAlertView.SCLAppearance(
//            showCloseButton:false
//        )
//        let alert = SCLAlertView(appearance:appearance).showWait(message, subTitle: kWaitingTitle, closeButtonTitle: nil, timeout: nil, colorStyle: nil, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            alert.setSubTitle("Progress: 10%")
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 , execute: {
//                alert.setSubTitle("Progress: 30%")
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//                    alert.setSubTitle("Progress: 50%")
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//                        alert.setSubTitle("Progress: 70%")
//
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//                            alert.setSubTitle("Progress: 90%")
//
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                                alert.close()
//                            }
//
//                        })
//
//                    })
//
//
//                })
//
//            })
//        }
//
//    }
//
//    func showCustomSubview(message:String) {
//        // 创建显示配置
//        let appearance = SCLAlertView.SCLAppearance(
//            kTitleFont:UIFont(name: "HelveticaNeue", size: 20)!,
//            kTextFont:UIFont(name: "HelveticaNeue", size: 14)!,
//            kButtonFont:UIFont(name: "HelveticaNeue-Bold", size: 14)!,
//            showCloseButton:false,
//            dynamicAnimatorActive:true
//        )
//
//        // 使用自定义显示配置创建弹出框
//        let alert = SCLAlertView(appearance: appearance)
//
//        //创建子视图
//        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 216, height: 70))
//        let x = (subview.frame.width - 180 ) / 2
//
//        //添加一个输入框
//        let textfield1 = UITextField(frame: CGRect(x: x, y: 10, width: 180, height: 25))
//        textfield1.layer.borderColor = UIColor.green.cgColor
//        textfield1.layer.borderWidth = 1.5
//        textfield1.layer.cornerRadius = 5
//        textfield1.placeholder = "Username"
//        textfield1.textAlignment = NSTextAlignment.center
//        subview.addSubview(textfield1)
//
//        //添加第二个输入框
//        let textfield2 = UITextField(frame: CGRect(x: x, y: textfield1.frame.maxY + 10, width: 180, height: 25))
//        textfield2.isSecureTextEntry = true
//        textfield2.layer.borderColor = UIColor.green.cgColor
//        textfield2.layer.borderWidth = 1.5
//        textfield2.layer.cornerRadius = 5
//        textfield2.placeholder = "Password"
//        textfield2.textAlignment = NSTextAlignment.center
//        subview.addSubview(textfield2)
//
//        //设置弹框的自定义视图属性
//        alert.customSubview = subview
//
//        _ = alert.addButton("Login", action: {
//            print("Logged in")
//        })
//
//        //添加超时按钮
//        let showTimeout = SCLButton.ShowTimeoutConfiguration(prefix:"(",suffix:"s)")
//        _ = alert.addButton("Timeout Button", backgroundColor: UIColor.brown, textColor: UIColor.yellow, showTimeout: showTimeout) {
//            print("Timeout button tapped")
//        }
//
//        let timeoutValue: TimeInterval = 10.0
//        let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {
//            print("Timeout occurred")
//        }
//
//        //显示
//        alert.showInfo("Login", subTitle: "", timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: timeoutValue, timeoutAction: timeoutAction))
//    }
//
////    func showCustomAlertmessage() {
////        // 创建显示配置
////        let appearance = SCLAlertView.SCLAppearance(
////            kTitleFont:UIFont(name: "HelveticaNeue", size: 20)!,
////            kTextFont:UIFont(name: "HelveticaNeue", size: 14)!,
////            kButtonFont:UIFont(name: "HelveticaNeue-Bold", size: 14)!,
////            showCloseButton:false,
////            dynamicAnimatorActive:true,
////            buttonsLayout: .horizontal
////        )
////
////        let alert = SCLAlertView(appearance:appearance)
////        _ = alert.addButton("First Button", target: self, selector: #selector(firstButton))
////        _ = alert.addButton("Second Button", action: {
////            print("Second button tapped")
////        })
////        let icon = UIImage(named: "custom_icon.png")
////        let color = UIColor.orange
////
////        _ = alert.showCustom("Custom color", subTitle: "Custom color", color: color, icon: icon!)
////
////    }
////
//
//
//
//}
