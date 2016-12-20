//
//  DataService.m
//  LXSZ
//
//  Created by xzm on 16/6/28.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#import "DataService.h"
#import "AFNetworking.h"

#define TIMEOUT 10


@implementation DataService



+ (void)requestWithUrlString:(NSString *)urlString
                      params:(NSDictionary *)params
                  httpMethod:(NSString *)httpMethod
                successBlock:(SuccessLoadHandle)successBlock
                   failBlock:(FailLoadHandle)failBlock
{
    
    AFHTTPSessionManager*manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:URLHEAD]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    NSLog(@"%@===%@",URLHEAD,urlString);
    NSComparisonResult result1 = [httpMethod caseInsensitiveCompare:@"GET"];
    
    if (result1 == NSOrderedSame) {
        
        [manager GET:[urlString stringByAddingPercentEscapesUsingEncoding:4] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject[@"status"] integerValue] != 0) {
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"ret_msg"]];
            }

            
            successBlock(responseObject);
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            failBlock(error);
            [SVProgressHUD showErrorWithStatus:@"请检查网络"];
            
        }];
    }
    
    //处理POST请求
    NSComparisonResult result2 = [httpMethod caseInsensitiveCompare:@"POST"];
    
    if (result2 == NSOrderedSame) {
        
        [manager POST:[urlString stringByAddingPercentEscapesUsingEncoding:4] parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject[@"status"] integerValue] != 0) {
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"ret_msg"]];
            }
            
            successBlock(responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            failBlock(error);
            [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        }];
    }
    
    
    
}


+ (void)postImagesWithUrlString:(NSString *)url params:(NSDictionary *)params
                        images :(NSArray *)imgs
                   successBlock:(SuccessLoadHandle)successBlock
                      failBlock:(FailLoadHandle)failureBlock
{
    //显示状态栏上的网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager  alloc] initWithBaseURL:[NSURL URLWithString:URLHEAD]];
        manager.requestSerializer.timeoutInterval = TIMEOUT;
        manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
        [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (int i = 0; i < imgs.count; i++) {
                UIImage *image = imgs[i];
                NSData *dataName ;
                if (UIImagePNGRepresentation(image) == nil) {
                    dataName = UIImageJPEGRepresentation(image, 1);
                } else {
                    dataName = UIImagePNGRepresentation(image);
                }
                if (dataName.length > 100*1024) {
                    if (dataName.length>1024*1024) {//1M以及以上
                        dataName=UIImageJPEGRepresentation(image, 0.1);
                    }else if (dataName.length>512*1024) {//0.5M-1M
                        dataName=UIImageJPEGRepresentation(image, 0.5);
                    }else if (dataName.length>200*1024) {//0.25M-0.5M
                        dataName=UIImageJPEGRepresentation(image, 0.9);
                    }
                }
                
                [formData appendPartWithFileData:dataName name:@"file" fileName:[NSString stringWithFormat:@"image%d", i] mimeType:@"image/png"];
            }

            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"status"] integerValue] != 0) {
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"ret_msg"]];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            successBlock (responseObject);
            NSLog(@"%@",responseObject[@"descs"]);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            errorStr = [errorStr stringByReplacingOccurrencesOfString:@"。" withString:@""];
            if ([errorStr isEqualToString:@"似乎已断开与互联网的连接"]) {
                errorStr = nil;
            }
            failureBlock (error);
            [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        }];
    });
    
}

#pragma mark -- 上传头像
+(void)upLoadHeaderViewRequestWithImage:(UIImage *)theimage success:(SuccessLoadHandle)successBlock fail:(FailLoadHandle)failBlock{
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8) {
        
        AFHTTPSessionManager*manager=[AFHTTPSessionManager  manager];
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];

        
        [manager POST:[NSString stringWithFormat:@"%@/index.php?m=api&c=user&a=saveAvater&token=%@",URLHEAD,[UserInfo sharedUserInfo].token] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            
            NSData *imgData = UIImageJPEGRepresentation(theimage, 0.01);
            [formData appendPartWithFileData:imgData name:@"file" fileName:@"1.png" mimeType:@"image/png"];
            
            
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject[@"status"] integerValue] != 0) {
                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                
            }
            
            successBlock(responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            failBlock(error);
            
        }];
        
    }else{
        
        NSString *tmpFileName = [NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];
        
        NSURL *tmpFileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpFileName]];
        
        NSMutableURLRequest *mutableRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@/index.php?m=content&c=user&a=saveAvatar&token=%@",URLHEAD,[UserInfo sharedUserInfo].token] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSData *imgData = UIImageJPEGRepresentation(theimage, 0.01);
            [formData appendPartWithFileData:imgData name:@"file" fileName:@"1.png" mimeType:@"image/png"];
            
            
        } error:nil];
        
        [[AFHTTPRequestSerializer serializer]requestWithMultipartFormRequest:mutableRequest writingStreamContentsToFile:tmpFileUrl completionHandler:^(NSError *error) {
            
            AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
            
            manager.securityPolicy.allowInvalidCertificates = YES;
            
            NSURLSessionUploadTask *upLoadTask = [manager uploadTaskWithRequest:mutableRequest fromFile:tmpFileUrl progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                
                if (error) {
                    
                    failBlock(error);
                    
                }else{
                    
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                    
                    successBlock(dic);
                    
                }
            }];
            
            [upLoadTask resume];
        }];
        
    }
}


@end
