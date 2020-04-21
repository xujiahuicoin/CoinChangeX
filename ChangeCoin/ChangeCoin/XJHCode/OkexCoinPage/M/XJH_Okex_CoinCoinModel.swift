//
//  XJH_Okex_CoinCoinModel.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit


///委托策略下单Model
class XJH_OkexCoinCoinStrategyModel : XJHBaseModel{

     var algo_id : String = "" /// 329967,
     var result : Bool = false /// true
}


///撤销订单 返回
class XJH_Okex_CancelOrderModel : XJHBaseModel {
    
    var order_id      :String = "" ///    订单ID
    var client_oid    :String = "" ///    由您设置的订单ID来识别您的订单
    var result        :Bool = false ///    撤单申请结果。若是撤单失败，将给出错误码提示
    var error_code    :String = "" ///    错误码，撤单成功时为空，撤单失败时会显示相应错误码
    var error_message :String = "" ///    错误信息，撤单成功时为空，撤单失败时会显示错误信息
    
}

///订单   model列表
class XJH_Okex_CoinCoinOrdersModel : XJHBaseModel {
  ///   订单ID
    var order_id      :String = ""
  ///   用户设置的订单ID
    var client_oid    :String = ""
  ///   委托价格
    var price         :String = ""
  ///   委托数量（交易货币数量）
    var size          :String = ""
  ///   买入金额，市价买入时返回
    var notional      :String = ""
  ///   0：普通委托//1：只做Maker（Post only） //2：全部成交或立即取消（FOK）//3：立即成交并取消剩余（IOC）
    var order_type    :String = ""
  ///  币对名称
    var instrument_id : String = ""
  ///  buy 或 sell
    var side          : String = ""
  ///  limit或market（默认是limit）
    var type          : String = ""
  ///  订单创建时间
    var timestamp     : String = ""
  ///  已成交数量
    var filled_size   : String = ""
  ///   已成交金额
    var filled_notional :String = ""
    //订单状态-2：失败-1：撤单成功 0：等待成交  1：部分成交2：完全成交3：下单中4：撤单中
    var state          : String = ""
//    成交均价
    var price_avg    :String = "-"
    
    
//------------------策略------------------
        ///   委托失效时间
       var rejected_at : String = ""
       ///   委托单ID
       var algo_id :    String = ""
       ///   订单状态1: 待生效2: 已生效3: 已撤销4: 部分生效5: 暂停生效
       var status :    String = ""

        ///   策略委托价格
       var algo_price : String = ""
        ///   1：币币2：杠杆
       var mode :       String = ""
        ///   策略委托触发价格
       var trigger_price : String = ""
    
}

///下单 返沪model
class XJH_Okex_CoinCoinOrderReturnModel : XJHBaseModel {
    var order_id      :String?///订单ID 为-1 时 下单失败
    var client_oid    :String?///由您设置的订单ID来识别您的订单
    var result        :Bool? //    下单结果。若是下单失败，将给出错误码提示
    var error_code    : String? ///错误码，下单成功时为空，下单失败时会显示相应错误码
    var error_message : String?/// 错误信息，下单成功时为空，下单失败时会显示错误信息
}

///单一币种的 行情信息
class XJH_Okex_CoinCoinModel: XJHBaseModel {

    var instrument_id    :String = ""  ///String    币对名称
    var last             :String = ""  ///String    最新成交价
    var best_bid         :String = ""  ///String    买一价
    var best_ask         :String = ""  ///String    卖一价
    var open_24h         :String = ""  ///String    24小时开盘价
    var high_24h         :String = ""  ///String    24小时最高价
    var low_24h          :String = ""  /// String    24小时最低价
    var base_volume_24h  :String = ""  ///  String    24小时成交量，按交易货币统计
    var quote_volume_24h :String = ""  ///   String    24小时成交量，按计价货币统计
    var timestamp        :String = ""  /// String    系统时间戳
    
}

///单一交易深度
class XJH_Okex_CoinTransactionDepthModel: XJHBaseModel {

    var asks      : Array<Array<String>>? ///List<String>    卖方深度
    var bids      : Array<Array<String>>? ///List<String>    买方深度
    var timestamp : String? ///   String    时间戳

}

///单一币种的 账户信息
class CJH_Okex_COinAccountsSingleModel : XJHBaseModel {

var currency   : String = "" ///    币种
var balance    : String = "" ///    余额
var hold       : String = "" ///    冻结（不可用）
var available  : String = "" ///    可用于交易的数量
var id         : String = "" ///    账户id
    
}
