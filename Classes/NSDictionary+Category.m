//
//  NSDictionary+Category.m
//  YnGoldInn
//
//  Created by 樊康鹏 on 2018/1/9.
//  Copyright © 2018年 YinNiu. All rights reserved.
//


#import "NSDictionary+Category.h"
#import "JWT.h"
#import <sys/utsname.h>
@implementation NSDictionary (Category)
- (NSString *)toJson{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if (![NSString isBlankString:key]) {
        if (value) {
            [super setValue:value forKey:key];
        }
    }
}
//+ (void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        Class selfClass = object_getClass([self class]);
//
//        SEL oriSEL = @selector(dictionaryWithObjects:forKeys:count:);
//        Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
//
//        SEL cusSEL = @selector(avoidCrashDictionaryWithObjects:forKeys:count:);
//        Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
//
//        BOOL addSucc = class_addMethod(selfClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
//        if (addSucc) {
//            class_replaceMethod(selfClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
//        }else {
//            method_exchangeImplementations(oriMethod, cusMethod);
//        }
//    });
//
//}
+ (instancetype)avoidCrashDictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self avoidCrashDictionaryWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException *exception) {
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self avoidCrashDictionaryWithObjects:newObjects forKeys:newkeys count:index];
    }
    @finally {
        return instance;
    }
}

- (id)YnObjectForKey:(id)aKey{
    id object = [self objectForKey:aKey];
    if ([object isEqual: nil]){
//        Class subClass = NSClassFromString(NSStringFromClass([object class]));
        return @"";
    }else{
        if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSData class ]] ||[object isKindOfClass:[YnModel class]] ||[object isKindOfClass:[NSAttributedString class]]) {
            return object;
        }else if ([object isKindOfClass:[NSNull class]]){
            return @"";
        }else{
            NSString * ss = [NSString stringWithFormat:@"%@",object];
            if ([ss rangeOfString:@"null"].location != NSNotFound || [ss rangeOfString:@"Null"].location != NSNotFound) {
                ss = @"";
            }
            return ss;
        }
    }
}
#pragma mark -  JWT加密


- (NSString *)toJWTEncry{
    NSString *key = Yn_KEY_JWT;
    NSString *algorithmName = @"HS256";
    JWTClaimsSet *set = [[JWTClaimsSet alloc] init];
    set.audience = @"";
    //加密所有参数
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addEntriesFromDictionary:self];
    //公共参数  手机型号 手机系统版本号 手机系统 接口版本号
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    [subDict setObject:Yn_APP_VERSION forKey:@"interfaceVersion"];
    [subDict setObject:@"ios" forKey:@"phoneSystem"];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    [subDict setObject:phoneVersion forKey:@"phoneVersion"];
    NSString * iphoneType = [self iphoneType];
    [subDict setObject:iphoneType forKey:@"phoneType"];
//    if (APPDELEGATE.myDeviceToken.length <= 0) {
//        [YnAlert alertMiddleMessage:@"无token"];
//    } 
    subDict[@"token"] = APPDELEGATE.myDeviceToken;
    dict[@"sub"] = subDict;
    
    set.subject = [dict toJson];
//    NSDictionary *headers = @{@"alg":@"HS256",@"typ":@"JWT"};
//    id<JWTAlgorithm> alg = [JWTAlgorithmFactory algorithmByName:algorithmName];

//    JWTBuilder *encodeBuilder = [JWT encodeClaimsSet:set];
//    NSString *resultStr = encodeBuilder.secret(key).algorithm(alg).headers(headers).encode;


    id<JWTAlgorithm> algorithm = [JWTAlgorithmFactory algorithmByName:algorithmName];
    JWTBuilder * builder = [JWTBuilder encodePayload:dict].secret(key).algorithm(algorithm);
    if (builder.jwtError == nil) {
        return builder.encode;
    }else
        return nil;
}

- (NSString*)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone1,1"])
        return @"iPhone 2G";
    else if([platform isEqualToString:@"iPhone1,2"])
        return @"iPhone 3G";
    else if([platform isEqualToString:@"iPhone2,1"])
        return @"iPhone 3GS";
    else if([platform isEqualToString:@"iPhone3,1"])
        return @"iPhone 4";
    else if([platform isEqualToString:@"iPhone3,2"])
        return @"iPhone 4";
    else if([platform isEqualToString:@"iPhone3,3"])
        return @"iPhone 4";
    else if([platform isEqualToString:@"iPhone4,1"])
        return @"iPhone 4S";
    else if([platform isEqualToString:@"iPhone5,1"])
        return @"iPhone 5";
    else if([platform isEqualToString:@"iPhone5,2"])
        return @"iPhone 5";
    else if([platform isEqualToString:@"iPhone5,3"])
        return @"iPhone 5c";
    else if([platform isEqualToString:@"iPhone5,4"])
        return @"iPhone 5c";
    else if([platform isEqualToString:@"iPhone6,1"])
        return @"iPhone 5s";
    else if([platform isEqualToString:@"iPhone6,2"])
        return @"iPhone 5s";
    else if([platform isEqualToString:@"iPhone7,1"])
        return @"iPhone 6 Plus";
    else if([platform isEqualToString:@"iPhone7,2"])
        return @"iPhone 6";
    else if([platform isEqualToString:@"iPhone8,1"])
        return @"iPhone 6s";
    else if([platform isEqualToString:@"iPhone8,2"])
        return @"iPhone 6s Plus";
    else if([platform isEqualToString:@"iPhone8,4"])
        return @"iPhone SE";
    else if([platform isEqualToString:@"iPhone9,1"])
        return @"iPhone 7";
    else if([platform isEqualToString:@"iPhone9,2"])
        return @"iPhone 7 Plus";
    else if([platform isEqualToString:@"iPhone10,1"])
        return @"iPhone 8";
    else if([platform isEqualToString:@"iPhone10,4"])
        return @"iPhone 8";
    else if([platform isEqualToString:@"iPhone10,2"])
        return @"iPhone 8 Plus";
    else if([platform isEqualToString:@"iPhone10,5"])
        return @"iPhone 8 Plus";
    else if([platform isEqualToString:@"iPhone10,3"])
        return @"iPhone X";
    else if([platform isEqualToString:@"iPhone10,6"])
        return @"iPhone X";
    else if([platform isEqualToString:@"iPod1,1"])
        return @"iPod Touch 1G";
    else if([platform isEqualToString:@"iPod2,1"])
        return @"iPod Touch 2G";
    else if([platform isEqualToString:@"iPod3,1"])
        return @"iPod Touch 3G";
    else if([platform isEqualToString:@"iPod4,1"])
        return @"iPod Touch 4G";
    else if([platform isEqualToString:@"iPod5,1"])
        return @"iPod Touch 5G";
    else if([platform isEqualToString:@"iPad1,1"])
        return @"iPad 1G";
    else if([platform isEqualToString:@"iPad2,1"])
        return @"iPad 2";
    else if([platform isEqualToString:@"iPad2,2"])
        return @"iPad 2";
    else if([platform isEqualToString:@"iPad2,3"])
        return @"iPad 2";
    else if([platform isEqualToString:@"iPad2,4"])
        return @"iPad 2";
    else if([platform isEqualToString:@"iPad2,5"])
        return @"iPad Mini 1G";
    else if([platform isEqualToString:@"iPad2,6"])
        return @"iPad Mini 1G";
    else if([platform isEqualToString:@"iPad2,7"])
        return @"iPad Mini 1G";
    else if([platform isEqualToString:@"iPad3,1"])
        return @"iPad 3";
    else if([platform isEqualToString:@"iPad3,2"])
        return @"iPad 3";
    else if([platform isEqualToString:@"iPad3,3"])
        return @"iPad 3";
    else if([platform isEqualToString:@"iPad3,4"])
        return @"iPad 4";
    else if([platform isEqualToString:@"iPad3,5"])
        return @"iPad 4";
    else if([platform isEqualToString:@"iPad3,6"])
        return @"iPad 4";
    else if([platform isEqualToString:@"iPad4,1"])
        return @"iPad Air";
    else if([platform isEqualToString:@"iPad4,2"])
        return @"iPad Air";
    else if([platform isEqualToString:@"iPad4,3"])
        return @"iPad Air";
    else if([platform isEqualToString:@"iPad4,4"])
        return @"iPad Mini 2G";
    else if([platform isEqualToString:@"iPad4,5"])
        return @"iPad Mini 2G";
    else if([platform isEqualToString:@"iPad4,6"])
        return @"iPad Mini 2G";
    else if([platform isEqualToString:@"iPad4,7"])
        return @"iPad Mini 3";
    else if([platform isEqualToString:@"iPad4,8"])
        return @"iPad Mini 3";
    else if([platform isEqualToString:@"iPad4,9"])
        return @"iPad Mini 3";
    else if([platform isEqualToString:@"iPad5,1"])
        return @"iPad Mini 4";
    else if([platform isEqualToString:@"iPad5,2"])
        return @"iPad Mini 4";
    else if([platform isEqualToString:@"iPad5,3"])
        return @"iPad Air 2";
    else if([platform isEqualToString:@"iPad5,4"])
        return @"iPad Air 2";
    else if([platform isEqualToString:@"iPad6,3"])
        return @"iPad Pro 9.7";
    else if([platform isEqualToString:@"iPad6,4"])
        return @"iPad Pro 9.7";
    else if([platform isEqualToString:@"iPad6,7"])
        return @"iPad Pro 12.9";
    else if([platform isEqualToString:@"iPad6,8"])
        return @"iPad Pro 12.9";
    else if([platform isEqualToString:@"i386"])
        return @"iPhone Simulator";
    else if([platform isEqualToString:@"x86_64"])
        return @"iPhone Simulator";
    return platform;
    
}

- (NSString *)JsonToUrl_scheme{
    NSString *url_scheme = @"";
    if ([self containsObjectForKey:@"url_scheme"]) {
        url_scheme = [NSString stringWithFormat:@"%@",DICTION_OBJECT(self, @"url_scheme")];
    }else{
        //构建url_scheme
        NSString *href = [NSString stringWithFormat:@"%@",DICTION_OBJECT(self, @"href")];
        NSString *o_class = [NSString stringWithFormat:@"%@",DICTION_OBJECT(self, @"o_class")];
        NSString *o_action = [NSString stringWithFormat:@"%@",DICTION_OBJECT(self, @"o_action")];
        NSString *o_id = [NSString stringWithFormat:@"%@",DICTION_OBJECT(self, @"o_id")];
        if ([href isNotBlank]) {
            url_scheme = href;
            if ([url_scheme hasPrefix:@"goldinn://"]) {
                NSDictionary *dict = [url_scheme url_scheme_to_dict];
                url_scheme = [dict JsonToUrl_scheme];
            }
        }else{
            url_scheme = @"goldinn://";
            if (o_class.length > 0) {
                url_scheme = [url_scheme stringByAppendingString:o_class];
                if (o_action.length > 0) {
                    url_scheme = [url_scheme stringByAppendingString:[NSString stringWithFormat:@"/%@",o_action]];
                    if (o_id.length > 0) {
                        url_scheme = [url_scheme stringByAppendingString:[NSString stringWithFormat:@"/%@",o_id]];
                    }
                }
            }
        }
    }
    return url_scheme;
}
@end
