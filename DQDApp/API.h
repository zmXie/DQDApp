//
//  API.h
//  DQDApp
//
//  Created by xzm on 16/10/14.
//  Copyright © 2016年 ypwl. All rights reserved.
//

#ifndef API_h
#define API_h

#ifdef DEBUG // 处于开发阶段
#define NSLog(...) NSLog(__VA_ARGS__)

#define URLHEAD @""

#else // 处于发布阶段

#define NSLog(...)
#define URLHEAD @""

#endif


#endif /* API_h */
