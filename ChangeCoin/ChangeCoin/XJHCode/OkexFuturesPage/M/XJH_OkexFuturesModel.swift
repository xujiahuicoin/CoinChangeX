//
//  XJH_OkexFuturesModel.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit
func changeValueToUSD(value: String) -> String {

    return value.replacingOccurrences(of: "USDT", with: "USD")
}
class XJH_OkexFuturesModel: XJHBaseModel {}

///订单详细信息
class XJH_OkexFuturesOrderDetailsModel : XJHBaseModel{
    ///    合约ID，如BTC-USD-180213
    var instrument_id :    String = ""
    ///    由您设置的订单ID来识别您的订单
    var client_oid :    String = ""
     ///    委托数量
    var size :    String = ""
    ///    委托时间
    var timestamp :    String = ""
    ///    成交数量
    var filled_qty :    String = ""
    ///    手续费
    var fee :    String = ""
    ///    订单ID
    var order_id :    String = ""
    ///    委托价格
    var price :    String = ""
    ///    成交均价
    var price_avg :    String = ""
    ///    订单类型1:开多2:开空3:平多4:平空
    var type :    String = ""
    ///    合约面值
    var contract_val :    String = ""
    ///    杠杆倍数，1-100的数值
    var leverage :    String = ""
    ///    0：普通委托1：只做Maker（Post only）2：全部成交或立即取消（FOK）3：立即成交并取消剩余（IOC）
    var order_type :    String = ""
    ///    收益
    var pnl :    String = ""
    ///    订单状态-2：失败-1：撤单成功0：等待成交1：部分成交2：完全成交3：下单中4：撤单中
    var state :    String = ""

}

class  XJH_OkexFuturesCutAllPendingOrderModel : XJHBaseModel{
    var instrument_id : String = ""  ///    String    是 合约ID，: BTC-USD-180213,BTC-USDT-191227
    var direction : String = ""  ///    String    是 平仓方向 long :平多 short /:平空
    var error_code : String = ""  ///    String    错误码，: 单成功时为0，下单失败时会显示相应错误码
    var error_message : String = ""  ///    String    错误信息，: 单成功时为空，下单失败时会显示错误信息
    var result : String = ""  ///    String    调用接口返回结果
}

///合约全部资产信息
class XJH_OkexFuturesAllBlanceModel: XJHBaseModel {
    ///    账户余额币种
    var currency :   String = ""
    ///    账户类型、全仓：crossed
    var margin_mode :String = ""
    ///    账户权益
    var equity :     String = ""
    ///    账户余额
    var total_avail_balance :   String = ""
     ///    保证金（挂单冻结+持仓已用）
    var margin :   String = ""
    ///    持仓已用保证金
    var margin_frozen :   String = ""
    ///    挂单冻结保证金
    var margin_for_unfilled :   String = ""
     ///    已实现盈亏
    var realized_pnl :   String = ""
     ///    未实现盈亏
    var unrealized_pnl :   String = ""
    ///    保证金率
    var margin_ratio :   String = ""
     ///    维持保证金率
    var maint_margin_ratio :   String = ""
    ///    强平模式：tier（梯度强平）
    var liqui_mode :   String = ""
    ///    可划转数量
    var can_withdraw :   String = ""
    ///    强平手续费
    var liqui_fee_rate :   String = ""
    ///    标的指数，如：BTC-USD，BTC-USDT
    var underlying :   String = ""

    
}

///获取全部订单结果
class XJH_OkexFuturesAllOrderModel : XJHBaseModel{
    var result: String = ""
    var holding : Array<Array<Any>> = [[]]
    
}
///订单列表
class XJH_OkexFuturesOldOrderModel : XJHBaseModel {
    
    var instrument_id :    String = ""///    合约ID，如BTC-USD-180213 ,BTC-USDT-191227
    var client_oid :     String = ""///    用户设置的订单ID
    var size :     String = ""///    委托数量
    var timestamp :     String = "" ///    委托时间
    var filled_qty :     String = ""///    成交数量
    var fee :     String = ""///    手续费
    var order_id :     String = ""///    订单ID
    var price :     String = ""///    委托价格
    var price_avg :     String = ""///    成交均价
    var type :     String = ""///    订单类型1:开多---2:开空--3:平多--4:平空
    var contract_val :     String = ""///    合约面值
    var leverage :     String = ""///    杠杆倍数，1-100的数值
    var order_type :     String = ""///    0：普通委托1：只做Maker（Post var only）2：全部成交或立即取消（FOK）3：立即成交并取消剩余（IOC） :
    var pnl :     String = ""///    收益
    var state :     String = ""///    订单状态-2：失败-1：撤单成功0：等待成交1：部分成交2：完全成交3：下单中4：撤单中

    //--------------策略委托----------------------
     ///    委托单ID
    var algo_ids  :  String = ""
    ///    订单状态1: 待生效2: 已生效3: 已撤销 4: 部分生效 5: 暂停生效
    var status  :  String = ""
    
    //----------止盈止损
     ///  触发价格，填写值0\<X
    var trigger_price : String = ""
    ///  委托价格，填写值0\<X\<=1000000
    var algo_price : String = ""
    ///  实际成交数量
    var real_amount : String = ""
    
    ///当前合约收益
    var order_InCome : String = "点击获取收益"
}

///委托策略下单Model
class XJH_OkexfuturesStrategyModel : XJHBaseModel{
 ///    调用接口返回结果
    var result :    Bool = false
    ///    合约ID，如BTC-USD-190328
    var instrument_id :    String = ""
     ///    1：止盈止损2：跟踪委托3：冰山委托4：时间加权
    var order_type :    String = ""
    ///    订单ID，下单失败时，此字段值为-1
    var algo_id :    String = ""
    ///    错误码，下单成功时为0，下单失败时会显示相应错误码
    var error_code :    String = ""
    ///    错误信息，下单成功时为空，下单失败时会显示错误信息
    var error_message :    String = ""

    ///撤单返回 撤销指定的委托单ID
    var algo_ids : String = ""

}



///单个合约持仓信息---全仓。  20次/2s GET /api/futures/v3/BTC-USD-180309/position
class XJH_OkexfuturesPositionModel_0 : XJHBaseModel
{
     // ": true,
    var result : Bool = false
    var holding : [XJH_OkexfuturesPositionModel_1] = []
    /// ": "crossed" 账户类型 全仓：crossed
    var margin_mode : String = ""
    
}
/*
 保证金率：
 逐仓：保证金率=（固定保证金+未实现盈亏）／仓位价值=（固定保证金+未实现盈亏）／（面值*张数／最新标记价格）
 全仓：保证金率=（余额+已实现盈亏+未实现盈亏）／(仓位价值+挂单冻结保证金*杠杆倍数) =（余额+已实现盈亏+未实现盈亏）／（面值*张数／最新标记价格+挂单冻结保证金*杠杆倍数）
 */
class XJH_OkexfuturesPositionModel_1 : XJHBaseModel {
    
     ///    预估强平价
    var liquidation_price  :    String = "0"
     ///    多仓数量
    var long_qty  :    String = "0"
    ///    多仓可平仓数量
    var long_avail_qty  :    String = "0"
     ///    开仓平均价
    var long_avg_cost  :    String = "0"
     ///    结算基准价
    var long_settlement_price  :    String = "0"
     ///    已实现盈余
    var realised_pnl  :    String = "0"
    ///    杠杆倍数
    var leverage  :    String = "0"
     ///    空仓数量
    var short_qty  :    String = "0"
    ///    空仓可平仓数量
    var short_avail_qty  :    String = "0"
    ///    开仓平均价
    var short_avg_cost  :    String = "0"
    ///    结算基准价
    var short_settlement_price  :    String = "0"
     ///    合约ID，如BTC-USD-180213,BTC-USDT-191227
    var instrument_id  :    String = "0"
    ///    创建时间
    var created_at  :    String = ""
    ///    最近一次加减仓的更新时间
    var updated_at  :    String = ""
    ///    空仓保证金
    var short_margin  :    String = ""
    ///    空仓收益
    var short_pnl  :    String = ""
    ///    空仓收益率
    var short_pnl_ratio  :    String = ""
     ///    空仓未实现盈亏
    var short_unrealised_pnl  :    String = ""
    ///    空仓已结算收益
    var short_settled_pnl  :    String = ""
    ///空仓保证金率
    var short_margin_ratio   :  String = ""
    ///空仓维持保证金率
    var short_maint_margin_ratio   :  String = ""
    
    ///    多仓保证金
    var long_margin  :    String = ""
    ///    多仓收益
    var long_pnl  :    String = ""
    ///    多仓收益率
    var long_pnl_ratio  :    String = ""
    ///    多仓未实现盈亏
    var long_unrealised_pnl  :    String = ""
    ///    多仓已结算收益
    var long_settled_pnl  :    String = ""
    ///多仓保证金率
    var long_margin_ratio  :  String = ""
    ///多仓维持保证金率
    var long_maint_margin_ratio  :  String = ""
    
    ///    最新成交价
    var last  :    String = ""
    
    
    
    
    ///截取币种
    func getInstrument_id()->String{
        
        let arrCoin = self.instrument_id.components(separatedBy: "-")
        if arrCoin.count > 0{
            return arrCoin[0]
        }
        return ""
    }
}


///设定 获取杠杆倍数返回
class XJH_OkexFuturesSetOrGetLeverageModel: XJHBaseModel {

     ///    账户类型--全仓：crossed
    var margin_mode :    String = ""
    ///    标的指数，如：BTC-USD，BTC-USDT
    var underlying :    String = ""
     ///    已设定的杠杆倍数，1-100的数值
    var leverage :    String = ""
     ///    返回设定结果，成功或错误码
    var result :    Bool = false
    
}

///单一币种的行情信息_全仓
class XJH_OkexFuturesSingleWallte: XJHBaseModel {
    
    ///公有///  账户类型 全仓：crossed
    var margin_mode :    String  = ""
     ///  账户余额
    var total_avail_balance :    String = ""
     ///  账户权益
    var equity :    String = ""
     ///  可划转数量、可以用与交易的
     var can_withdraw :    String = ""
     ///  强平模式：tier（梯度强平）
    var liqui_mode :    String = ""
     ///  账户余额币种
    var currency :    String = ""
    
    ///全仓Model
    /// 保证金（挂单冻结+持仓已用）
    var margin :    String = ""
    ///  持仓已用保证金
    var margin_frozen :    String = ""
     ///  挂单冻结保证金
    var margin_for_unfilled :    String = ""
     ///  已实现盈亏
    var realized_pnl :    String = ""
    ///  未实现盈亏
    var unrealized_pnl :    String = ""
    ///  保证金率
    var margin_ratio :    String = ""
     ///  维持保证金率
    var maint_margin_ratio :    String = ""
      ///  强平手续费
     var liqui_fee_rate :    String = ""
     ///  标的指数，如：BTC-USD，BTC-USDT
    var underlying :    String = ""
    
    
    ///逐仓
    var auto_margin :         String = "" ///    是否自动追加保证金 1 : : 自动追加已开启 = "" ///  0 : : 自动追加未开启 = "" ///
    var contracts : [XJH_OkexFuturesFixedContracts] = [] /// :
}

class XJH_OkexFuturesFixedContracts : XJHBaseModel{
    var available_qty :      String = "" /// :     String = "" ///    逐仓可用余额
    var fixed_balance :      String = "" ///    逐仓账户余额
    var instrument_id :      String = "" ///    合约ID，如BTC-USD-180213,BTC-USDT-191227
    var margin_for_unfilled :     String = "" ///    挂单冻结保证金
    var margin_frozen :      String = "" ///    持仓已用保证金
    var realized_pnl :       String = "" ///    已实现盈亏
    var unrealized_pnl :     String = "" ///    未实现盈亏
}

///单一币种的行情信息
class XJH_OkexFuturesTicker : XJHBaseModel {
    
    
    var instrument_id :   String = "" ///    合约ID，如BTC-USD-180213,BTC-USDT-191227
    var last :            String = "" ///    最新成交价
    var best_ask :        String = "" ///    卖一价
    var best_bid :        String = "" ///    买一价
    var high_24h :        String = "" ///    24小时最高价
    var low_24h :         String = "" ///    24小时最低价
    var volume_24h :      String = "" ///    24小时成交量，按张数统计
    var timestamp :       String = "" ///    系统时间戳
}
///合约币种列表 信息--- 合约信息
class XJH_OkexFuturesListInstrumentsModel: XJHBaseModel {
    ///    合约ID，如BTC-USD-180213,BTC-USDT-191227
    var instrument_id :       String = ""
    ///    标的指数，如：BTC-USD
    var underlying :          String = ""
    ///    交易货币，如：BTC-USD中的BTC  ,BTC-USDT中的BTC
    var base_currency :       String = ""
     ///    计价货币币种，如：BTC-USD中的USD,BTC-USDT中的USDT
    var quote_currency :      String = ""
    ///    盈亏结算和保证金币种，如BTC
    var settlement_currency : String = ""
    ///    合约面值(美元)
    var contract_val :        String = ""
    ///    上线日期
    var listing :             String = ""
    ///    交割日期
    var delivery :            String = ""
    ///    下单价格精度
    var tick_size :           String = ""
    ///    下单数量精度
    var trade_increment :     String = ""
     ///    本周 this_week  次周 next_week  季度 quarter
    var alias :               String = ""
    ///    True or false ,是否 币本位保证金合约
    var is_inverse :           Bool?
    ///    合约面值计价币种 如 usd，btc，ltc，etc xrp eos
    var contract_val_currency :    String = ""

    func getInfoFromArray(array : [XJH_OkexFuturesListInstrumentsModel],listStruct:FutureListPairRuturn) -> XJH_OkexFuturesListInstrumentsModel {
        
        for  mod :XJH_OkexFuturesListInstrumentsModel in array {
            
            if mod.base_currency == listStruct.futuresName {
            
            if mod.alias == listStruct.aliasType.rawValue {
                return mod
            }
            }
        }
        
        return XJH_OkexFuturesListInstrumentsModel()
    }
    
}
///传入model 输出：ETH-季度-191108
func XJH_Okex_FuturesreturnFuturesNameFormatStr(mod:XJH_OkexFuturesListInstrumentsModel)-> String{
    
    return mod.instrument_id.replacingOccurrences(of: mod.quote_currency, with: ok_FuturesAliasType(rawValue: mod.alias)!.getAliasString())
    
}

///传入Name ETH-USD-191108，传出mod
func XJH_Okex_FuturesNameReturnFuturesInfoModel(instrument_id:String,modArr:[XJH_OkexFuturesListInstrumentsModel])-> XJH_OkexFuturesListInstrumentsModel{
    
    
    for  mod in modArr {
        
        if mod.instrument_id == instrument_id {
            return mod
        }
        
    }
    
  return XJH_OkexFuturesListInstrumentsModel()
    
}
