//
//  DQDRecommendViewController.m
//  DQDApp
//
//  Created by xzm on 16/10/14.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "DQDRecommendViewController.h"

@interface DQDRecommendTableView : UITableView

@property (nonatomic,assign)NSInteger page;

@end

@implementation DQDRecommendTableView

@end


@interface DQDRecommendViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UIButton *_lastBtn;
    NSMutableArray *_freeData;
    NSMutableArray *_expertData;
}

@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,weak)DQDRecommendTableView *currentTableView;

@property (nonatomic,weak)NSMutableArray *currentData;

@end

@implementation DQDRecommendViewController

#pragma mark -- lazzy
- (UIView *)topView{
    
    if (!_topView) {
        
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWith, 40)];
        [_topView addLineWithFrame:CGRectMake(0, _topView.height-1, kScreenWith, 1) color:[UIColor separatorColor]];
        UIView *scrollLine = [[UIView alloc]initWithFrame:CGRectMake(0, _topView.bottom - 3, _topView.width/2.f, 3)];
        scrollLine.tag = 88;
        scrollLine.backgroundColor = [UIColor NavigationColor];
        
        for (int i = 0; i < 2; i ++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(scrollLine.width*i, 0, scrollLine.width, _topView.height-1)];
            btn.tag = 100+i;
            [btn setTitle:i==0?@"免费推荐":@"专家推荐" forState:0];
            [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor darkGrayColor] forState:0];
            [btn setTitleColor:[UIColor NavigationColor] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.selected = i==0?YES:NO;
            if(i == 0)_lastBtn = btn;
            [_topView addSubview:btn];
        }
        
        [_topView addSubview:scrollLine];
    }
    
    return _topView;
}

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.topView.height, kScreenWith, kScreenHeight - self.topView.bottom - 49 - 64)];
        _scrollView.contentSize = CGSizeMake(_scrollView.width*2, _scrollView.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [_scrollView.panGestureRecognizer addTarget:self action:@selector(panCallBack:)];
        
        for (int i = 0; i < 2; i ++) {
            DQDRecommendTableView *tbv = [[DQDRecommendTableView alloc]initWithFrame:CGRectMake(_scrollView.width*i, 0, _scrollView.width, _scrollView.height) style:UITableViewStylePlain];
            tbv.tag = 200+i;
            tbv.delegate = self;
            tbv.dataSource = self;
            [tbv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
            __weak typeof(tbv) weakTbv = tbv;
            tbv.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                weakTbv.page = 0;
                [self requestData];
            }];
            tbv.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                weakTbv.page ++;
                [self requestData];
            }];
            tbv.mj_footer.hidden = YES;
            if(i == 0)self.currentTableView = tbv;
            [_scrollView addSubview:tbv];
        }
    }
    
    return _scrollView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpUI];
    
    [self setUpData];
}

- (void)setUpUI{
    
    [self.view addSubview:self.topView];
    
    [self.view addSubview:self.scrollView];
}

- (void)setUpData{
    
    self.currentData = _freeData = [NSMutableArray array];
    _expertData = [NSMutableArray array];
    
    [self.currentTableView.mj_header beginRefreshing];
}

#pragma mark -- 事件响应
- (void)topBtnClick:(UIButton *)btn{
    _lastBtn.selected = NO;
    btn.selected = YES;
    _lastBtn = btn;
    UIView *line = [_topView viewWithTag:88];
    [UIView animateWithDuration:0.25 animations:^{
        line.left = btn.left;
        [_scrollView setContentOffset:CGPointMake(line.left*2, 0) animated:NO];
    }completion:^(BOOL finished) {
        
        self.currentTableView = [_scrollView viewWithTag:btn.tag+100];
        self.currentData = line.left ==0?_freeData:_expertData;
        if (self.currentData.count == 0) {
            [self.currentTableView.mj_header beginRefreshing];
        }
    }];
    
}

- (void)panCallBack:(UIPanGestureRecognizer *)pan{
    
    if (_scrollView.contentOffset.x <= 0) {
        [self.ypContentViewController panGesture:pan];
    }
}

- (void)requestData{
    NSLog(@"page == %ld",(long)self.currentTableView.page);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.currentTableView.page == 0) {
            [self.currentData removeAllObjects];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (int i =  0; i < 10; i ++) {
                
                [self.currentData addObject:_scrollView.contentOffset.x==0?@"免费推荐":@"专家推荐"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentTableView.mj_footer.hidden = self.currentData.count==0?YES:NO;
                [self.currentTableView reloadData];
                [self.currentTableView.mj_header endRefreshing];
                [self.currentTableView.mj_footer endRefreshing];
            });
            
        });
    });
}

#pragma mark -- UITableViewDataSource &delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.currentData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@",(long)indexPath.row,self.currentData[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:[BaseViewController new] animated:YES];
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _scrollView) {
        NSInteger index = scrollView.contentOffset.x/kScreenWith;
        
        [self topBtnClick:[self.topView viewWithTag:100+index]];
    }
    
}

@end
