//
//  XJH_BaiduTool.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_BaiduTranslationModel : XJHBaseModel {
    var from : String = "" ///    TEXT    翻译源语言    返回用户指定的语言，或自动检测的语言（源语言设为auto时）
    var to : String = "" ///    TEXT    译文语言    返回用户指定的目标语言
    var trans_result: Array<Any> = []//   MIXED LIST    翻译结果    返回翻译结果，包含src 和 dst 字段。
    var error_code : Int = 0 ///    Int32    错误码    仅当出现错误时显示
}

class XJH_Baidutrans_result : XJHBaseModel{
    
    var src : String = ""
    var dst : String = ""
}


class XJH_BaiduTool: NSObject {
    
    ///百度翻译
    ///q    TEXT    Y    请求翻译query    UTF-8编码
    ///from    TEXT    Y    翻译源语言    语言列表(可设置为auto)
    ///to    TEXT    Y    译文语言    语言列表(不可设置为auto)
    ///appid    TEXT    Y    APP ID    可在管理控制台查看
    ///salt    TEXT    Y    随机数
    ///sign    TEXT    Y    签名    appid+q+salt+密钥 的MD5值
    func XJH_BaiduTranslation(q:String, from:String = "en", to:String = "zh",blockSuccess:@escaping (_ model:XJH_Baidutrans_result)->(),blockError:@escaping (_ err:XJHError)->() ){
        
        let salt = "\(Date().timeStamp)"
        let sign = md5Detail(mdString: Baidu_APPID + q + salt + Baidu_pass)
        
        let getUrl = "http://api.fanyi.baidu.com/api/trans/vip/translate?" +
            "q=" + q.urlEncoded +
            "&from=" + from + "&to=" + to +
            "&appid=" + Baidu_APPID +
            "&salt=" + salt +
            "&sign=" + sign
        
        XJHRequestManager.request(.get, url: getUrl, params: nil, success: { (info) in
            
            if let dict:[String:Any] = info as? Dictionary<String, Any> {
                
                let mod:XJH_BaiduTranslationModel = XJH_BaiduTranslationModel.deserialize(from: dict)!
                
                if mod.trans_result.count > 0 {
                   
                    if let dic:[String:Any] = mod.trans_result[0] as? Dictionary<String, Any> {
                        let mods = XJH_Baidutrans_result.deserialize(from: dic)
                        
//                        blockSuccess(mods!)
                    }
                }
                
            }else{
//                blockError(XJHError(code: 401))
            }
            
        }) { (err) in
//            blockError(err)
        }
        
    }
    
    
}
