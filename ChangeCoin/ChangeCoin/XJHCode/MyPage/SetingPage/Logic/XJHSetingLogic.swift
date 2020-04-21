//
//  XJHSetingLogic.swift
//  ChangeCoin
//
//  Created by xujiahui on 2020/1/5.
//  Copyright © 2020 www.xujiahuiCoin.com. All rights reserved.
//

import UIKit

class XJHSetingLogic: NSObject {
    
    ///获取路径
    class func xjh_GetSetingPath() -> String{
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let fileName:String =  "\(documentPath)/CoinSeting.plist"
        
        return fileName
    }
    
    ///个人设置的---读取
    class func Xjh_SetReadData()  {
        
        
        //读取数据
        var dict:NSMutableDictionary = NSMutableDictionary(contentsOfFile: xjh_GetSetingPath()) ?? [:]
        
        if (dict.allKeys.count > 0) {
            //有数据
            //dict 转model
            let mod = XJHSetModel.deserialize(from:dict)
            
            XJHSetingShareModel.shareModel = mod!
            
        }else{
            //没有数据新建立
            XJHSetingShareModel.shareModel = XJHSetModel()
        }
        
    }
    
    ///个人设置的---修改
    class func Xjh_SetWriteData(mod:XJHSetModel){
        
        //mod 转字典
        let dict:NSDictionary = ["baseCurrency":mod.baseCurrency,"currentWallet":mod.currentWallet]
        //写入plist
        dict.write(toFile: xjh_GetSetingPath(), atomically: true)
    }
    ///
    
    
}
