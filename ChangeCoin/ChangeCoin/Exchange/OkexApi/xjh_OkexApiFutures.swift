//
//  xjh_OkexApiDeliveryContract.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//
///-----------------  交割合约
import UIKit



class xjh_OkexApiFutures: NSObject {
    
    ///获取订单信息。收益提交历史记录
    class func okex_futuresOrderDetails(intIndex:Int = okex_header_number,intinstrument_id:String, order_id:String, blockSuccess:@escaping (_ mod:XJH_OkexFuturesOrderDetailsModel)->(),blaockError:@escaping(_ errcod:XJHError)->()){
    
    let urlStr = okex_futuresOrderDetail_Get + "/" + intinstrument_id + "/" + order_id
    
    let header = XJH_OkExTool().okex_GetOK_Header(header_num:intIndex,getBool: true, requestPath: urlStr)
    
    XJHRequestManager.requestHeader(.get, url: okex_Current_APi + urlStr, params: nil, headers: header, success: { (info) in
    
        let model: XJH_OkexFuturesOrderDetailsModel = XJH_OkexFuturesOrderDetailsModel.deserialize(from: info as! Dictionary<String,Any>)!
        
    blockSuccess(model)
    
    }) { (err) in
    blaockError(err)
    }
    
    }
    /////所有合约持仓信息
    class  func okex_futuresStraregyOrderList(intIndex:Int = okex_header_number,blockSuccess:@escaping (_ mods : [XJH_OkexfuturesPositionModel_1])->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        let header = XJH_OkExTool().okex_GetOK_Header(header_num:intIndex,getBool: true, requestPath: okex_futuresAllOrder_Get)
        
        XJHRequestManager.requestHeader(.get, url: okex_Current_APi + okex_futuresAllOrder_Get, params: nil, headers: header, success: { (info) in
            print(info)
            let result: XJH_OkexFuturesAllOrderModel = XJH_OkexFuturesAllOrderModel.deserialize(from: info as? Dictionary<String,Any> ?? ["":""])!
            
            if result.holding.count > 0 {
                
                let mods = [XJH_OkexfuturesPositionModel_1].deserialize(from: result.holding[0] ?? [])!
                blockSuccess(mods as! [XJH_OkexfuturesPositionModel_1])
                return
            }
            
            blaockError(XJHError(code: 401))
            
        }) { (err) in
            blaockError(err)
        }
        
        
        
    }
    ///撤销所有平仓挂单--撤销所有 为成交平仓 委托POST {"instrument_id":"BTC-USD-180213","direction":"long"}
    class func okex_futuresCutAllPendingOrder( instrument_id:String,direction:ok_FuturesType, blockSuccess:@escaping (_ Mod : XJH_OkexFuturesCutAllPendingOrderModel)->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        let param : Dictionary<String,Any> = [
            "instrument_id":instrument_id,
            "direction":direction.rawValue]as [String : Any]
        
        //getJSONStringFromDictionary(param)
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: false, requestPath: okex_futuresCutAllPendingOrder_POST, body: getJSONStringFromDictionary(param)!)
        
        XJHRequestManager.requestHeader(.post, url: okex_Current_APi + okex_futuresCutAllPendingOrder_POST, params: param, headers: header, success: { (info) in
            
            if let dict: Dictionary<String,Any> = info as? Dictionary<String, Any> {
                let mod = XJH_OkexFuturesCutAllPendingOrderModel.deserialize(from: dict)!
                
                if mod.error_code == "0" {
                    blockSuccess(mod)
                    return
                }else{
                    blaockError(XJHError(code: Int(mod.error_code) ?? 400,message: mod.error_message))
                    return
                }
                
            }
            blaockError(XJHError(code: 401))
            
            
        }) { (err) in
            blaockError(err)
        }
        
        
        
    }
    ///委托策略撤单--单个\多个  algo_ids=[“”]
    class func okex_FuturesStraregyCancelOrder( instrument_id:String,order_type:Okex_StrategyOrderType,algo_ids:[String], blockSuccess:@escaping (_ orderMod : XJH_OkexfuturesStrategyModel)->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        let param : Dictionary<String,Any> = [
            "order_type":order_type.rawValue,
            "instrument_id":instrument_id,
            "algo_ids":algo_ids]as [String : Any]
        
        //getJSONStringFromDictionary(param)
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: false, requestPath: okex_futuresStraregyCancelOrder_POST, body: getJSONStringFromDictionary(param)!)
        
        
        XJHRequestManager.requestHeader(.post, url: okex_Current_APi + okex_futuresStraregyCancelOrder_POST, params: param, headers: header, success: { (info) in
            
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
    ///获取委托单列表
    class  func okex_futuresStraregyOrderList(intIndex:Int = okex_header_number, instrument_id:String,order_type:Okex_StrategyOrderType,status:ok_futuresOrderStatus, blockSuccess:@escaping (_ mods : [XJH_OkexFuturesOldOrderModel])->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        let urlStr = okex_futuresStraregyOrderList_Get(instrument_id: instrument_id, order_type: order_type, status: status)
        
        
        let header = XJH_OkExTool().okex_GetOK_Header(header_num:intIndex, getBool: true, requestPath: urlStr)
        
        XJHRequestManager.requestHeader(.get, url: okex_Current_APi + urlStr, params: nil, headers: header, success: { (info) in
            
            if let arr: Array<Any> = info as? Array<Any> {
                
                let mods = [XJH_OkexFuturesOldOrderModel].deserialize(from: arr)!
                
                blockSuccess(mods as! [XJH_OkexFuturesOldOrderModel])
                return
            }
            
            blaockError(XJHError(code: 401))
            
        }) { (err) in
            blaockError(err)
        }
        
        
        
    }
    ///委托策略下单
    /// - Parameter instrument_id: 币种
    /// - Parameter type:
    /// - Parameter order_type:
    /// - Parameter trigger_price: 触发价格
    /// - Parameter algo_price: 价格
    /// - Parameter size: 张
    class func okex_FuturesOrderStraregy( instrument_id:String,type:ok_FuturesOpenOrderType,order_type:Okex_StrategyOrderType,trigger_price:String,algo_price:String, size:String, blockSuccess:@escaping (_ orderMod : XJH_OkexfuturesStrategyModel)->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        let param : Dictionary<String,Any> = [
            "order_type":order_type.rawValue,
            "instrument_id":instrument_id,
            "type":type.rawValue,
            "trigger_price":trigger_price,
            "algo_price":algo_price,
            "size":size]as [String : Any]
        
        //getJSONStringFromDictionary(param)
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: false, requestPath: okex_FuturesOrderStraregy_Post, body: getJSONStringFromDictionary(param)!)
        
        
        XJHRequestManager.requestHeader(.post, url: okex_Current_APi + okex_FuturesOrderStraregy_Post, params: param, headers: header, success: { (info) in
            
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
    ///单个合约持仓信息---全仓。  20次/2s   okex_futuresPosition_Get
    class func okex_FuturesePosition(instrument_id: String,blockSuccess:@escaping (_ PositionMods : XJH_OkexfuturesPositionModel_0)->(), blackError : @escaping (_ errcod:XJHError)->())  {
        
        let halfUrl = okex_futuresPosition_Get(instrument_id:instrument_id)
        
        let header = XJH_OkExTool().okex_GetOK_Header(requestPath: halfUrl)
        
        XJHRequestManager.requestHeader(url: okex_Current_APi + halfUrl , params: nil, headers: header, success: { (info) in
            
            if let dict : Dictionary<String,Any> = info as? Dictionary<String,Any>{
                
                let modarr : XJH_OkexfuturesPositionModel_0 = XJH_OkexfuturesPositionModel_0.deserialize(from: dict)!
                
                if modarr.result {
                    blockSuccess(modarr)
                    return
                }
            }
            
            blackError(XJHError(code: 401))
            
        }) { (err) in
            blackError(err)
        }
        
        
        
    }
    ///批量撤单----限价
    class func okex_FututresCancel_MoreOrder(order_ids:Array<String>, instrument_id: String, blockSuccess:@escaping (_ orderMod : XJH_Okex_CancelOrderModel)->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        let param : Dictionary<String,Any> = [
            "order_ids":order_ids]
            as [String : Any]
        
        let halfUrl = okex_futuresCancel_MoreOrders_Post(instrument_id: instrument_id)
        
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: false, requestPath:halfUrl, body: getJSONStringFromDictionary(param)!)
        
        
        XJHRequestManager.requestHeader(.post, url: okex_Current_APi + halfUrl, params: param, headers: header, success: { (info) in
            
            if let dict: Dictionary<String,Any> = info as? Dictionary<String, Any> {
                let mod = XJH_Okex_CancelOrderModel.deserialize(from: dict)!
                
                if (mod.result != true ) {
                    blaockError(XJHError(code: 401, message: "撤单失败"))
                }
                blockSuccess(mod)
            }else{
                blaockError(XJHError(code: 401))
            }
            
        }) { (err) in
            blaockError(err)
        }
        
        
        
    }
    
    ///撤销指定订单 okex_coinCoinCancel_Orders_Post
    class func okex_FututresCancel_Order(order_id:String, instrument_id: String, blockSuccess:@escaping (_ orderMod : XJH_Okex_CancelOrderModel)->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        let param : Dictionary<String,Any> = [
            "instrument_id":instrument_id]
            as [String : Any]
        
        let halfUrl = okex_futuresCancel_Orders_Post(instrument_id: instrument_id, order_id: order_id)
        
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: false, requestPath:halfUrl, body: getJSONStringFromDictionary(param)!)
        
        
        XJHRequestManager.requestHeader(.post, url: okex_Current_APi + halfUrl, params: param, headers: header, success: { (info) in
            
            if let dict: Dictionary<String,Any> = info as? Dictionary<String, Any> {
                let mod = XJH_Okex_CancelOrderModel.deserialize(from: dict)!
                
                if (mod.result != true ) {
                    blaockError(XJHError(code: 401, message: "撤单失败"))
                    
                }
                blockSuccess(mod)
            }else{
                blaockError(XJHError(code: 401))
            }
            
        }) { (err) in
            blaockError(err)
        }
        
        
        
    }
    ///获取订单列表 20次/2s  GET /api/futures/v3/orders/BTC-USD-190628?state=2&after=2517062044057601&limit=2
    class func okex_FuturesOrdersWithState(intIndex:Int = okex_header_number, instrument_id: String, after: String="", before: String="", state: Okex_OrderState,limit: String = "100", blockSuccess:@escaping (_ orderMod : [XJH_OkexFuturesOldOrderModel])->(), blackError : @escaping (_ errcod:XJHError)->())  {
        
        let path = okex_FuturesOldOrders_Get(instrument_id:instrument_id) + "?limit=" + limit  + "&state=" + state.rawValue + ((before != "") ? ("&before=" + before) : "") + ((after != "") ? ("&after=" + after) : "")
        let urlStr = okex_Current_APi + path
        
        //就是自己
        let header = XJH_OkExTool().okex_GetOK_Header(header_num:intIndex,requestPath: path)
        
        XJHRequestManager.requestHeader(url: urlStr, params: nil, headers: header, success: { (info) in
            
            if let dict = info as? Dictionary<String,Any>{
                if let array = dict["order_info"] as? Array<Any> {
                    
                    let modarr  = ([XJH_OkexFuturesOldOrderModel].deserialize(from: array) ?? nil)
                    
                    blockSuccess(modarr! as! [XJH_OkexFuturesOldOrderModel])
                    return
                }
            }
            
            
            blackError(XJHError(code: 401))
            
        }) { (err) in
            blackError(err)
        }
        
        
        
    }
    
    ///下单 40次/2s POST /api/futures/v3/order
    /// - Parameter instrument_id: 币name
    /// - Parameter type:
    /// - Parameter order_type: 下单类型
    /// - Parameter price: 价格
    /// - Parameter size: 张
    /// - Parameter match_price: 市价单 与否
    class func okex_FuturesOpenOrder( instrument_id:String,type:ok_FuturesOpenOrderType,order_type:Okex_CoinCoin_orderType = .limit,price:String, size:String, match_price:String = "0", blockSuccess:@escaping (_ orderMod : XJH_Okex_CoinCoinOrderReturnModel)->(), blaockError : @escaping (_ errcod:XJHError)->())  {
        
        let param : Dictionary<String,Any> = [
            "order_type":order_type.rawValue,
            "instrument_id":instrument_id,
            "type":type.rawValue,
            "client_oid":okex_setOrdersID_Futures(),
            "price":price,
            "size":size,
            "match_price":match_price]as [String : Any]
        
        //getJSONStringFromDictionary(param)
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: false, requestPath: okex_FuturesOrder_Post, body: getJSONStringFromDictionary(param)!)
        
        
        XJHRequestManager.requestHeader(.post, url: okex_Current_APi + okex_FuturesOrder_Post, params: param, headers: header, success: { (info) in
            
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
    
    ///设定k合约杠杆倍数
    ///获取合约杠杆倍数 GET /api/futures/v3/accounts/btc-usdt/leverage
    class func okex_FuturesGetOrSetFuturesLeverage(underlying:String,getYes:Bool,leverage:String = "",blockSuccess: @escaping (_ futuresModel : XJH_OkexFuturesSetOrGetLeverageModel) ->(), blaocError : @escaping (_ errcod:XJHError)->()) {
        //okex_FuturesSetOrGetFuturesLeverage_Post
        let param : Dictionary<String,Any> = ["underlying":underlying,"leverage":leverage]
        let thisUrl = okex_FuturesSetOrGetFuturesLeverage_getPost(underlying: underlying)
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: getYes, requestPath: thisUrl, body: (getYes ? "" : getJSONStringFromDictionary(param)!))
        
        XJHRequestManager.requestHeader((getYes ? XJHMethodType.get : XJHMethodType.post), url: okex_Current_APi + thisUrl, params: (getYes ? nil : param), headers: header, success: { (data) in
            
            if let dict:Dictionary<String,Any> = data as? Dictionary<String, Any>{
                
                let mod = XJH_OkexFuturesSetOrGetLeverageModel.deserialize(from: dict)
                blockSuccess(mod!)
            }
            
            
        }) { (err) in
            blaocError(err)
        }
        
    }
    
    ///设置账户合约模式-- 全仓 逐仓 underlying     标的指数，如：BTC-USD,BTC-USDT
    class func okex_FuturesSetAccountCoinModels(underlying:String,margin_mode:ok_futuresMargin_Model,blockResults : @escaping (_ bools : Bool)->(),blaocError : @escaping (_ errcod:XJHError)->())  {
        
        let param : Dictionary<String,Any> = ["underlying":underlying,"margin_mode":margin_mode.rawValue]
        
        let header = XJH_OkExTool().okex_GetOK_Header(getBool: false, requestPath: okex_FuturesSetAccountCoinModel_POst, body: getJSONStringFromDictionary(param)!)
        
        XJHRequestManager.requestHeader(.post, url: okex_Current_APi + okex_FuturesSetAccountCoinModel_POst, params: param, headers: header, success: { (data) in
            
            if let dict:Dictionary<String,Any> = data as? Dictionary<String, Any>{
                
                
                if dict.keys.contains("result") {
                    //
                    blockResults((dict["result"] as! Bool))
                    return
                }
            }
            blaocError(XJHError(code: 401))
            
        }) { (err) in
            blaocError(err)
        }
        
    }
    ///公共-获取某个ticker信息  限速规则：20次/2s
    class func okex_Pub_GerFuturesTicker(instrument_id:String,blockSuccess: @escaping (_ futuresModel : XJH_OkexFuturesTicker) ->(), blaocError : @escaping (_ errcod:XJHError)->())  {
        
        XJHRequestManager.request(url: okex_FuturesTicker(instrument_id: instrument_id), params: nil, success: { (info) in
            
            if let dict = info as? Dictionary<String,Any> {
                
                let mod = XJH_OkexFuturesTicker.deserialize(from: dict)
                
                blockSuccess(mod!)
                
            }else {
                blaocError(XJHError(code: 401))
            }
            
        }) { (err) in
            blaocError(err)
        }
        
        
    }
    
    ///公共-获取深度数据 20次/2s
    class func okex_FuturesDepthDict_Get(currencyName:String,size:Int, blockSuccess: @escaping (_ dataMod: XJH_Okex_CoinTransactionDepthModel) ->(), blaocError : @escaping (_ errcod:XJHError)->())  {
        
        XJHRequestManager.request(url: okex_FuturesDepthBook_Get(instrument_id: currencyName,size:size ), params: nil, success: { (info) in
            
            if let dict = info as?  Dictionary<String,Any> {
                
                if dict.keys.contains("asks") {
                    let dictMod = XJH_Okex_CoinTransactionDepthModel.deserialize(from: dict)
                    blockSuccess(dictMod!)
                    
                    return
                }
            }
            blaocError(XJHError(code: 401))
            
        }) { (err) in
            blaocError(err)
        }
        
    }
    
    ///公共-获取合约信息
    class func okex_Pub_GerFuturesInstrumentsList(blockSuccess: @escaping (_ coiinModel : [XJH_OkexFuturesListInstrumentsModel]) ->(), blaocError : @escaping (_ errcod:XJHError)->()) {
        
        XJHRequestManager.request(url: okex_FuturesInstruments_Get, params: nil, success: { (info) in
            
            if let array = info as? Array<Any> {
                
                let arrMods = [XJH_OkexFuturesListInstrumentsModel].deserialize(from: array)
                
                blockSuccess(arrMods! as! [XJH_OkexFuturesListInstrumentsModel])
                
                return
                
            }
            blaocError(XJHError(code: 401))
            
        }) { (err) in
            blaocError(err)
        }
        
        
    }
    
}
