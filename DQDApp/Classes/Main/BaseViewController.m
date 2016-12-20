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
        
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (self.navigationController == APPDelegate.tabbarVC.viewControllers[0] || self.navigationController == APPDelegate.tabbarVC.viewControllers[2]) {
        
        if (self.navigationController.viewControllers.count > 1) {
            
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }else{
            
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
