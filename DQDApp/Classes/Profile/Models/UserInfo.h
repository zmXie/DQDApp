//
//  UserInfo.h
//  XTZApp
//
//  Created by xiezhimin on 15/9/14.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject <NSCoding>
+(UserInfo*)sharedUserInfo;//单例
-(void)saveData;//用户信息保存本地
-(void)clearData; //清除

@property (nonatomic, copy)NSString *userid; //用户id
@property (nonatomic, copy)NSString *token;
@property (nonatomic, copy)NSString *avatarUrl; //头像
@property (nonatomic, copy)NSNumber *bindQQFlag; //是否绑定QQ 0，未绑定  1，绑定
@property (nonatomic, copy)NSNumber *bindSinaFlag; //是否绑定新浪
@property (nonatomic, copy)NSNumber *bindWeixinFlag; //是否绑定微信
@property (nonatomic, copy)NSString *is_invite_used; //是否使用过红包
@property (nonatomic, copy)NSString *nickname; //昵称
@property (nonatomic, copy)NSString *returnedMoneyFlag; //回款提醒 1,已开启，0，未开启
@property (nonatomic, copy)NSString *appRecommendFlag; //app推荐提醒 1,已开启，0，未开启
@property (nonatomic, copy)NSString *phone; //手机号
@property (nonatomic, copy)NSString *activityUrl; //是新用户 则返回活动链接
@property (nonatomic, copy)NSString *activityTitle; // 标题
@property (nonatomic, copy)NSString *invite_code;//邀请码
@property (nonatomic, strong)NSDictionary *placesDic;
@property (nonatomic, strong)NSArray *places; //地址数组

@property (nonatomic, copy)NSMutableArray *compareArr; //平台对比储存数组（只做记录 不做缓存）

@property (nonatomic, assign)BOOL isLogin;

-(void)setDataWithDic:(NSDictionary *)dic; //赋值

@end