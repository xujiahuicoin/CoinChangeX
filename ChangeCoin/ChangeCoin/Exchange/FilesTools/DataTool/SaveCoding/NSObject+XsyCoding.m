//
//  NSObject+XsyCoding.m
//  RecordHealth
//
//  Created by mac on 2019/5/24.
//  Copyright © 2019 xujiahui. All rights reserved.
//

#import "NSObject+XsyCoding.h"
#import "XsyModelManager.h"

static const char XSYAllowedCodingPropertyNamesKey = '\0';
static const char XSYIgnoredCodingPropertyNamesKey = '\0';


static NSMutableDictionary *allowedCodingPropertyNamesDict_;
static NSMutableDictionary *ignoredCodingPropertyNamesDict_;

@implementation NSObject (XsyCoding)


+ (void)load
{
    allowedCodingPropertyNamesDict_ = [NSMutableDictionary dictionary];
    ignoredCodingPropertyNamesDict_ = [NSMutableDictionary dictionary];
}

+ (NSMutableDictionary *)dictForKey:(const void *)key
{
    @synchronized (self) {
        if (key == &XSYAllowedCodingPropertyNamesKey) return allowedCodingPropertyNamesDict_;
        if (key == &XSYIgnoredCodingPropertyNamesKey) return ignoredCodingPropertyNamesDict_;
        return nil;
    }
}

/**
 归档对象
 
 @param encoder encoder
 */
- (void)Xsy_encode:(NSCoder *)encoder
{
    Class clazz = [self class];
    
    NSArray *allowedCodingPropertyNames = [clazz Xsy_totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [clazz Xsy_totalIgnoredCodingPropertyNames];
    BOOL ignore = [clazz Xsy_ignoreSuperNames];
    [clazz Xsy_enumeratePropertiesIgnoreSuperClassPropertyNames:ignore enumeration:^(XsyModelManager *property, BOOL *stop) {
        
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        id value = [property valueForObject:self];
        if (value == nil) return;
        
        /**
         //开始存档对象 存档的数据都会存储到NSMutableData中 会调用对象的`encodeWithCoder`方法
         [archiver encodeObject:object forKey:key];
         */
        [encoder encodeObject:value forKey:property.name];
    }];
}
/**
 解档对象
 
 对象的`initWithCoder`方法会调用该方法
 @param decoder decoder
 */
- (void)Xsy_decode:(NSCoder *)decoder
{
    Class clazz = [self class];
    
    NSArray *allowedCodingPropertyNames = [clazz Xsy_totalAllowedCodingPropertyNames];
    NSArray *ignoredCodingPropertyNames = [clazz Xsy_totalIgnoredCodingPropertyNames];
    BOOL ignore = [clazz Xsy_ignoreSuperNames];
    
    [clazz Xsy_enumeratePropertiesIgnoreSuperClassPropertyNames:ignore enumeration:^(XsyModelManager *property, BOOL *stop) {
        
        // 检测是否被忽略
        if (allowedCodingPropertyNames.count && ![allowedCodingPropertyNames containsObject:property.name]) return;
        if ([ignoredCodingPropertyNames containsObject:property.name]) return;
        
        id value = [decoder decodeObjectForKey:property.name];
        if (value == nil) {
            return ;
        }
        
        [property setValue:value forObject:self];
    }];
}


/**
 是否忽略归档父类
 
 @return 是否忽略
 */
+ (BOOL)Xsy_ignoreSuperNames
{
    SEL selector = @selector(Xsy_ignoreCodingSuperClassPropertyNames);
    if ([self respondsToSelector:selector]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        BOOL ignore = [self performSelector:selector];
#pragma clang diagnostic pop
        
        return ignore;
    }
    return NO;
}
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSMutableArray *)Xsy_totalIgnoredCodingPropertyNames
{
    return [self Xsy_totalObjectsWithSelector:@selector(Xsy_ignoredCodingPropertyNames) key:&XSYIgnoredCodingPropertyNamesKey];
}

+ (NSMutableArray *)Xsy_totalAllowedCodingPropertyNames
{
    return [self Xsy_totalObjectsWithSelector:@selector(Xsy_allowedCodingPropertyNames) key:&XSYAllowedCodingPropertyNamesKey];
}

+ (NSMutableArray *)Xsy_totalObjectsWithSelector:(SEL)selector key:(const char *)key
{
    NSMutableArray *array = [self dictForKey:key][NSStringFromClass(self)];
    if (array) return array;
    
    // 创建、存储
    [self dictForKey:key][NSStringFromClass(self)] = array = [NSMutableArray array];
    
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSArray *subArray = [self performSelector:selector];
#pragma clang diagnostic pop
        if (subArray) {
            [array addObjectsFromArray:subArray];
        }
    }
    
    [self Xsy_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        NSArray *subArray = objc_getAssociatedObject(c, key);
        [array addObjectsFromArray:subArray];
    }];
    return array;
}


@end
