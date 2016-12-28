//
//  UIViewController+NavigationBar.h
//  LXSZ
//
//  Created by xzm on 16/6/24.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBar)

- (void)addCustomNavigationBar;

@property (nonatomic,weak)UIView *bar;

@property (nonatomic,weak)UIButton *backBtn;

@property (nonatomic,weak)UILabel *titleLab;

@end
