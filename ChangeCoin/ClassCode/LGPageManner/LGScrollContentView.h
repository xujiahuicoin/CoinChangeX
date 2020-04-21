//
//  LGScrollTitleVStyle.h
//  LGPageDemo
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 LG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGScrollContentView;

@protocol LGScrollContentViewDelegate <NSObject>

/**
 *  结束滚动后调用方法
 *
 *  @param scrollContentView 当前视图
 *  @param index             滚动到的索引
 */
- (void)scrollContentView:(LGScrollContentView *)scrollContentView didScrollToIndex:(NSInteger)index;

/**
 *  滚动时调用的方法
 *
 *  @param scrollContentView 当前视图
 *  @param scale             滚动时的偏移量倍数
 */
- (void)scrollContentView:(LGScrollContentView *)scrollContentView contentOffsetScaleWhileScroll:(CGFloat)scale;

@end
/**
 *  滚动内容视图
 */
@interface LGScrollContentView : UIView

/**
 *  滚动内容scrollView
 */
@property (nonatomic, strong, readonly) UIScrollView *contentScrollView;
/**
 *  初始化
 *
 *  @param frame                frame
 *  @param parentViewController 父控制器
 *  @param childVcs             子控制器
 *  @param delegate             代理，以代理形式与外界通信
 *
 *  @return 自身
 */
- (instancetype)initWithFrame:(CGRect)frame
         parentViewController:(UIViewController *)parentViewController
                     childVcs:(NSArray *)childVcs
                     delegate:(id<LGScrollContentViewDelegate>)delegate;

@end
