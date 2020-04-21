//
//  dataCompression.h
//  ChangeCoin
//
//  Created by mac on 2019/12/10.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface dataCompression : NSObject
///压缩
- (NSData *)gzipDeflate:(NSData*)data;

///解压缩
- (NSData *)gzipInflate:(NSData*)data;
@end

NS_ASSUME_NONNULL_END
