//
//  YPBLiveShowRoom.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBLiveShowRoom.h"

@implementation YPBLiveShowRoom

+ (NSString *)primaryKey {
    return @"roomId";
}

+ (NSString *)namespace {
    return kUserLiveShowRoomPersistenceNamespace;
}

+ (instancetype)roomWithId:(NSUInteger)roomId {
    YPBLiveShowRoom *room = [[self alloc] init];
    room.roomId = @(roomId);
    room.accumulatedAudiences = @(arc4random_uniform(10000));
    room.currentAudiences = @(arc4random_uniform((u_int32_t)(room.accumulatedAudiences.unsignedIntegerValue)));
    room.popularity = @(arc4random_uniform(10000));
    return room;
}

+ (instancetype)existingRoomWithId:(NSUInteger)roomId {
    return [self objectInRealm:[self classRealm] forPrimaryKey:@(roomId)];
}
@end
