//
//  UIView+UIViewController.m
//  DQDApp
//
//  Created by xzm on 16/10/17.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)

- (UIViewController *)viewController{
    
    id next = [self nextResponder];
    while (![next isKindOfClass:[UIViewController class]]) {
        next = [next nextResponder];
    }
    
    return next;
}
@end
