//
//  RequestManager.swift
//  Project
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019 hhl. All rights reserved.
//

import Foundation
import Alamofire

// 请求方式
enum XJHMethodType : String {
    
    case get = "get"
    case post = "post"
}

class XJHRequestManager {
    
    //设置请求超时 时间
    static var timeoutManager: Alamofire.SessionManager = {
        //修改属性的值
        let config = URLSessionConfiguration.default
        //设置请求超时时间
        config.timeoutIntervalForRequest = 10
        return Alamofire.SessionManager(configuration: config)
    }()
    
    
    /// 网络请求 无Header
    ///
    /// - Parameters:
    ///   - type: 请求类型 get/post
    ///   - url: 链接
    ///   - params: 参数
    ///   - success: 成功回调
    ///   - failure: 失败回调
    class func request(_ type : XJHMethodType = .get, url : String, params : [String : Any]?, success : @escaping(_ data : Any) ->(), failure : @escaping (_ error : XJHError) ->()){
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        self.timeoutManager.request(url, method: method, parameters: params).responseJSON(completionHandler: { (response) in
            
            if let json = response.result.value {
                
                //                print("返回数据：\(json)")
                
                let resData:structDataIsError =  Okex_DataIsErrorModel(json: json)
                
                if resData.errorBool {
                    
                    let errMessage = type.rawValue + url + resData.error_xjh.message
                    //----获取翻译
                    XJH_BaiduTool().XJH_BaiduTranslation(q: resData.error_xjh.message, blockSuccess: { (mod) in
                        
                        if self.xjh_showCodeMessage(code: resData.error_xjh.code, message: mod.dst) {
                            
                             failure(XJHError(code: resData.error_xjh.code, message: "\(resData.error_xjh.code)" + mod.dst))
                        }
                        
                    }) { (err) in
                        failure(XJHError(code: resData.error_xjh.code, message:errMessage))
                        
                    }
                    //------------------------------------
                    
                    print("=-=\(errMessage)")
                }else{
                    
                    success(json)
                }
                
                
                
                
            }else {
                
                if let httpResponse = response.response {
                    
                    failure(XJHError(code: httpResponse.statusCode, message: "不在状态啦..."))
                    
                }else {
                    
                    failure(XJHError(code: -1004, message: "网络出现了问题，轻触重试"))
                    
                }
                
            }
        })
    }
    
    
    
    ///有Header的请求
    class func requestHeader(_ type : XJHMethodType = .get, url : String, params : [String : Any]?,headers:[String:Any], success : @escaping(_ data : Any) ->(), failure : @escaping (_ error : XJHError) ->()){
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        self.timeoutManager.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers:(headers as! HTTPHeaders)).responseJSON(completionHandler: { (response) in
            
            if let json = response.result.value {
                
                let resData:structDataIsError =  Okex_DataIsErrorModel(json: json)
                
                if resData.errorBool {
                    
                    let errMessage = type.rawValue + "--\(url)--" + resData.error_xjh.message + "\(resData.error_xjh.code)"
                    
                    //----获取翻译
                    XJH_BaiduTool().XJH_BaiduTranslation(q: resData.error_xjh.message, blockSuccess: { (mod) in
                        
                        if self.xjh_showCodeMessage(code: resData.error_xjh.code, message: mod.dst) {
                           
                            failure(XJHError(code: resData.error_xjh.code, message: "\(resData.error_xjh.code)" + mod.dst))
                        }
                        
                    }) { (err) in
                        failure(XJHError(code: resData.error_xjh.code, message:errMessage))
                        XJHProgressHUD.showError(message: "\(resData.error_xjh.code)" + errMessage)
                    }
                    //------------------------------------
                    
                    print("=-=\(errMessage)---\(params)")
                     failure(XJHError(code: 401, message: "请求失败..."))
                    return
                }else{
                    
                    success(json)
                }
            }else {
                
                if let httpResponse = response.response {
                    
                    failure(XJHError(code: httpResponse.statusCode, message: "不在状态啦..."))
                    
                }else {
                    
                    failure(XJHError(code: -1004, message: "网络出现了问题，轻触重试"))
                    
                }
                
            }
        })
    }
    
    ///有Header的其他请求
    class func requestDocumentHeader(_ type:HTTPMethod, url : String, params : [String : Any]?,headers:[String:Any], success : @escaping(_ data : Any) ->(), failure : @escaping (_ error : XJHError) ->()){
        
        self.timeoutManager.request(url, method: type, parameters: params, encoding: JSONEncoding.default, headers:(headers as! HTTPHeaders)).responseJSON(completionHandler: { (response) in
            
            if let json = response.result.value {
                
                let resData:structDataIsError =  Okex_DataIsErrorModel(json: json)
                
                if resData.errorBool {
                    
                    let errMessage = "put" + "--\(url)--" + resData.error_xjh.message + "\(resData.error_xjh.code)"
                    
                    //----获取翻译
                    XJH_BaiduTool().XJH_BaiduTranslation(q: resData.error_xjh.message, blockSuccess: { (mod) in
                        
                        if self.xjh_showCodeMessage(code: resData.error_xjh.code, message: mod.dst) {
                           
                            failure(XJHError(code: resData.error_xjh.code, message: "\(resData.error_xjh.code)" + mod.dst))
                        }
                        
                    }) { (err) in
                        failure(XJHError(code: resData.error_xjh.code, message:errMessage))
                        XJHProgressHUD.showError(message: "\(resData.error_xjh.code)" + errMessage)
                    }
                    //------------------------------------
                    
                    print("=-=\(errMessage)---\(params)")
                    return
                }else{
                    
                    success(json)
                }
            }else {
                
                if let httpResponse = response.response {
                    
                    failure(XJHError(code: httpResponse.statusCode, message: "不在状态啦..."))
                    
                }else {
                    
                    failure(XJHError(code: -1004, message: "网络出现了问题，轻触重试"))
                    
                }
                
            }
        })
    }
    
    ///全局展示  返回值,bool == yes : 可以返回错误信息
    class func xjh_showCodeMessage(code:Int, message:String) -> Bool{
        
        //30008时间戳过期
        //30003 需要时间戳
        //32040 期货-用户当前有该币种持仓
        
        if code != 30003 && code != 30008 && code != 32040 {
            XJHProgressHUD.showSuccess(message: "代码：\(code)\n" + message)
            
            return true
        }
        
        return false
    }
}
