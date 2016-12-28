//
//  BaseNavigationController.m
//  XTZApp
//
//  Created by xzm on 16/3/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "BaseNavigationController.h"
#import "DQDProfileViewController.h"

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]

@interface BaseNavigationController (){
    
    CGPoint startTouch;
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}

@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,assign) BOOL isMoving;

@end

@implementation BaseNavigationController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.screenShotsList = [NSMutableArray array];
        self.canDragBack = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.delegate = self;
    self.navigationBar.translucent = NO;
//    //实力去黑线
//    [self.navigationBar setBackgroundImage:[AppTools createImageWithColor:[UIColor NavigationColor]]  forBarMetrics:UIBarMetricsDefault];
//
//    [self.navigationBar setShadowImage:[UIImage new]];
    //设置标题形式
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor whiteColor],
                                              NSForegroundColorAttributeName,
                                              [UIFont systemFontOfSize:18],
                                              NSFontAttributeName,
                                              nil];
    self.navigationBar.barTintColor = [UIColor NavigationColor];

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
    
    
    
}

#pragma mark -- UINavigationControllerDelegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    [self.screenShotsList addObject:[self capture]];
    
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置左边的返回按钮
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_back_pressed"] forState:UIControlStateSelected];
        [btn setTitle:@"返回" forState:0];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 15)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
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
    
    [self.screenShotsList removeLastObject];
    if (self.viewControllers.count <= 2) {
        
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
        DQDProfileViewController *leftVC = (DQDProfileViewController *)APPDelegate.contentVC.leftViewController;
        if (leftVC.needOpen) {
            [APPDelegate.contentVC openLeftViewControllerWithAnimated:animated];
            leftVC.needOpen = NO;
        }
    }
    
    return [super popViewControllerAnimated:animated];
}

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.viewControllers.count <= 1 || !self.canDragBack) return NO;
    
    return YES;
}

#pragma mark -- priviteMethod
-(void)back{
        
    [self popViewControllerAnimated:YES];

}

- (UIImage *)capture
{

    UIWindow *screenWindow = APPDelegate.window;
    
    UIGraphicsBeginImageContextWithOptions(screenWindow.bounds.size, screenWindow.opaque, 0.0);
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
        
    return viewImage;
}

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            self.backgroundView.backgroundColor = [UIColor blackColor];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:kScreenWith];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }else if (recoginzer.state == UIGestureRecognizerStateChanged){
        
#warning 滑动隐藏键盘
        if (touchPoint.y - startTouch.y != 0) {
            [self.view endEditing:YES];
        }
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

- (void)moveViewWithX:(float)x
{
    x = MIN(kScreenWith, x);
    x = MAX(x, 0);
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/(20*[UIScreen mainScreen].bounds.size.width))+0.95;
    float alpha = 0.4 - (x/800);
    
    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    blackMask.alpha = alpha;
    
}


@end
