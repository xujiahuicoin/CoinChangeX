//
//  LGScrollTitleVStyle.h
//  LGPageDemo
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 LG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LGScrollTitleViewStyle : NSObject

@property (assign, nonatomic) CGFloat titleMenuHeight;
/** 是否显示滚动条 默认为NO*/
@property (assign, nonatomic, getter=isShowLine) BOOL showLine;
/** 滚动条的高度 默认为2 */
@property (assign, nonatomic) CGFloat scrollLineHeight;
/**
 *  滚动条的颜色
 */
@property (strong, nonatomic) UIColor *scrollLineColor;
/** 标题之间的间隙 默认为15.0 */
@property (assign, nonatomic) CGFloat titleMargin;
/**
 *  标题的字体 默认为14
 */
@property (strong, nonatomic) UIFont *titleFont;
/**
 *  普通标题颜色
 */
@property (nonatomic, strong) UIColor *titleNormalColor;
/**
 *  选中的标题颜色
 */
@property (nonatomic, strong) UIColor *titleSelectedColor;
/**
 *  标题缩放倍数, 默认1.3
 */
@property (assign, nonatomic) CGFloat titleBigScale;
/**
 *  按钮高度
 */
@property (nonatomic, assign) CGFloat segmentHeight;


@end
