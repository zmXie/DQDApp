//
//  NSDate+Extension.m
//  HuaweiCloudPb
//
//  Created by lee on 15/6/30.
//  Copyright (c) 2015年 text. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger) day
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [NSString stringWithFormat:@"%d-%02d-%02d", (int)year, (int)month, (int)day];
    return [fmt dateFromString:selfStr];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger) day hour:(NSInteger)hour minutes:(NSInteger) minutes
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMddHHmm";
    NSString *selfStr = [NSString stringWithFormat:@"%d%02d%02d%02d%02d", (int)year, (int)month, (int)day, (int)hour, (int)minutes];
    return [fmt dateFromString:selfStr];
}
/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

-(NSDateComponents* )dateDetail
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
    | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSQuarterCalendarUnit | NSWeekOfMonthCalendarUnit
    | NSWeekOfYearCalendarUnit | NSYearForWeekOfYearCalendarUnit | NSCalendarCalendarUnit | NSTimeZoneCalendarUnit;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return dateComponent;
}

-(NSInteger)year
{
    return [self dateDetail].year;
}

-(NSInteger)month
{
    return [self dateDetail].month;
}

-(NSInteger)day
{
    return [self dateDetail].day;
}

-(NSInteger)hour
{
    return [self dateDetail].hour;
}

-(NSInteger)second
{
    return [self dateDetail].second;
}

-(NSInteger)minute
{
    return [self dateDetail].minute;
}
-(NSString *)weekday
{
    switch ([self dateDetail].weekday) {
        case WeekTypeSun:
            return @"周日";
            break;
        case WeekTypeMon:
            return @"星期一";
            break;
        case WeekTypeTues:
            return @"星期二";
            break;
        case WeekTypeWednes:
            return @"星期三";
            break;
        case WeekTypeThurs:
            return @"星期四";
            break;
        case WeekTypeFri:
            return @"星期五";
            break;
        case WeekTypeSatur:
            return @"星期六";
            break;
        default:
            break;
    }
    return nil;
}

-(LTimeInterval)distance

{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *  senddate=[NSDate date];
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:@"2014-6-24 00:00:00"];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    //得到相差秒数
    
    NSTimeInterval time=[endDate timeIntervalSinceDate:senderDate];
    
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/3600/60;
    LTimeInterval timeInterval;
    timeInterval.days = days;
    timeInterval.hours = hours;
    timeInterval.minute = minute;
    return timeInterval;
}


- (NSInteger)numberOfDaysInMonth

{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}


+(NSComparisonResult)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay

{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    
    //    int a;
    //
    //    a=150;
    //
    //    NSLog(@"%d",a<0?a==0:a>120?a==120:a==20);
    
    return result;
    ////    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    //    if (result == NSOrderedDescending) {
    //        //NSLog(@"Date1  is in the future");
    //        return 1;
    //    }
    //    else if (result == NSOrderedAscending){
    //        //NSLog(@"Date1 is in the past");
    //        return -1;
    //    }
    //    //NSLog(@"Both dates are the same");
    //    return 0;
    
}
//- (BOOL)isThisYear
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    // 获得某个时间的年月日时分秒
//    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
//    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
//    return dateCmps.year == nowCmps.year;
//}

/**
 *  判断某个时间是否为昨天
 */
//- (BOOL)isYesterday
//{
//    NSDate *now = [NSDate date];
//
//    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
//    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd";
//
//    // 2014-04-30
//    NSString *dateStr = [fmt stringFromDate:self];
//    // 2014-10-18
//    NSString *nowStr = [fmt stringFromDate:now];
//
//    // 2014-10-30 00:00:00
//    NSDate *date = [fmt dateFromString:dateStr];
//    // 2014-10-18 00:00:00
//    now = [fmt dateFromString:nowStr];
//
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
//
//    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
//}

/**
 *  判断某个时间是否为今天
 */
//- (BOOL)isToday
//{
//    NSDate *now = [NSDate date];
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd";
//
//    NSString *dateStr = [fmt stringFromDate:self];
//    NSString *nowStr = [fmt stringFromDate:now];
//
//    return [dateStr isEqualToString:nowStr];
//}

+ (NSString *)created:(NSString*)createDate
{
    
    NSLog(@"%@",createDate);
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    //    _created_at = @"Tue Sep 30 17:06:25 +0600 2014";
    NSDate* inputDate = [NSDate dateWithTimeIntervalSince1970:[createDate integerValue]]; // 微博的创建日期
    
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:inputDate toDate:now options:0];
    
    if ([inputDate isThisYear]) { // 今年
        if ([inputDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:inputDate];
        } else if ([inputDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            
            fmt.dateFormat = @"MM-dd";
            return [fmt stringFromDate:inputDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:inputDate];
    }
}

+ (NSString *)createdChinese:(NSString*)createDate
{
    
    NSLog(@"%@",createDate);
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    //    _created_at = @"Tue Sep 30 17:06:25 +0600 2014";
    NSDate* inputDate = [NSDate dateWithTimeIntervalSince1970:[createDate integerValue]]; // 微博的创建日期
    
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:inputDate toDate:now options:0];
    
    if ([inputDate isThisYear]) { // 今年
        if ([inputDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:inputDate];
        } else if ([inputDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            
            fmt.dateFormat = @"MM月dd日";
            return [fmt stringFromDate:inputDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy年MM月dd日";
        return [fmt stringFromDate:inputDate];
    }
}


+(NSString*)getShowTime:(NSString*)showTime{
    
    NSLog(@"%@",showTime);
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    //    _created_at = @"Tue Sep 30 17:06:25 +0600 2014";
    NSDate* inputDate = [NSDate dateWithTimeIntervalSince1970:[showTime integerValue]]; // 微博的创建日期
    
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:inputDate toDate:now options:0];
    
    if ([inputDate isThisYear]) { // 今年
        if ([inputDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:inputDate];
        } else if ([inputDate isToday]) { // 今天
            
            fmt.dateFormat = @"HH:mm";
            return [fmt stringFromDate:inputDate];
            
        } else { // 今年的其他日子
            
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:inputDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:inputDate];
    }
}

+(BOOL)isThisDayWith:(NSString*)time{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    //    _created_at = @"Tue Sep 30 17:06:25 +0600 2014";
    NSDate* inputDate = [NSDate dateWithTimeIntervalSince1970:[time integerValue]]; // 微博的创建日期
    
    if ([inputDate isThisYear]) {
        
        return  [inputDate isToday];
    }
    
    return NO;
    
}


+(BOOL)isYesterdayWith:(NSString*)time{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    //    _created_at = @"Tue Sep 30 17:06:25 +0600 2014";
    NSDate* inputDate = [NSDate dateWithTimeIntervalSince1970:[time integerValue]]; // 微博的创建日期
    
    if ([inputDate isYesterday]) {
        
        return  [inputDate isYesterday];
    }
    
    return NO;
    
}

+(NSString *)getToNowDateWithInterval:(double)interval{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    //    _created_at = @"Tue Sep 30 17:06:25 +0600 2014";
    NSDate* inputDate = [NSDate dateWithTimeIntervalSince1970:interval]; // 微博的创建日期
    
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:inputDate toDate:now options:0];
    
    if ([inputDate isThisYear]) { // 今年
        if ([inputDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:inputDate];
        } else if ([inputDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:inputDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:inputDate];
    }
    
}

+(NSString *)getDateWithInterval:(double)interval formart:(NSString *)formart{
    
    NSString *dateStr;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:formart];
    
    dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}


+(NSString *)GetTomorrowDay:(NSDate *)aDate dateFormat:(NSString *)dateFormat
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:dateFormat];
    return [dateday stringFromDate:beginningOfWeek];
}

@end
