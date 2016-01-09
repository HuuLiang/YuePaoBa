//
//  YPBContact.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPBPersistentObject.h"

@class YPBPushedMessage;

@interface YPBContact : YPBPersistentObject

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *logoUrl;
@property (nonatomic) NSString *nickName;

@property (nonatomic) NSString *recentMessage;
@property (nonatomic) NSString *recentTime;
@property (nonatomic) NSNumber<RLMInt> *unreadMessages;

+ (instancetype)contactWithUser:(YPBUser *)user;
+ (instancetype)contactWithPushedMessage:(YPBPushedMessage *)message;
+ (instancetype)existingContactWithUserId:(NSString *)userId;
+ (NSArray<YPBContact *> *)allContacts;

+ (BOOL)refreshContactRecentTimeWithUser:(YPBUser *)user;

@end

RLM_ARRAY_TYPE(YPBContact)