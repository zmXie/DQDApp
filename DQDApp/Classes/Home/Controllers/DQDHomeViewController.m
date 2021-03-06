//
//  DQDHomeViewController.m
//  DQDApp
//
//  Created by xzm on 16/10/14.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "DQDHomeViewController.h"
#import "DQDScrollContentView.h"
#import "DQDHomeItemView.h"

@interface DQDHomeViewController ()<DQDScrollContentViewDataSource>{
    
    DQDScrollContentView *_contentView;
}

@end

@implementation DQDHomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpUI];
    
}

- (void)setUpUI{
    
    _contentView = [[DQDScrollContentView alloc]initWithFrame:CGRectMake(0, 0, kScreenWith, kScreenHeight - 64 - 49)];
    _contentView.dataSource = self;
    [self.view addSubview:_contentView];
}

#pragma mark --DQDScrollContentViewDataSource
- (NSArray *)homeViewWithTitleArray{
    
    return @[@"头条",@"圈子",@"懂球号",@"集锦",@"中超",@"专题",@"深度",@"足彩",@"闲情",@"视频",@"装备",@"英超",@"西甲",@"德甲",@"意甲",@"五洲"];
}

- (DQDScrollContentItemView *)homeViewItemWithContentView{
    
    DQDHomeItemView *homeItemView = [DQDHomeItemView new];
    return homeItemView;
}


@end
