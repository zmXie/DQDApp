//
//  DQDLiveDetailViewController.m
//  DQDApp
//
//  Created by xzm on 16/10/20.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "DQDLiveDetailViewController.h"
#import "UIViewController+NavigationBar.h"

@interface DQDLiveDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,weak)UITableView *tableView;

@end

@implementation DQDLiveDetailViewController

#pragma mark -- lazzy
- (UIView *)headView{
    
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, i5Height(180))];
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:_headView.bounds];
        bgView.tag = 19;
        bgView.image = [UIImage imageNamed:@"matchTopBack"];
        bgView.userInteractionEnabled = YES;
        [_headView addSubview:bgView];
    }
    
    return _headView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpUI];

}

- (void)setUpUI{
    
    [self.view addSubview:self.headView];
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headView.bottom, kScreenWith, kScreenHeight - self.headView.bottom) style:UITableViewStylePlain];
    [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tb.delegate = self;
    tb.dataSource = self;
    [self.view addSubview:tb];

    [self addCustomNavigationBar];
    self.bar.backgroundColor = [UIColor clearColor];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = @"哈哈😝";
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController pushViewController:[BaseViewController new] animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
