//
//  YPBVipUpgradeInfo.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBVipUpgradeInfo.h"

@implementation YPBVipUpgradeInfo

+ (NSString *)namespace {
    return kVIPUpgradePersistenceNamespace;
}

+ (NSString *)primaryKey {
    return @"upgradeId";
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.upgradeId = [NSUUID UUID].UUIDString.md5;
    }
    return self;
}

+ (NSArray<YPBVipUpgradeInfo *> *)allUncomittedInfos {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"upgradeStatus=%ld", YPBVipUpgradeStatusUncommited];
    RLMResults *results = [self objectsInRealm:[self classRealm] withPredicate:predicate];
    return [self objectsFromResults:results];
}
@end
