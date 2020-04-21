//
//  NSObject+XsyCoding.h
//  RecordHealth
//
//  Created by mac on 2019/5/24.
//  Copyright © 2019 xujiahui. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol XsyCoding <NSObject>

@optional
/**
 *  这个数组中的属性名才会进行归档
 */
+ (NSArray *)Xsy_allowedCodingPropertyNames;
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)Xsy_ignoredCodingPropertyNames;

/**
 忽略归档父类的属性
 
 @return 是否忽略
 */
+ (BOOL)Xsy_ignoreCodingSuperClassPropertyNames;

@end
@interface NSObject (XsyCoding)<XsyCoding>

- (void)Xsy_encode:(NSCoder *)encoder;

- (void)Xsy_decode:(NSCoder *)decoder;
@end

#define XSYCodingImplementation \
- (instancetype)initWithCoder:(NSCoder *)aDecoder\
{\
if (self = [super init]) {\
[self Xsy_decode:aDecoder];\
}\
return self;\
}\
- (void)encodeWithCoder:(NSCoder *)aCoder\
{\
[self Xsy_encode:aCoder];\
}
