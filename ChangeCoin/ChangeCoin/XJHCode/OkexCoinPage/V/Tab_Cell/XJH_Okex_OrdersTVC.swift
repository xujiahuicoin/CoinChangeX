//
//  XJH_Okex_OrdersTVC.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/6.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit
protocol XJH_Okex_OrdersTVC_cancelBtnDelegate {
    func XJH_Okex_OrdersTVC_cancelBtnAction(thisModel: Any)
}

class XJH_Okex_OrdersTVC: UITableViewCell {
    
    @IBOutlet weak var side_lab: UILabel!
    
    @IBOutlet weak var product_id_Lab: UILabel!
    
    @IBOutlet weak var created_at_Lab: UILabel!
    
    ///委托总量
    @IBOutlet weak var size_Lab: UILabel!
    ///已成交量
    @IBOutlet weak var filled_size_Lab: UILabel!
    ///委托价格
    @IBOutlet weak var price_Lab: UILabel!
    ///成交均价
    @IBOutlet weak var price_Jun_Lab: UILabel!
    
    ///撤销btn
    @IBOutlet weak var btn_button: UIButton!
    ///成交均价text
    @IBOutlet weak var rightBottomLab: UILabel!
    ///已成交量text
    @IBOutlet weak var leftBottomLab: UILabel!
    ///订单状态
    @IBOutlet weak var order_state: UILabel!
    ///合约收益label
    @IBOutlet weak var orderIncomelab: UILabel!
    
    ///合约收益值
    @IBOutlet weak var orderIncomeValue: UILabel!
    ///加载收益loding
    @IBOutlet weak var lodingView: UIActivityIndicatorView!
    
    ///是否可以进行点击事件
    var isClickBool : Bool = false
    
    var btnDelegate : XJH_Okex_OrdersTVC_cancelBtnDelegate?
    
    var thisModel : Any?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btn_button.setTitleColor(XJHButtonColor_Blue, for: .normal)
        self.contentView.backgroundColor = XJHMainColor
        order_state.textColor = XJHSecondTextColor
    }
    
    
    
    @IBAction func btn_Action(_ sender: Any) {
        btnDelegate!.XJH_Okex_OrdersTVC_cancelBtnAction(thisModel: thisModel!)
        
        
    }
    
    /// 刷新数据
    /// - Parameter mod: 数据模型
    /// - Parameter isCoinCoin: 是不是bibi交易
    /// - Parameter XJH_StrategyType: 策略交易类型，默认normal，限价的交易
    func XJH_Pub_updateOrderModel(mod:Any,isCoinCoin:Bool = true, XJH_StrategyType :Okex_StrategyOrderType = .type_normal,currentOrderBool:Bool){
        
        thisModel = mod
        
        if currentOrderBool {
            //当前 显示撤销
            btn_button.isHidden = false
            //隐藏状态
            order_state.isHidden = true
        }else{
            //历史 隐藏撤销
            btn_button.isHidden = true
            order_state.isHidden = false
            
        }
        
        if isCoinCoin {
            //bibi 订单
            let model: XJH_Okex_CoinCoinOrdersModel = mod as! XJH_Okex_CoinCoinOrdersModel
            
            if model.side == "buy" {
                side_lab.backgroundColor = XJHGreenColor
                side_lab.text = " 买  "
            }else{
                side_lab.backgroundColor = XJHRedColor
                side_lab.text = " 卖  "
            }
            //总量
            product_id_Lab.text = model.instrument_id
            
            created_at_Lab.text = XJH_IOSDateToString(ISOStr: model.timestamp, timeType: .Time_MD_HMS)
            //订单状态
            order_state.text = Okex_OrderState(rawValue: model.state)?.selfToString()
            
            if XJH_StrategyType == .type_normal{
                //限价
                
                //已成交
                filled_size_Lab.text = model.filled_size
                price_Lab.text = xjh_AutoRoundToString(model.price)
                price_Jun_Lab.text = xjh_AutoRoundToString(model.price_avg)
                
                //委托总量
                size_Lab.text = model.size
            }else{
                //策略
                rightBottomLab.text = "触发价格"
                price_Jun_Lab.text = xjh_AutoRoundToString(model.trigger_price)
                
                //已成交
                filled_size_Lab.text = model.filled_size
                
                price_Lab.text = xjh_AutoRoundToString(model.algo_price)
                
                //委托总量
                size_Lab.text = model.size
            }
            
        }else{
            
            //futures 订单
            let model : XJH_OkexFuturesOldOrderModel = mod as! XJH_OkexFuturesOldOrderModel
            
            //显示收益和加载
//            orderIncomelab.isHidden = false
//            orderIncomeValue.isHidden = false
            orderIncomeValue.text = model.order_InCome

            if model.order_InCome == "" {
                isClickBool = false
            }else{
                isClickBool = true
            }
            //订单状态
            order_state.text = Okex_OrderState(rawValue: model.state)?.selfToString()
            let openOrderType = ok_FuturesOpenOrderType(rawValue: model.type)
            if  openOrderType == .openLong {
                side_lab.backgroundColor = XJHGreenColor
                side_lab.text = " 买入开多 "
            }else if openOrderType == .openShort {
                side_lab.backgroundColor = XJHRedColor
                side_lab.text = " 卖出开空 "
            }else if openOrderType == .stopLong {
                side_lab.backgroundColor = XJHRedColor
                side_lab.text = " 卖出平多 "
            }else if openOrderType == .stopShort {
                side_lab.backgroundColor = XJHRedColor
                side_lab.text = " 买入平空 "
            }
            
            product_id_Lab.text = model.instrument_id
            created_at_Lab.text = XJH_IOSDateToString(ISOStr: model.timestamp, timeType: .Time_MD_HMS)
            //获取委托总量 bi
            let acountNum = Okex_FuturesSheetsToCoinNums(price: model.price, sheets: model.size, futuresName: model.instrument_id)
            
            //------------------------------------
            if XJH_StrategyType == .type_normal{
                //限价
                price_Lab.text = xjh_AutoRoundToString(model.price)
                
                rightBottomLab.text = "保证金"
                filled_size_Lab.text = Okex_FuturesSheetsToCoinNums(price: model.price, sheets: model.filled_qty, futuresName: model.instrument_id)
                    
                //保证金
                let baozheng : Double = (Double(acountNum) ?? 0) / (Double(model.leverage) ?? 1)
                price_Jun_Lab.text = baozheng.xjh_roundToString(places: 2)

                //委托总量
                size_Lab.text = Okex_FuturesSheetsToCoinNums(price: model.price, sheets: model.size, futuresName: model.instrument_id)
            }else{
                
                rightBottomLab.text = "触发价格"
                price_Jun_Lab.text = xjh_AutoRoundToString(model.trigger_price)
                
                //已成交
                filled_size_Lab.text = Okex_FuturesSheetsToCoinNums(price: model.trigger_price, sheets: model.real_amount, futuresName: model.instrument_id)
                price_Lab.text = xjh_AutoRoundToString(model.algo_price)
                
                //委托总量
                size_Lab.text = Okex_FuturesSheetsToCoinNums(price: model.algo_price, sheets: model.size, futuresName: model.instrument_id)
            }
            
        }
        
        
    }
    
    func updateStraregyDataModel(){
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
