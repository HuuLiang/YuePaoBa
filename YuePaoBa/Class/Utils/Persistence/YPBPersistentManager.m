//
//  YPBPersistentManager.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPersistentManager.h"
#import <Realm/Realm.h>

@interface YPBPersistentManager ()
//@property (nonatomic,retain) NSMutableDictionary<NSString *, RLMRealm *> *realms;
@end

@implementation YPBPersistentManager

//DefineLazyPropertyInitialization(NSMutableDictionary, realms)

+ (instancetype)sharedManager {
    static YPBPersistentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[YPBPersistentManager alloc] init];
    });
    return _sharedManager;
}

- (NSError *)persistentObject:(YPBPersistentObject *)object {
    NSError *error;
    RLMRealm *realm = [self realmWithPersistentClass:[object class]];
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:object];
    [realm commitWriteTransaction:&error];
    return error;
}

- (RLMRealm *)realmWithPersistentClass:(Class)persistentClass {
    if (![persistentClass isSubclassOfClass:[YPBPersistentObject class]]) {
        return nil;
    }
    
    NSString *folder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *realmPath = [NSString stringWithFormat:@"%@/%@.realm", folder, [persistentClass namespace]];
    RLMRealmConfiguration *configuration = [RLMRealmConfiguration defaultConfiguration];
    configuration.path = realmPath;
    configuration.schemaVersion = YPB_DB_VERSION;
    configuration.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        NSDictionary<NSString *, NSNumber *> *newPropertiesForMigration = [persistentClass newPropertiesForMigration];
        NSDictionary *newPropertyDefaultValues = [persistentClass newPropertyDefaultValuesForMigration];
        NSMutableDictionary<NSString *, id> *newProperties = [NSMutableDictionary dictionary];
        [newPropertiesForMigration enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            if (oldSchemaVersion < obj.unsignedIntegerValue) {
                id defaultValue = [newPropertyDefaultValues objectForKey:key];
                if (defaultValue) {
                    [newProperties setObject:defaultValue forKey:key];
                }
            }
        }];

        if (newProperties.count > 0) {
            [migration enumerateObjects:[persistentClass className] block:^(RLMObject * _Nullable oldObject, RLMObject * _Nullable newObject) {
                [newProperties enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    newObject[key] = obj;
                }];
            }];
        }
    };
    
    RLMRealm *realm = [RLMRealm realmWithConfiguration:configuration error:nil];
    return realm;
}

- (void)persistentObjects:(YPBPersistentObjectArray *)objects {
    NSMutableDictionary<NSString *, YPBPersistentObjectMutableArray *> *objectNamespaceMapping = [NSMutableDictionary dictionary];
    [objects enumerateObjectsUsingBlock:^(YPBPersistentObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YPBPersistentObjectMutableArray *arr = objectNamespaceMapping[[[obj class] namespace]];
        if (!arr) {
            arr = [YPBPersistentObjectMutableArray array];
            [objectNamespaceMapping setObject:arr forKey:[[obj class] namespace]];
        }
        
        [arr addObject:obj];
    }];

    [objectNamespaceMapping enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, YPBPersistentObjectMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
        RLMRealm *realm = [self realmWithPersistentClass:[obj.firstObject class]];
        [realm beginWriteTransaction];
        [obj enumerateObjectsUsingBlock:^(YPBPersistentObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [realm addOrUpdateObject:obj];
        }];
        [realm commitWriteTransaction];
    }];
}

- (NSArray *)persistentObjectsWithObjectClass:(Class)objClass {
    if (![objClass isSubclassOfClass:[YPBPersistentObject class]]) {
        return nil;
    }
    
    RLMRealm *realm = [self realmWithPersistentClass:objClass];
    if (!realm) {
        return nil;
    }
    
    RLMResults *results = [objClass allObjectsInRealm:realm];
    if (results.count == 0) {
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (YPBPersistentObject *obj in results) {
        [arr addObject:obj];
    }
    return arr;
}
@end
