//
//  YPBPersistentObject.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPersistentObject.h"
#import "YPBPersistentManager.h"
#import <Realm/Realm.h>

static NSString *kDefaultPersistentNamespace = @"yuepaoba_default_persistent_namespace";

@implementation YPBPersistentObject

+ (NSString *)namespace {
    return kDefaultPersistentNamespace;
}

- (NSError *)persist {
    return [[YPBPersistentManager sharedManager] persistentObject:self];
}

+ (NSString *)primaryKey {
    return [super primaryKey];
}

+ (NSArray *)objectsFromPersistence {
    return [[YPBPersistentManager sharedManager] persistentObjectsWithObjectClass:[self class]];
}

+ (NSArray *)objectsFromResults:(RLMResults *)results {
    NSMutableArray *arr = [NSMutableArray array];
    for (YPBPersistentObject *object in results) {
        [arr addObject:object];
    }
    return arr.count > 0 ? arr : nil;
}

+ (RLMRealm *)classRealm {
    return [[YPBPersistentManager sharedManager] realmWithPersistentClass:[self class]];
}

- (void)beginUpdate {
    [self.realm beginWriteTransaction];
}

- (NSError *)endUpdate {
    if (self.realm) {
        NSError *error;
        [self.realm commitWriteTransaction:&error];
        return error;
    } else {
        return [self persist];
    }
    
}

- (void)deleteFromPersistence {
    [self.realm beginWriteTransaction];
    [self.realm deleteObject:self];
    [self.realm commitWriteTransaction];
}

+ (void)deleteObjects:(NSArray<YPBPersistentObject *> *)objects {
    if (objects.count == 0) {
        return ;
    }
    
    BOOL hasObjectOfOtherNamespace = [objects bk_any:^BOOL(YPBPersistentObject *obj) {
        return ![[[obj class] namespace] isEqualToString:[[self class] namespace]];
    }];
    
    if (hasObjectOfOtherNamespace) {
        return ;
    }
    
    RLMRealm * realm = [self classRealm];
    if (!realm) {
        return ;
    }
    
    [realm beginWriteTransaction];
    [realm deleteObjects:objects];
    [realm commitWriteTransaction];
}

+ (NSDictionary<NSString *,NSNumber *> *)newPropertiesForMigration { return nil; }

+ (NSDictionary<NSString *,id> *)newPropertyDefaultValuesForMigration { return nil; }
@end
