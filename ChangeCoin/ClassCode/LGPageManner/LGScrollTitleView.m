//
//  LGScrollTitleVStyle.h
//  LGPageDemo
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 LG. All rights reserved.
//


#import "LGScrollTitleView.h"
#import "LGScrollTitleMenuLabel.h"

#define LGsctollBackColor  [UIColor clearColor]

typedef void(^TitleBtnOnClickBlock)(UILabel *label, NSInteger index);

/**
 *  每一个tab之间的间隙
 */
static const CGFloat tabGap = 20;
/**
 *  tab与滚动条之间的间隙
 */
static const CGFloat bottomGap = 5;

/**
 *  滚动标题视图
 */
@interface LGScrollTitleView ()
// 所有的标题
@property (strong, nonatomic) NSArray *titles;
/**
 *  menuLabel数组
 */
@property (nonatomic, strong) NSMutableArray *menuLabels;
/**
 *  label宽度数组
 */
@property (nonatomic, strong) NSMutableArray *menuLabelTitleWidths;
/**
 *  titleScrollView
 */
@property (nonatomic, strong) UIScrollView *titleScrollView;
/**
 *  menuLabel点击时执行的block
 */
@property (copy, nonatomic) TitleBtnOnClickBlock titleBtnOnClickBlock;

@end

@implementation LGScrollTitleView

- (instancetype)initWithFrame:(CGRect )frame
                        style:(LGScrollTitleViewStyle *)style
                       titles:(NSArray<NSString *> *)titles
                titleDidClick:(void (^) (UILabel *label, NSInteger index))titleBtnOnClickBlock {
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.titles = titles;
        self.titleBtnOnClickBlock = titleBtnOnClickBlock;
        
        [self p_initData];
        [self p_initView];
    }
    
    return self;
}

- (void)p_initData {
    self.menuLabels = [NSMutableArray array];
    self.menuLabelTitleWidths = [NSMutableArray array];
}

- (void)p_initView {
    
    // 0.创建标题滚动scrollView
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
//   self.titleScrollView.user
    [self addSubview:self.titleScrollView];
    
    // 1.创建scrollView上的标题label和滚动条scrollBar
    if (_titles && _titles.count > 0) {
        for (int i = 0; i < _titles.count; i++) {
            // 1.1 创建按钮
             // 1.1.1计算按钮宽度，并保存到按钮宽度数组中
            CGFloat tltleWidth = [LGScrollTitleView getLabelFitSize:_titles[i] labelWidth:MAXFLOAT font:[UIFont systemFontOfSize:14]].width;
            [_menuLabelTitleWidths addObject:@(tltleWidth)];
            
            // 1.1.2创建按钮
            LGScrollTitleMenuLabel *menuLabel = [[LGScrollTitleMenuLabel alloc] initWithFrame:CGRectZero];
            menuLabel.tag = i;
            menuLabel.text = _titles[i];
            menuLabel.textColor = [UIColor whiteColor];
            menuLabel.font = [UIFont systemFontOfSize:14];
            
            [menuLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapTitleItem:)]];
            
            [self.titleScrollView addSubview:menuLabel];
            
            [_menuLabels addObject:menuLabel];// 将按钮保存
            
            // 1.2 创建scrollBar
            self.scrollBar = [UIImageView new];
            self.scrollBar.backgroundColor = LGsctollBackColor;
            [self.titleScrollView addSubview:self.scrollBar];
        }
        
        [self p_setUpView];
    }
}

- (void)p_setUpView {
    // 1.根据标题和间隔获取所有的标题宽度
    CGFloat titleX = 0.0;
    CGFloat titleY = bottomGap;// 标题距离上一个bottomGap,才能上下对称
    CGFloat titleW = 0.0;
    CGFloat titleH = self.frame.size.height - bottomGap * 2;
    
    CGFloat allTitlesWidth = 0.0;
    
    for (NSInteger i = 0; i < _titles.count; i++) {
        // 标题总长度 = 每一个tab + 对应的间距tabGap
        allTitlesWidth = allTitlesWidth + tabGap + [_menuLabelTitleWidths[i] floatValue];
    }
    
    allTitlesWidth += tabGap;// 加上最后一个间距tabGap;
    
    // 补充额外的间距，如果计算后的标题总长度小于自身的长度，则会补充额外的间距
    CGFloat addedMargin = allTitlesWidth < self.bounds.size.width ? (self.bounds.size.width - allTitlesWidth)/(self.menuLabelTitleWidths.count + 1) : 0 ;
    allTitlesWidth = allTitlesWidth > self.bounds.size.width ? allTitlesWidth : self.bounds.size.width;
    allTitlesWidth = allTitlesWidth + self.menuLabelTitleWidths.count * addedMargin;
    
    // 2.设置titleScrollView的frame和contentSize,contentOffsets
    self.titleScrollView.frame = self.bounds;
    self.titleScrollView.contentSize = CGSizeMake(allTitlesWidth, self.bounds.size.height);
    
    // 3.设置label的frame
    CGFloat lastLabelMaxX = 0;
    for (NSInteger i = 0; i < self.menuLabels.count; i++) {
        LGScrollTitleMenuLabel *label = self.menuLabels[i];
        titleW = [_menuLabelTitleWidths[i] floatValue];
        titleX = lastLabelMaxX + (addedMargin + tabGap);
        label.frame = CGRectMake(titleX, titleY, titleW, titleH);
        
        lastLabelMaxX = titleX + titleW;
        
        if (label.tag == 0) {
            label.scale = 1;
        }
        
        [self.titleScrollView addSubview:label];
    }
    
    // 4.设置滚动条的frame
    // 默认scrollBar宽度等于第一个title宽度 * label扩大比例
    CGFloat scrollBarW = [self.menuLabelTitleWidths[0] integerValue] * 1.2;
    // 默认scrollBar的x值等于第一个titleLabel的x值
    LGScrollTitleMenuLabel *label = self.menuLabels[0];
    CGFloat scrollBarX = label.frame.origin.x;
    CGFloat scrollBarY = self.frame.size.height - 10;
    CGFloat scrollBarH = 2;
    self.scrollBar.frame = CGRectMake(scrollBarX, scrollBarY, scrollBarW, scrollBarH);
}

#pragma mark - 业务

+ (CGSize)getLabelFitSize:(NSString *)content labelWidth:(CGFloat)labelWidth font:(UIFont *)font {
    CGSize size = CGSizeMake(labelWidth, MAXFLOAT); // 设置一个行高上限
    CGSize returnSize;
    
    NSDictionary *attribute = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:14] };
    returnSize = [content boundingRectWithSize:size
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return returnSize;
}

#pragma mark - gesture

- (void)p_tapTitleItem:(UITapGestureRecognizer *)tap {
    LGScrollTitleMenuLabel *menuLabel = (LGScrollTitleMenuLabel *)tap.view;
    NSInteger index = menuLabel.tag;
    menuLabel.textColor = [UIColor whiteColor];
    if (_titleBtnOnClickBlock) {
        _titleBtnOnClickBlock(menuLabel, index);
    }
}

@end
