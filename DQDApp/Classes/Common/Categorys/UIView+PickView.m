//
//  UIView+PickView.m
//  LXSZ
//
//  Created by xzm on 16/6/29.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "UIView+PickView.h"
#import <objc/runtime.h>
@interface UIView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)NSArray *arr;

@property (nonatomic,copy)NSString *lastStr;

@property (nonatomic,copy)NSString *firstStr;

@property (nonatomic,copy)NSString *secondStr;

@end

const void*PickViewFirstStr = &PickViewFirstStr;
const void*PickViewSecondStr = &PickViewSecondStr;
const void*PickViewLastStr = &PickViewLastStr;

const void*PickViewDataArr = &PickViewDataArr;
const void*ViewPickView = &ViewPickView;
const void*PickViewTitleLabel = &PickViewTitleLabel;
const void*PickContentControl = &PickContentControl;
const void*PickViewFinishBlock = &PickViewFinishBlock;


@implementation UIView (PickView)

- (void)showPickerWithDataArr:(NSArray *)dataArr
                  finishBlock:(void(^)(NSString *result))block{
    
    objc_setAssociatedObject(self, PickViewFinishBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (dataArr.count > 3) {
        
        [dataArr subarrayWithRange:NSMakeRange(0, 3)];
    }
    
    self.arr = dataArr;
    
    UIPickerView *pickView = [self.pickViewControl viewWithTag:600];

    if (dataArr.count == 1) {
        
        self.firstStr = dataArr.firstObject[0];
        self.lastStr = self.firstStr;
        [pickView reloadAllComponents];

    }else if (dataArr.count == 2){
        self.firstStr = dataArr.firstObject[0];
        self.secondStr = [[dataArr[1] objectForKey:self.firstStr] firstObject];
        [pickView reloadAllComponents];
        [pickView selectRow:0 inComponent:1 animated:NO];
        
    }else{
        self.firstStr = dataArr.firstObject[0];
        self.secondStr = [[dataArr[1] objectForKey:self.firstStr] firstObject];
        self.lastStr =  [[dataArr[2] objectForKey:self.secondStr] firstObject];
        
        [pickView reloadAllComponents];
        [pickView selectRow:0 inComponent:1 animated:NO];
        [pickView selectRow:0 inComponent:2 animated:NO];
    }
    
    [pickView selectRow:0 inComponent:0 animated:NO];

    self.pickViewControl.hidden = NO;

    UIView *bgView = [self.pickViewControl viewWithTag:400];
    
    [UIView animateWithDuration:0.2 animations:^{
         
        bgView.bottom = kScreenHeight;
    }];
    
}

#pragma mark -- lazzy

- (void)setArr:(NSArray *)arr{
    
    objc_setAssociatedObject(self, PickViewDataArr, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)arr{
    
    NSArray *arr = objc_getAssociatedObject(self, PickViewDataArr);
    
    if (arr == nil) {
        
        arr = [NSArray array];
        self.arr = arr;
    }
    
    return arr;
}

- (void)setPickTitleLabel:(UILabel *)pickTitleLabel{
    
    objc_setAssociatedObject(self, PickViewTitleLabel, pickTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)pickTitleLabel{
    
    UILabel *titleLabel = objc_getAssociatedObject(self, PickViewTitleLabel);
    
    if (titleLabel == nil) {
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 120, 40)];
        titleLabel.textColor = [UIColor grayColor];
        self.pickTitleLabel = titleLabel;
    }
    
    return titleLabel;
}

- (void)setFirstStr:(NSString *)firstStr{
    
    objc_setAssociatedObject(self, PickViewFirstStr, firstStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)firstStr{
    
    NSString *firstStr = objc_getAssociatedObject(self, PickViewFirstStr);
    
    if (firstStr == nil) {
        
        firstStr = [[NSString alloc]init];
        self.firstStr = firstStr;
    }
    
    return firstStr;
}

- (void)setSecondStr:(NSString *)secondStr{
    
    objc_setAssociatedObject(self, PickViewSecondStr, secondStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)secondStr{
    
    NSString *secondStr = objc_getAssociatedObject(self, PickViewSecondStr);
    
    if (secondStr == nil) {
        
        secondStr = [[NSString alloc]init];
        self.secondStr = secondStr;
    }
    
    return secondStr;
}

- (void)setLastStr:(NSString *)lastStr{
    
    objc_setAssociatedObject(self, PickViewLastStr, lastStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)lastStr{
    
    NSString *lastStr = objc_getAssociatedObject(self, PickViewLastStr);
    
    if (lastStr == nil) {
        
        lastStr = [[NSString alloc]init];
        self.lastStr = lastStr;
    }
    
    return lastStr;
}

#pragma mark -- 时间响应
- (UIControl *)pickViewControl{
    
    UIControl *pickViewControl = objc_getAssociatedObject(self, PickContentControl);
    
    if (pickViewControl == nil) {
        
        pickViewControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, kScreenWith, kScreenHeight)];
        pickViewControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [pickViewControl addTarget:self action:@selector(pickControlAction) forControlEvents:UIControlEventTouchUpInside];
        [self.window addSubview:pickViewControl];
        
        objc_setAssociatedObject(self, PickContentControl, pickViewControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWith, 200 + 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.tag = 400;
        [pickViewControl addSubview:bgView];
        
        [bgView addSubview:self.pickTitleLabel];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(kScreenWith-20-50, 0, 50, 40);
        [button addTarget: self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, kScreenWith, 200)];
        pickView.tag = 600;
        pickView.delegate = self;
        pickView.dataSource = self;
        [bgView addSubview:pickView];
        
    }
    
    return pickViewControl;
}

- (void)sureAction{
    
    void(^block)(NSString *result) = objc_getAssociatedObject(self, PickViewFinishBlock);
    
    UIView *bgView = [self.pickViewControl viewWithTag:400];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        bgView.top = kScreenHeight;
        
    }completion:^(BOOL finished) {
        
        self.pickViewControl.hidden = YES;
        
        if (block) {
            
            block(self.arr.count == 1?self.firstStr:(self.arr.count == 2?self.secondStr:self.lastStr));
        }
    }];
}


- (void)pickControlAction{
    
    UIView *bgView = [self.pickViewControl viewWithTag:400];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        bgView.top = kScreenHeight;
        
    }completion:^(BOOL finished) {
        
        self.pickViewControl.hidden = YES;

    }];

}

#pragma mark -- delegate  dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return self.arr.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        
        return [self.arr[component] count];
        
    }else if (component == 1){
        
        return  [[self.arr[component] valueForKey:self.firstStr] count];
        
    }else if (component == 2){
        
        return [[self.arr[component] valueForKey:self.secondStr] count];
    }
    
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            
            return self.arr[component][row];
            
            break;
            
        case 1:
            
            return [self.arr[component] valueForKey:self.firstStr][row];
            
            break;
            
        case 2:
            
            return [self.arr[component] valueForKey:self.secondStr][row];
            
            break;
            
        default:
            break;
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (component) {
        case 0:{
            
            NSArray *arr = self.arr[component];
            
            self.firstStr = arr[row];

            if (self.arr.count > 1) {
                
//                [pickerView selectRow:0 inComponent:1 animated:YES];
                
                if ([self.arr[1] isKindOfClass:[NSDictionary class]]) {
                    
                    self.secondStr = [[self.arr[1] objectForKey:self.firstStr] firstObject];
                }
            }
            
            if (self.arr.count > 2) {

//                [pickerView selectRow:0 inComponent:2 animated:YES];

                if ([self.arr[2] isKindOfClass:[NSDictionary class]]) {

                    self.lastStr = [[self.arr[2] objectForKey:self.secondStr] firstObject];
                }
            }
        }
            
            break;
        case 1:
            
            self.secondStr = [self.arr[component] valueForKey:self.firstStr][row];
            
            if (self.arr.count > 2) {
                
//                [pickerView selectRow:0 inComponent:2 animated:YES];
                
                if ([self.arr[2] isKindOfClass:[NSDictionary class]]) {
                    
                    self.lastStr = [[self.arr[2] objectForKey:self.secondStr] firstObject];
                }
            }
            
            break;
        case 2:
            
            self.lastStr = [self.arr[component] valueForKey:self.secondStr][row];
            
            break;
            
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
}
@end
