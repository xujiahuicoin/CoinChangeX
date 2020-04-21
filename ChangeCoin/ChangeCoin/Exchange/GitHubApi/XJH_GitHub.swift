//
//  XJH_GitHub.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/17.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//


import UIKit
import Alamofire
class XJH_GitHub: NSObject {
    
    ///单独获取 内容点Mod
    class func GitHubProject_getFileContentMod(mod:XJh_GithubProjectContentsModel,blockSuccess:@escaping(_ mods : XJH_UserInfoModel)->(),blockError:@escaping(_ error : XJHError)->())  {
        
        XJH_GitHub.GitHubProjectPathFiledict(pathUrl: GitHubBaseUrl + mod.path, blockSuccess: { (mod) in
            
            if mod.content.count < 1{
                
                blockError(XJHError(code: 401,message:  "此文本没有内容，无法进入"))
            }else{
                ///json 字符串 转model
                let strtext = mod.Base64ToString()
                
                //json 转model
                if let dict = getDictionaryFromJSONString(strtext) as? Dictionary<String,Any> {
                    
                    let mod: XJH_UserInfoModel = XJH_UserInfoModel.deserialize(from: dict)!
                    
                    //成功返回
                    blockSuccess(mod)
                    
                }else{
                    //内容有误
                    blockError(XJHError(code: 401,message: "内容有误，请联系终端修改"))
                }
                
            }
            XJHProgressHUD.hide()
            
        }) { (errs) in
            XJHProgressHUD.hide()
            blockError(errs)
        }
    }
    
    
    ///获取指定文件的信息mod
    class func GitHubProjectPathFiledict(pathUrl:String ,blockSuccess:@escaping(_ mods : XJh_GithubProjectContentsModel)->(),blockError:@escaping(_ error : XJHError)->()){
        
        Github_BaseGetApi(type: .get, urlPath: pathUrl, params: nil, blockSuccess: { (data) in
            XJHProgressHUD.hide()
            if let dict = data as? Dictionary<String,Any> {
                
                let model = XJh_GithubProjectContentsModel.deserialize(from: dict)
                
                blockSuccess(model!)
                return
            }
            
            blockError(XJHError(code: 401))
            
        }) { (err) in
            XJHProgressHUD.hide()
            blockError(XJHError(code: 401))
        }
        
    }
    
    ///获取仓库的目录下的内容 列表
    /// - Parameters:
    ///   - pathUrl: 路径
    ///   - blockSuccess: 成功返回 目录列表数组
    ///   - blockError: 失败
    class func GitHubProjectPathdict(pathUrl:String ,blockSuccess:@escaping(_ mods : [XJh_GithubProjectContentsModel])->(),blockError:@escaping(_ error : XJHError)->()){
        
        Github_BaseGetApi(type: .get, urlPath: pathUrl, params: nil, blockSuccess: { (data) in
            XJHProgressHUD.hide()
            if let array = data as? Array<Any> {
                
                let arrModel = [XJh_GithubProjectContentsModel].deserialize(from: array)
                
                blockSuccess(arrModel! as! [XJh_GithubProjectContentsModel])
                return
            }
            
            blockError(XJHError(code: 401))
            
        }) { (err) in
            XJHProgressHUD.hide()
            blockError(XJHError(code: 401))
        }
        
    }
    
    
    
    ///带有请求头的请求
    class func Github_BaseGetApi(type:XJHMethodType, urlPath:String,params:Dictionary<String,Any>?,blockSuccess:@escaping(_ data : Any)->(),blockError:@escaping(_ error : XJHError)->()){
        
        XJHRequestManager.requestHeader(type, url: urlPath, params: params, headers: ["Authorization":"token " + GitHUb_less_Token], success: { (data) in
            XJHProgressHUD.hide()
            if let dict = data as? Dictionary<String,Any> {
                
                let errorModel = XJH_GithubErrorModel.deserialize(from: dict)
                if errorModel!.message.count > 0 {
                    //返回错误。停止运行
                    blockError(XJHError(code: 401, message: errorModel!.message))
                    return
                }
            }
//            print(data)
            blockSuccess(data)
            
        }) { (err) in
            XJHProgressHUD.hide()
            blockError(XJHError(code: 401, message: err.message))
        }
    }
    
    //-------------文件操作-----------------
    
    ///创建用户时 获取固定的jsonString
    class func Github_CreatUserInfo_JsonString()->String {
        
        let filePath:String = Bundle.main.path(forResource: "xujiahui", ofType: "json")!
        let jsonString:String = try! String.init(contentsOfFile: filePath)
        
        return jsonString
    }
    
    ///文件处理----用户------更新文件 PUT、删除文件 Delete
    class func Github_UpdateFileWith(_ type: GithubType, sha:String = "",content:Dictionary<String,Any>,path:String = "",blockSuccess:@escaping()->(),blockError:@escaping(_ error : XJHError)->()) {
        
        
        var jsonStr = ""
        
        if type != .delete {
            
            //修改后的杠杆倍数 最小不能大于最大
            let minNum:Int = content["leverageMin"] as! Int
            let maxNum:Int = content["leverageMax"] as! Int
            if minNum > maxNum {
                XJHProgressHUD.hide()
                BaseAlertController.showAlertOneAction(message: "最小杠杆倍数,不能大于最大倍数值", vc: xjh_getTopVC()!) {
                }
                return
            }
            
            
            var value = content
            //如果是创建的 需要将密码md5
            if type == .create {
                value.append(md5Detail(mdString: value["passWord"] as! String) , forKey: "passWord")
            }
            
            //获取到的数据结构的字典
            //字典转jsonstring
            jsonStr = getJSONStringFromDictionary(value) ?? ""
            if jsonStr.count < 1{
                XJHProgressHUD.showError(message: "数据转化失败，检查内容")
                return
            }
        }
        
        /////------------------准备请求
        //默认 更新
        var params = ["message": "update from INSOMNIA",
                      "content": jsonStr.base64Encoded,
                      "sha": sha]
        //
        var urlStr = GitHubBaseUrl + path
        //删除没有内容
        if type == .delete {
            
            params = ["message": "delete a file",
                      "sha": sha]
            
        }else if type == .create {
            
            params = ["message": "commit from INSOMNIA",
                      "content": jsonStr.base64Encoded]
            urlStr = XJH_GitInfoGet(userName: path)
        }
        
        XJHRequestManager.requestDocumentHeader(type==GithubType.delete ? HTTPMethod.delete : HTTPMethod.put,url: urlStr, params: params as [String : Any], headers: ["Authorization":"token " + GitHUb_less_Token], success: { (data) in
            XJHProgressHUD.hide()
            if let dict = data as? Dictionary<String,Any> {
                
                let errorModel = XJH_GithubErrorModel.deserialize(from: dict)
                if errorModel!.message.count > 0 {
                    //返回错误。停止运行
                    blockError(XJHError(code: 401, message: errorModel!.message))
                    
                    return
                }
                
                if dict.keys.contains("commit"){
                    
                    blockSuccess()
                    return
                }
            }
            print(data)
            blockError(XJHError(code: 401, message: "提交失败，请重试"))
            
        }) { (err) in
            XJHProgressHUD.hide()
            blockError(XJHError(code: 401, message: err.message))
        }
    }
    
    
    //    文件处理----管理员------更新文件 PUT、删除文件 Delete
    class func Github_UpdateAdminFileWith(_ type: GithubType, sha:String = "",content:Dictionary<String,Any>,path:String = "",blockSuccess:@escaping()->(),blockError:@escaping(_ error : XJHError)->()) {
        //获取到的数据结构的字典
        //字典转jsonstring
        let jsonStr = getJSONStringFromDictionary(content) ?? ""
        
        if jsonStr.count < 1{
            XJHProgressHUD.showError(message: "数据转化失败，检查内容")
            return
        }
        /////------------------准备请求
        //默认 更新
        var params = ["message": "update from INSOMNIA",
                      "content": jsonStr.base64Encoded,
                      "sha": sha]
        //
        var urlStr = GitHubBaseUrl + path
        //删除没有内容
        if type == .delete {
            
            params = ["message": "delete a file",
                      "sha": sha]
            
        }else if type == .create {
            
            params = ["message": "commit from INSOMNIA",
                      "content": jsonStr.base64Encoded]
            urlStr = XJH_GitInfoGet(userName: path)
        }
        
        XJHRequestManager.requestDocumentHeader(type==GithubType.delete ? HTTPMethod.delete : HTTPMethod.put,url: urlStr, params: params as [String : Any], headers: ["Authorization":"token " + GitHUb_less_Token], success: { (data) in
            XJHProgressHUD.hide()
            if let dict = data as? Dictionary<String,Any> {
                
                let errorModel = XJH_GithubErrorModel.deserialize(from: dict)
                if errorModel!.message.count > 0 {
                    //返回错误。停止运行
                    blockError(XJHError(code: 401, message: errorModel!.message))
                    
                    return
                }
                
                if dict.keys.contains("commit"){
                    blockSuccess()
                    
                    return
                }
            }
            print(data)
            
            blockError(XJHError(code: 401, message: "提交失败，请重试"))
            
        }) { (err) in
            XJHProgressHUD.hide()
            blockError(XJHError(code: 401, message: err.message))
        }
    }
    
    
    
    // 请求------更新文件 PUT、删除文件 Delete
    
    
    
}
