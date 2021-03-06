//
//  DQDScrollContentView.m
//  DQDApp
//
//  Created by xzm on 16/10/18.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "DQDScrollContentView.h"
#import "DQDSegementView.h"

#pragma mark -------------- 滑动视图item的配置模型 ----------------
@implementation DQDScrollConfigModel


@end



#pragma mark ----------------滑动视图的item ----------------
@implementation DQDScrollContentItemView

- (void)setConfigModel:(DQDScrollConfigModel *)configModel{
    
    _configModel = configModel;
    
    [self setContentOffset:CGPointMake(0, _configModel.offsetY)];
    
    if(!self.configModel.dataArray)return;
    
    if (self.configModel.dataArray.count > 0){
        self.mj_footer.hidden = NO;
        [self reloadData];
    }else{
        [self.mj_header beginRefreshing];
    }
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    _configModel.offsetY = scrollView.contentOffset.y;
    _configModel.offsetY = MAX(_configModel.offsetY, 0);
    
}

@end



#pragma mark ---------------- 滑动视图 ----------------
@interface DQDScrollContentView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UIGestureRecognizerDelegate>{
    
    NSMutableArray *_configModelArray;
}

@property (nonatomic,strong)DQDSegementView *segementView;

@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation DQDScrollContentView

static const CGFloat DQDSegementViewHeight = 40;

#pragma mark -- lazzy
- (DQDSegementView *)segementView{
    
    if (!_segementView) {
        
        _segementView = [[DQDSegementView alloc]initWithFrame:CGRectMake(0, 0, kScreenWith, DQDSegementViewHeight)];
        WeakSelf
        _segementView.segementViewSelectBlock = ^(NSInteger index,NSString *title){
            
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        };
    }
    
    return _segementView;
}

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake(self.width, self.height - DQDSegementViewHeight);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, DQDSegementViewHeight, self.width, self.height - DQDSegementViewHeight) collectionViewLayout:flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.allowsSelection = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"contentCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        pan.delegate = self;
        [_collectionView addGestureRecognizer:pan];
        
    }
    
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    
    return self;
}

- (void)setUpUI{
    
    [self addSubview:self.segementView];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    NSArray *titleArray = [self.dataSource homeViewWithTitleArray];
    _configModelArray = [NSMutableArray arrayWithCapacity:titleArray.count];
    self.segementView.titleArray = titleArray;
   
    for (int i = 0; i < titleArray.count; i ++) {
        NSMutableArray *arr = [NSMutableArray array];
        DQDScrollConfigModel *configModel = [[DQDScrollConfigModel alloc]init];
        configModel.dataArray = arr;
        configModel.offsetY = 0;
        configModel.page = 0;
        configModel.title = titleArray[i];
        [_configModelArray addObject:configModel];
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    UIPanGestureRecognizer *pan =(UIPanGestureRecognizer *) gestureRecognizer;
    CGPoint point = [pan translationInView:pan.view];
    if (point.x < 0 || _collectionView.contentOffset.x > 0) {
        return NO;
    }else{
        return YES;
    }
}
- (void)panAction:(UIPanGestureRecognizer *)pan{
    
    [APPDelegate.contentVC panGesture:pan];
    
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _configModelArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"contentCell" forIndexPath:indexPath];
    
    DQDScrollContentItemView * itemView = [cell.contentView viewWithTag:200];
    if (!itemView) {
        
        itemView = [self.dataSource homeViewItemWithContentView];
        itemView.frame = cell.contentView.bounds;
        itemView.tag = 200;
        [cell.contentView addSubview:itemView];
    }
    itemView.configModel = _configModelArray[indexPath.item];

    return cell;
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/kScreenWith;
    
    [self.segementView selectItemToIndex:index];
}


@end
