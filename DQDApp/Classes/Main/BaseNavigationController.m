//
//  BaseNavigationController.m
//  XTZApp
//
//  Created by xzm on 16/3/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.delegate = self;
    
    WeakSelf;

    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        
    }
    
    
    self.navigationBar.translucent = NO;
    
//    //实力去黑线
//    [self.navigationBar setBackgroundImage:[AppTools createImageWithColor:ColorWithRGB(230, 230, 230)]  forBarMetrics:UIBarMetricsDefault];
//
//    [self.navigationBar setShadowImage:[UIImage new]];

    
    //设置标题形式
    
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor blackColor],
                                              NSForegroundColorAttributeName,
                                              [UIFont systemFontOfSize:18],
                                              NSFontAttributeName,
                                              nil];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置左边的返回按钮
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

        [btn setImage:[UIImage imageNamed:@"btn_008"] forState:UIControlStateNormal];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        
             UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        
        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer,leftItem];
        
    }
    
    [super pushViewController:viewController animated:animated];
    
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    

    return [super popViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        if (self.viewControllers.count > 1) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }else{
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    

}


-(void)back{
    
    [self popViewControllerAnimated:YES];

}

@end
