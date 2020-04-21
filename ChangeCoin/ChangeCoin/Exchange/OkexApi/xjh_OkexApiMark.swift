//
//  xjh_CoinMarkCode.swift
//  CoinChange
//
//  Created by xujiahui on 2019/11/4.
//  Copyright © 2019 www..cn. All rights reserved.
//

// 子账号 不支持提现o功能--查询 交易
/*
 apikey = "f1ccb6f7-3f80b3bd955d8ee"
 secretkey = "A3FF192C2F6A44F924E789"
 IP = "0"
 备注名 = "coinx"
 权限 = "只读/交易"
 */

import UIKit


let okex_header_number = 0

let okex_Current_APi = okex_Rest_Api
let okex_Rest_Api = "https://www.okex.com"
let okex_WS_Api = "wss://real.okex.com:8443/ws/v3"

///请求服务器时间
let okex_serverTime_Get = "/api/general/v3/time"


//---------------账户资金-----------

///账户资产估计
/// - Parameters:
///   - account_type: 业务线，0总资产
///   - valuation_currency: 基础币种
func okex_AccountWallet(account_type:String,valuation_currency:String)-> String{
    
    return "/api/account/v3/asset-valuation?account_type=" + account_type + "&valuation_currency=" + valuation_currency
}
///合约资金信息
let okex_FuturesAccountWallet_GET = "/api/futures/v3/accounts"
///币币-所以资金信息  20次/2s
let okex_accountWallet_GET = "/api/account/v3/wallet"
///单一币种账户信息 20次/2s
func okex_accountSingleWallet_GET(currencyPair: String) -> String{
    return "/api/spot/v3/accounts/\(currencyPair)"
}

//---------------币币交易-----------

///委托策略撤单 POST
let okex_coinCancelStraregyOrder_Post = "/api/spot/v3/cancel_batch_algos"
///获取委托单列表
func okex_coinStraregyOrderList_Get(instrument_id:String,order_type:Okex_StrategyOrderType,status:String)->String {
    return "/api/spot/v3/algo?instrument_id=\(instrument_id)&order_type=\(order_type.rawValue)&status=\(status)"
}
///未成交订单------获取所有 20次/2s
let okex_orders_pending_Get = "/api/spot/v3/orders_pending"
///订单列表------获取分类   state 订单类型
let okex_orders_Get = "/api/spot/v3/orders"
///下单------- OKEx币币交易提供限价单和市价单和高级限价单下单模式 100次/2s
let okex_coinCoinOrders_POST = "/api/spot/v3/orders"
///批量撤销订单-
func okex_coinCoinCancel_MoreOrders_Post(instrument_id: String) -> String{
 return  "/api/spot/v3/cancel_batch_orders/\(instrument_id)"
}
///撤销指定订单-------- 100次/2s  POST /api/spot/v3/cancel_orders/<order_id> or <client_oid>
func okex_coinCoinCancel_Orders_Post(order_id: String) -> String{
 return  "/api/spot/v3/cancel_orders/\(order_id)"
}
///策略委托下单_Post
let okex_strategyOrderAlgo_Post = "/api/spot/v3/order_algo"

///公共-获取某个ticker信息 20次/2s
func okex_coinCoinInfo_Get(currencyPair: String) -> String{
 return  okex_Current_APi + "/api/spot/v3/instruments/\(currencyPair)/ticker"
}
///公共-获取深度数据 20次/2s
func okex_coinCoinDepth_Get(currencyPair: String) -> String{
 return  okex_Current_APi + "/api/spot/v3/instruments/\(currencyPair)/book?size=5"
}


//---------------交割合约-----------
///获取订单信息
let okex_futuresOrderDetail_Get = "/api/futures/v3/orders"

///所有合约持仓信息
let okex_futuresAllOrder_Get = "/api/futures/v3/position"
 ///撤销所有平仓挂单--撤销所有 为成交平仓 委托POST {"instrument_id":"BTC-USD-180213","direction":"long"}
let okex_futuresCutAllPendingOrder_POST = "/api/futures/v3/cancel_all"

///委托策略撤单--单个algo_ids=“”--多个  algo_ids=[“”]  止盈止损参数 （最多同时存在10单）根据指定的algo_id撤销某个合约的未完成订单，每次最多可撤6（冰山/时间）/10（计划/跟踪）个
let okex_futuresStraregyCancelOrder_POST = "/api/futures/v3/cancel_algos"
///获取委托单列表
func okex_futuresStraregyOrderList_Get(instrument_id:String,order_type:Okex_StrategyOrderType,status:ok_futuresOrderStatus) -> String{
    return  "/api/futures/v3/order_algo/\(instrument_id)?order_type=\(order_type.rawValue)&status=\(status.rawValue)"
}
///委托策略下单 POST
 let okex_FuturesOrderStraregy_Post  = "/api/futures/v3/order_algo"
///单个合约持仓信息---全仓。  20次/2s  XJH_OkexfuturesPositionModel_0
func okex_futuresPosition_Get(instrument_id:String) -> String{
 return  "/api/futures/v3/\(instrument_id)/position"
}
///批量撤单---限价
func okex_futuresCancel_MoreOrders_Post(instrument_id:String) -> String{
 return  "/api/futures/v3/cancel_batch_orders/\(instrument_id)"
}
///撤单--限价--单个
func okex_futuresCancel_Orders_Post(instrument_id:String,order_id: String) -> String{
 return  "/api/futures/v3/cancel_order/\(instrument_id)/\(order_id)"
}
///获取订单列表 20次/2s  GET /api/futures/v3/orders/BTC-USD-190628?state=2&after=2517062044057601&limit=2
func okex_FuturesOldOrders_Get(instrument_id: String) -> String{
    return  "/api/futures/v3/orders/\(instrument_id)"
}
///下单 40次/2s POST /api/futures/v3/order
let okex_FuturesOrder_Post  = "/api/futures/v3/order"
///获取、设置合约币种杠杆倍数---POST
func okex_FuturesSetOrGetFuturesLeverage_getPost(underlying: String) -> String{
 return  "/api/futures/v3/accounts/\(underlying)/leverage"
}
///设置合约币种账户模式---设置合约币种账户模式，注意当前仓位有挂单时禁止切换账户模式。POST {"underlying":"btc-usd","margin_mode":"crossed"}
let okex_FuturesSetAccountCoinModel_POst = "/api/futures/v3/accounts/margin_mode"
///单个币种合约账户信息 --- GET /api/futures/v3/accounts/btc-usd
func okex_FuturesSingleAccounts(instrument_id: String) -> String{
 return  "/api/futures/v3/accounts/\(instrument_id)"
}
///公共-获取某个ticker信息 20次/2s
func okex_FuturesTicker(instrument_id: String) -> String{
 return  okex_Current_APi + "/api/futures/v3/instruments/\(instrument_id)/ticker"
}
///公共-获取合约信息--获取可用合约的列表， GET
let okex_FuturesInstruments_Get = okex_Current_APi +  "/api/futures/v3/instruments"
///公共-获取深度数据 -- GET /api/futures/v3/instruments/BTC-USD-180309/book?size=50
func okex_FuturesDepthBook_Get(instrument_id: String, size:Int) -> String{
 return  okex_Current_APi + "/api/futures/v3/instruments/\(instrument_id)/book?size=\(size)"
}
