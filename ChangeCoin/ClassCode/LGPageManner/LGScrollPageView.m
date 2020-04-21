//
//  LGScrollTitleVStyle.h
//  LGPageDemo
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 LG. All rights reserved.
//


#import "LGScrollPageView.h"
#import "LGScrollTitleMenuLabel.h"

#define LGsctollBackColor  [UIColor clearColor]

@interface LGScrollPageView ()<LGScrollContentViewDelegate>
/**
 *  标题视图的风格
 */
@property (nonatomic, strong) LGScrollTitleViewStyle *titleViewStyle;
/**
 *  scrollTitleView(外面只读，可供使用)
 */
@property (nonatomic, strong) LGScrollTitleView *scrollTitleView;
/**
 *  scrollContentView(外面只读，可供使用)
 */
@property (nonatomic, strong) LGScrollContentView *scrollContentView;

@property (weak, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) NSArray *childVcs;
@property (strong, nonatomic) NSArray *titlesArray;
/**
 *  当前的页面
 */
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation LGScrollPageView

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
                     delegate:(id<LGScrollPageViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.titleViewStyle = segmentStyle;
        self.parentViewController = parentViewController;
        self.parentViewController.view.backgroundColor = LGsctollBackColor;
        self.titlesArray = titles;
        self.childVcs = childVcs;
        self.delegate = delegate;
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame style:(LGScrollTitleViewStyle *)style backgroundColor:(UIColor *)bgColor{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.titleViewStyle = style;
        self.backgroundColor = LGsctollBackColor;
    }
    
    return self;
}

- (void)setTiltes:(NSArray<NSString *> *)titles childVcs:(NSArray<UIViewController *> *)childVcs parentViewController:(UIViewController *)parentViewController delegate:(id<LGScrollPageViewDelegate>)delegate {
    self.parentViewController = parentViewController;
    self.titlesArray = titles;
    self.childVcs = childVcs;
    self.delegate = delegate;
   
}

- (void)p_initView {
    self.currentPage = 0;
  
    
    [self p_initScrollTitleView];
    [self p_initScrollContentView];
}

- (void)p_initScrollTitleView {
    _scrollTitleView = [[LGScrollTitleView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40) style:self.titleViewStyle titles:self.titlesArray titleDidClick:^(UILabel *label, NSInteger index) {
        self->_scrollTitleView.backgroundColor = LGsctollBackColor;
        CGPoint offset = self.scrollContentView.contentScrollView.contentOffset;
        offset.x = index * self.scrollContentView.contentScrollView.frame.size.width;
        
        // 如果选中的索引大于当前页面+1，则先让scrollView没有动画滚动到选中页面-1位置
//        if (index > self.currentPage + 1) {
//            CGPoint tempOffset = self.scrollContentView.contentScrollView.contentOffset;
//            tempOffset.x = (index - 1) * self.scrollContentView.contentScrollView.bounds.size.width;
//            [self.scrollContentView.contentScrollView setContentOffset:tempOffset animated:NO];
//        }
//        
//        // 如果选中的索引小于当前页面-1，则先让scrollView没有动画滚动到选中页面+1位置
//        if (index < self.currentPage - 1) {
//            CGPoint tempOffset = self.scrollContentView.contentScrollView.contentOffset;
//            tempOffset.x = (index + 1) * self.scrollContentView.contentScrollView.bounds.size.width;
//            [self.scrollContentView.contentScrollView setContentOffset:tempOffset animated:NO];
//        }

        self.scrollContentView.contentScrollView.backgroundColor = LGsctollBackColor;
        // 最后动画滚动到指定页面
        [self.scrollContentView.contentScrollView setContentOffset:offset animated:YES];
    }];
    
    [self addSubview:_scrollTitleView];
}

- (void)p_initScrollContentView {
    _scrollContentView = [[LGScrollContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollTitleView.frame), self.frame.size.width, self.frame.size.height - CGRectGetHeight(self.scrollTitleView.frame)) parentViewController:self.parentViewController childVcs:self.childVcs delegate:self];
    
    _scrollContentView.backgroundColor = LGsctollBackColor;
    self.backgroundColor = LGsctollBackColor;
    [self addSubview:_scrollContentView];
}

- (void)generate {
    // 设置contentSize
    [self p_initView];
}

#pragma mark - BBScrollContentViewDelegate

/**
 *  scrollContentView结束滚动后调用方法
 *
 *  @param scrollContentView 当前视图
 *  @param index             滚动到的索引
 */
- (void)scrollContentView:(LGScrollContentView *)scrollContentView didScrollToIndex:(NSInteger)index {
    self.currentPage = index;
    
//    NSLog(@"self.scrollTitleView.titleScrollView.contentOffset = %@", NSStringFromCGPoint(self.scrollTitleView.titleScrollView.contentOffset));
//
//    CGFloat width =  self.scrollTitleView.titleScrollView.frame.size.width;
//    
//    // 让对应的顶部标题居中显示
    LGScrollTitleMenuLabel*label = self.scrollTitleView.menuLabels[index];
    label.textColor = [UIColor systemBlueColor];
//    CGPoint titleOffset = self.scrollTitleView.titleScrollView.contentOffset;
//    titleOffset.x = label.center.x - width * 0.5;
//    
//    // 左边超出处理
//    if (titleOffset.x < 0)  titleOffset.x = 0;
//    
//    // 右边超出处理
//    CGFloat maxTitleOffsetX =  self.scrollTitleView.titleScrollView.contentSize.width - width;
//    if (titleOffset.x > maxTitleOffsetX) titleOffset.x = maxTitleOffsetX;
//    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        // 设置滚动条的中心
        CGPoint scrollBarCenter = self.scrollTitleView.scrollBar.center;
        scrollBarCenter.x = label.center.x;
        self.scrollTitleView.scrollBar.center = scrollBarCenter;
        
        
//        [self.scrollTitleView.titleScrollView setContentOffset:titleOffset animated:YES];
    } completion:nil];
//    
    if (self.delegate && [_delegate respondsToSelector:@selector(lgPageSendTitle:index:)]) {
        [self.delegate lgPageSendTitle:label.text index:self.currentPage];
    }
    
//  
    // 让其他label回到最初的状态
    for (LGScrollTitleMenuLabel *otherLabel in self.scrollTitleView.menuLabels) {
        if (label != otherLabel) {
            otherLabel.scale = 0;
            otherLabel.textColor = UIColor.whiteColor;
        }
    }
}

/**
 *  内容视图的scrollView滚动时调用的方法
 *
 *  @param scrollContentView 当前视图
 *  @param scale             滚动时的偏移量倍数
 */
- (void)scrollContentView:(LGScrollContentView *)scrollContentView contentOffsetScaleWhileScroll:(CGFloat)scale {
    
    // 如果最左边滚动，和最右边滚动，啥事也不干
    if (scale < 0 || scale > self.childVcs.count - 1) return;
    
    // 获得需要操作的左边label
    NSInteger leftIndex = scale;
    LGScrollTitleMenuLabel *leftLabel = self.scrollTitleView.menuLabels[leftIndex];
    
    // 获得需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    LGScrollTitleMenuLabel *rightLabel = (rightIndex == self.scrollTitleView.menuLabels.count) ? nil : self.scrollTitleView.menuLabels[rightIndex];
    
    // 左边label的宽度和x值
    CGFloat leftLabelW = leftLabel.frame.size.width;
    CGFloat leftLabelX = leftLabel.frame.origin.x;
    
    // 右边label的宽度和x值
    CGFloat rightLabelW = rightLabel.frame.size.width;
    CGFloat rightLabelX = rightLabel.frame.origin.x;
    
    // 右边比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1- rightScale;
    
    // 滚动条的宽度
    CGRect scrollBarFrame = self.scrollTitleView.scrollBar.frame;
    scrollBarFrame.size.width = (leftLabelW + (rightLabelW - leftLabelW) * rightScale);
    
    // 滚动条的x值
    scrollBarFrame.origin.x = leftLabelX + (rightLabelX - leftLabelX) * rightScale;
    self.scrollTitleView.scrollBar.frame = scrollBarFrame;
    
    // 设置label比例
    leftLabel.scale = leftScale;
    rightLabel.scale = rightScale;
}

@end
