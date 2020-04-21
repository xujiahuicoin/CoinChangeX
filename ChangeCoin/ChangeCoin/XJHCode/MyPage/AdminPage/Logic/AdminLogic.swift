//
//  AdminLogic.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/7.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import Foundation

class AdminLogic : NSObject{
    
    class func Xjh_GetUserArraylist() -> Array<String> {
        
        let mods = XJH_UserModel.sharedInstance.adminUserModel
        var array: [String] = []
        for mod in mods {
            array.append(mod.userName)
        }
        
        return array
    }
    
    ///管理员密码验证
    class func Xjh_AdminPassworldValidation(blockSuccess:@escaping()->()){
        
        BaseAlertController.showAlertTextField(title: "权限验证", message: "输入管理员密码", actionTextOne: "取消", actionTextTwo: "确定", placeholder: "输入密码", vc: BaseAlertController.getRootVC(), FFActionOne: {
            
        }) { (text) in
            //密码核对
            if md5Detail(mdString: text) == XJH_UserModel.sharedInstance.adminPassword{
                
                blockSuccess()
                
            }else{
                XJHProgressHUD.showError(message: "验证失败")
                
            }
        }
        
        
    }
    
    ///修改用户设置 提交验证方案
    ///1、只要修改就需要验证
    class func Xjh_AdminChangeUserFileProgram_One(creatform:Bool, value:Dictionary<String,Any>, fileModel:XJh_GithubProjectContentsModel?,currentMod:XJH_UserInfoModel?,blockSuccess:@escaping()->(), blockError:@escaping()->()){
        
        AdminLogic.Xjh_AdminPassworldValidation(blockSuccess: {
            
            XJh_AdminCommitFile(creatform: creatform, value: value, fileModel: fileModel, blockSuccess: {
                
            }) {
                blockError()
                
            }
        })
    }
    
    
    ///：2、修改 冻结、删除、给予权限时
    class func Xjh_AdminChangeUserFileProgram_Two(creatform:Bool, value:Dictionary<String,Any>, fileModel:XJh_GithubProjectContentsModel?,currentMod:XJH_UserInfoModel?,blockSuccess:@escaping()->(), blockError:@escaping()->()){
        
        if creatform {
            //创建
            AdminLogic.Xjh_AdminPassworldValidation(blockSuccess: {
                
                XJh_AdminCommitFile(creatform: creatform, value: value, fileModel: fileModel, blockSuccess: {
                    
                }) {
                    blockError()
                    
                }
            })
        }else{
            //判断修改时：是否修改了冻结\管理员
            if currentMod!.adminBool != value["adminBool"] as! Bool || currentMod!.freeze != value["freeze"] as! Bool
            {
                
                AdminLogic.Xjh_AdminPassworldValidation(blockSuccess: {
                    
                    XJh_AdminCommitFile(creatform: creatform, value: value, fileModel: fileModel, blockSuccess: {
                        blockSuccess()
                        
                    }) {
                        
                        blockError()
                        
                    }
                    
                })
                
            }else
            {
                XJh_AdminCommitFile(promt:true, creatform: creatform, value: value, fileModel: fileModel, blockSuccess: {
                    blockSuccess()
                    
                }) {
                    
                    blockError()
                    
                }
            }
        }
        
    }
   
    ///3、删除、其他无需验证
    class func Xjh_AdminChangeUserFileProgram_Three(creatform:Bool, value:Dictionary<String,Any>, fileModel:XJh_GithubProjectContentsModel?,currentMod:XJH_UserInfoModel?,blockSuccess:@escaping()->(), blockError:@escaping()->()){
           
               XJh_AdminCommitFile(promt:true, creatform: creatform, value: value, fileModel: fileModel, blockSuccess: {
                   
               }) {
                   blockError()
                   
               }

       }
    ///可以提交创建了
    class func XJh_AdminCommitFile(promt:Bool = false,creatform:Bool, value:Dictionary<String,Any>, fileModel:XJh_GithubProjectContentsModel?, blockSuccess:@escaping()->(), blockError:@escaping()->()){

            if promt {
            //提示
            BaseAlertController.showAlertTwoAction(message: creatform ? "可以提交创建了" : "对原数据修改", vc: BaseAlertController.getRootVC(), FFActionOne: {
                
            }) {
                
                XJHProgressHUD.show()
                
                XJH_GitHub.Github_UpdateFileWith( creatform ? .create : .update, sha: fileModel?.sha ?? "", content: value, path: creatform ? (value["userName"] as! String) : (fileModel?.path ?? ""), blockSuccess: { () in
                    
                    XJHProgressHUD.hide()
                    XJHProgressHUD.showSuccess(message:creatform ? "创建成功" : "修改成功")
                    
                    blockSuccess()
                    
                }) { (err) in
                    
                    XJHProgressHUD.hide()
                    XJHProgressHUD.showError(message: err.message)
                    blockError()
                }
                
            }
            
            
        }else{
            
            XJHProgressHUD.show()
            
            XJH_GitHub.Github_UpdateFileWith( creatform ? .create : .update, sha: fileModel?.sha ?? "", content: value, path: creatform ? (value["userName"] as! String) : (fileModel?.path ?? ""), blockSuccess: { () in
                
                XJHProgressHUD.hide()
                XJHProgressHUD.showSuccess(message:creatform ? "创建成功" : "修改成功")
                
                blockSuccess()
                
            }) { (err) in
                
                XJHProgressHUD.hide()
                XJHProgressHUD.showError(message: err.message)
                blockError()
            }
        }
        
        
        
    }
    
}
