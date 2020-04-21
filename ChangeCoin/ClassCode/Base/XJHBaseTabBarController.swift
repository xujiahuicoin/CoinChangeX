//
//  BaseTabBarController.swift
//  xujiahuiCoin
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 www.xujiahuiCoin.cn. All rights reserved.
//
import UIKit

enum XJH_TabType :Int {
    
    case type_user = 0
    case type_admin = 1
}

import SwifterSwift
class XJHBaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.xjh_color(lightColor: .white, darkColor: XJHLineColor)
        
        self.tabBar.tintColor = .white
        //        self.tabBar.unselectedItemTintColor = .black
    }
    
    func XJH_PubCreatTabWith(type:XJH_TabType){
        
        if type == .type_admin {
            self.addChildrenViewController(viewController: XJH_AdminVC(), title: "管理员", image: UIImage(named: "mypage_img0")?.original, selectedImage: UIImage(named: "mypage_img1")?.original)
        }else{
            
            
            self.addChildrenViewController(viewController: XJH_OkexPageVC(), title: "BB", image: UIImage(named: "mainpage_img10")?.original, selectedImage: UIImage(named: "mainpage_img11")?.original)
            //
            self.addChildrenViewController(viewController: XJH_OkexWholePageVC(), title: "合约", image: UIImage(named: "qushitu_img0")?.original, selectedImage: UIImage(named: "qushitu_img1")?.original)
            
            if XJH_UserModel.sharedInstance.adminBool {
                self.addChildrenViewController(viewController: XJH_AdminVC(), title: "管理员", image: UIImage(named: "mypage_img0")?.original, selectedImage: UIImage(named: "mypage_img1")?.original)
            }
            
        }
    }
    
    
    func addChildrenViewController(viewController : UIViewController, title : String, image : UIImage?, selectedImage : UIImage?) {
        
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = selectedImage
        viewController.title = title
        
        let nav = XJHBaseNavigationController.init(rootViewController: viewController)
        self.addChild(nav)
    }
    
}
