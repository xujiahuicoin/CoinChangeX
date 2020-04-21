//
//  LGScrollTitleVStyle.h
//  LGPageDemo
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 LG. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LGScrollTitleView.h"
#import "LGScrollContentView.h"

@protocol LGScrollPageViewDelegate <NSObject>

-(void)lgPageSendTitle:(NSString *)titleString index:(NSInteger)index;

@end

/**
 *  滚动分页视图
 */
@interface LGScrollPageView : UIView
/**
 *  scrollTitleView(外面只读，可供使用)
 */
@property (nonatomic, strong, readonly) LGScrollTitleView *scrollTitleView;
/**
 *  scrollContentView(外面只读，可供使用)
 */
@property (nonatomic, strong, readonly) LGScrollContentView *scrollContentView;
/**
 *  代理放在头文件，可以让它成为别的类的代理
 */
@property (nonatomic, weak) id<LGScrollPageViewDelegate> delegate;

/**
 *  初始化
 *
 *  @param frame                frame
 *  @param segmentStyle         标题的风格
 *  @param titles               标题数组
 *  @param parentViewController 父控制器
 *
 *  @return 自身
 */
- (instancetype)initWithFrame:(CGRect)frame
                 segmentStyle:(LGScrollTitleViewStyle *)segmentStyle
                       titles:(NSMutableArray<NSString *> *)titles
                    childVcs:(NSMutableArray *)childVcs
         parentViewController:(UIViewController *)parentViewController
                     delegate:(id<LGScrollPageViewDelegate>) delegate;

- (instancetype)initWithFrame:(CGRect)frame style:(LGScrollTitleViewStyle *)style backgroundColor:(UIColor *)bgColor;

- (void)setTiltes:(NSArray<NSString *> *)titles childVcs:(NSArray<UIViewController *> *)childVcs parentViewController:(UIViewController *)parentViewController delegate:(id<LGScrollPageViewDelegate>)delegate;
- (void)generate;
@end
