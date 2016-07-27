//
//  YPBContact.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBContact.h"
#import "YPBPushedMessage.h"

@implementation YPBContact

+ (NSString *)namespace {
    return kUserContactPersistenceNamespace;
}

+ (NSString *)primaryKey {
    return @"userId";
}

+ (NSArray<YPBContact *> *)allContacts {
    return [self findByCriteria:[NSString stringWithFormat:@"order by recentTime desc"]];
}

+ (instancetype)existingContactWithUserId:(NSString *)userId {
    return [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE userId=%@",userId]];
}

+ (instancetype)contactWithUser:(YPBUser *)user {
    if (![user isRegistered]) {
        return nil;
    }
    
    YPBContact *contact = [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE userId=%@",user.userId]];
    if (!contact) {
        contact = [[self alloc] init];
        contact.userId = user.userId;
        contact.logoUrl = user.logoUrl;
        contact.nickName = user.nickName;
        contact.userType = [user.userType integerValue];
    }
    
    return contact;
}

+ (instancetype)contactWithPushedMessage:(YPBPushedMessage *)message {
    if (message.userId.length == 0) {
        return nil;
    }
    
    YPBContact *contact = [self findFirstByCriteria:[NSString stringWithFormat:@"WHERE userId=%@",message.userId]];
    if (!contact) {
        contact = [[self alloc] init];
        contact.userId = message.userId;
        contact.logoUrl = message.logoUrl;
        contact.nickName = message.nickName;
        contact.userType = YPBUserTypeRobot;
    }
    
    return contact;
}

+ (BOOL)refreshContactRecentTimeWithUser:(YPBUser *)user {
    YPBContact *contact = [self contactWithUser:user];
    contact.recentTime = [YPBUtil currentDateString];
    return [contact saveOrUpdate];
}

+ (NSDictionary<NSString *,NSNumber *> *)newPropertiesForMigration {
    return @{@"userType":@(1)};
}

+ (NSDictionary<NSString *,id> *)newPropertyDefaultValuesForMigration {
    return @{@"userType":@(YPBUserTypeRobot)};
}
@end
