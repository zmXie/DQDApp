//
//  UIView+DatePicker.h
//  LXSZ
//
//  Created by xzm on 16/6/22.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DatePicker)

- (void)showDatePickerWithFinishBlock:(void(^)(NSDate *date))block;

- (void)showDatePickerWithDate:(NSDate *)date finishBlock:(void(^)(NSDate *date))block;

@end
