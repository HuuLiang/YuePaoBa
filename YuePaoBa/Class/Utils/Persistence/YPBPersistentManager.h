//
//  YPBPersistentManager.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPBPersistentObject.h"

@interface YPBPersistentManager : NSObject

+ (instancetype)sharedManager;

- (NSArray *)persistentObjectsWithObjectClass:(Class)objClass;
- (NSError *)persistentObject:(YPBPersistentObject *)object;
- (void)persistentObjects:(YPBPersistentObjectArray *)objects;

- (RLMRealm *)realmWithPersistentClass:(Class)persistentClass;

@end
