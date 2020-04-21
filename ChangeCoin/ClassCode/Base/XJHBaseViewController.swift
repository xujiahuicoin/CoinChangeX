//
//  BaseViewController.swift
//  xujiahuiCoin
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 www.xujiahuiCoin.cn. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import PKHUD

let hudShowTime = 1.5

class XJHBaseViewController: UIViewController,XJHViewEventsDelegate,NVActivityIndicatorViewable {
    
 
    
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.view.backgroundColor = XJHBackgroundColor_dark
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.stopAnimating()
        }

        // Do any additional setup after loading the view.
    }
    
    func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
        
    }
    
//    创建左侧title
    func createLeftTitle(title : String) {
        
        self.navigationItem.title = ""
        
        let titleLabel = UILabel.init(frame: .zero, text: title, font: FontBold(font: XJHFontNum_Max()), color: .white, alignment: .left, lines: 0)
        let leftItem = UIBarButtonItem.init(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    //  创建zuo侧图片按钮
       func xjh_createLeftButtonItem(image : UIImage, target : Any?, action : Selector?) {
           
           let buttonItem = UIBarButtonItem.init(image: image, style: .plain, target: target, action: action)
           self.navigationItem.leftBarButtonItem = buttonItem
       }
       
       //  创建zuo侧文字按钮
       func xjh_createLeftButtonItem(title : String, target : Any?, action : Selector?) {
           
           let buttonItem = UIBarButtonItem.init(title: title, style: .plain, target: target, action: action)
           buttonItem.tintColor = XJHButtonColor_Blue
           self.navigationItem.leftBarButtonItem = buttonItem
       }

    //  创建右侧图片按钮
    func xjh_createRightButtonItem(image : UIImage, target : Any?, action : Selector?) {
        
        let buttonItem = UIBarButtonItem.init(image: image, style: .plain, target: target, action: action)
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    //  创建右侧文字按钮
    func xjh_createRightButtonItem(title : String, target : Any?, action : Selector?) {
        
        let buttonItem = UIBarButtonItem.init(title: title, style: .plain, target: target, action: action)
        buttonItem.tintColor = XJHButtonColor_Blue
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    
    /// 展示HUD
    func xjh_HUDShow(){

        XJHProgressHUD.show(view: self.view)
    }
    
    ///隐藏HUD
    func xjh_hideHUD(){
        XJHProgressHUD.hide()
    }
    
    
    func xjh_showError_Text(text:String, view:UIView){
        XJHProgressHUD.showError(message: text, view: view)
      
    }
    func xjh_showError_Text(text:String){

        XJHProgressHUD.showError(message: text)
    }
    
    
    func xjh_showSuccess_Text(text:String, view:UIView){
    
        XJHProgressHUD.showSuccess(message: text, view: view)
        
    }
    func xjh_showSuccess_Text(text:String){
        XJHProgressHUD.showSuccess(message: text)
    }
    
    func xjh_showProgress_Text(text:String,view:UIView){
        
    HUD.flash(.labeledProgress(title: nil, subtitle: text as String), delay: hudShowTime)
    }
 
    ///去登录
    func yxs_goToLoginVC(){
        
//        self.navigationController?.pushViewController(XJHLoginViewController(), animated: true)
    }
    
    //返回
   @objc func goLeftVC(){
        xjh_hideHUD()
        self.navigationController?.popViewController(animated: true)
    }
}
