//
//  LGScrollTitleVStyle.h
//  LGPageDemo
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 LG. All rights reserved.
//


#import "LGScrollTitleMenuLabel.h"
#define LGsctollBackColor  [UIColor clearColor]

static const CGFloat MBSRed = 0.0;
static const CGFloat MBSGreen = 0.0;
static const CGFloat MBSBlue = 0.0;

/**
 *  滚动的标题菜单label
 */
@implementation LGScrollTitleMenuLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.font = [UIFont boldSystemFontOfSize:15];
        self.textColor = [UIColor blackColor]; // 黑
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = LGsctollBackColor;
        self.userInteractionEnabled = YES;
        
    }
    
    return self;
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    // 变红  1 0 0
//    CGFloat red = MBSRed + (163 - MBSRed) * scale;
//    CGFloat green = MBSGreen + (81 - MBSGreen) * scale;
//    CGFloat blue = MBSBlue + (40 - MBSBlue) * scale;
//    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    self.textColor = [UIColor whiteColor];
    // 大小缩放比例
    CGFloat transformScale = 1 + scale * 0.2;
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}

@end
