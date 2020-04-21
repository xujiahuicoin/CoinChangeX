//
//  LGScrollTitleVStyle.h
//  LGPageDemo
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 LG. All rights reserved.
//



#import "LGScrollContentView.h"
#define LGsctollBackColor  [UIColor clearColor]

/**
 *  滚动内容视图
 */
@interface LGScrollContentView ()<UIScrollViewDelegate>

/**
 *  滚动内容scrollView
 */
@property (nonatomic, strong) UIScrollView *contentScrollView;
/**
 *  父控制器
 */
@property (nonatomic, weak) UIViewController *parentViewController;
/**
 *  子控制器
 */
@property (nonatomic, strong) NSArray *childVcs;
@property (nonatomic, weak) id<LGScrollContentViewDelegate> delegate;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation LGScrollContentView

/**
 *  初始化
 *
 *  @param frame                frame
 *  @param parentViewController 父控制器
 *  @param childVcs             子控制器
 *  @param delegate             代理
 *
 *  @return 自身
 */
- (instancetype)initWithFrame:(CGRect)frame
         parentViewController:(UIViewController *)parentViewController
                     childVcs:(NSArray *)childVcs
                     delegate:(id<LGScrollContentViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.parentViewController = parentViewController;
        self.childVcs = childVcs;
        self.delegate = delegate;
        [self initView];
    }
    
    return self;
}

- (void)initView {
    // 滚动scrollview
    _contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _contentScrollView.backgroundColor = LGsctollBackColor;
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _currentPage = 0;
    
    _contentScrollView.contentSize = CGSizeMake(self.bounds.size.width * self.childVcs.count, 0);

    [self addSubview:self.contentScrollView];
    
    [self scrollViewDidEndScrollingAnimation:_contentScrollView];
}

#pragma mark - scrollViewDelegate

/**
 *  只要scrollView在滚动就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollContentView:contentOffsetScaleWhileScroll:)]) {
        [_delegate scrollContentView:self contentOffsetScaleWhileScroll:scale];
    }
}

/**
 *  手指拉动scrollview，停止减速时调用方法
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 *  scrollView结束滚动动画后会调用这个方法
 *
 *  @param scrollView scrollView
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 当前位置要显示的控制器索引
    NSInteger index = offsetX / width;
    self.currentPage = index;
    
    // 通知代理，scrollView结束滚动，滚动结束时，将要显示的控制器索引
    if (_delegate && [_delegate respondsToSelector:@selector(scrollContentView:didScrollToIndex:)]) {
        [_delegate scrollContentView:self didScrollToIndex:index];
    }

    // 取出需要显示的控制器
    UIViewController *willShowVC = self.childVcs[index];
    
    // 如果当前位置时，控制器已经显示过了，直接返回
    if ([willShowVC isViewLoaded])  return;
    
    // 添加控制器的view到contentScrollView上
    willShowVC.view.frame = CGRectMake(offsetX, 0, width, height);
    
    [self.contentScrollView addSubview:willShowVC.view];
}

@end
