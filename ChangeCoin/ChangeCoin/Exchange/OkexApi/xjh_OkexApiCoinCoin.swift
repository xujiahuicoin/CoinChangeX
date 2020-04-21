//
//  xjh_OkexApiCoinCoin.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//
///-----------------  币币Api
import UIKit

class xjh_OkexApiCoinCoin: NSObject {
    
  
    ///委托策略---多个撤单
    class func okex_CoinCoinCancel_StraregyOrder(instrument_id:String,order_type:Okex_StrategyOrderType,algo_ids:[String], blockSuccess:@escaping (_ orderMod : XJH_OkexfuturesStrategyModel)->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        let param : Dictionary<String,Any> = [
            "order_type":order_type.rawValue,
            "instrument_id":instrument_id,
            "algo_ids":algo_ids]as [String : Any]
        
        //getJSONStringFromDictionary(param)
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: false, requestPath: okex_coinCancelStraregyOrder_Post, body: getJSONStringFromDictionary(param)!)
        
        
        XJHRequestManager.requestHeader(.post, url: okex_Current_APi + okex_coinCancelStraregyOrder_Post, params: param, headers: header, success: { (info) in
            
            if let dict: Dictionary<String,Any> = info as? Dictionary<String, Any> {
                let mod = XJH_OkexfuturesStrategyModel.deserialize(from: dict)!
                
                if mod.result {
                    blockSuccess(mod)
                    return
                }else if mod.algo_id == "-1"{
                    blaockError(XJHError(code: 401,message: mod.error_message))
                    return
                }
                
            }
            blaockError(XJHError(code: 401))
            
            
        }) { (err) in
            blaockError(err)
        }
        
    }
    ///获取策略委托订单列表
    class  func okex_coinCoinStraregyOrderList(instrument_id:String,order_type:Okex_StrategyOrderType,status:ok_futuresOrderStatus, blockSuccess:@escaping (_ mods : [XJH_Okex_CoinCoinOrdersModel])->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        let urlStr = okex_coinStraregyOrderList_Get(instrument_id: instrument_id, order_type: order_type, status:status.rawValue)
        
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: true, requestPath: urlStr)
        
        
        XJHRequestManager.requestHeader(.get, url: okex_Current_APi + urlStr, params: nil, headers: header, success: { (info) in
            
            if let dict: Dictionary<String,Any> = info as? Dictionary<String,Any> {
                
                let keys = dict.keys
                
                for key in keys{
                    
                    if let arr:Array<Any> = dict[key] as? Array<Any>{
                        
                        let mods = [XJH_Okex_CoinCoinOrdersModel].deserialize(from: arr)!
                        
                        blockSuccess(mods as! [XJH_Okex_CoinCoinOrdersModel])
                        return
                    }
                    
                    
                    
                }
                
                
            }
            
            blaockError(XJHError(code: 401))
            
        }) { (err) in
            blaockError(err)
        }
        
        
        
    }
    
    ///委托策略下单--止盈止损
    /// - Parameter instrument_id: coin
    /// - Parameter sideBuy: 是不是买
    /// - Parameter size: 数量-张
    /// - Parameter trigger_price: 触发价格
    /// - Parameter algo_price: 委托价格
    /// - Parameter blockSuccess: 成功
    /// - Parameter blaockError: 失败
    class func okex_CoinCoinStrategyOrders(order_type:Okex_StrategyOrderType,instrument_id:String,sideBuy:Bool,size: String, trigger_price:String,algo_price: String, blockSuccess:@escaping (_ orderMod : XJH_OkexCoinCoinStrategyModel)->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        let param : Dictionary<String,Any> = [
            "instrument_id":instrument_id,
            "mode":"1",
            "side":sideBuy ? "buy" : "sell",
            "size":size,
            "order_type":order_type.rawValue,
            "trigger_price":trigger_price,
            "algo_price":algo_price]
            as [String : Any]
        
        //getJSONStringFromDictionary(param)
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: false, requestPath: okex_strategyOrderAlgo_Post, body: getJSONStringFromDictionary(param)!)
        
        XJHRequestManager.requestHeader(.post, url: okex_Current_APi + okex_strategyOrderAlgo_Post, params: param, headers: header, success: { (info) in
            
            if let dict: Dictionary<String,Any> = info as? Dictionary<String, Any> {
                let mod = XJH_OkexCoinCoinStrategyModel.deserialize(from: dict)!
                
                if mod.result {
                    blockSuccess(mod)
                    return
                }else if mod.algo_id == "-1"{
                    blaockError(XJHError(code: 401,message: "下单失败了，-1"))
                    return
                }
                
            }
            blaockError(XJHError(code: 401))
            
            
        }) { (err) in
            blaockError(err)
        }
        
        
        
    }
    ///批量撤销订单okex_coinCoinCancel_MoreOrders_Post
      class func okex_CoinCoinCancel_MoreOrder(instrument_id:String,order_ids:Array<String>, blockSuccess:@escaping (_ orderMod : XJH_Okex_CancelOrderModel)->(), blaockError : @escaping (_ errcod:XJHError)->())  {
             
             let param : Dictionary<String,Any> = [ "order_ids":order_ids]
             
             let url = okex_coinCoinCancel_MoreOrders_Post(instrument_id: instrument_id)
             let header = XJH_OkExTool().okex_GetOK_Header(getBool: false, requestPath: url, body: getJSONStringFromDictionary(param)!)
             
             
             XJHRequestManager.requestHeader(.post, url: okex_Current_APi + url, params: param, headers: header, success: { (info) in
                 
                 if let dict: Dictionary<String,Any> = info as? Dictionary<String, Any> {
                     let mod = XJH_Okex_CancelOrderModel.deserialize(from: dict)!
                     
                     if mod.result {
                         blockSuccess(mod)
                         return
                     }else{
                         blaockError(XJHError(code: 401,message: mod.error_message))
                         return
                     }
                     
                 }
                 blaockError(XJHError(code: 401))
                 
                 
             }) { (err) in
                 blaockError(err)
             }
             
         }
    ///撤销指定订单 POST /api/spot/v3/cancel_orders/<order_id> or <client_oid>
    class func okex_CoinCoinCancel_Order(order_id:String = "", instrument_id: String = "", blockSuccess:@escaping (_ orderMod : XJH_Okex_CancelOrderModel)->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        
        let param : Dictionary<String,Any> = [
            "instrument_id":instrument_id]
            as [String : Any]
        
        //getJSONStringFromDictionary(param)
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: false, requestPath: okex_coinCoinCancel_Orders_Post(order_id: order_id), body: getJSONStringFromDictionary(param)!)
        
        
        XJHRequestManager.requestHeader(.post, url: okex_Current_APi + okex_coinCoinCancel_Orders_Post(order_id: order_id), params: param, headers: header, success: { (info) in
            
            if let dict: Dictionary<String,Any> = info as? Dictionary<String, Any> {
                let mod = XJH_Okex_CancelOrderModel.deserialize(from: dict)
                
                if ((mod?.order_id) == nil) {
                    blaockError(XJHError(code: 401, message: dict["message"] as! String))
                    return
                }
                blockSuccess(mod!)
            }else{
                blaockError(XJHError(code: 401))
            }
            
        }) { (err) in
            blaockError(err)
        }
        
        
        
    }
    
    ///获取订单列表---选择订单类型- - okex_orders_Get
    class func okex_CoinCoinGetOrders_Get(state: Okex_OrderState,instrument_id: String, after: String="", before: String="", limit: String, blockSuccess:@escaping (_ orderMod : [XJH_Okex_CoinCoinOrdersModel])->(), blackError : @escaping (_ errcod:XJHError)->())  {
        
        let path = okex_orders_Get + "?instrument_id=" + instrument_id + "&state=" + state.rawValue + "&limit=" + limit  + ((before != "") ? ("&before=" + before) : "") + ((after != "") ? ("&after=" + after) : "")
        
        let urlStr = okex_Current_APi + path
        
        let header = XJH_OkExTool().okex_GetOK_Header( requestPath: path)
        
        //XJH_Okex_CoinCoinOrdersModel
        XJHRequestManager.requestHeader(url: urlStr, params: nil, headers: header, success: { (info) in
            
            if let array = info as? Array<Any> {
                let modarr  = ([XJH_Okex_CoinCoinOrdersModel].deserialize(from: array) ?? nil)
                
                if modarr != nil {
                    
                    blockSuccess(modarr! as! [XJH_Okex_CoinCoinOrdersModel])
                    return
                }else if let dict = info as? Dictionary<String,Any>{
                    
                    blackError(XJHError(code: 401, message: dict["message"] as! String))
                    return
                }
                
                
            }
            
            blackError(XJHError(code: 401))
            
        }) { (err) in
            blackError(err)
        }
        
        
        
    }
    
    ///获取单个币种的所有未成交订单--撤销-等待
    class func okex_CoinCoinGetOrderPending_Get(instrument_id: String, after: String="", before: String="", limit: String, blockSuccess:@escaping (_ orderMod : [XJH_Okex_CoinCoinOrdersModel])->(), blackError : @escaping (_ errcod:XJHError)->())  {
        
        let path = okex_orders_pending_Get + "?limit=" + limit + "&instrument_id=" + instrument_id + ((before == "") ? ("&before=" + before) : "") + ((after == "") ? ("&after=" + after) : "")
        let urlStr = okex_Current_APi + path
        
        let header = XJH_OkExTool().okex_GetOK_Header( requestPath: path)
        
        //XJH_Okex_CoinCoinOrdersModel
        XJHRequestManager.requestHeader(url: urlStr, params: nil, headers: header, success: { (info) in
            
            if let array = info as? Array<Any> {
                let modarr  = ([XJH_Okex_CoinCoinOrdersModel].deserialize(from: array) ?? nil)
                
                if modarr != nil {
                    
                    blockSuccess(modarr! as! [XJH_Okex_CoinCoinOrdersModel])
                    
                }else if let dict = info as? Dictionary<String,Any>{
                    
                    blackError(XJHError(code: 401, message: dict["message"] as! String))
                    
                }
                
                blackError(XJHError(code: 401))
            }
        }) { (err) in
            blackError(err)
        }
        
    }
    //下单 bibi
    /// 下单------OKEx币币交易提供限价单和市价单和高级限价单下单模式
    /// - Parameter type_limit: limit默认，market（市价）下单
    /// - Parameter price: 限价单 价格
    /// - Parameter size: 买入卖出数量，市价卖出时必填size
    /// - Parameter notional: 市价买入时必填notional
    /// - Parameter side_buy: buy 或 sell
    /// - Parameter instrument_id: 币对名称
    /// - Parameter order_type: 参数填数字0：普通委托（order type不填或填0都是普通委托）1：只做Maker（Post only）2：全部成交或立即取消（FOK）3：立即成交并取消剩余（IOC）
    /// - Parameter blockSuccess: 成功返回
    /// - Parameter blaocError: 错误返回
    class func okex_CoinCoinOrders(type_limit:Bool = true, price:String = "0", size: String = "0", market_notional : String = "0", side_buy:Bool = true,instrument_id:String,order_type:Okex_CoinCoin_orderType,margin_trading: Okex_CoinCoin_margin_trading = .coincoin, blockSuccess:@escaping (_ orderMod : XJH_Okex_CoinCoinOrderReturnModel)->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        let param : Dictionary<String,Any> = [
            "type":(type_limit ? "limit" : "market"),
            "side":(side_buy ? "buy" : "sell"),
            "instrument_id":instrument_id,
            "size":size,
            "client_oid":okex_setOrdersID_CoinCoin(),
            "price":price,
            //            "notional":market_notional,
            "margin_trading":margin_trading.rawValue,
            "order_type":order_type.rawValue]
            as [String : Any]
        
        //getJSONStringFromDictionary(param)
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: false, requestPath: okex_coinCoinOrders_POST, body: getJSONStringFromDictionary(param)!)
        
        
        XJHRequestManager.requestHeader(.post, url: okex_Current_APi + okex_coinCoinOrders_POST, params: param, headers: header, success: { (info) in
            
            if let dict: Dictionary<String,Any> = info as? Dictionary<String, Any> {
                let mod = XJH_Okex_CoinCoinOrderReturnModel.deserialize(from: dict)!
                if (mod.order_id == "-1") {
                    blaockError(XJHError(code: Int(mod.error_code!)!, message: mod.error_message as! String))
                    return
                }
                blockSuccess(mod)
            }else{
                blaockError(XJHError(code: 401))
            }
            
        }) { (err) in
            blaockError(err)
        }
        
        
        
    }
    
    //    公共-获取某个ticker信息  限速规则：20次/2s okex_coinCoin_Get
    class func okex_Pub_GerInstrumentsTicker(currencyName:String,blockSuccess: @escaping (_ coiinModel : XJH_Okex_CoinCoinModel) ->(), blaocError : @escaping (_ errcod:XJHError)->())  {
        
        XJHRequestManager.request(url: okex_coinCoinInfo_Get(currencyPair: currencyName), params: nil, success: { (info) in
            
            if let dict = info as? Dictionary<String,Any> {
                
                let mod = XJH_Okex_CoinCoinModel.deserialize(from: dict)
                
                blockSuccess(mod!)
                
            }else {
                blaocError(XJHError(code: 401))
            }
            
        }) { (err) in
            blaocError(err)
        }
        
        
    }
    
    ///公共-获取深度数据 20次/2s
    class func okex_Pub_GerInstrumentsDepthData(currencyName:String,blockSuccess: @escaping (_ dataDict: Dictionary<String,Any>) ->(), blaocError : @escaping (_ errcod:XJHError)->())  {
        
        XJHRequestManager.request(url: okex_coinCoinDepth_Get(currencyPair: currencyName), params: nil, success: { (info) in
            
            if let dict = info as? Dictionary<String,Any> {
                
                if dict.keys.contains("asks") {
                    
                    blockSuccess(dict)
                    
                    return
                }
            }
            blaocError(XJHError(code: 401))
            
        }) { (err) in
            blaocError(err)
        }
        
    }
    
}
