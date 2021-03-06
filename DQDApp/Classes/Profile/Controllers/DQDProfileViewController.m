//
//  DQDProfileViewController.m
//  DQDApp
//
//  Created by xzm on 16/10/14.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "DQDProfileViewController.h"

@interface DQDProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,strong)UIView *headView;

@end

@implementation DQDProfileViewController

#pragma mark -- Lazzy
- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 49, self.view.width, 49)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        NSArray *titles = @[@"反馈",@"搜索",@"设置"];
        NSArray *images = @[@"NewSuggestIcon",@"NewSearchIcon",@"NewSettingIcon"];
        CGFloat width = _bottomView.width/titles.count;
        for (int i = 0; i < titles.count; i ++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(width*i, 0, width, _bottomView.height)];
            [btn setTitle:titles[i] forState:0];
            btn.tag = i;
            [btn setTitleColor:[UIColor blackColor] forState:0];
            [btn setImage:[UIImage imageNamed:images[i]] forState:0];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:btn];
        }
    }
    
    return _bottomView;
}

- (UIView *)headView{
    
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, i5Height(180))];
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:_headView.bounds];
        bgView.tag = 19;
        bgView.image = [UIImage imageNamed:@"DrawerUserBack"];
        bgView.userInteractionEnabled = YES;
        [_headView addSubview:bgView];
    }
    
    return _headView;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, kScreenHeight - self.bottomView.height) style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headView;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setUpUI];
}

- (void)setUpUI{
    
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomView];
    
    [self.view addLineWithFrame:CGRectMake(0, kScreenHeight - 49.5, self.view.width, 0.5) color:ColorWithRGB(200, 200, 200)];
}

#pragma mark -- 事件响应
- (void)bottomBtnClick:(UIButton *)btn{
    
    BaseViewController *vc = [BaseViewController new];
    switch (btn.tag) {
        case 0:
            vc.title = @"反馈";
            break;
        case 1:
            vc.title = @"搜索";
            break;
        case 2:
            vc.title = @"设置";
            break;
            
        default:
            break;
    }
    
    [self letCenterNavPushWithVC:vc];
}

- (void)letCenterNavPushWithVC:(UIViewController *)vc{
    
    _needOpen = YES;
    
    [(UINavigationController *)[(UITabBarController *)self.ypContentViewController.centerViewController selectedViewController] pushViewController:vc animated:NO];
    
    [self.ypContentViewController closeLeftViewControllerWithAnimated:YES];
}

#pragma mark -- tableViewDatasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 4;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"我的通知";
            cell.imageView.image = [UIImage imageNamed:@"NewGrayAt"];
            break;
        case 1:
            cell.textLabel.text = @"我的收藏";
            cell.imageView.image = [UIImage imageNamed:@"NewGrayCollect"];
            break;
        case 2:
            cell.textLabel.text = @"系统消息";
            cell.imageView.image = [UIImage imageNamed:@"NewGrayMessage"];
            break;
        case 3:
            cell.textLabel.text = @"我的订单";
            cell.imageView.image = [UIImage imageNamed:@"NewGrayOrder"];
            break;
            
        default:
            break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BaseViewController *vc = [BaseViewController new];
    switch (indexPath.row) {
        case 0:
            vc.title = @"我的通知";
            break;
        case 1:
            vc.title = @"我的收藏";
            break;
        case 2:
            vc.title = @"系统消息";
            break;
        case 3:
            vc.title = @"我的订单";
            break;
            
        default:
            break;
    }
    
    [self letCenterNavPushWithVC:vc];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    UIImageView *imageView = [self.headView viewWithTag:19];
    if (offsetY < 0) {
        imageView.frame = CGRectMake(0, offsetY, self.view.width, i5Height(180)-offsetY);
    }
}

@end
