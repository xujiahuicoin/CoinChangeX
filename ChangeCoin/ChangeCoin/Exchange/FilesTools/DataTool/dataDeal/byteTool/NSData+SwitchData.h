//
//  NSData+SwitchData.h
//  ChangeCoin
//
//  Created by mac on 2019/12/10.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (SwitchData)
/**
NSData 转  十六进制string

@return NSString类型的十六进制string
*/
- (NSString *)convertDataToHexStr;

/**
 NSData 转 NSString
 
 @return NSString类型的字符串
 */
- (NSString *)dataToString ;
@end

NS_ASSUME_NONNULL_END
