//
//  YPBLiveShowRoom.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPersistentObject.h"

@interface YPBLiveShowRoom : YPBPersistentObject

@property (nonatomic) NSNumber<RLMInt> *roomId;
@property (nonatomic) NSNumber<RLMInt> *accumulatedAudiences;
@property (nonatomic) NSNumber<RLMInt> *currentAudiences;
@property (nonatomic) NSNumber<RLMInt> *popularity;

+ (instancetype)roomWithId:(NSUInteger)roomId;
+ (instancetype)existingRoomWithId:(NSUInteger)roomId;

@end
