//
//  EnumFileHeader.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import Foundation


//---------------项目枚举---------------------
enum GithubType  {
    case create
    case delete
    case update
    case adminChagne
}

enum Okex_TransactionType : String {
    //bibi交易
    case coinCoin = "coinCoin"
    //期货交易
    case futures = "futures"
}
///策略委托下单
enum Okex_StrategyOrderType :String {
    ///限价委托 默认
    case type_normal = "0"
    ///止盈止损
    case type_TakeProfitStopLoss = "1"
    ///跟踪委托
    case type_tracking = "2"
    ///冰山
    case type_iceberg = "3"
    ///时间加权
    case type_timeAdd = "4"
    
}

///提交订单类型
enum Okex_CoinCoin_orderType : String {
    ///：普通委托（order type不填或填0都是普通委托）
    case limit = "0"
    ///1：只做Maker（Post only）
    case market = "1"
    ///：全部成交或立即取消（FOK）
    case FOK = "2"
    ///：立即成交并取消剩余（IOC）
    case IOC = "3"
    
}

///coinCoin交易
enum Okex_CoinCoin_margin_trading : String{
    //：币币交易订单
    case coincoin = "1"
    //：杠杆交易订单
    case coinLeverage = "2"
    
}

///订单状态
enum Okex_OrderState : String {
    /// ：失败
    case failure  = "-2"
    /// ：撤单成功
    case drawaled = "-1"
    /// 等待成交
    case pending  = "0"
    /// 部分成交
    case partDeal = "1"
    /// 完全成交
    case allDeal = "2"
    /// 下单中
    case ordering = "3"
    /// 撤单中
    case drawaling  = "4"
    /// 未完成（等待成交+部分成交）
    case NoSuccess = "6"
    ///:已完成（撤单成功+完全成交）
    case allSuccess = "7"
    
    func selfToString()->String{
        switch self {
        case .failure: return "交易失败"
        case .drawaled: return "撤单成功"
        case .pending: return "等待成交"
        case .partDeal: return "部分成交"
        case .allDeal: return "完全成交"
        case .ordering: return "下单中"
        case .drawaling: return "撤单中"
        case .NoSuccess: return "未完成"
        case .allSuccess: return "已完成"
        default:
            return ""
        }
    }
}

//-------------期货-----------------------

//交割类型
enum ok_FuturesAliasType : String {
    //本周
    case this_week = "this_week"
    //次周
    case next_week = "next_week"
    //季度
    case quarter   = "quarter"
    
    func getAliasString()->String{
        if self == .this_week{
            return "本周"
        }else if self == .next_week {
            return "次周"
        }else{
            return "季度"
        }
    }
}

enum ok_futuresOrderStatus : String {
    ///：待生效
    case type_loding = "1"
    ///：已生效
    case type_success = "2"
    ///：已撤销
    case type_cancel = "3"
    ///：部分生效
    case type_halfSuccess = "4"
    ///：暂停生效
    case type_stopUseing = "5"
    ///：委托失败
    case type_failed = "6"
}
///账户类型 全仓 逐仓
enum ok_futuresMargin_Model : String {
    ///全仓
    case crossed = "crossed"
    ///逐仓
    case fixed = "fixed"
}
///交易价格类型：市价 限价
enum ok_futuresMatch_price :String {
    ///限价
    case price = "0"
    ///市价
    case fastPrice = "1"
}
///合约多空类型
enum ok_FuturesType : String {
    ///平/开*-*多
    case long = "long"
    ///平/开*-*空
    case short = "short"
    
}
///下单类型
enum ok_FuturesOpenOrderType : String {
    ///:开多
    case openLong = "1"
    ///:开空
    case openShort = "2"
    ///:平多
    case stopLong =  "3"
    ///:平空
    case stopShort = "4"
    
    func ok_Returnok_FuturesTypeString()->ok_FuturesType {
        
        if self == .stopLong || self == .openLong {
            return ok_FuturesType.long
        }
        return ok_FuturesType.short
        
    }
}
///bibi 交易 主页面
enum OkexPageAction : String {
    ///货币点击事件
    case xjh_currencyNameAction = "currencyAction"
    ///交易区 交易对点击
    case xjh_transactionPairTab = "transactionPairTab"
    ///交易区 交易对点击 了 第几个
    case xjh_transactionPairTabRow = "xjh_transactionPairTabRow"
    ///交易对列表 点击
    case xjh_transactionListTab = "transactionListTab"
    ///交易深度列表点击
    case xjh_TransactionDepthTab = "TransactionDepthTab"
    //bibi交易参数 买卖变化
    case xjh_coinCoinBuySellChange = "coinCoinBuySellChange"
    /// 触发交易事件
    case xjh_TransactionBeginAction = "TransactionBeginAction"
    ///点击 订单cell
    case xjh_TransactionOrdersCell = "xjh_TransactionOrdersCell"
    ///全部委托 btn
    case xjh_AllComissionAction = "xjh_AllComissionAction"
    ///取消单个订单
    case xjh_ListCancelSingleOrder = "xjh_coinCoinCancelSingleOrder"
    
    ///交易规则事件 限价、止盈止
    case xjh_TradingRulesBtnAction = "xjh_TradingRulesBtnAction"
    
    ///下单成功刷新未成交列表
    case xjh_OrdersSuccessUpListAction = "xjh_OrdersSuccessUpListAction"
    
    //------------- 期货-----------------------
    ///期货 交易按钮
    case xjh_futuresButtonClick = "xjh_futuresButtonClick"
    ///选择杠杆倍数
    case xjh_futuresLeverageClick = "xjh_futuresLeverageClick"
    ///持仓列表 调整杠杆。平仓按钮
    case xjh_futuresChagneLeverageOrCutOrder = "xjh_futuresChagneLeverageOrCutOrder"
    ///tableView滑动了
    case xjh_TableViewScrollViewWillBeginDragging = "xjh_TableViewScrollViewWillBeginDragging"
    //---------------持仓---------------------
    ///市价平
    case xjh_futuresCurrentPriceCut = "xjh_futuresCurrentPriceCut"
    ///设定价格平
    case xjh_futuresSetPriceCut = "xjh_futuresSetPriceCut"
    
    
    //---------------文档管理---------------------
    ///文档目录
       case xjh_documentPathClick = "xjh_documentPathClick"
}
//---------------- 账户 枚举--------------------
///获取某一个业务线资产估值 。
enum Okex_WalletAccount_type : String {
///   0.预估总资产
    case okex_walletAll = "0"
///    1.币币账户
    case okex_walletCoinCoin = "1"
///    3.交割账户
    case okex_walletFutures = "3"
///    4.法币账户
    case okex_walletRMB = "4"
///    5.币币杠杆
    case okex_walletCoinCoinLeverge = "5"
///    6.资金账户
    case okex_walletFundAccount = "6"
///    8. 余币宝账户
///    9.永续合约
    case okex_walletFuturesFuture = "9"
///    14.挖矿账户
    
    func Account_typeToNameString()->String{
        
        if self == .okex_walletAll  {
            return "预估总资产"
        }else if self == .okex_walletCoinCoin  {
            return "币币账户"
        }else if self == .okex_walletFutures  {
            return "交割账户"
        }
        
        return ""
    }
    
    func nameStringToAccount_type(nameStr:String)->Okex_WalletAccount_type{
        
        if nameStr == "预估总资产"  {
            return .okex_walletAll
        }else if nameStr == "币币账户"   {
            return .okex_walletCoinCoin
        }else if nameStr ==  "交割账户"  {
            return .okex_walletFutures
        }
        
        return .okex_walletAll
    }
}

///按照某一个法币为单位的估值，默认BTC
enum Okex_WalletBaseCurrency : String {
    ///btc基础计价
    case okex_BaseBTC = "BTC"
    ///USD基础计价
    case okex_BaseUSD = "USD"
    ///CNY基础计价
    case okex_BaseCNY = "CNY"
    
}


//---------------- 通用 枚举--------------------

///通知触发
enum Okex_NotificationAction : String {
    ///2s 定时发送 ， 刷新实时数据页面
    case noti_updateDataTimersAction = "updateDataTimersAction"
    ///期货--更换了期货的种类
    case noti_ChangeFutureName = "ChangeFutureName"
    ///更改了杠杆倍数
    case noti_ChangeFuturesLeverage = "ChangeFuturesLeverage"
    ///订单列表 编辑事件
    case noti_ChangeFuturesOrderEditing = "ChangeFuturesOrderEditing"
    ///通知 期货批量扯淡按钮 回复原状
    case noti_ChangeStraregyItemToStar = "ChangeStraregyItemToStar"
    ///全部合约仓位
    case noti_AllFuturesOrderItem = "noti_AllFuturesOrderItem"
    
}
///时间格式
enum TimeTypes : String {
    
    //yyyy-MM-dd'T'HH:mm:ss
    
    ///"yyyy-MM-dd HH:MM"
    case Time_YMD_HM = "yyyy-MM-dd HH:mm"
    ///"MM-dd 11:23:28"
    case Time_MD_HMS = "MM-dd HH:mm:ss"
    
}
///登录判断
enum LoginState {
    ///失败
    case failed
    ///成功
    case success
}

