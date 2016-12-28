//
//  BaseViewController.m
//  XTZApp
//
//  Created by user on 15/9/12.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.navigationController &&self.navigationController.viewControllers.count == 1) {
        
        UIButton *headBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [headBtn setImage:[UIImage imageNamed:@"header"] forState:0];
        headBtn.layer.cornerRadius = headBtn.height/2.f;
        headBtn.layer.masksToBounds = YES;
        [headBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:headBtn];
        self.navigationItem.leftBarButtonItem = item;
    }
     
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
}

#pragma mark -- priviteMethod
- (void)leftAction{
    
    if (self.ypContentViewController.side == YPSideLeft) {
        [self.ypContentViewController closeLeftViewControllerWithAnimated:YES];
    }else{
        [self.ypContentViewController openLeftViewControllerWithAnimated:YES];
    }
    
}

- (void)dealloc
{
    NSLog(@"%@死了！！",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
