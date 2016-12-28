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
        bar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self.view addSubview:bar];
        
    }
    
    
    if (titleLab == nil) {
        
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 34, kScreenWith, 18)];
        titleLab.font = [UIFont systemFontOfSize:18];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [bar addSubview:titleLab];
        
    }

    if (backBtn == nil) {
        
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 70, 44)];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"btn_back_pressed"] forState:UIControlStateSelected];
        [backBtn setTitle:@"返回" forState:0];
        [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 15)];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [bar addSubview:backBtn];

    }
    
    self.bar = bar;
    self.titleLab = titleLab;
    self.backBtn = backBtn;
    
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
