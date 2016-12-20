//
//  UIView+addLine.h
//  LXSZ
//
//  Created by xzm on 16/6/21.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (addLine)

//CGRectMake(0, 0, kScreenWith, 0.5);[UIColor separatorColor]
- (void)addLine;

- (void)addLineWithFrame:(CGRect)rect color:(UIColor *)color;

@end
