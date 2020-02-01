//
//  NSDictionary+Category.h
//  YnGoldInn
//
//  Created by 樊康鹏 on 2018/1/9.
//  Copyright © 2018年 YinNiu. All rights reserved.
//


#import <Foundation/Foundation.h>
#define DICTION_OBJECT(dict,key) [dict isKindOfClass:[NSDictionary class]] ? [dict YnObjectForKey:key] : @""
@interface NSDictionary (Category)
- (id)YnObjectForKey:(id)aKey;
- (NSString *)toJson;
#pragma mark -  JWT加密
- (NSString *)toJWTEncry;
/**根据json构建URL_SCHEME*/
- (NSString *)JsonToUrl_scheme;
@end
