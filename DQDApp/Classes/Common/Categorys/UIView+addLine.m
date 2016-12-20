//
//  UIView+addLine.m
//  LXSZ
//
//  Created by xzm on 16/6/21.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "UIView+addLine.h"

@implementation UIView (addLine)

- (void)addLine{
    
    [self addLineWithFrame:CGRectMake(0, 0, kScreenWith, 0.5) color:[UIColor separatorColor]];
}

- (void)addLineWithFrame:(CGRect)rect color:(UIColor *)color{
    
    UIView *line = [[UIView alloc]initWithFrame:rect];
    line.backgroundColor = color;
    [self addSubview:line];
}
@end
