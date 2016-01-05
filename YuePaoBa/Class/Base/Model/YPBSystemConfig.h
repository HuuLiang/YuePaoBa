//
//  YPBSystemConfig.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPBSystemConfig : NSObject
@property (nonatomic) NSString *imgUrl;

+ (instancetype)configFromPersistence;
+ (instancetype)defaultConfig;
- (void)persist;

@end
