//
//  XJH_AccountLogic.swift
//  ChangeCoin
//
//  Created by mac on 2019/12/16.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJH_AccountLogic: NSObject {
    
    ///获取账户资金----记录时间对比，，时间差大于23s重新请求
    /// - Parameters:
    ///   - loadIntIndex: 是自己还是监控者
    ///   - Account_type: 账户类型--==默认： 所有账户资金
    ///   - returnWallet: 返回 账户j金额== 以USDT 计价
    class func xjh_GetWalletAccount(loadIntIndex:Int = okex_header_number,Account_type:Okex_WalletAccount_type = .okex_walletAll,returnWallet:@escaping(_ wallet:String)->()){
        
        //key
        let keyStr:String = "\(loadIntIndex)wallet" + Account_type.rawValue 
        
        //判断value 是否过期
        if let dict = UserDefaults.standard.object(forKey: keyStr) as? Dictionary<String,Any> {
            
            //记录的时间戳
            let stampOld:Int = dict["timeStamp"] as! Int
            //记录的钱包
            let wallet:String = dict["wallet"] as! String
            //当前的时间戳
            let stampNow:Int = Date().timeStamp
            
            //时间间隔对比
            let jumpTime = stampNow - stampOld
            print("\(loadIntIndex)=资产总计==上一次请求后的。。。。。\(jumpTime)s")
            
            if jumpTime > 30 {
                //可以再次请求
                print("\(loadIntIndex)=资产总计==走了请求。。。。。\(jumpTime)s")
                
                xjh_OkexApiFundAcount.okex_getAccountWalletAssetValuation(loadIntIndex:loadIntIndex, blockSuccess: { (mod) in
                    
                    //请求成功记录新值
                    DispatchQueue.main.async(execute: {
                        //返回新值
                        returnWallet(mod.balance)
                        print("\(loadIntIndex)=资产总计==走了请求。。。。成功\(mod.balance)")
                        //保存记录
                        UserDefaults.standard.set(["timeStamp":Date().timeStamp,"wallet":mod.balance], forKey: keyStr)
                    })
                }) { (err) in
                    
                    UserDefaults.standard.set(["timeStamp":Date().timeStamp,"wallet":""], forKey: keyStr)
                    print("\(loadIntIndex)=资产总计==走了请求。。。。。 请求失败")
                    //超时请求错误 不用原值
                    returnWallet("")
                    
                }
                
            }else{
                //只能用原值
                returnWallet(wallet)
            }
            
        }else{
            
            //没有保存过---请求去
            xjh_OkexApiFundAcount.okex_getAccountWalletAssetValuation(loadIntIndex:loadIntIndex, blockSuccess: { (mod) in
                
                //请求成功记录新值
                DispatchQueue.main.async(execute: {
                    //返回新值
                    returnWallet(mod.balance)
                    //保存记录
                    UserDefaults.standard.set(["timeStamp":Date().timeStamp,"wallet":mod.balance], forKey: keyStr)
                })
            }) { (err) in
                //返回空
                returnWallet("")
                UserDefaults.standard.set(["timeStamp":Date().timeStamp,"wallet":""], forKey: keyStr)
            }
        }
        
        
    }
    
    
    
    
}
