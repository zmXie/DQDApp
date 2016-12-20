//
//  NSDate+Extension.h
//  HuaweiCloudPb
//
//  Created by lee on 15/6/30.
//  Copyright (c) 2015年 text. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    WeekTypeSun = 1,
    WeekTypeMon,
    WeekTypeTues,
    WeekTypeWednes,
    WeekTypeThurs,
    WeekTypeFri,
    WeekTypeSatur
}WeekType;

//时间差距 天、时、分
typedef struct LTimeInterval {
    NSInteger days;
    NSInteger hours;
    NSInteger minute;
} LTimeInterval;

@interface NSDate (Extension)

@property(nonatomic,assign,readonly) NSInteger year;
@property(nonatomic,assign,readonly) NSInteger month;
@property(nonatomic,assign,readonly) NSInteger day;
@property(nonatomic,assign,readonly) NSInteger hour;
@property(nonatomic,assign,readonly) NSInteger minute;
@property(nonatomic,assign,readonly) NSInteger second;
@property(nonatomic,copy,readonly) NSString *weekday;

//本月最大天数
@property (nonatomic, assign,readonly) NSInteger numberOfDaysInMonth;

//@property(nonatomic,assign) LTimeInterval timeInterval;
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  使用年月日创建新日期
 */
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger) day;

/**
 *  使用年月日时分创建新日期
 */
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger) day hour:(NSInteger)hour minutes:(NSInteger) minutes;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

+(NSComparisonResult)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;


+(NSString *)created:(NSString*)createDate;
+(NSString*)getShowTime:(NSString*)showTime;
+(BOOL)isThisDayWith:(NSString*)time;
+(BOOL)isYesterdayWith:(NSString*)time;
+ (NSString *)createdChinese:(NSString*)createDate;
/**
 *  获取明天的日期
 *
 *  @param aDate NSDate
 *
 *  @return NSString
 */
+(NSString *)GetTomorrowDay:(NSDate *)aDate dateFormat:(NSString *)dateFormat;

@end
