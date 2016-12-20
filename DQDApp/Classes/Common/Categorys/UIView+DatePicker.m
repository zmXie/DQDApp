//
//  UIView+DatePicker.m
//  LXSZ
//
//  Created by xzm on 16/6/22.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "UIView+DatePicker.h"
#import <objc/runtime.h>

const void *DatePickerControl = &DatePickerControl;
const void *DateFinishBlock = &DateFinishBlock;

@interface UIView ()

@property (nonatomic,strong)UIDatePicker *datePicker;

@end

@implementation UIView (DatePicker)

- (void)showDatePickerWithFinishBlock:(void(^)(NSDate *date))block{
    
    [self showDatePickerWithDate:nil finishBlock:block];
}

- (void)showDatePickerWithDate:(NSDate *)date finishBlock:(void(^)(NSDate *date))block{
    
    objc_setAssociatedObject(self, DateFinishBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    self.datePickControl.hidden = NO;
    
    if (date != nil) {
        
        [self.datePicker setDate:date animated:YES];
    }
    
    UIView *bgView = [self.datePickControl viewWithTag:200];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        bgView.bottom = kScreenHeight;
    }];
}

- (UIControl *)datePickControl{
    
    UIControl *datePickControl = objc_getAssociatedObject(self, DatePickerControl);
    
    if (datePickControl == nil) {
        
        datePickControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, kScreenWith, kScreenHeight)];
        datePickControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [datePickControl addTarget:self action:@selector(datePickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.window addSubview:datePickControl];
        
        objc_setAssociatedObject(self, DatePickerControl, datePickControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWith, autoScaleH(200)+50)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.tag = 200;
        [datePickControl addSubview:bgView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 120, 40)];
        label.text = @"请选择日期";
        label.textColor = [UIColor grayColor];
        [bgView addSubview:label];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor main_BlueColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(kScreenWith-20-50, 0, 50, 40);
        [button addTarget: self action:@selector(datePickAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UIDatePicker *datePick = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, kScreenWith, autoScaleH(200))];
        datePick.tag = 300;
        datePick.datePickerMode = UIDatePickerModeDate;
        [bgView addSubview:datePick];
    }
    
    return datePickControl;
}

- (void)datePickAction{
    
    UIView *bgView = [self.datePickControl viewWithTag:200];
    
    void (^ block)(NSDate *date) = objc_getAssociatedObject(self, DateFinishBlock);
    
    [UIView animateWithDuration:0.2 animations:^{
        
        bgView.top = kScreenHeight;
        
    }completion:^(BOOL finished) {
        
        self.datePickControl.hidden = YES;
        
        block(self.datePicker.date);
    }];
}

- (UIDatePicker *)datePicker{
    
    return [self.datePickControl viewWithTag:300];
    
}

@end
