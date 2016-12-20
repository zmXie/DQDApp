//
//  UIView+PickView.h
//  LXSZ
//
//  Created by xzm on 16/6/29.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PickView)

/**
 *
 *
 *  @param dataArr 二维数组@[   @["深圳","广州"],   @{"深圳":["南山","罗湖"], "广州":@[]} ,   @{"南山":["白石洲","世界之窗"],  "罗湖":@[]    ]   二维数组里面最多三个元素！！传多了也没用
 *  @param block   返回结果，最后一级选中的字符串
 */

- (void)showPickerWithDataArr:(NSArray *)dataArr
                  finishBlock:(void(^)(NSString *result))block;


@property (nonatomic,strong)UILabel *pickTitleLabel;

@end
