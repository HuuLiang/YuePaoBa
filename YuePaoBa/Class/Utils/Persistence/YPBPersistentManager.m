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
    RLMRealm *realm = [self realmWithNamespace:[[object class] namespace]];
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:object];
    [realm commitWriteTransaction:&error];
    return error;
}

- (RLMRealm *)realmWithNamespace:(NSString *)namespace {
    NSString *folder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *realmPath = [NSString stringWithFormat:@"%@/%@.realm", folder, namespace];
    RLMRealm *realm = [RLMRealm realmWithPath:realmPath];
    return realm;
//    RLMRealm *realm = self.realms[namespace];
//    if (!realm) {
//        NSString *folder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//        NSString *realmPath = [NSString stringWithFormat:@"%@/%@.realm", folder, namespace];
//        realm = [RLMRealm realmWithPath:realmPath];
//        [self.realms setObject:realm forKey:namespace];
//    }
//    return realm;
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
        RLMRealm *realm = [self realmWithNamespace:key];
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
    
    NSString *namespace = [objClass namespace];
    RLMRealm *realm = [self realmWithNamespace:namespace];
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
