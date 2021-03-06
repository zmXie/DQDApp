//
//  DQDLiveViewController.m
//  DQDApp
//
//  Created by xzm on 16/10/14.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "DQDLiveViewController.h"
#import "DQDLiveItemView.h"
@interface DQDLiveViewController ()<DQDScrollContentViewDataSource>

@end

@implementation DQDLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    
}

- (void)setUpUI{
    
    DQDScrollContentView *contentView = [[DQDScrollContentView alloc]initWithFrame:CGRectMake(0, 0, kScreenWith, kScreenHeight - 64 - 49)];
    contentView.dataSource = self;
    [self.view addSubview:contentView];
}

#pragma mark --DQDScrollContentViewDataSource
- (NSArray *)homeViewWithTitleArray{
    
    return @[@"重要",@"关注",@"足彩",@"节目",@"中超",@"英超",@"西甲",@"德甲",@"意甲"];
}

- (DQDScrollContentItemView *)homeViewItemWithContentView{
    
    DQDLiveItemView *contentItemView = [[DQDLiveItemView alloc]init];
    return contentItemView;
}

@end
