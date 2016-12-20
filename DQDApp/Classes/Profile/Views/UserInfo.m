//
//  UserInfo.m
//  XTZApp
//
//  Created by xiezhimin on 15/9/14.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "UserInfo.h"
//#import "SFHFKeychainUtils.h"

@implementation UserInfo
static UserInfo* userInfo = nil;

+(UserInfo*)sharedUserInfo{
    @synchronized(self){
        if (nil == userInfo) {
            userInfo = [[UserInfo alloc] init];
            NSString* path = NSHomeDirectory();
            userInfo = [UserInfo sharedUserInfo];
            path = [path stringByAppendingPathComponent:@"Library/user.arc"];
            NSLog(@"---------------path%@",path);
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UserInfo* localUser = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
                if ([localUser isKindOfClass:[UserInfo class]]) {
                    userInfo.token = localUser.token;
                    userInfo.avatarUrl = localUser.avatarUrl;
                    userInfo.bindQQFlag = localUser.bindQQFlag;
                    userInfo.bindSinaFlag = localUser.bindSinaFlag;
                    userInfo.bindWeixinFlag = localUser.bindWeixinFlag;
                    userInfo.is_invite_used = localUser.is_invite_used;
                    userInfo.nickname = localUser.nickname;
                    userInfo.returnedMoneyFlag = localUser.returnedMoneyFlag;
                    userInfo.appRecommendFlag = localUser.appRecommendFlag;
                    userInfo.phone = localUser.phone;
                    userInfo.activityTitle = localUser.activityTitle;
                    userInfo.activityUrl = localUser.activityUrl;
                    userInfo.invite_code = localUser.invite_code;
                    userInfo.userid = localUser.userid;

                    
                }
            }
        }
    }
    return userInfo;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.avatarUrl = [aDecoder decodeObjectForKey:@"avatarUrl"];
        self.bindQQFlag = [aDecoder decodeObjectForKey:@"bindQQFlag"];
        self.bindSinaFlag = [aDecoder decodeObjectForKey:@"bindSinaFlag"];
        self.bindWeixinFlag = [aDecoder decodeObjectForKey:@"bindWeixinFlag"];
        self.is_invite_used = [aDecoder decodeObjectForKey:@"is_invite_used"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.returnedMoneyFlag = [aDecoder decodeObjectForKey:@"returnedMoneyFlag"];
        self.appRecommendFlag = [aDecoder decodeObjectForKey:@"appRecommendFlag"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.activityUrl = [aDecoder decodeObjectForKey:@"activityUrl"];
        self.activityTitle = [aDecoder decodeObjectForKey:@"activityTitle"];
        self.invite_code = [aDecoder decodeObjectForKey:@"invite_code"];
        self.userid = [aDecoder decodeObjectForKey:@"userid"];

        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
    [aCoder encodeObject:self.bindSinaFlag forKey:@"bindSinaFlag"];
    [aCoder encodeObject:self.bindQQFlag forKey:@"bindQQFlag"];
    [aCoder encodeObject:self.bindWeixinFlag forKey:@"bindWeixinFlag"];
    [aCoder encodeObject:self.is_invite_used forKey:@"is_invite_used"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.returnedMoneyFlag forKey:@"returnedMoneyFlag"];
    [aCoder encodeObject:self.appRecommendFlag forKey:@"appRecommendFlag"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.activityTitle forKey:@"activityTitle"];
    [aCoder encodeObject:self.activityUrl forKey:@"activityUrl"];
    [aCoder encodeObject:self.invite_code forKey:@"invite_code"];
    [aCoder encodeObject:self.userid forKey:@"userid"];

}

- (BOOL)isLogin{
    
    if ([self.token isEqualToString:@""] || !self.token) {
        return NO;
    }else{
        return YES;
    }
    
}

//个人信息保存到本地
-(void)saveData{
    NSString* path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"Library/user.arc"];
    if (userInfo) {
        [NSKeyedArchiver archiveRootObject:userInfo toFile:path];
    }
}

-(void)clearData{
    self.token = @"";
    self.userid = @"";
    self.returnedMoneyFlag = @"";
    self.nickname = @"";
    self.avatarUrl = @"";
   
    [self saveData];
    
}//清除

-(void)setDataWithDic:(NSDictionary *)dic{
    
     [self setValuesForKeysWithDictionary:dic];
    
    //登陆成功发送通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil];
    
}//赋值

- (void)setPlacesDic:(NSDictionary *)placesDic{
    
    _placesDic = placesDic;
    
    //        [UserInfo sharedUserInfo].places = result[@"start"];
    //        @[   @["深圳","广州"],   @{"深圳":["南山","罗湖"], "广州":@[]} ,   @{"南山":["白石洲","世界之窗"],  "罗湖":@[]    ]
    
    NSArray *sArr = placesDic.allKeys;
    
    NSMutableDictionary *qAllDic = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *jAllDic = [NSMutableDictionary dictionary];
    
    for (NSString *str in sArr) {
        
        NSDictionary *qDic = placesDic[str];
        
        NSArray *qArr = qDic.allKeys;
        
        [qAllDic setObject:qArr forKey:str];
        
        for (NSString *qStr in qArr) {
            
            [jAllDic setObject:qDic[qStr] forKey:qStr];
        }
        
    }
    
    [UserInfo sharedUserInfo].places = @[sArr,qAllDic,jAllDic];

}

- (NSArray *)places{
    
    if (_places == nil || _places.count == 0 ) {
        
        //得到完整的文件名
        NSString *filename=[[NSBundle mainBundle]pathForResource:@"place" ofType:@"plist"];
       
        NSDictionary *placeDic = [[NSDictionary alloc] initWithContentsOfFile:filename];
        self.placesDic = placeDic;
        
    }
    
    return _places;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end
