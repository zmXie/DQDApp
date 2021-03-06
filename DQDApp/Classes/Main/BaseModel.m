//
//  BaseModel.m
//  LXSZ
//
//  Created by xzm on 16/6/24.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dic];
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSDictionary*)dictionaryWithModel {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSString *key in [[self class] getAllKeys]) {
        
        id value = [self valueForKey:key];
        if (value != nil) {
            
            if ([value isKindOfClass:[NSArray class]]) {
                if ([value count]==0) {
                    continue;
                }
            }
            else if ([value isKindOfClass:[NSString class]]) {
                if ([value length]==0) {
                    continue;
                }
            }
            [dictionary setValue:[self valueForKey:key] forKey:key];
        }
        else {
            
            continue;
        }
    }
    return dictionary;
}

+ (NSArray *)getAllKeys {
    
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        
        const char *char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    
    free(properties);
    return props;
}

- (NSArray*)getAllKeys {
    
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        
        const char *char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    
    free(properties);
    return props;
}

- (NSArray *)getAllValues {
    
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSDictionary *dictionary = [self dictionaryWithModel];
    for (i = 0; i < outCount; i++) {
        
        const char *char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        id value = [dictionary objectForKey:propertyName];
        if(value == nil || [value isKindOfClass:[NSNull class]]) {
            value = @"";
        }
        [props addObject:value];
    }
    
    free(properties);
    return props;
}

@end
