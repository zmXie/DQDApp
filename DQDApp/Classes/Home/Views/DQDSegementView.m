//
//  DQDSegementView.m
//  DQDApp
//
//  Created by xzm on 16/10/17.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "DQDSegementView.h"

@interface DQDSegementView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    UICollectionView *_collectionV;
    UIView *_lineView;
    NSIndexPath *_selectIndexPath;
    NSIndexPath *_lastSelectIndexPath;
    NSMutableArray *_widthArray;
    CGFloat _itemMinWidth;
}

@end

@implementation DQDSegementView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame scrollEnabled:(BOOL)scrollEnabled{
    
    self = [self initWithFrame:frame];
    
    _collectionV.scrollEnabled = NO;
    
    return self;
}

#pragma mark -- privateMethod
- (void)setUp{
    _itemMinWidth = 55;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    _collectionV = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionV.showsHorizontalScrollIndicator = NO;
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    [_collectionV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"segementCell"];
    _collectionV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionV];
    
    [self addLineWithFrame:CGRectMake(0, self.height - 1, self.width, 1) color:[UIColor separatorColor]];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 4, _itemMinWidth, 4)];
    _lineView.backgroundColor = [UIColor NavigationColor];
    [_collectionV addSubview:_lineView];
    
    _selectIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    _lastSelectIndexPath = _selectIndexPath;
}

- (void)setTitleArray:(NSArray *)titleArray{
    
    _titleArray = titleArray;
    if (!_collectionV.scrollEnabled) {
        _itemMinWidth = self.width/_titleArray.count;
        _lineView.width = _itemMinWidth;
    }
    _widthArray = [NSMutableArray arrayWithCapacity:_titleArray.count];
    for (NSString *str in _titleArray) {
        
        CGFloat width = [AppTools widthOfString:str font:[UIFont systemFontOfSize:14] height:_collectionV.height];
        width += 12;
        width = MAX(_itemMinWidth, width);
        [_widthArray addObject:@(width)];
        
    }
    
    [_collectionV reloadData];
}

/**
 选中某一item
 
 @param index 索引
 */
- (void)selectItemToIndex:(NSInteger)index{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    if (_collectionV.scrollEnabled) {
        [_collectionV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }else{
        [_collectionV selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    
    _selectIndexPath = indexPath;
    
    [self resetChangeViews];
    
    if (!_collectionV.scrollEnabled && self.segementViewSelectBlock) {
        _segementViewSelectBlock(indexPath.item,_titleArray[indexPath.item]);
    }
    
}

- (void)resetChangeViews{
    
    UICollectionViewCell *lastCell = [_collectionV cellForItemAtIndexPath:_lastSelectIndexPath];
    if (lastCell) {
        UILabel *label = [lastCell.contentView viewWithTag:100];
        label.textColor = [UIColor darkGrayColor];
    }
    
    UICollectionViewCell *cell = [_collectionV cellForItemAtIndexPath:_selectIndexPath];
    if (cell) {
        UILabel *label = [cell.contentView viewWithTag:100];
        label.textColor = [UIColor NavigationColor];
        
        CGRect cellRect = [cell.contentView convertRect:cell.contentView.frame toView:self];
        [UIView animateWithDuration:0.1 animations:^{
        
            _lineView.width = cell.contentView.width;
            _lineView.left = cellRect.origin.x + _collectionV.contentOffset.x;
        }];
    }
    
    _lastSelectIndexPath = _selectIndexPath;
    
    if(self.titleArray.count > _selectIndexPath.item) _currentTitle =_titleArray[_selectIndexPath.item],_currentIndex = _selectIndexPath.item;
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _titleArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"segementCell" forIndexPath:indexPath];
    
    UILabel *label = [cell.contentView viewWithTag:100];
    if (!label) {
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, collectionView.height)];
        label.tag = 100;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    label.textColor = _selectIndexPath == indexPath?[UIColor NavigationColor]:[UIColor darkGrayColor];
    label.width = [_widthArray[indexPath.item] floatValue];
    label.text = _titleArray[indexPath.row];
    return cell;
}

#pragma mark -- UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake([_widthArray[indexPath.item] floatValue], collectionView.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self selectItemToIndex:indexPath.row];
    
    if (collectionView.scrollEnabled && self.segementViewSelectBlock) {
        _segementViewSelectBlock(indexPath.item,_titleArray[indexPath.item]);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    if (_selectIndexPath) [self resetChangeViews];
}

@end
