//
//  DQDSegementView.h
//  DQDApp
//
//  Created by xzm on 16/10/17.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQDSegementView : UIView

@property (nonatomic,strong)NSArray *titleArray;

@property (nonatomic,copy)NSString *currentTitle;

@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,copy)void(^segementViewSelectBlock)(NSInteger index,NSString *title);

/**
 选中某一item

 @param index 索引
 */
- (void)selectItemToIndex:(NSInteger)index;


/**
 是否可以滑动，如果不可以则contentSize为bound.size,每个item的宽度均分。

 @param frame    坐标
 @param scrollEnabled 是否可以滑动

 @return DQDSegementView
 */
- (instancetype)initWithFrame:(CGRect)frame scrollEnabled:(BOOL)scrollEnabled;

@end
