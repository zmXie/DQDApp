//
//  TabBarViewController.m
//  XTZApp
//
//  Created by xzm on 16/3/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "OrderViewController.h"
#import "ProfileViewController.h"
#import "CustomerViewController.h"

@interface TabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation TabBarViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.homeVC = [[HomeViewController alloc]init];
    
    [self addChildVC:self.homeVC title:@"首页" image:@"sy" selectImage:@"sy_select"];
    
    [self addChildVC:[[OrderViewController alloc]init] title:@"订单" image:@"dd" selectImage:@"dd_select"];
    
//    [self addChildVC:[[CustomerViewController alloc]init] title:@"客服" image:@"kf" selectImage:@"kf_select"];
    
    [self addChildVC:[[ProfileViewController alloc]init] title:@"我的" image:@"wd" selectImage:@"wd_select"];
    
}

-(void)addChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)imageStr selectImage:(NSString *)selectImageStr{
    
    vc.title = title;
    
    vc.tabBarItem.image = [[UIImage imageNamed:imageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; //使用原始图片  忽略渲染效果
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor main_BlueColor];
    
    [vc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
    
}

#pragma mark -- TabbarDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){

    if([UserInfo sharedUserInfo].token.length==0){
        
        if(viewController==tabBarController.viewControllers[1]){
            
            [self showAlertGoLoginVCtrlWithCancleBlock:nil];
            
            return NO;
        }
        
    }
    
    return YES;
}


@end
