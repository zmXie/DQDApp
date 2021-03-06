//
//  DQDDataItemView.m
//  DQDApp
//
//  Created by xzm on 16/10/20.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "DQDDataItemView.h"
#import "DQDDataDetailViewController.h"

@implementation DQDDataItemView

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        [self setUp];
    }
    
    return self;
}

#pragma mark -- privateMethod
- (void)setUp{
    
    self.delegate = self;
    self.dataSource = self;
    
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.configModel.page = 0;
        [self setUpData];
    }];
    
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.configModel.page ++;
        [self setUpData];
    }];
    
    self.mj_footer.hidden = YES;
    
}


- (void)setUpData{
    NSLog(@"%@,%ld",self.configModel.title,(long)self.configModel.page);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.configModel.page == 0) {
            [self.configModel.dataArray removeAllObjects];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (int i =  0; i < 10; i ++) {
                
                [self.configModel.dataArray addObject:self.configModel.title];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.mj_footer.hidden = self.configModel.dataArray.count==0?YES:NO;
                
                [self reloadData];
                [self.mj_header endRefreshing];
                [self.mj_footer endRefreshing];
            });
            
        });
        
    });
}

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.configModel.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //根据数据模型来确定不同的重用符即可
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.configModel.dataArray.count > indexPath.row) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@",(long)indexPath.row,self.configModel.dataArray[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DQDDataDetailViewController *vc = [DQDDataDetailViewController new];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
