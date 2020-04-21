//
//  LGScrollTitleVStyle.h
//  LGPageDemo
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 LG. All rights reserved.
//


#import "LGScrollTitleViewStyle.h"

@implementation LGScrollTitleViewStyle

- (instancetype)init {
    if(self = [super init]) {
        self.showLine = NO;
        self.scrollLineHeight = 2.0;
        self.scrollLineColor = [UIColor blueColor];
//        self.titleSelectedColor =[UIColor clearColor];
//        self.titleNormalColor = UIColor.grayColor;
//        self.titleMargin = 15.0;
//        self.titleFont = [UIFont systemFontOfSize:14.0];
//        self.titleBigScale = 1.5;
//        self.segmentHeight = 44.0;
    }
    return self;
}


@end
