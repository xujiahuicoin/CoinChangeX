//
//  dataCompression.m
//  ChangeCoin
//
//  Created by mac on 2019/12/10.
//  Copyright © 2019 www.xujiahuiCoin.com. All rights reserved.
//

#import "dataCompression.h"
#import <zlib.h>
#pragma clang diagnostic ignored "-Wcast-qual"

@implementation dataCompression
//压缩
- (NSData *)gzipDeflate:(NSData*)data
{
    if ([data length] == 0) return data;
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in=(Bytef *)[data bytes];
    strm.avail_in = (uInt)[data length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit2(&strm, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY) != Z_OK) return nil;
    
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];  // 16K chunks for expansion
    
    do {
        
        if (strm.total_out >= [compressed length])
            [compressed increaseLengthBy: 16384];
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
        
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength: strm.total_out];
    return [NSData dataWithData:compressed];
}


///解压缩
- (NSData *)gzipInflate:(NSData*)data
{
    if ([data length] == 0) return data;
    
    unsigned long full_length = [data length];
    unsigned long  half_length = [data length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[data bytes];
    strm.avail_in = (uInt)[data length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK)
        return nil;
    
    while (!done)
    {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END)
            done = YES;
        else if (status != Z_OK)
            break;
    }
    if (inflateEnd (&strm) != Z_OK)
        return nil;
    
    // Set real length.
    if (done)
    {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    }
    else return nil;
}
///官方C++ 解压
int gzdecompress(Byte *zdata, uLong nzdata, Byte *data, uLong *ndata)
   {
       int err = 0;
       z_stream d_stream = {0}; /* decompression stream */

       static char dummy_head[2] = {
           0x8 + 0x7 * 0x10,
           (((0x8 + 0x7 * 0x10) * 0x100 + 30) / 31 * 31) & 0xFF,
       };

       d_stream.zalloc = NULL;
       d_stream.zfree = NULL;
       d_stream.opaque = NULL;
       d_stream.next_in = zdata;
       d_stream.avail_in = 0;
       d_stream.next_out = data;

       
       if (inflateInit2(&d_stream, -MAX_WBITS) != Z_OK) {
           return -1;
       }

       // if(inflateInit2(&d_stream, 47) != Z_OK) return -1;

       while (d_stream.total_out < *ndata && d_stream.total_in < nzdata) {
           d_stream.avail_in = d_stream.avail_out = 1; /* force small buffers */
           if((err = inflate(&d_stream, Z_NO_FLUSH)) == Z_STREAM_END)
           break;

           if (err != Z_OK) {
               if (err == Z_DATA_ERROR) {
                   d_stream.next_in = (Bytef*) dummy_head;
                   d_stream.avail_in = sizeof(dummy_head);
                   if((err = inflate(&d_stream, Z_NO_FLUSH)) != Z_OK) {
                       return -1;
                   }
               } else {
                   return -1;
               }
           }
       }

       if (inflateEnd(&d_stream)!= Z_OK)
           return -1;
       *ndata = d_stream.total_out;
       return 0;
   }

@end
