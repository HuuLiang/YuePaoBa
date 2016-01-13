//
//  YPBVipUpgradeInfo.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPersistentObject.h"

typedef NS_ENUM(NSUInteger, YPBVipUpgradeStatus) {
    YPBVipUpgradeStatusUnknown,
    YPBVipUpgradeStatusUncommited,
    YPBVipUpgradeStatusCommited
};

@interface YPBVipUpgradeInfo : YPBPersistentObject

@property (nonatomic) NSString *upgradeId;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSNumber<RLMInt> *upgradeMonths;
@property (nonatomic) NSString *upgradeTime;
@property (nonatomic) NSNumber<RLMInt> *upgradeStatus;

+ (NSArray<YPBVipUpgradeInfo *> *)allUncomittedInfos;

@end

RLM_ARRAY_TYPE(YPBVipUpgradeInfo)