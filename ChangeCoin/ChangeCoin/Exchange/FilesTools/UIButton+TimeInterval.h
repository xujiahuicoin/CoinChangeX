//
//  UIButton+TimeInterval.h
//  buttonMoreAction
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 www.xujiahuifutures.com. All rights reserved.
//

///
/*
 使用时：异常简单，和普通的按钮用法一模一样，只是需要多加一个属性。

 关键属性，设置每隔多少秒按钮可点
btn.timeInterval = 2;


*/

#import <UIKit/UIKit.h>

@interface UIButton (TimeInterval)
/**
 点击时间间隔
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

@end

