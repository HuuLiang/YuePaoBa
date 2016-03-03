//
//  YPBBarrage.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YPBBarrageType) {
    YPBBarrageTypeUnknown,
    YPBBarrageTypePhoto,
    YPBBarrageTypeVideo
};

@interface YPBBarrage : NSObject
@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *msg;
@property (nonatomic) NSNumber *objectType;
@property (nonatomic) NSNumber *objectId;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSNumber *barrageTime;
@property (nonatomic) NSString *userName;

@end
