//
//  BaseModel.h
//  LXSZ
//
//  Created by xzm on 16/6/24.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

/**
 *  初始化
 *
 *  @param dic 字典数据源
 *
 *  @return self
 */
-(instancetype)initWithDic:(NSDictionary *)dic;

/**
 * 将实例转化为字典
 */
- (NSDictionary *)dictionaryWithModel;

/**
 * 获取所有key
 */
+ (NSArray *)getAllKeys;

/**
 * 获取所有key
 */
- (NSArray *)getAllKeys;

/**
 * 获取所有value
 */
- (NSArray *)getAllValues;
@end
