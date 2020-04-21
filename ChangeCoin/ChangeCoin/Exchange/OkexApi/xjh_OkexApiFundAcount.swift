//
//  xjh_OkexApiFundAcount.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

///-----------------  资金账户
import UIKit

class xjh_OkexApiFundAcount: NSObject {
    
    ///账户资产估计
    /// - Parameters:
    ///   - Account_type: 账户选择：全部、币币、合约
    ///   - valuation_currency: 基础货币：btc、usd、cny
    class func okex_getAccountWalletAssetValuation(loadIntIndex:Int = okex_header_number,blockSuccess:@escaping(_ model : XJHAccountValuationModel)->(), blockError: @escaping(_ errCode:XJHError) ->() ) {
        
        let url:String = okex_AccountWallet(account_type: (Okex_WalletAccount_type(rawValue: "0")?.nameStringToAccount_type(nameStr: XJHSetingShareModel.shareModel.currentWallet))!.rawValue, valuation_currency: XJHSetingShareModel.shareModel.baseCurrency)
        
        let header = XJH_OkExTool().okex_GetOK_Header(header_num:loadIntIndex, requestPath: url)
        
        XJHRequestManager.requestHeader(.get, url: okex_Current_APi + url, params: nil, headers: header, success: { (data) in
            
            if let dict = data as? Dictionary<String, Any>{
               
                 let mod = XJHAccountValuationModel.deserialize(from: dict)
                
                blockSuccess(mod!)
                
            }else{
             blockError(XJHError(code: 401))
                
            }
    
        }) { (err) in
            
            blockError(err)
        }
        
        
    }
    
    
    //---------------Futures---------------------
    ///所有币种合约账户信息 GET 。
    class func okex_getFuturesAccountWallet(loadIntIndex:Int = okex_header_number,blockSuccess: @escaping (_ mods:[XJH_OkexFuturesAllBlanceModel]) ->(), blockError: @escaping(_ errCode:XJHError) ->() ){
        
        let header = XJH_OkExTool().okex_GetOK_Header(header_num:loadIntIndex,requestPath: okex_FuturesAccountWallet_GET)
        
        XJHRequestManager.requestHeader(.get, url: okex_Current_APi + okex_FuturesAccountWallet_GET, params: nil, headers: header, success: { (data) in
            
            if let dict = data as? Dictionary<String, Any>{
                if let dic = dict["info"] as? Dictionary<String, Any>{
                    var mods:[XJH_OkexFuturesAllBlanceModel] = []
                    
                    for key in dic.keys {
                        if let di = dic[key] as? Dictionary<String, Any>{
                            let mod = XJH_OkexFuturesAllBlanceModel.deserialize(from: di)
                            mods.append(mod!)
                        }
                    }
                    
                    blockSuccess(mods as! [XJH_OkexFuturesAllBlanceModel])
                }
                
            }else{
                
                blockError(XJHError(code: 401))
                
            }
            
            
        }) { (err) in
            
            blockError(err)
        }
    }
    
    ///获取单个资产信息
    class func okex_getFuturesAccountSingleWallet(loadIntIndex:Int = okex_header_number,currencyPair: String ,blockSuccess: @escaping (_ mods : XJH_OkexFuturesSingleWallte) ->(), blockError: @escaping(_ errCode:XJHError) ->() ){
        
        ///currencyPair.replacingOccurrences(of: "USDT", with: "USD") usdt 会有虚拟资产。所以用usd
        
        let HalfUrl = okex_FuturesSingleAccounts(instrument_id: currencyPair)
        
        let header = XJH_OkExTool().okex_GetOK_Header(header_num:loadIntIndex,requestPath:HalfUrl)
        
        
        XJHRequestManager.requestHeader(.get, url: okex_Current_APi + HalfUrl, params: nil, headers: header, success: { (data) in
            
            print("----当前资产--\(data)")
            
            if let dict = data as? Dictionary<String, Any>{
                
                let mod :XJH_OkexFuturesSingleWallte = XJH_OkexFuturesSingleWallte.deserialize(from: dict)!
                blockSuccess(mod)
                return
            }
            blockError(XJHError(code: 401))
            
            
        }) { (err) in
            
            blockError(err)
        }
        
    }
    
    //---------------coinCOin---------------------
    //获取单个资产信息
    class func okex_getAccountSingleWallet(loadIntIndex:Int = okex_header_number,currencyPair: String ,blockSuccess: @escaping (_ mods : CJH_Okex_COinAccountsSingleModel) ->(), blockError: @escaping(_ errCode:XJHError) ->() ){
        
        let header = XJH_OkExTool().okex_GetOK_Header(header_num:loadIntIndex, requestPath: okex_accountSingleWallet_GET(currencyPair: currencyPair))
        
        
        XJHRequestManager.requestHeader(.get, url: okex_Current_APi + okex_accountSingleWallet_GET(currencyPair: currencyPair), params: nil, headers: header, success: { (data) in
            
            if let dict = data as? Dictionary<String, Any>{
                
                let errMod :CJH_Okex_COinAccountsSingleModel = CJH_Okex_COinAccountsSingleModel.deserialize(from: dict)!
                blockSuccess(errMod)
                
            }else{
                blockError(XJHError(code: 401))
            }
            
            
        }) { (err) in
            
            blockError(err)
        }
        
    }
    /*
     如果传入有效的API key 用user id限速；如果没有则拿公网IP限速。
     限速规则：各个接口上有单独的说明，如果没有一般接口限速为 6次/秒。
     特殊说明：批量下单时，若下4个币对，每个币对10个订单时，计为一次请求
     */
    ///账户所有持有币种信息资金
    class func okex_getAccountWallet(loadIntIndex:Int = okex_header_number,blockSuccess: @escaping (_ mods:[xjh_Okex_FundAcountModel]) ->(), blockError: @escaping(_ errCode:XJHError) ->() ){
        
        let header = XJH_OkExTool().okex_GetOK_Header(header_num:loadIntIndex, requestPath: okex_accountWallet_GET)
        
        XJHRequestManager.requestHeader(.get, url: okex_Current_APi + okex_accountWallet_GET, params: nil, headers: header, success: { (data) in
            
            if let dict = data as? Dictionary<String, Any>{
                
                
                let errMod :xjh_Okex_ErrorModel = xjh_Okex_ErrorModel.deserialize(from: dict)!
                blockError(XJHError(code: errMod.code, message: errMod.message))
                
            }else if let array =  data as? Array<Any> {
                
                let mods = [xjh_Okex_FundAcountModel].deserialize(from: array)
                
                blockSuccess(mods! as! [xjh_Okex_FundAcountModel])
                
            }else{
                
                blockError(XJHError(code: 401))
                
            }
            
            
        }) { (err) in
            
            blockError(err)
        }
    }
    
}
