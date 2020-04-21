//
//  SocketRocketUtility.h
//  AirspaceProject
//
//  Created by xujiahui on 2018/8/23.
//  Copyright © 2018年 AirspaceProject. All rights reserved.
/*
 ///启动 WebSocket + deviceToken
 -(void)startWebSocketAdddeviceToken{

     NSString *urlstring = [NSString stringWithFormat:@"%@%@",webSocketURl,UserModelonline.userId];
     
 //启动websocket
     [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:urlstring];
   
     //启动通知
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kWebSocketdidReceiveMessageNote object:nil];
 
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];

 }
 
 //websock 通知
 - (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {

 */
#import <Foundation/Foundation.h>
#import <SocketRocket.h>

extern NSString * const kNeedPayOrderNote;
extern NSString * const kWebSocketDidOpenNote;
extern NSString * const kWebSocketDidCloseNote;
extern NSString * const kWebSocketdidReceiveMessageNote;

@interface SocketRocketUtility : NSObject

// 获取连接状态
@property (nonatomic,assign,readonly) SRReadyState socketReadyState;

+ (SocketRocketUtility *)instance;

-(void)SRWebSocketOpenWithURLString:(NSString *)urlString;//开启连接

/**
 关闭连接
 */
-(void)SRWebSocketClose;//

/**
 发送数据

 @param data <#data description#>
 */
- (void)sendData:(id)data;//发送数据

/**
 重连接
 */
- (void)reConnect;


@end
