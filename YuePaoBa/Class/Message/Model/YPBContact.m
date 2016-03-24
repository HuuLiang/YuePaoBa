//
//  YPBContact.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBContact.h"
#import "YPBPersistentManager.h"
#import "YPBPushedMessage.h"
#import <Realm/RLMResults.h>

@implementation YPBContact

+ (NSString *)namespace {
    return kUserContactPersistenceNamespace;
}

+ (NSString *)primaryKey {
    return @"userId";
}

+ (NSArray<YPBContact *> *)allContacts {
    RLMResults *results = [self allObjectsInRealm:[self classRealm]];
    if (results.count == 0) {
        return nil;
    }
    
    results = [results sortedResultsUsingProperty:@"recentTime" ascending:NO];
    return [self objectsFromResults:results];
}

+ (instancetype)existingContactWithUserId:(NSString *)userId {
    return [self objectInRealm:[self classRealm] forPrimaryKey:userId];
}

+ (instancetype)contactWithUser:(YPBUser *)user {
    if (![user isRegistered]) {
        return nil;
    }
    
    YPBContact *contact = [self objectInRealm:[self classRealm] forPrimaryKey:user.userId];
    if (!contact) {
        contact = [[self alloc] init];
        contact.userId = user.userId;
        contact.logoUrl = user.logoUrl;
        contact.nickName = user.nickName;
        contact.userType = user.userType;
    }
    
    return contact;
}

+ (instancetype)contactWithPushedMessage:(YPBPushedMessage *)message {
    if (message.userId.length == 0) {
        return nil;
    }
    
    YPBContact *contact = [self objectInRealm:[self classRealm] forPrimaryKey:message.userId];
    if (!contact) {
        contact = [[self alloc] init];
        contact.userId = message.userId;
        contact.logoUrl = message.logoUrl;
        contact.nickName = message.nickName;
        contact.userType = @(YPBUserTypeRobot);
    }
    
    return contact;
}

+ (BOOL)refreshContactRecentTimeWithUser:(YPBUser *)user {
    YPBContact *contact = [self contactWithUser:user];
    
    [contact beginUpdate];
    contact.recentTime = [YPBUtil currentDateString];
    return [contact endUpdate] == nil;
}

+ (NSDictionary<NSString *,NSNumber *> *)newPropertiesForMigration {
    return @{@"userType":@(1)};
}

+ (NSDictionary<NSString *,id> *)newPropertyDefaultValuesForMigration {
    return @{@"userType":@(YPBUserTypeRobot)};
}

- (id)copyWithZone:(NSZone *)zone {
    YPBContact *contact = [[[self class] allocWithZone:zone] init];
    contact.userId = [self.userId copyWithZone:zone];
    contact.logoUrl = [self.logoUrl copyWithZone:zone];
    contact.nickName = [self.nickName copyWithZone:zone];
    contact.userType = [self.userType copyWithZone:zone];
    contact.recentMessage = [self.recentMessage copyWithZone:zone];
    contact.recentTime = [self.recentTime copyWithZone:zone];
    contact.unreadMessages = [self.unreadMessages copyWithZone:zone];
    return contact;
}
@end
