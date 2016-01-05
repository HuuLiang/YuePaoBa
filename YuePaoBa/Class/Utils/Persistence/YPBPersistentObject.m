//
//  YPBPersistentObject.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPersistentObject.h"
#import "YPBPersistentManager.h"

static NSString *kDefaultPersistentNamespace = @"yuepaoba_default_persistent_namespace";

@implementation YPBPersistentObject

- (NSString *)namespace {
    return kDefaultPersistentNamespace;
}

- (void)persist {
    [[YPBPersistentManager sharedManager] persistentObject:self];
}

+ (NSString *)primaryKey {
    return [super primaryKey];
}
@end
