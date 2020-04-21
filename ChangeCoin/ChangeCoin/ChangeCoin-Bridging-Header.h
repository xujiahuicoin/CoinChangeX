//
//  XJH-Bridging-Header.h
//  xujiahuiCoin
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 www.xujiahuiCoin.cn. All rights reserved.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//小数位的限制
#import "NumberFormatterTool.h"
//Byte、Byte数组、NSData的相互转换
#import "NSData+SwitchData.h"
#import "NSString+SwitchData.h"
//数据压缩解压
#import "dataCompression.h"
//数据加密
#import "aesTools.h"
#import <Bugly/Bugly.h>
//pageview VCs
#import "LGScrollPageView.h"
//自定义button
#import "myButton.h"
//数据本地化
#import "NSObject+XsyCoding.h"
#import "XsyModelManager.h"
#import "XsyFileManager.h"
//卸载保存
#import "KeychainManager.h"

//webScok
#import "SocketRocketUtility.h"
//防止崩溃
#import "AvoidCrash.h"
#import "NSArray+AvoidCrash.h"

//#import <JPUSHService.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
