//
//  xjh_OkexWSApi.swift
//  ChangeCoin
//
//  Created by xujiahui on 2019/12/4.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

import Foundation

//WebSocket
//地址：wss://real.okex.com:8443/ws/v3
//--------------交割合约----------------------
//{"op": "<value>", "args": ["<value1>","<value2>"]}
//其中 op 的取值为 1--subscribe 订阅； 2-- unsubscribe 取消订阅 ；3--login 登录
//args: 取值为频道名，可以定义一个或者多个频道

let webSocketUrl = "wss://real.okex.com:8443/ws/v3?compress=true"

///链接 WS
func Okex_linkWebSocket(){
    SocketRocketUtility.instance()?.srWebSocketOpen(withURLString: webSocketUrl)
}
///发送数据
func Okex_sendData_WS(data:Any){
     SocketRocketUtility.instance()?.sendData(data)
}


///--订阅 --发起期货 "futures/depth5:BTC-USD-191227"
func Okex_FuturesSubscribeWS(Channel:Array<Any>){
    let dict = ["op":"subscribe","args":Channel] as [String : Any]
           
          let strJson = getJSONStringFromDictionary(dict)
    
          Okex_sendData_WS(data: strJson)
}
///--取消订阅 --发起期货 "futures/depth5:BTC-USD-191227"
func Okex_FuturesCancleSubscribeWS(Channel:Array<Any>){
   
    let dict = ["op":"unsubscribe","args":Channel] as [String : Any]
           
          let strJson = getJSONStringFromDictionary(dict)
    
           Okex_sendData_WS(data: strJson)
}

///--登录--{"op":"login","args":["<api_key>","<passphrase>","<timestamp>","<sign>"]}
func Okex_FuturesLoginWS(okex_isoTime:String){
   
    let sign = XJH_OkExTool().okex_GetOK_ACCESS_SIGN(timestamp: (okex_isoTime == "") ? okex_isoTime2 : okex_isoTime, getBool: true, requestPath: "/users/self/verify", secretKey: XJH_UserModel.sharedInstance.okex_secretkey)
    
    let dict = ["op":"login","args":[XJH_UserModel.sharedInstance.okex_apikey,XJH_UserModel.sharedInstance.okex_PassPHRASE,okex_isoTime,sign]] as [String : Any]
           
          let strJson = getJSONStringFromDictionary(dict)
        Okex_sendData_WS(data: strJson)
}
///退出登录




