//
//  XJH_UserDataTool.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit
let serverTishi = "请选择服务器"
class XJH_UserDataTool: NSObject {
    
    ///加载所支持的交易对信息
    class func XJH_LoadWholeChangeCoinsData(){
        
        //判断是否有值
        let coinDict = XJH_UserModel.sharedInstance.wholeChange?.coinBTC ?? []
        
        if coinDict.count < 1{
            //没有数值 需要请求
            let url = GitHubBaseUrl + "coinData"
            
            XJH_GitHub.GitHubProjectPathFiledict(pathUrl:url, blockSuccess: { (mod) in
                
                DispatchQueue.main.async(execute: {
                    
                    if let dict = mod.contentToDict() as? Dictionary<String,Any> {
                        
                        let mods = XJH_UserInfoModel.deserialize(from: dict)!
                        XJH_UserModel.sharedInstance.wholeChange = mods
                        
                    }
                })
                
                
            }) { (err) in
                
            }
            
        }
    }
    
    ///获取管理员信息
    @objc class func XJH_GetSupervisionUserInfoMode() {
        
        let url = XJH_GitSupervisionInfoGet()
        
        XJH_GitHub.GitHubProjectPathFiledict(pathUrl:url, blockSuccess: { (modic) in
            
            if let dict = modic.contentToDict() as? Dictionary<String,Any> {
                
                let mod = XJH_AdminModel.deserialize(from: dict)!
                //解析 user 中的key
                if mod.user.count > 0{
                    //设置管理员密码
                    XJH_UserModel.sharedInstance.adminPassword = mod.infoNumber
                    //设置管理权限方案
                    XJH_UserModel.sharedInstance.AdminChangeUserFileProgram = mod.AdminChangeUserFileProgram
                    //有需要管理的用户进行解密
                    for arr:[String] in mod.user {
                        if arr.count != 2 {
                            XJHProgressHUD.showError(message: "管理用户数据有问题-adminInfo")
                            break
                        }
                        let mod :XJH_AdminUserModel = self.XJH_decryptDataToAdminUserModel(thisKey: arr[1], passWord: mod.infoNumber, userNameStr: arr[0])
                        
                        ///如果有数据--添加管理用户
                        if mod.userName.count > 0
                        {
                            XJH_UserModel.sharedInstance.adminUserModel.append(mod)
                        }
                    }
                    
                    
                    //加载所支持的交易对信息
                    XJH_UserDataTool.XJH_LoadWholeChangeCoinsData()
                    
                }
            }
            
        }) { (err) in
            
            
            
        }
        
        
    }
    
    ///获取用户信息
    class func XJH_GetUserInfoMode(userName:String,blockSuccess: @escaping (_ mod : XJH_UserInfoModel) ->(), blaocError : @escaping (_ errcod:XJHError)->() ) {
        
        let url = XJH_GitInfoGet(userName: userName)
        
        if url.count < 1 {
            BaseAlertController.showAlertOneAction(message: "还没有选择服务器", vc: BaseAlertController.getRootVC()) { }
            XJHProgressHUD.hide()
            return
        }
        
        
        XJH_GitHub.GitHubProjectPathFiledict(pathUrl:url, blockSuccess: { (mod) in
            
            DispatchQueue.main.async(execute: {
                
                if let dict = mod.contentToDict() as? Dictionary<String,Any> {
                    
                    let mods = XJH_UserInfoModel.deserialize(from: dict)!
                    
                    ///判断是否冻结状态。是的话直接跳到 登录页面
                    if mods.freeze {
                        //冻结了
                        XJHProgressHUD.showError(message: "该账户已被冻结，请联系管理员")
                        
                        self.perform(#selector(xjh_changeTabLogin), with: self, afterDelay: 2)
                        return
                    }
                    
                    if mods.passWord.count > 1{
                        blockSuccess(mods)
                        return
                    }
                }
                
                blaocError(XJHError(code: 401))
            })
            
            
        }) { (err) in
            
            blaocError(XJHError(code: 401))
        }
    }
    
    //切换登录tab
    @objc class func xjh_changeTabLogin(){
        accountIsFreezeToLogined()
    }
    
    ///处理登录前 --参数---进行判断
    class func  XJH_Login_ParameterJudgmentBeforeLogin(userNameStr:String, passwordStr:String,pairTexrStr:String,Vc:XJHBaseViewController,blockState : @escaping (_ returnType :LoginState)->()){
        
        //获取key
        var thisKey = ""
        
        let keyLocal:String = UserDefaults.standard.value(forKey: okex_keyPairString + userNameStr) as? String  ?? ""
        
        //服务器名称
        let servername:String = XJH_UserInfo.XJH_getServerNameInInfo()
        
        if servername == serverTishi {
            blockState(.failed)
            BaseAlertController.showAlertOneAction(message: "请选择服务器", vc: Vc) {}
            
            return
        }
        
        //---判断有么有用户名
        if userNameStr.count < 1 {
            
            BaseAlertController.showAlertOneAction(message: "请输入账号", vc: Vc) {}
            blockState(.failed)
            
        }else if passwordStr.count < 1 {
            
            //---判断有么有密码
            BaseAlertController.showAlertOneAction(message: "请输入密码", vc: Vc) {}
            blockState(.failed)
            
            
        }else if keyLocal.count < 1{
            
            //---没有本地值
            //也没有输入值
            if pairTexrStr.count < 1{
                //                BaseAlertController.showAlertOneAction(message: "该用户，还没有密钥记录\n输入密钥", vc: Vc) {}
                //                blockState(.failed)
            }else if pairTexrStr.count > 1{
                
                //本地没有 首次输入
                thisKey = pairTexrStr
                //进行请求
                //                XJH_LoginDealDataModel(userNameStr: userNameStr, passwordStr: passwordStr, thisKey: thisKey, Vc: Vc) { (state) in
                //                    blockState(state)
                //                }
                
            }
            
            ///有么有输入 否可以进行请求
            XJH_LoginDealDataModel(userNameStr: userNameStr, passwordStr: passwordStr, thisKey: thisKey, Vc: Vc) { (state) in
                blockState(state)
            }
            
            
        }else if keyLocal.count > 1{
            
            //---本地有值
            //没有输入值
            if pairTexrStr.count < 1 ||  pairTexrStr == textviewText {
                thisKey = keyLocal
                //进行请求
                XJH_LoginDealDataModel(userNameStr: userNameStr, passwordStr: passwordStr, thisKey: thisKey, Vc: Vc) { (state) in
                    blockState(state)
                }
                
            }else{
                
                //也有输入值。也输入了 是否更换
                BaseAlertController.showAlertTwoAction(message: "登录成功后，更新密钥会被记录\n是否更换新值", actionTextOne: "一次登录", actionTextTwo: "更换", vc: Vc, FFActionOne: {
                    
                    thisKey = keyLocal
                    //进行请求
                    XJH_LoginDealDataModel(userNameStr: userNameStr, passwordStr: passwordStr, thisKey: thisKey, Vc: Vc) { (state) in
                        blockState(state)
                    }
                    
                }, FFActionTwo: {
                    
                    thisKey = pairTexrStr
                    //进行请求
                    XJH_LoginDealDataModel(userNameStr: userNameStr, passwordStr: passwordStr, thisKey: thisKey, Vc: Vc) { (state) in
                        blockState(state)
                    }
                    
                })
            }
            
            
        }
    }
    
    ///登录之后的 不定时刷新用户数据
    class func XJH_updateUserData()  {
        
        XJH_UserDataTool.XJH_GetUserInfoMode(userName: XJH_UserModel.sharedInstance.userName, blockSuccess: { (mod) in
            
            //设置mod
            
            mod.okex_secretkey  = XJH_UserModel.sharedInstance.okex_secretkey
            mod.okex_PassPHRASE = XJH_UserModel.sharedInstance.okex_PassPHRASE
            mod.okex_apikey     = XJH_UserModel.sharedInstance.okex_apikey
            mod.okex_remarkName = XJH_UserModel.sharedInstance.okex_remarkName
            mod.userName = XJH_UserModel.sharedInstance.userName
            
            //更新
            XJH_UserModel.sharedInstance = mod
            
            //判断是不是管理员 是了 加载管理员数据
            if XJH_UserModel.sharedInstance.adminBool{
                XJH_GetSupervisionUserInfoMode()
            }
            
        }) { (err) in
            //
            
        }
        
        
    }
    
    ///开始登录--
    class func XJH_LoginDealDataModel(userNameStr:String,passwordStr:String, thisKey:String,Vc:XJHBaseViewController,blockState:@escaping (_ state:LoginState)->()){
        
        ///获取用户资料 验证密码 XJH_UserModel.sharedInstance
        XJH_UserDataTool.XJH_GetUserInfoMode(userName: userNameStr, blockSuccess: { (mod) in
            
            //没有密钥传过来的 可能是管理员
            if thisKey.count < 1 ||  thisKey == textviewText{
                //正确
                XJH_UserModel.sharedInstance = mod
                
                //判断是不是管理员 是了 加载管理员数据
                if mod.adminBool{
                    //请求管理数据
                    XJH_GetSupervisionUserInfoMode()
                    //设置控制器 只为管理员
                    isChangeLoginedToVC(type: .type_admin)
                    
                }else{
                    
                    //不是了提示 密钥
                    BaseAlertController.showAlertOneAction(message: "该用户，还没有密钥记录\n输入密钥", vc: Vc) {}
                    blockState(.failed)
                    
                }
                
                return
            }
            
            
            //---验证密码
            if md5Detail(mdString: passwordStr) == mod.passWord {
                
                let str :String = aesTools.aes(to: thisKey, keyString: mod.passWord) ?? ""
                //解密 验证密钥成功与否
                if str.count < 1 {
                    //解密失败
                    BaseAlertController.showAlertOneAction(message: "输入密钥不正确啊", vc: Vc) {}
                    XJHProgressHUD.hide()
                    blockState(.failed)
                    
                }else{
                    //解密成功
                    //设置mod
                    let arrmod = str.components(separatedBy: ",")
                    
                    if arrmod.count == 4 {
                        
                        mod.okex_secretkey  = arrmod[0]
                        mod.okex_PassPHRASE = arrmod[1]
                        mod.okex_apikey     = arrmod[2]
                        mod.okex_remarkName = arrmod[3]
                        mod.userName = userNameStr
                        //保存本地密钥--到model
                        UserDefaults.standard.set(thisKey, forKey: okex_keyPairString + userNameStr )
                        //正确
                        XJH_UserModel.sharedInstance = mod
                        
                        //判断是不是管理员 是了 加载管理员数据
                        if XJH_UserModel.sharedInstance.adminBool{
                            XJH_GetSupervisionUserInfoMode()
                        }
                        
                        //进入页面---切换tab
                        isChangeLoginedToVC()
                        
                        blockState(.success)
                        return
                        
                    }else{
                        //mod 数据不全
                        BaseAlertController.showAlertOneAction(message: "密钥中，数据不完整", vc: Vc) {}
                        
                    }
                    
                }
                
            }else{
                //验证密码失败
                BaseAlertController.showAlertOneAction(message: "密码错误", vc: Vc) {}
                XJHProgressHUD.hide()
                blockState(.failed)
            }
        }) { (err) in
            //
            BaseAlertController.showAlertOneAction(message: "账号/网络出现问题", vc: Vc) {}
            blockState(.failed)
        }
        
    }
    
    
    ///解密返回解密Model
    class func XJH_decryptDataToAdminUserModel(thisKey:String,passWord:String,userNameStr:String)->XJH_AdminUserModel{
        
        let mod = XJH_AdminUserModel()
        
        let str :String = aesTools.aes(to: thisKey, keyString: passWord) ?? ""
        
        //解密 验证密钥成功与否
        
        if str.count < 1   {
            //解密失败
            //            BaseAlertController.showAlertOneAction(message: "此用户密钥有问题："+userNameStr, vc: BaseAlertController.getRootVC()) {
            //
            //                }
            
            
        }else{
            //解密成功
            //设置mod
            let arrmod = str.components(separatedBy: ",")
            
            if arrmod.count == 4 {
                mod.okex_secretkey  = arrmod[0]
                mod.okex_PassPHRASE = arrmod[1]
                mod.okex_apikey     = arrmod[2]
                mod.okex_remarkName = arrmod[3]
                mod.userName = userNameStr
                
                return mod
            }
        }
        
        return mod
    }
}
