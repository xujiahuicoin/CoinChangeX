//
//  LGScrollTitleVStyle.h
//  LGPageDemo
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 LG. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LGScrollTitleViewStyle.h"

/**
 *  滚动标题视图
 */
@interface LGScrollTitleView : UIView

/**
 *  所有标题的设置
 */
@property (strong, nonatomic) LGScrollTitleViewStyle *style;

/**
 *  menuLabel数组，只读
 */
@property (nonatomic, strong, readonly) NSMutableArray *menuLabels;
/**
 *  titleScrollView, 只读
 */
@property (nonatomic, strong, readonly) UIScrollView *titleScrollView;
/**
 *  滚动条
 */
@property (nonatomic, strong) UIImageView *scrollBar;

/**
 *  初始化
 *
 *  @param frame         尺寸
 *  @param segmentStyle  风格
 *  @param titles        标题数组
 *  @param titleDidClick 标题按钮点击block，以block形式与外界通信
 *
 *  @return 本身
 */
- (instancetype)initWithFrame:(CGRect )frame
                 style:(LGScrollTitleViewStyle *)style
                       titles:(NSArray<NSString *> *)titles
                titleDidClick:(void (^) (UILabel *label, NSInteger index))titleBtnOnClickBlock;
@end
