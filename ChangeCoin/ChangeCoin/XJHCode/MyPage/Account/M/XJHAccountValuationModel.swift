//
//  XJHAccountValuationModel.swift
//  ChangeCoin
//
//  Created by xujiahui on 2019/12/10.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJHAccountValuationModel: XJHBaseModel {
    ///    按照某一个法币为单位的估值，如BTC
    var valuation_currency    :  String = ""
    ///    预估资产
    var balance    :  String = ""
     ///    数据返回时间
    var timestamp    :  String = ""
    ///    账户类型
    var account_type    :  String = ""

}
