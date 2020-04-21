//
//  XJH_UserModel.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//


import UIKit

class XJH_UserModel {
    static var sharedInstance = XJH_UserInfoModel()
}
class XJH_UserInfoModel: XJHBaseModel {

    var userName : String = ""
    var futures : [String] = []
    var coinBTC : [String] = []
    var coinETH : [String] = []
    var coinUSDT : [String] = []
    
    var leverageMax  : Double = 1 // "3",
    var leverageMin  : Double = 1 // "1",
    var passWord  : String = "" // "ljh123
    ///操作是否冻结 默认不冻结--444
    var freeze : Bool = false
    ///是不是管理员 ，默认不是
    var adminBool : Bool = false
    ///管理的目录文件
    var adminPath: String = ""
    var adminUserModel : [XJH_AdminUserModel] = []
    var adminPassword: String = ""
    /*
     管理员密码验证方案：
     1、只要修改就需要验证
     2、创建、冻结、删除、给予权限时
     3、删除、其他无需验证
     */
    var AdminChangeUserFileProgram : Int!
//----------------本地 存入--------------

    var okex_apikey : String = ""
    var okex_secretkey : String = ""
    var okex_remarkName : String = ""
    var okex_PassPHRASE : String = ""
    
//------------- 支持的交易对--------------------
    var wholeChange : XJH_UserInfoModel?
}
///管理用户的 model
class XJH_AdminUserModel : XJHBaseModel {
    var userName : String = ""
    var okex_apikey : String = ""
    var okex_secretkey : String = ""
    var okex_remarkName : String = ""
    var okex_PassPHRASE : String = ""
}
///管理员的数据信息
class XJH_AdminModel : XJHBaseModel {
    var user : [[String]] = [[]]
    var infoNumber : String = ""
    var AdminChangeUserFileProgram : Int = 2

}
