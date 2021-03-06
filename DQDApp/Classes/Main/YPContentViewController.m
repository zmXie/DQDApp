//
//  YPContentViewController.m
//  SuperLink
//
//  Created by xzm on 16/10/13.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "YPContentViewController.h"

@implementation UIViewController (YPContentViewController)

-(YPContentViewController*)ypContentViewController{
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController != nil) {
        if([parentViewController isKindOfClass:[YPContentViewController class]]){
            return (YPContentViewController *)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}

@end

@interface YPContentViewController (){
    
    YPTransitionModel _transitionModel;
    //pan手势开始触摸位置
    CGFloat _startX;
    //centerView初始位置
    CGFloat _centerViewX;
}

@property (nonatomic,strong)UIControl *centerMask;

@end

@implementation YPContentViewController

CGFloat const YPContentDefaultAnimationTime = 0.2;
CGFloat const YPContentDefaultScalePersent = 0.8;
CGFloat const YPContentDefaultShadowRadius = 10.0f;
CGFloat const YPContentDefaultShadowOpacity = 0.8;

#pragma mark -- lazzy
- (UIControl *)centerMask{
    
    if (!_centerMask) {
        _centerMask = [[UIControl alloc]initWithFrame:self.centerViewController.view.bounds];
        _centerMask.backgroundColor = [UIColor clearColor];
        [_centerMask addTarget:self action:@selector(centerMaskClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _centerMask;
}

- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController
                          leftViewController:(UIViewController *)leftViewController
                             transitionModel:(YPTransitionModel)transitionModel{
    
    self = [super init];
    if (self) {
        
        self.centerViewController = centerViewController;
        self.leftViewController = leftViewController;
        self.leftWidthPersent = 0.8;
        self.showsShadow = YES;
        _side = YPSideCenter;
        _transitionModel = transitionModel;
        [self addChildViewController:self.centerViewController];
        [self addChildViewController:self.leftViewController];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpViews];
    
}

- (void)setUpViews{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.leftViewController.view.frame = CGRectMake(0, 0, kScreenWith*self.leftWidthPersent, kScreenHeight);
    
    [self.view addSubview:self.leftViewController.view];
    [self.view addSubview:self.centerViewController.view];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self.centerViewController.view addGestureRecognizer:pan];
}

- (void)setLeftWidthPersent:(CGFloat)leftWidthPersent{
    
    _leftWidthPersent = leftWidthPersent;
    self.leftViewController.view.width =  kScreenWith*self.leftWidthPersent;
}

#pragma mark -- PrivateMethod
- (void)panGesture:(UIPanGestureRecognizer *)pan{
    
    if (!pan) {
        [self restoreOpenState];
    }
    
    CGPoint touchPoint = [pan locationInView:[[UIApplication sharedApplication]keyWindow]];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _startX = touchPoint.x;
            _centerViewX = self.centerViewController.view.left;
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat currentX = MAX(_centerViewX + touchPoint.x - _startX, 0);
            currentX = MIN(currentX, self.leftViewController.view.width);
            self.centerViewController.view.left = currentX;
            if (_transitionModel == YPTransitionModelScale) {
                CGFloat currentPersent = 1-(1-YPContentDefaultScalePersent)*currentX/self.leftViewController.view.width;
                self.centerViewController.view.transform = CGAffineTransformMakeScale(currentPersent, currentPersent);
                self.centerViewController.view.top = kScreenHeight * (1-currentPersent)/2;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:{
            
            CGFloat minimumWidth = 50;
            if (self.side == YPSideLeft) {
                
                if ((touchPoint.x - _startX) < -minimumWidth){
                    [self closeLeftViewControllerWithAnimated:YES];
                }else{
                    [self openLeftViewControllerWithAnimated:YES];
                }
                
            }else{
                if ((touchPoint.x - _startX) > minimumWidth){
                    [self openLeftViewControllerWithAnimated:YES];
                }else{
                    [self closeLeftViewControllerWithAnimated:YES];
                }
            }
            
        }
            break;
        case UIGestureRecognizerStateCancelled:{
            
            [self restoreOpenState];
        }
            break;
    
        default:
            break;
    }
}

- (void)restoreOpenState{
    if (self.side == YPSideLeft) {
        
        [self closeLeftViewControllerWithAnimated:YES];
        
    }else{
        
        [self openLeftViewControllerWithAnimated:YES];
    }
}

- (void)centerMaskClick{
    
    [self closeLeftViewControllerWithAnimated:YES];
}

- (void)setShowsShadow:(BOOL)showsShadow{
    
    _showsShadow = showsShadow;
    [self updateShadowForCenterView];
}
/**
 更新阴影
 */
-(void)updateShadowForCenterView{
    UIView * centerView = self.centerViewController.view;
    if(self.showsShadow){
        centerView.layer.masksToBounds = NO;
        centerView.layer.shadowRadius = YPContentDefaultShadowRadius;
        centerView.layer.shadowOpacity = YPContentDefaultShadowOpacity;
        centerView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:centerView.bounds] CGPath];
    }
    else {
        centerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectNull].CGPath;
        centerView.layer.masksToBounds = YES;
    }
}
/**
 打开侧栏
 */
- (void)openLeftViewControllerWithAnimated:(BOOL)animated{
    CGFloat time = YPContentDefaultAnimationTime;
    if (!animated) time = 0;
    [UIView transitionWithView:self.centerViewController.view duration:time options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        if (_transitionModel == YPTransitionModelScale) {
            self.centerViewController.view.transform = CGAffineTransformMakeScale(YPContentDefaultScalePersent, YPContentDefaultScalePersent);
            self.centerViewController.view.top = kScreenHeight * (1-YPContentDefaultScalePersent)/2;
        }
        self.centerViewController.view.left = self.leftViewController.view.width;
        
    } completion:^(BOOL finished){
        
        _side = YPSideLeft;
        if (![self.centerViewController.view.subviews containsObject:self.centerMask])
            [self.centerViewController.view addSubview:self.centerMask];
        self.centerMask.hidden = NO;
    }];

}
/**
 关闭侧栏
 */
- (void)closeLeftViewControllerWithAnimated:(BOOL)animated{
    
    CGFloat time = YPContentDefaultAnimationTime;
    if (!animated) time = 0;
    [UIView transitionWithView:self.centerViewController.view duration:time options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (_transitionModel == YPTransitionModelScale) {
            self.centerViewController.view.transform = CGAffineTransformIdentity;
            self.centerViewController.view.top = 0;
        }
        self.centerViewController.view.left = 0;
        
    } completion:^(BOOL finished){
        
        _side = YPSideCenter;
        self.centerMask.hidden = YES;
    }];
}

@end
