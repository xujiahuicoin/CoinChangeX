//
//  xjh_CoinDataTool.h
//  CoinChange
//
//  Created by xujiahui on 2019/11/4.
//  Copyright © 2019 www.CustomizeProject.cn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface xjh_CoinDataTool : NSObject


////////////--------------------------------时间处理
///ISO8601标准的时间格式，精确到毫秒
+(NSDate*)xjh_getDateByOriginalDateStr:(NSString*)strDate;
///获取当前时间 毫秒级的时间戳
+(NSString *)xjh_getTimestamp;
////////////--------------------------------数据处理
///单纯的256加密
+ (NSString *)xjh_SHA256:(NSString *)Str;

///使用hmac 通过key字段加密
+ (NSString *)xjh_hmac:(NSString *)plaintext withKey:(NSString *)key;

///base64 编码
+ (NSString *)xjh_base64EncodeString:(NSString *)string;
///base64 解码
+ (NSString *)xjh_base64DecodeString:(NSString *)string;




@end


