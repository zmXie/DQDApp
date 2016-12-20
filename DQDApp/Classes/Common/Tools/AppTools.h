//
//  AppTools.h
//  XTZApp
//
//  Created by xiezhimin on 15/9/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AppTools : NSObject

//获取最上面的window
+(UIWindow *)lastWindow;

//处理null数据
+ (NSString *)handleNullToString:(NSString *)str;

//判断是否为整形
+ (BOOL)isPureInt:(NSString*)string;

/**
 *  是否是字母
 *
 */
+ (BOOL)isAlphabetWithStr:(NSString *)str;

//邮箱
+ (BOOL)isValidateEmail:(NSString *)email;

//手机号
+ (BOOL)isValidateMobile:(NSString *)mobile;

//获取当前时间
+ (NSString *)getCurrentTime;

//字符串转货币格式
+ (NSString*)getNumber:(NSString*)numberstring;

//汉字转拼音
+ (NSString *)ChineseRepalceToPinyinWithChinese:(NSString *)chinese;

//是否在今天以前
+(BOOL)isBeforeTodayWithTimeStr:(NSString *)return_time;

#pragma mark - 获取手机型号
+(NSString*)getDeviceModel;

#pragma mark - Public Method 获取md5值
+ (NSString *)getMD5:(NSString *)str;

//向上取整
+ (NSString *)getMaxWithStr:(NSString *)str;

//获取文字宽度
+(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height;

//获取文字高度
+(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;

+(NSString *)getDateWithInterval:(double)interval formart:(NSString *)formart;

+(UIColor *) colorWithHexString: (NSString *) stringToConvert;


//保存userdefaults
+(BOOL)saveUserDefaultsObj:(id)obj forKey:(NSString *)key;

//获取userdefaults
+(id)getUserDefaultsObjForKey:(NSString *)key;

//移除userdefaults
+(BOOL)removeDefaultsObjForKey:(NSString *)key;

/**
 * 将UIColor变换为UIImage
 *
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  将照片扶正
 *
 *  @param aImage 需要扶正的照片
 *
 *  @return 返回扶正后的照片
 */
+(UIImage *)fixOrientation:(UIImage *)aImage;

+(NSString*)getDateString:(NSString *)sourceDate withFormate:(NSString*)formateString;

//把字符串里面的 "," 转成 ""
+(NSString*)stringByReplacing:(NSString *)sourceString;

//一行字体显示不同的大小和颜色
+(NSMutableAttributedString*)getChangedMutableString:(NSString*)changeString fontSize:(CGFloat)fontSize color:(UIColor *)color range:(NSRange)range;


//是否是有效的银行卡号
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber;

//判断输入的是否为数字
+ (BOOL)isPureNumandCharacters:(NSString *)string;


//快速创建label
+ (UILabel *)creatWithFrame:(CGRect)rect
                       font:(UIFont *)font
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
              textAlignment:(NSTextAlignment)textAlignment;


@end
