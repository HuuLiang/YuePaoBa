//
//  YPBPersistentObject.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/RLMObject.h>

@interface YPBPersistentObject : RLMObject

+ (NSString *)primaryKey;
- (NSString *)namespace;
- (void)persist;

@end

typedef NSArray<YPBPersistentObject *> YPBPersistentObjectArray;
typedef NSMutableArray<YPBPersistentObject *> YPBPersistentObjectMutableArray;