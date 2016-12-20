//
//  UIViewController+NavigationBar.m
//  LXSZ
//
//  Created by xzm on 16/6/24.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import <objc/runtime.h>

const void *VCBar = &VCBar;
const void *VCBackBtn = &VCBackBtn;
const void *VCTitleLab = &VCTitleLab;

@implementation UIViewController (NavigationBar)

- (void)addCustomNavigationBar{
    
    UIView *bar = objc_getAssociatedObject(self, VCBar);
    UIButton *backBtn = objc_getAssociatedObject(self, VCBackBtn);
    UILabel *titleLab = objc_getAssociatedObject(self, VCTitleLab);
    
    if (bar == nil) {
        
        bar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWith, 64)];
        bar.backgroundColor = [UIColor whiteColor];
        bar.alpha = 0;
        [self.view addSubview:bar];
        self.bar = bar;
    }
    
    if (titleLab == nil) {
        
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 34, kScreenWith, 18)];
        titleLab.font = [UIFont systemFontOfSize:18];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:titleLab];
        self.titleLab = titleLab;
    }

    if (backBtn == nil) {
        
        backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 45, 44)];
        
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [backBtn setImage:[UIImage imageNamed:@"btn_008-1"] forState:UIControlStateNormal];
        
        [self.view addSubview:backBtn];
        self.backBtn = backBtn;

    }

    
}

- (void)setBar:(UIView *)bar{
    
    objc_setAssociatedObject(self, VCBar, bar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bar{
    
    return  objc_getAssociatedObject(self, VCBar);
}

- (void)setBackBtn:(UIButton *)backBtn{
    
    objc_setAssociatedObject(self, VCBackBtn, backBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)backBtn{
    
    return  objc_getAssociatedObject(self, VCBackBtn);
}

- (void)setTitleLab:(UILabel *)titleLab{
    
    objc_setAssociatedObject(self, VCTitleLab, titleLab, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)titleLab{
    
    return  objc_getAssociatedObject(self, VCTitleLab);
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
