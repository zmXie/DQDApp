//
//  DataService.h
//  LXSZ
//
//  Created by xzm on 16/6/28.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessLoadHandle) (id result);

typedef void(^FailLoadHandle) (NSError *error);

@interface DataService : NSObject

//GET,POST
+ (void)requestWithUrlString:(NSString *)urlString
                      params:(NSDictionary *)params
                  httpMethod:(NSString *)httpMethod
                successBlock:(SuccessLoadHandle)successBlock
                   failBlock:(FailLoadHandle)failBlock;

//上传图片
+ (void)postImagesWithUrlString:(NSString *)url params:(NSDictionary *)params
                        images :(NSArray *)imgs
                   successBlock:(SuccessLoadHandle)successBlock
                      failBlock:(FailLoadHandle)failureBlock;

+(void)upLoadHeaderViewRequestWithImage:(UIImage *)theimage success:(SuccessLoadHandle)successBlock fail:(FailLoadHandle)failBlock;
@end
