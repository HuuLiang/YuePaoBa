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
@property (nonatomic,retain) NSMutableDictionary<NSString *, RLMRealm *> *realms;
@end

@implementation YPBPersistentManager

DefineLazyPropertyInitialization(NSMutableDictionary, realms)

+ (instancetype)sharedManager {
    static YPBPersistentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[YPBPersistentManager alloc] init];
    });
    return _sharedManager;
}

- (void)persistentObject:(YPBPersistentObject *)object {
    RLMRealm *realm = [self realmWithNamespace:[object namespace]];
    [realm beginWriteTransaction];
    [realm addObject:object];
    [realm commitWriteTransaction];
}

- (RLMRealm *)realmWithNamespace:(NSString *)namespace {
    RLMRealm *realm = self.realms[namespace];
    if (!realm) {
        NSString *realmPath = [NSString stringWithFormat:@"%@/%@.rlm", [NSBundle mainBundle].resourcePath, namespace];
        realm = [RLMRealm realmWithPath:realmPath];
        [self.realms setObject:realm forKey:namespace];
    }
    return realm;
}

- (void)persistentObjects:(YPBPersistentObjectArray *)objects {
    NSMutableDictionary<NSString *, YPBPersistentObjectMutableArray *> *objectNamespaceMapping = [NSMutableDictionary dictionary];
    [objects enumerateObjectsUsingBlock:^(YPBPersistentObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YPBPersistentObjectMutableArray *arr = objectNamespaceMapping[obj.namespace];
        if (!arr) {
            arr = [YPBPersistentObjectMutableArray array];
            [objectNamespaceMapping setObject:arr forKey:obj.namespace];
        }
        
        [arr addObject:obj];
    }];
    
    [objectNamespaceMapping enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, YPBPersistentObjectMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
        RLMRealm *realm = [self realmWithNamespace:key];
        [realm beginWriteTransaction];
        [obj enumerateObjectsUsingBlock:^(YPBPersistentObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [realm addObject:obj];
        }];
        [realm commitWriteTransaction];
    }];
}
@end
