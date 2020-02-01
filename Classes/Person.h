//
//  Person.h
//  Demo12
//
//  Created by 陈伟滨 on 2020/2/1.
//  Copyright © 2020 Evon2020. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic,assign) NSInteger age;
@property (nonatomic,copy)   NSString  *name;


/// 转化输出
/// @param dic <#dic description#>
-(void)transformWithDictionary:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
