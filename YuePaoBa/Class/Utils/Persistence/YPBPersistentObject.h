//
//  YPBPersistentObject.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMObject.h>
#import <Realm/RLMProperty.h>
#import <Realm/RLMResults.h>

@interface YPBPersistentObject : RLMObject

+ (NSString *)primaryKey;
+ (NSString *)namespace;
- (NSError *)persist;

+ (NSArray *)objectsFromPersistence;
+ (NSArray *)objectsFromResults:(RLMResults *)results;

+ (RLMRealm *)classRealm;

- (void)beginUpdate;
- (NSError *)endUpdate;

@end

typedef NSArray<YPBPersistentObject *> YPBPersistentObjectArray;
typedef NSMutableArray<YPBPersistentObject *> YPBPersistentObjectMutableArray;