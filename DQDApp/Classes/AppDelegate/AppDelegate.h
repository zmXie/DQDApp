//
//  AppDelegate.h
//  DQDApp
//
//  Created by xzm on 16/10/14.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APPDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong)YPContentViewController *contentVC;
@end

