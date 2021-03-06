//
//  DQDDataDetailViewController.m
//  DQDApp
//
//  Created by xzm on 16/10/26.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "DQDDataDetailViewController.h"
#import "UIViewController+NavigationBar.h"
#import "BaseNavigationController.h"
#import "DQDSegementView.h"
#import <objc/runtime.h>

@interface UIScrollView (title)

@property (nonatomic,copy)NSString *title;

@end

const void *DQDScrollView_Title = &DQDScrollView_Title;

@implementation UIScrollView (title)

- (void)setTitle:(NSString *)title{
    
    objc_setAssociatedObject(self, (void *)&DQDScrollView_Title, title, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)title{
    
    return objc_getAssociatedObject(self, DQDScrollView_Title);
}

@end

@interface DQDDataDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    
    CGFloat _contentInsetTop; //顶部偏移
}

@property (nonatomic,strong)UIImageView *headView;
@property (nonatomic,strong)DQDSegementView *segementView; //顶部切换栏
@property (nonatomic,strong)UIScrollView *bgContentView; //底部承载视图
@property (nonatomic,weak)UIScrollView *currentContentView; //当前的内容视图
@property (nonatomic,strong)NSMutableArray *contentViewsArray; //内容视图数组
@end

@implementation DQDDataDetailViewController

const void *DQDScrollView_ContentOffSet_Observer = &DQDScrollView_ContentOffSet_Observer;
const void *DQDSegementView_Frame_Observer = &DQDSegementView_Frame_Observer;

#pragma mark -- lazzy
- (NSMutableArray *)contentViewsArray{
    
    if (!_contentViewsArray) {
        _contentViewsArray = [NSMutableArray array];
    }
    return _contentViewsArray;
}
- (UIView *)headView{
    
    if (!_headView) {
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, i5Height(180))];
        _headView.image = [UIImage imageNamed:@"newTeamTopBack"];
        _headView.userInteractionEnabled = YES;
    }
    
    return _headView;
}
- (UIScrollView *)bgContentView{
    
    if (!_bgContentView) {
        _bgContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWith, kScreenHeight)];
        _bgContentView.showsHorizontalScrollIndicator = NO;
        _bgContentView.bounces = NO;
        _bgContentView.pagingEnabled = YES;
        _bgContentView.delegate = self;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        pan.delegate = self;
        [_bgContentView addGestureRecognizer:pan];
    }
    
    return _bgContentView;
}
- (DQDSegementView *)segementView{
    
    if (!_segementView) {
        _segementView = [[DQDSegementView alloc]initWithFrame:CGRectMake(0, self.headView.bottom, self.view.width, 40) scrollEnabled:NO];
        
        _segementView.titleArray = @[@"动态",@"赛程",@"球员",@"资料"];
        
        [self creatContentViews];
        
        WeakSelf
        _segementView.segementViewSelectBlock = ^(NSInteger index,NSString *title){
            
            [weakSelf handleSubViewsWithTarget:weakSelf];
            
        };
        
         [self.segementView addObserver:self forKeyPath:NSStringFromSelector(@selector(frame)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&DQDSegementView_Frame_Observer];
    }
    
    return _segementView;
}

#pragma mark -- 生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpData];
    
    [self setUpUI];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark -- private Method
- (void)setUpData{
    
    
}
- (void)setUpUI{
    
    [self.view addSubview:self.bgContentView];

    [self.view addSubview:self.headView];
    
    [self.view addSubview:self.segementView];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.segementView selectItemToIndex:1];
        
    });
    
    [self addCustomNavigationBar];
    
    self.titleLab.text = @"球队";
}
/**
 创建子视图
 */
- (void)creatContentViews{
    
    self.bgContentView.contentSize = CGSizeMake(kScreenWith*_segementView.titleArray.count, kScreenHeight);
    
    [_segementView.titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWith, kScreenHeight) style:UITableViewStyleGrouped];
        tb.title = obj;
        if ([tb.title isEqualToString:@"资料"] ) {
            [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"%@0",obj]];
            [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"%@1",obj]];
        }else{
            [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:obj];
        }
        tb.delegate = self;
        tb.dataSource = self;
        tb.tableFooterView = [UIView new];
        
        [self.contentViewsArray addObject:tb];
        _contentInsetTop = self.segementView.bottom;
        tb.contentInset = UIEdgeInsetsMake(_contentInsetTop, 0, 0, 0);
        [tb setContentOffset:CGPointMake(0, -_contentInsetTop)];
        tb.left = idx*kScreenWith;
        [self.bgContentView addSubview:tb];
        
    }];
}
/**
 处理子视图切换

 @param vc    当前控制器
 */
- (void)handleSubViewsWithTarget:(DQDDataDetailViewController *)vc {
    
    if (vc.currentContentView) {
        [vc removeObseverForDataDetailController:vc all:NO];
        [self.currentContentView setContentOffset:CGPointMake(0, -self.segementView.bottom)];
//        [vc.currentContentView removeFromSuperview];
    }
    [self.bgContentView setContentOffset:CGPointMake(vc.segementView.currentIndex*kScreenWith, 0)];
    
    UIScrollView *view = vc.contentViewsArray[vc.segementView.currentIndex];
    vc.currentContentView = view;
    /*     底部不添加bgContentView的时候，记录偏移量
//    [vc.view insertSubview:view atIndex:0];
//    CGFloat offsetY = self.currentContentView.contentOffset.y + _contentInsetTop;
//    CGFloat gradH = self.headView.height - self.bar.height;
//    if (self.segementView.top != self.headView.height) { //偏移量不为0
//        if (offsetY >= 0 && offsetY <= gradH) { //偏移量大于0，且能看到头视图
//            [self.currentContentView setContentOffset:CGPointMake(0, -self.segementView.bottom)];
//        }
//    }else{//偏移量为0的时候
//        [self.currentContentView setContentOffset:CGPointMake(0, -self.segementView.bottom)];
//    }
     */
    [self.currentContentView setContentOffset:CGPointMake(0, -self.segementView.bottom)];

    [vc addObserverForDataDetailController:vc];
}

/**
 处理手势冲突
 
 @param pan pan
 */
- (void)panAction:(UIPanGestureRecognizer *)pan{
    
    [(BaseNavigationController *)self.navigationController paningGestureReceive:pan];
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    UIPanGestureRecognizer *pan =(UIPanGestureRecognizer *) gestureRecognizer;
    CGPoint point = [pan translationInView:pan.view];
    if (point.x < 0 || _bgContentView.contentOffset.x > 0) {
        return NO;
    }else{
        return YES;
    }
}

/**
 获取标题

 @param section 区
 */
- (NSString *)titleWithSection:(NSInteger)section tableView:(UITableView *)tableView{
    NSString *title;
    if ([tableView.title isEqualToString:@"赛程"]) {
        title = @"  2016-10-27";
    }else if ([tableView.title isEqualToString:@"球员"]){
        switch (section) {
            case 0:
                title = @"  教练";
                break;
            case 1:
                title = @"  前锋";
                break;
            case 2:
                title = @"  中场";
                break;
            case 3:
                title = @"  后卫";
                break;
            case 4:
                title = @"  门卫";
                break;
                
            default:
                break;
        }
    }else if ([tableView.title isEqualToString:@"资料"]){
        if(section == 0){
            title = @"  基本资料";
        }else{
            title = @"  荣誉记录";
        }
    }
    return title;
}

#pragma mark -- UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if ([tableView.title isEqualToString:@"动态"]) {
        return 1;
    }else if ([tableView.title isEqualToString:@"赛程"]){
        return 5;
    }else if ([tableView.title isEqualToString:@"球员"]){
        return 5;
    }else{
        return 2;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView.title isEqualToString:@"动态"]) {
        return 20;
    }else if ([tableView.title isEqualToString:@"赛程"]){
        return 5;
    }else if ([tableView.title isEqualToString:@"球员"]){
        return 4;
    }else{
        return 3;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identify = [tableView.title isEqualToString:@"资料"] ? [NSString stringWithFormat:@"%@%ld",tableView.title,(long)indexPath.section] : tableView.title;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld%@😝",(long)indexPath.row,tableView.title];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView.title isEqualToString:@"球员"])return 60;
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([tableView.title isEqualToString:@"动态"]) {
        return 0.1;
    }
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([tableView.title isEqualToString:@"动态"]) {
        
        return nil;
    }else{
       
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWith, 25)];
        label.backgroundColor = [UIColor backgroundGrayColor];
        label.textColor = [UIColor darkGrayColor];
        label.text = [self titleWithSection:section tableView:tableView];
        label.adjustsFontSizeToFitWidth = YES;
        return label;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -- KVO
-(void)addObserverForDataDetailController:(DQDDataDetailViewController *)controller
{
    if (self.currentContentView != nil) {
        [self.currentContentView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&DQDScrollView_ContentOffSet_Observer];
    }
}

-(void)removeObseverForDataDetailController:(DQDDataDetailViewController *)controller all:(BOOL)all
{
    if (self.currentContentView != nil) {
        @try {
            [self.currentContentView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
        }
        @catch (NSException *exception) {
            NSLog(@"exception ==== %@",exception);
        }
        @finally {
            
        }
    }
    if (all) {
        @try {
            [self.segementView removeObserver:self forKeyPath:NSStringFromSelector(@selector(frame))];
        }
        @catch (NSException *exception) {
            NSLog(@"exception ==== %@",exception);
        }
        @finally {
            
        }
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    
    if (object == self.currentContentView && [keyPath isEqualToString:@"contentOffset"]) {
        
        CGFloat offsetY = self.currentContentView.contentOffset.y + _contentInsetTop;
        CGFloat gradH = self.headView.height - self.bar.height;
        
        if (offsetY < 0) {
            self.bar.backgroundColor = ColorWithRGBA(0, 0, 0, 0.2);
            
            self.headView.frame = CGRectMake(0, 0, self.view.width, i5Height(180)-offsetY);
            self.segementView.top = self.headView.bottom;
        }else if (offsetY <= gradH){
            CGFloat persent = offsetY/gradH;
            self.bar.backgroundColor = ColorWithRGBA(38*persent, 170*persent, 66*persent, 0.2+persent*0.8);
            self.titleLab.text = @"球队";
            
            self.headView.top = -offsetY;
            self.segementView.top = self.headView.bottom;
        }else{
            self.bar.backgroundColor = [UIColor NavigationColor];
            self.titleLab.text = @"巴塞罗那";
            
            self.headView.top = -offsetY;
            self.segementView.top = self.bar.height;
        }
        
    }else if (object == self.segementView && [keyPath isEqualToString:@"frame"]){
        
        //当segemeget位置变化时，同步scrollView的contentoffet；
        [self.contentViewsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj != self.currentContentView) {
                [(UIScrollView *)obj setContentOffset:CGPointMake(0, -self.segementView.bottom)];
            }
        }];
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.bgContentView) {
        
        NSInteger index = scrollView.contentOffset.x/kScreenWith;
        
        [self.segementView selectItemToIndex:index];
        
    }
}

#pragma mark -- dealloc
- (void)dealloc
{
    [self removeObseverForDataDetailController:self all:YES];
}


@end
