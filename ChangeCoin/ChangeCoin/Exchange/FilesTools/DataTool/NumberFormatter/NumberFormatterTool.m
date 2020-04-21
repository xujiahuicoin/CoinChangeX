//
//#import "NumberFormatterTool.h"
//
//@implementation NumberFormatterTool
//
///**
// 根据服务器传来的资产数据转换成展示的数据，整数部分使用","分割
// 例如：NSString *numStr = [NSString convertToDisplayStringWithOriginNum:@"4624671262.46720089" decimalsLimit:3  prefix:@"" suffix:@" CNY"];
// numStr = @"4，624，671，262.467 CNY"
//
// @param numString 原始数据
// @param prefix 前缀
// @param suffix 后缀
// @param decimal 小数位数限制: <0 代表不生效
// @return 转换后的字符串
// */
//+ (NSString *)XJH_convertToDisplayStringWithOriginNum:(NSString *)numString decimalsLimit:(NSInteger)decimal prefix:(NSString *)prefix suffix:(NSString *)suffix {
//    // 判断合法性
//    if ([numString isEqualToString:@"NaN"] || [numString isEqualToString:@"nan"] || [numString isEqualToString:@"NAN"] || numString.length <= 0) {
//        numString = @"0";
//    }
//
//    NSNumber *tempNum = [numString XJH_digitalValue];
//
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//
//    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans_CN"];
//    // 设置数字样式为小数
//    formatter.numberStyle = NSNumberFormatterDecimalStyle;
//    // 最小整数位数为1
//    formatter.minimumIntegerDigits = 1;
//    // 设置整数分割位数
//    [formatter setGroupingSize:3];
//    // 设置进位模式
//    formatter.roundingMode = kCFNumberFormatterRoundDown;
//    // 最多小数位数为8
//    formatter.maximumFractionDigits = 8;
//
//    // 设置小数位数限制
//    if (decimal >= 0) {
//        formatter.minimumFractionDigits = decimal;
//        formatter.maximumFractionDigits = decimal;
//    }
//
//    // 设置前缀
//    if(prefix && prefix.length >= 1) {
//        formatter.positivePrefix = prefix;
//    }
//
////    // 设置后缀(此种方法小数负数失效)
////    if (suffix && suffix.length >= 1) {
////        formatter.positiveSuffix = suffix;
////    }
//
//    // 从上述格式生成数字对应字符串
//    NSString *result = [formatter stringFromNumber:tempNum];
//
//    if (suffix && suffix.length >= 1) {
//        result = [result stringByAppendingString:suffix];
//    }
//
//    return result ? : @"";
//}
//
//
///**
// 修复数字字符串的小数位数限制
//
// @param numString 数字字符串
// @param minDecimal 最小小数位数限制
// @param maxDecimal 最大小数位数限制
// */
//+ (NSString * )XJH_fixNumString:(NSString * )numString minDecimalsLimit:(NSInteger)minDecimal maxDecimalsLimit:(NSInteger)maxDecimal; {
//
//    // 判断合法性
//    if ([numString isEqualToString:@"NaN"] || [numString isEqualToString:@"nan"] || [numString isEqualToString:@"NAN"] || numString.length <= 0) {
//        numString = @"0";
//    }
//
//    NSNumber *tempNum = [numString XJH_digitalValue];
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//
//    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans_CN"];
//
//    // 设置数字样式为小数
//    formatter.numberStyle = NSNumberFormatterNoStyle;
//    // 最小整数位数为1
//    formatter.minimumIntegerDigits = 1;
//    // 设置进位模式
//    formatter.roundingMode = kCFNumberFormatterRoundDown;
//    // 设置最小小数位数限制
//    if (minDecimal >= 0) {
//        formatter.minimumFractionDigits = minDecimal;
//    }
//    // 设置最大小数位数限制
//    if (maxDecimal >= 0) {
//        formatter.minimumFractionDigits = maxDecimal;
//    }
//
//    // 从上述格式生成数字对应字符串
//    NSString *result = [formatter stringFromNumber:tempNum];
//
//    return result ? : @"";
//}
//
//
///* 将字符串转换为小数对象 */
//- (NSDecimalNumber *)XJH_digitalValue {
//
//    NSDecimalNumber *decimalNum = nil;
//
//    if (!isStrEmpty(self) && [self isKindOfClass:[NSString class]]) {
//        decimalNum = [[NSDecimalNumber alloc] initWithString:self];
//    }
//
//    return decimalNum;
//}
//
//
///**
// 大数字的格式化
//
// @param numString 需要格式化的数字
// @param decimal 小数位数
// @param unit 分割的单位
// @param prefix 前缀
// @param suffix 后缀
// @return 格式化后的文字
// */
//- (NSString *)XJH_formetterBigNumber:(NSString *)numString decimalsLimit:(NSInteger)decimal separatorUnit:(NSInteger)unit prefix:(NSString *)prefix suffix:(NSString *)suffix {
//
//    NSString *ret = numString;
//
//    long num = [numString longLongValue];
//
//    if (num >= unit) {
//        CGFloat shortNum = (CGFloat)num / (CGFloat)unit;
//        NSString *printF = [NSString stringWithFormat:@"%%.%df",(int)decimal];
//
//        NSString *numString = [NSString stringWithFormat:printF,shortNum];
//
//        ret = [NSString stringWithFormat:@"%@%@%@",prefix,numString,suffix];
//    }
//
//    return ret;
//}
//
//@end
