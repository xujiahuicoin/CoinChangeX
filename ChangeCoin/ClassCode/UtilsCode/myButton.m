//
//  myButton.m
//  FuturesPassTwo
//
//  Created by mac on 2019/6/4.
//  Copyright © 2019 FuturesPassTwo. All rights reserved.
//

#import "myButton.h"
@interface myButton()

@property (nonatomic,copy) myButtonBlock block;
@end

@implementation myButton

+(myButton *)buttonWithType:(UIButtonType)type frame:(CGRect )frame title:(NSString *)title colors:color andBackground:(UIColor *)backgroundColor tag:(NSInteger)tag andBlock:(myButtonBlock)block{
    myButton *button = [myButton buttonWithType:type];
    
    button.frame =  frame;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:button action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.backgroundColor = backgroundColor;
    
    button.tag = tag;
    
    button.block = block;
    
    return button;
    
}


+(myButton *)buttonWithType:(UIButtonType)type frame:(CGRect)frame  tag:(NSInteger)tag image:(NSString *)image andBlock:(myButtonBlock)block{
    myButton *button = [myButton buttonWithType:type];
    
    button.frame =  frame;
    
    [button addTarget:button action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([image hasPrefix:@"http:"] || [image hasPrefix:@"https:"]) {
        
        //[button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:image]];
    }else{
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }


    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.imageView.layer.masksToBounds = YES;
    button.tag = tag;
    
    button.block = block;
    
    return button;

}

+(myButton *)buttonWithType:(UIButtonType )type frame:(CGRect )frame title:(NSString *)title titleColor:(UIColor*)color andBackground:(UIColor *)backgroundColor cornerRadius:(CGFloat)corner tag:(NSInteger)tag andBlock:(myButtonBlock)block{
    
    
    myButton *button = [myButton buttonWithType:type];
    
    button.frame =  frame;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    
    button.layer.cornerRadius = corner;
    button.layer.masksToBounds = YES;
    
    [button addTarget:button action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = backgroundColor;

    button.tag = tag;
    
    button.block = block;
    
    return button;
    
    
}
-(void)buttonClicked:(UIButton *)btn{

    self.block(self);
}
@end
