//
//  DQDScrollContentView.h
//  DQDApp
//
//  Created by xzm on 16/10/18.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import <UIKit/UIKit.h>


/**-------------------------------------------------------------------------
 滑动视图item的配置模型
 */
@interface DQDScrollConfigModel : NSObject
/**标题*/
@property (nonatomic,copy)NSString *title;
/**数据源数组*/
@property (nonatomic,strong)NSMutableArray *dataArray;
/**偏移量缓存*/
@property (nonatomic,assign)CGFloat offsetY;
/**页码*/
@property (nonatomic,assign)NSInteger page;

@end


/**-------------------------------------------------------------------------
 滑动视图的item
 */
@interface DQDScrollContentItemView : UITableView
/**配置模型*/
@property (nonatomic,strong)DQDScrollConfigModel *configModel;

@end



/**-------------------------------------------------------------------------
 滑动视图数据源
 */
@protocol DQDScrollContentViewDataSource <NSObject>
@required
/**@return 标题数组*/
- (NSArray *)homeViewWithTitleArray;
/**@return 内容视图*/
- (DQDScrollContentItemView *)homeViewItemWithContentView;

@end



/**---------------------------------------------------------------------
 滑动视图
 */
@interface DQDScrollContentView : UIView
@property (nonatomic,weak)id <DQDScrollContentViewDataSource>dataSource;

@end
