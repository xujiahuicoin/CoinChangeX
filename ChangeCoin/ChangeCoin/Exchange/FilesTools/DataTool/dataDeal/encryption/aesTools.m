//
//  aesTools.m
//  Map-wms-Draw
//
//  Created by 徐士友 on 2018/9/7.
//  Copyright © 2018年 xujiahui. All rights reserved.
//

#import "aesTools.h"
#import "GTMBase64.h"
#import "NSData+AES.h"

#import <iconv.h>

//若key为空  内部数据，不易公开，需要自己补充;
//static NSString *  keys = @"kakAkeke";


@implementation aesTools
+(NSString*)StringToAESWith:(NSString*)string keyString:(NSString*)keys{
    
    NSData * data1 =[string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData * result = [data1 AES128EncryptWithKey:keys iv:keys];
    
    //转换为2进制字符串

    if(result && result.length > 0)

    {

    Byte *datas = (Byte *)[result bytes];

    NSMutableString *outPut = [NSMutableString stringWithCapacity:result.length];

    for(int i = 0 ; i < result.length ; i++)

    {

    [outPut appendFormat:@"%02x",datas[i]];
    }
       return outPut;
    }
        
    return @"";
}

+(NSString*)AESToString:(NSString*)string keyString:(NSString*)keys{
    
    
    NSMutableData *dataNew = [NSMutableData dataWithCapacity:string.length/2.0];

    unsigned char whole_bytes;

    char byte_chars[3] = {'\0','\0','\0'};

    int i;

    for(i = 0 ; i < [string length]/2 ; i++)

    {

    byte_chars[0] = [string characterAtIndex:i * 2];

    byte_chars[1] = [string characterAtIndex:i * 2 + 1];

    whole_bytes = strtol(byte_chars, NULL, 16);

    [dataNew appendBytes:&whole_bytes length:1];

    }
    
    NSData * data2 = [dataNew AES128DecryptWithKey:keys iv:keys];
    NSString * str  =[[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];

    return str;
}

@end
