//
//  DQDDataViewController.m
//  DQDApp
//
//  Created by xzm on 16/10/14.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "DQDDataViewController.h"
#import "DQDScrollContentView.h"
#import "DQDDataItemView.h"

@interface DQDDataViewController ()<DQDScrollContentViewDataSource>

@end

@implementation DQDDataViewController

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
    
    return @[@"中超",@"英超",@"西甲",@"德甲",@"意甲",@"世亚预",@"世欧预",@"欧冠",@"中甲",@"法甲",@"亚冠",@"欧联",@"足协杯",@"足总杯",@"国王杯",@"德国杯",@"英联赛杯",@"意大利杯",@"南美预选",@"世非杯",@"FIFA排名",@"欧战积分",@"中乙",@"英冠",@"苏超",@"荷甲",@"葡超",@"意乙",@"西乙",@"德乙",@"法乙",@"俄超",@"土超",@"日职",@"港超",@"K联赛",@"美职",@"阿甲",@"解放者杯",@"巴甲",@"丹超",@"芬超",@"瑞典超",@"澳甲",@"比甲",@"希腊超",@"奥运男足",@"奥运女足",@"美洲杯",@"世界杯"];
}

- (DQDScrollContentItemView *)homeViewItemWithContentView{
    
    DQDDataItemView *contentItemView = [[DQDDataItemView alloc]init];
    return contentItemView;
}
@end
