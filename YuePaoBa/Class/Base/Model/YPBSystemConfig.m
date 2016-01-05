//
//  YPBSystemConfig.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBSystemConfig.h"

static NSString *const kSystemConfigKeyName = @"yuepaoba_systemconfig_keyname";

@implementation YPBSystemConfig

+ (instancetype)configFromPersistence {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kSystemConfigKeyName];
    return [[self alloc] initFromDictionary:dic];
}

+ (instancetype)defaultConfig {
    YPBSystemConfig *config = [[self alloc] init];
    config.imgUrl = YPB_DEFAULT_PHOTOSERVER_URL;
    return config;
}

- (instancetype)initFromDictionary:(NSDictionary *)dic {
    if (dic == nil) {
        return nil;
    }
    
    self = [self init];
    if (self) {
        self.imgUrl = dic[@"imgUrl"];
    }
    return self;
}

- (void)persist {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kSystemConfigKeyName];
    NSMutableDictionary *persistDic = [dic mutableCopy];
    if (!persistDic) {
        persistDic = [NSMutableDictionary dictionary];
    }
    
    [persistDic safely_setObject:self.imgUrl forKey:@"imgUrl"];
    [[NSUserDefaults standardUserDefaults] setObject:persistDic forKey:kSystemConfigKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
