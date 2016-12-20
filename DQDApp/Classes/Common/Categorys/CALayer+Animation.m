//
//  CALayer+Animation.m
//  LXSZ
//
//  Created by xzm on 16/7/18.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "CALayer+Animation.h"

//弧度转角度 3.14->180
#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
//角度转弧度 180 ->3.14
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

@implementation CALayer (Animation)

- (void)shake{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translate.x"];
    
    CGFloat s = 10;
    
    animation.values = @[@(-s),@(0),@(s),@(-s),@(0),@(s)];
    
    animation.duration = .1f;
    
    animation.repeatCount = 2;
    
    animation.removedOnCompletion = YES;
    
    [self addAnimation:animation forKey:@"shake"];
    
}

- (void)tremble{
    
    //创建关键帧动画，并告诉系统这是什么动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    //设置动画路径
    animation.values = @[@(DEGREES_TO_RADIANS(-2)),@(0),@(DEGREES_TO_RADIANS(2)),@(0)];
    //动画执行完删除动画
    animation.removedOnCompletion = YES;
    //动画执行完之后保存原始状态
    animation.fillMode = kCAFillModeBackwards;
    animation.duration = 0.15;
    animation.repeatCount = MAXFLOAT;
    [self addAnimation:animation forKey:@"tremble"];
}

@end
