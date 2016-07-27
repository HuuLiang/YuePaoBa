//
//  YPBLiveShowRoom.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/2.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPersistentObject.h"
#import "JKDBModel.h"

@interface YPBLiveShowRoom : JKDBModel

@property (nonatomic) NSInteger roomId;
@property (nonatomic) NSInteger accumulatedAudiences;
@property (nonatomic) NSInteger currentAudiences;
@property (nonatomic) NSInteger popularity;

+ (instancetype)roomWithId:(NSInteger)roomId;
+ (instancetype)existingRoomWithId:(NSInteger)roomId;

@end
