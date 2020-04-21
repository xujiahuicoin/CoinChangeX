//
//  XJH_SetSignatureTool.swift
//  CoinChange
//
//  Created by xujiahui on 2019/11/4.
//  Copyright © 2019 www.xujiahuiCoin.cn. All rights reserved.
//

import UIKit


let okex_futures_key = "okex_futures"
///okex 密钥
let okex_keyPairString = "okex_keyPairString"
///给出多仓数量判断 是平多空
func okex_getFuturesCutLongOrShor(long_qty:String)-> ok_FuturesOpenOrderType {
    
    let longqty: Double = Double(long_qty) ?? 0
    
    if longqty > 0 {
        //多仓 平多
        return ok_FuturesOpenOrderType.stopLong
    }
    return ok_FuturesOpenOrderType.stopShort
}

///给出全仓 mod 返回持仓数量
func okex_getFuturesCutAccount(mod:XJH_OkexfuturesPositionModel_1)-> String {
    
    let longqty: Double = Double(mod.long_qty) ?? 0
    
    if longqty > 0 {
        //多仓 平多
        return mod.long_qty
    }
    return mod.short_qty
}

///如BTC-USD-180213  返回 BTC 或者BTC-USD
/// - Parameter instrument_id: BTC-USD-180213
/// - Parameter typeName: true:BTC   false:BTC-USD
func okex_instrument_idGetFuturesNameStype(instrument_id: String,typeName:Bool) -> String{
    
    let arr:Array<String> = instrument_id.components(separatedBy: "-")
    
    if arr.count != 3{
        return ""
    }
    
    if typeName{
        return arr[0]
    }
    
    return arr[0] + "-" + arr[1]
    
    
}

///设置CoinCOin的订单ID来识别您的订单  1--32 位字符
///bibi 订单ID
func okex_setOrdersID_CoinCoin()->String {
    return  XJH_UserModel.sharedInstance.userName + "\(Date().milliStamp)"
}
///Futures
func okex_setOrdersID_Futures()->String {
    return  XJH_UserModel.sharedInstance.userName + "\(Date().milliStamp)"
}


///根据比较获得实际平仓数量
///由于张数 只能是整数，当平仓与可平仓差距小于2也就是等于1 的时候，将平仓所有可平仓位
/// - Parameter price: 价格
/// - Parameter numCoin: bi数量
/// - Parameter futuresName: 名字
/// - Parameter positionModel_1: model数据
/// - Parameter match_price: 市价与否
/// - Parameter type: 多空
func Okex_futuresActualCloseableAccount(price:String,numCoin:String,futuresName:String,positionModel_1:XJH_OkexfuturesPositionModel_1,match_price: ok_futuresMatch_price,type:ok_FuturesOpenOrderType)->String{
    
    let Sheet = Okex_FuturesCoinNumToSheet(price: price, numCoin: numCoin, futuresName: futuresName)
    //多空判断
    if type == .stopLong
    {
        
        //价格/市价
        if match_price == .fastPrice || (Int(Sheet)! - Int(positionModel_1.long_avail_qty)!) == -1
        {
            return positionModel_1.long_avail_qty
        }
        
    }else
    {
        //价格/市价
        if match_price == .fastPrice || (Int(Sheet)! - Int(positionModel_1.short_avail_qty)!) == -1
        {
            return positionModel_1.short_avail_qty
            
        }
    }
    
    return Sheet
}
///futures bi数 zhuan 张数
func Okex_FuturesCoinNumToSheet(price:String,numCoin:String,futuresName:String )->String{
    return Okex_FuturesNumberCoinAndSheetsMutualTransfer(sheetToNum: false, price: price, sheets: "", numCoin: numCoin, futuresName: futuresName)
}
///futures 张数 转 bi数
func Okex_FuturesSheetsToCoinNums(price:String,sheets:String,futuresName:String) -> String{
    
    return Okex_FuturesNumberCoinAndSheetsMutualTransfer(sheetToNum: true, price: price, sheets: sheets, numCoin: "", futuresName: futuresName)
}
///futures 张数 与bi数互转g
/// - Parameter sheetToNum: 张转个数 true
/// - Parameter price: 价格
/// - Parameter sheets: 张数
/// - Parameter numCoin: 个数
/// - Parameter isBTC: 是不是btc，默认 不是
func Okex_FuturesNumberCoinAndSheetsMutualTransfer(sheetToNum:Bool,price:String,sheets:String,numCoin:String ,futuresName:String)->String{
    
    //    1张btn = 100$    1张coin = 10$
    var lever = 10.0
    if futuresName.contains("BTC") {
        lever = 100.0
    }
    //返回数据
    var returnStr = 0.00
    
    if sheetToNum {
        //张数转个数 = 张数*单张美元数/单个价钱
        if price.count > 0 {
            returnStr = (Double(sheets) ?? 0) * lever/(Double(price) ?? 1)
            return xjh_AutoRoundToString(doubleDou: returnStr)
        }
        
    }
    //个数转张数 = 个数*单个价钱/单张价格
    returnStr = (Double(numCoin) ?? 0) * (Double(price) ?? 0)/lever
    //切割
    return "\(Int(returnStr) < 1 ? 1 : Int(returnStr))"
}

///错误信息返回
class Okex_CodeMessageModel :XJHBaseModel{
    var code : Int = 401
    var message : String = "请求错误"
}

///判断 返回数据是不是错误参数---返回Any 判断 是不是  ==Okex_CodeMessageModel
struct structDataIsError  {
    var errorBool : Bool
    var error_xjh : XJHError
}
func Okex_DataIsErrorModel(json:Any)-> structDataIsError{
    
    if let dict:[String:Any] = json as? Dictionary<String, Any> {
        
        if dict.keys.count == 2 && dict.keys.contains("message") && dict.keys.contains("code") {
            
            let mod = Okex_CodeMessageModel.deserialize(from: dict)
            return structDataIsError(errorBool: true, error_xjh: XJHError(code: mod!.code, message: mod!.message))
        }
        
    }
    
    return structDataIsError(errorBool: false, error_xjh: XJHError(code: 200))
    
}


class XJH_OkExTool: NSObject {
    
    //--------- OKEX ------- REST API------------------
    
    ///获取服务器时间进行对比
    func okex_getGeneralTime(blockSuccess: @escaping (_ timeStamp:String) ->(), blockError: @escaping(_ errCode:XJHError) ->() ){
        
        XJHRequestManager.request(url: okex_Current_APi+okex_serverTime_Get , params: nil, success: { (info) in
            
            if let dict:[String:Any] = (info as! Dictionary<String, Any>) {
                
                if dict.keys.contains("iso"){
                    
                    let iso: String = dict["iso"] as! String
                    
                    blockSuccess(iso)
                    return
                }
                
                
            }
            blockError(XJHError(code: 401))
            
        }) { (err) in
            
            blockError(err)
            
        }
        
    }
    
    ///--------------------okex 请求头制作
    /// 所有REST请求头都必须包含以下内容：
    /// - Parameter API_Key: 字符串类型的API Key
    /// - Parameter PASSPHRASE: 您在创建API密钥时指定的Passphrase
    /// - Parameter TIMESTAMP: 发起请求的时间戳。
    /// - Parameter getBool: 请求方法，字母全部大写：GET/POST
    /// - Parameter requestPath: 请求接口路径。例如：/orders?before=2&limit=3
    /// - Parameter body: 指请求主体的字符串，如果请求没有主体(通常为GET请求)则body可省略。例如：{"product_id":"BTC-USD-0309","order_id":"377454671037440"}
    /// - Parameter secretKey: secretKey为用户申请API Key时所生成
    func okex_GetOK_Header(header_num:Int = okex_header_number,API_Key: String = XJH_UserModel.sharedInstance.okex_apikey,PASSPHRASE: String = XJH_UserModel.sharedInstance.okex_PassPHRASE,getBool: Bool = true,requestPath: String,body: String = "",secretKey: String = XJH_UserModel.sharedInstance.okex_secretkey)-> Dictionary<String,Any>{
        
        let TIMESTAMP = okex_isoTime.count>0 ? okex_isoTime : okex_isoTime2
        //就是自己
        let headerDic : [String:Any]
        if header_num == okex_header_number {
            
            headerDic = ["OK-ACCESS-KEY":API_Key,
                         "OK-ACCESS-SIGN":self.okex_GetOK_ACCESS_SIGN(timestamp: TIMESTAMP, getBool: getBool, requestPath: requestPath, body: body, secretKey: secretKey),
                         "OK-ACCESS-TIMESTAMP":TIMESTAMP,
                         "OK-ACCESS-PASSPHRASE":PASSPHRASE]
            
        }else{
            
            let usermod:XJH_AdminUserModel =  XJH_UserModel.sharedInstance.adminUserModel[header_num]
            
            headerDic = ["OK-ACCESS-KEY":usermod.okex_apikey,
                         "OK-ACCESS-SIGN":self.okex_GetOK_ACCESS_SIGN(timestamp: TIMESTAMP, getBool: getBool, requestPath: requestPath, body: body, secretKey: usermod.okex_secretkey),
                         "OK-ACCESS-TIMESTAMP":TIMESTAMP,
                         "OK-ACCESS-PASSPHRASE":usermod.okex_PassPHRASE]
        }
        
        return headerDic
    }
    
    
    ///--------------------okex的签名制作
    ///OK-ACCESS-SIGN 请求头 SHA256加密 通过Base64编码
    /// - Parameter timestamp: 与OK-ACCESS-TIMESTAMP请求头相同
    /// - Parameter method: 请求方法，字母全部大写：GET/POST
    /// - Parameter requestPath: 请求接口路径。例如：/orders?before=2&limit=30
    /// - Parameter body: 指请求主体的字符串，如果请求没有主体(通常为GET请求)则body可省略。例如：{"product_id":"BTC-USD-0309","order_id":"377454671037440"}
    /// - Parameter secretKey: secretKey为用户申请API Key时所生成
    func okex_GetOK_ACCESS_SIGN(timestamp: String,getBool: Bool = true,requestPath: String,body: String = "",secretKey: String) -> String{
        
        let method: String = getBool ? "GET" : "POST"
        
        let addStr:String = timestamp + method + requestPath + body
        
        return HMAC_Sign(algorithm: .SHA256, keyString: secretKey, dataString: addStr)
    }
    
    
}

