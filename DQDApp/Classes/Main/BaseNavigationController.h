//
//  BaseNavigationController.h
//  XTZApp
//
//  Created by xzm on 16/3/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController<UINavigationControllerDelegate,UIGestureRecognizerDelegate,UITabBarControllerDelegate>

//是否能手势返回,默认为YES
@property (nonatomic,assign) BOOL canDragBack;
//截图数组
@property (nonatomic,retain) NSMutableArray *screenShotsList;

/**
 pan手势回调

 @param recoginzer panGestureRecognizer
 */
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer;

@end
