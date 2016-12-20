
//
//  AppTools.m
//  XTZApp
//
//  Created by xiezhimin on 15/9/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "AppTools.h"
#import "sys/utsname.h"
#import <CommonCrypto/CommonDigest.h>

#import "NSDate+Extension.h"

@implementation AppTools

+ (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            
            return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

//处理null数据
+ (NSString *)handleNullToString:(NSString *)str{
    
    if (str == nil) {
         return @"";
    }
    if (str == NULL) {
         return @"";
    }
    if ([str isKindOfClass:[NSNull class]]) {
         return @"";
    }
    if (![str isKindOfClass:[NSString class]]) {
        str = [NSString stringWithFormat:@"%@",str];
    }
    if ([str isEqualToString:@"<null>"]) {
        return @"";
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return @"";
    }
    
    return str;
}

//判断是否为整形
+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  是否是字母
 *
 */
+ (BOOL)isAlphabetWithStr:(NSString *)str{
    
    NSString * MOBILE = @"^[A-Za-z]+$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if ([regextestmobile evaluateWithObject:str] == YES)
        
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *expression = [NSString stringWithFormat:@"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"];
    NSError *error = NULL;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:email options:0 range:NSMakeRange(0, [email length])];
    if (match) {
        NSLog(@"right");
        return YES;
    }else {
        NSLog(@"wrong");
        return NO;
    }
}

+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9])|(14[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

//获取当前时间
+ (NSString *)getCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyyMMdd"];
    
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    return dateTime;
    
}

//字符串转货币格式
+ (NSString*)getNumber:(NSString*)numberstring{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
//    enum {
//        NSNumberFormatterNoStyle = kCFNumberFormatterNoStyle,
//        NSNumberFormatterDecimalStyle = kCFNumberFormatterDecimalStyle,
//        NSNumberFormatterCurrencyStyle = kCFNumberFormatterCurrencyStyle,
//        NSNumberFormatterPercentStyle = kCFNumberFormatterPercentStyle,
//        NSNumberFormatterScientificStyle = kCFNumberFormatterScientificStyle,
//        NSNumberFormatterSpellOutStyle = kCFNumberFormatterSpellOutStyle
//    };
//    typedef NSUInteger NSNumberFormatterStyle;
//    各个枚举对应输出数字格式的效果如下：
//    [1243:403] Formatted number string:123456789
//    [1243:403] Formatted number string:123,456,789
//    [1243:403] Formatted number string:￥123,456,789.00
//    [1243:403] Formatted number string:-539,222,988%
//    [1243:403] Formatted number string:1.23456789E8
//    [1243:403] Formatted number string:一亿二千三百四十五万六千七百八十九
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithDouble:[numberstring doubleValue]]];
    
    if ([string intValue] == 0) {
        
        string = @"0.00";
    }
    
    return string;
    
}

//汉字转拼音
+ (NSString *)ChineseRepalceToPinyinWithChinese:(NSString *)chinese{
    
    NSMutableString *ms = [[NSMutableString alloc] initWithString:chinese];
    
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
        
    }
    
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        
        return ms;
    }
    

    return @"";
}

//是否在今天以前
+(BOOL)isBeforeTodayWithTimeStr:(NSString *)return_time{
    
    //YES 待确认 NO待操作
    NSDate*today=[NSDate date];
    
    NSString *nowTimeSp = [NSString stringWithFormat:@"%ld", (long)[today timeIntervalSince1970]];
    
    if ([NSDate isThisDayWith:return_time]) {
        //今天
        return YES;
        
    }
    
    if ([nowTimeSp doubleValue]>[return_time doubleValue]) {
        
        //今天以前
        return YES;
    }
    //今天以后
    return NO;
}

#pragma mark - Public Method 获取md5值
+ (NSString *)getMD5:(NSString *)str
{
    if (!str)
    {
        return nil;
    }
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+(NSString*)getDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([deviceString isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G ";
    if ([deviceString isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G ";
    if ([deviceString isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G ";
    if ([deviceString isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G ";
    if ([deviceString isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G ";
    
    if ([deviceString isEqualToString:@"iPad1,1"])   return @"iPad 1G ";
    
    if ([deviceString isEqualToString:@"iPad2,1"])   return @"iPad 2 ";
    if ([deviceString isEqualToString:@"iPad2,2"])   return @"iPad 2 ";
    if ([deviceString isEqualToString:@"iPad2,3"])   return @"iPad 2 ";
    if ([deviceString isEqualToString:@"iPad2,4"])   return @"iPad 2 ";
    if ([deviceString isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G ";
    if ([deviceString isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G ";
    if ([deviceString isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G ";
    
    if ([deviceString isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

+ (NSString *)getMaxWithStr:(NSString *)str{
    
    NSString *newStr = [NSString stringWithFormat:@"%d",[str intValue]];
    
    NSInteger length = newStr.length;
    
    if (length>=5) {
        
        length=4;
    }
    
    int n = (int)pow(10, length-1);
    
    CGFloat newFloat = ceilf(newStr.floatValue/n);
    
    if (length == 1) {
        
        return @"10";
    }
    
    return [NSString stringWithFormat:@"%.0f",newFloat*n];
}

+(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height
{
    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
    CGRect rect=[string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}

+(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds=[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    return bounds.size.height;
}

+(NSString *)getDateWithInterval:(double)interval formart:(NSString *)formart{
    
    NSString *dateStr;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:formart];
    
    dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

+(UIColor *) colorWithHexString: (NSString *) stringToConvert  //@"#5a5a5a"
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
            
                           green:((float) g / 255.0f)
            
                            blue:((float) b / 255.0f)
            
                           alpha:1.0f];
    
}

+(NSString *)stringDeleteString:(NSString *)str;
{
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if ( c == ',' || c == '%') { //此处可以是任何字符
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:str1];
    return newstr;
}



/**
 * 将UIColor变换为UIImage
 *
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

/**
 *  将照片扶正
 *
 *  @param aImage 需要扶正的照片
 *
 *  @return 返回扶正后的照片
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
+(NSString*)getDateString:(NSString *)sourceDate withFormate:(NSString*)formateString;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *newdate = [formatter dateFromString:sourceDate];
    NSString __autoreleasing *newDateString=[NSString stringWithFormat:@"%@",newdate];
    return newDateString;
}
+(NSString*)stringByReplacing:(NSString *)sourceString;{
    
    return  [sourceString stringByReplacingOccurrencesOfString:@"," withString:@""] ;

}


+(NSMutableAttributedString*)getChangedMutableString:(NSString*)changeString fontSize:(CGFloat)fontSize color:(UIColor *)color range:(NSRange)range{
    
    NSMutableAttributedString *newString = @"";
    
    if(changeString.length > 0){
        
        newString=[[NSMutableAttributedString alloc] initWithString:changeString];
        
        [newString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
        [newString addAttribute:NSForegroundColorAttributeName value:color range:range];
        
    }
    
    
    return newString;
    
}


//是否是有效的银行卡号
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}

//判断输入的是否为数字
+ (BOOL)isPureNumandCharacters:(NSString *)string;
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}


+ (UILabel *)creatWithFrame:(CGRect)rect
                       font:(UIFont *)font
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
              textAlignment:(NSTextAlignment)textAlignment
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.font = font;
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    return label;
}

@end
