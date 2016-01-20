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
@property (nonatomic) NSString *vipExpireTime;
@property (nonatomic) NSNumber<RLMInt> *upgradeStatus;

+ (NSArray<YPBVipUpgradeInfo *> *)allUncomittedInfos;

@end

RLM_ARRAY_TYPE(YPBVipUpgradeInfo)