//
//  TabBarViewController.m
//  XTZApp
//
//  Created by xzm on 16/3/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "TabBarViewController.h"
#import "DQDDataViewController.h"
#import "DQDHomeViewController.h"
#import "DQDLiveViewController.h"
#import "DQDRecommendViewController.h"
#import "BaseNavigationController.h"

@interface TabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation TabBarViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self addChildVC:[[DQDHomeViewController alloc]init] title:@"首页" image:@"news_normal" selectImage:@"news_press"];
    
    [self addChildVC:[[DQDLiveViewController alloc]init] title:@"直播" image:@"game_normal" selectImage:@"game_press"];
    
    [self addChildVC:[[DQDRecommendViewController alloc]init] title:@"推荐" image:@"circle_normal" selectImage:@"circle_press"];
    
    [self addChildVC:[[DQDDataViewController alloc]init] title:@"数据" image:@"date_normal" selectImage:@"date_press"];
    
}

-(void)addChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)imageStr selectImage:(NSString *)selectImageStr{
    
    vc.title = title;
    
    vc.tabBarItem.image = [[UIImage imageNamed:imageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; //使用原始图片  忽略渲染效果
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor NavigationColor];
    
    [vc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
    
}

#pragma mark -- TabbarDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){

    return YES;
}


@end
