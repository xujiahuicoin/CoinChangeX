//
//  XJH_Okex_OtherData.swift
//  ChangeCoin
//
//  Created by mac on 2019/11/5.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_Okex_OtherData: NSObject {

    ///获取 交易对
    class func XJH_getTransactionPairArray() -> Array<String> {
        return ["USDT","BTC","ETH"]
    }
    
    ///获取交易对的 列表
    class func XJH_getTransactionPairList(fileName : String ,blockSuccess: @escaping (_ listDict : Dictionary<String,Any>) ->(), blaocError : @escaping (_ errcod:XJHError)->() ) {
        ///xjh_testing 测试
        let url = "https://raw.githubusercontent.com/OnYourMark-Sun/XJH_ExchangeCoinInfo/master/\(fileName)"
        
        XJHRequestManager.request(url: url, params: nil, success: { (info) in
            
            if let dict = info as? Dictionary<String,Any>{
                
                blockSuccess(dict)
                
            }else{
                blaocError(XJHError(code: 401))
            }
            
        }) { (err) in
            blaocError(err)
        }
    }
    
}
