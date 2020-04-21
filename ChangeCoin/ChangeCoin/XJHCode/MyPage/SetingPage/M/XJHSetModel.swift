//
//  XJHSetModel.swift
//  ChangeCoin
//
//  Created by xujiahui on 2020/1/5.
//  Copyright © 2020 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit
class XJHSetingShareModel {
    static var shareModel = XJHSetModel()
}

class XJHSetModel: XJHBaseModel {
    
    var baseCurrency : String = "USD"
    var currentWallet : String = "0"
    
}
