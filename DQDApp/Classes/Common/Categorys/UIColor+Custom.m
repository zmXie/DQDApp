//
//  UIColor+Custom.m
//  LXSZ
//
//  Created by xzm on 16/6/17.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+(UIColor *)main_BlueColor{
    
    return ColorWithRGB(52,135,234);
}

+ (UIColor *)main_GrayColor{
    
    return ColorWithRGB(240, 240, 240);
}

+ (UIColor *)cellText_GrayColor{
    
    return ColorWithRGB(180, 180, 180);
}

+ (UIColor *)main_redColor{
    
    return ColorWithRGB(230, 0, 18);
}

+ (UIColor *)main_yellowColor{
    
    return ColorWithRGB(247, 177, 46);
}

+ (UIColor *)main_greenColor{
    
    return ColorWithRGB(42, 204, 140);
}

+ (UIColor *)main_orangeColor{
    
    return ColorWithRGB(246, 78, 41);
}


+ (UIColor *)separatorColor{
    
    return ColorWithRGB(230, 230, 230);
}

+ (UIColor *)main_LightGrayColor{
    
     return ColorWithRGB(139, 139, 139);
}

+ (UIColor *)main_DarkGrayColor{
    
    return ColorWithRGB(60, 60, 60);
}





@end
