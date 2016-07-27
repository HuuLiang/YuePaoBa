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

+ (instancetype)roomWithId:(NSInteger)roomId {
    NSDate *date = [NSDate date];
    
    YPBLiveShowRoom *room = [[self alloc] init];
    room.roomId = roomId;
    room.accumulatedAudiences = arc4random_uniform(date.hour>12?1000:100);
    room.currentAudiences = arc4random_uniform((u_int32_t)(room.accumulatedAudiences));
    room.popularity = arc4random_uniform(date.hour>12?1000:100);
    return room;
}

+ (instancetype)existingRoomWithId:(NSInteger)roomId {
    [self createTable];
    int i = [[NSNumber numberWithUnsignedInteger:roomId] intValue];
    
    return [self findByPK:i];
}
@end
