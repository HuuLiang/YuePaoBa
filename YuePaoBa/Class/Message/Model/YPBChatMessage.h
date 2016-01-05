//
//  YPBChatMessage.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPBPersistentObject.h"

typedef NS_ENUM(NSUInteger, YPBChatMessageType) {
    YPBChatMessageTypeUnknown,
    YPBChatMessageTypeWord,
    YPBChatMessageTypePhoto,
    YPBChatMessageTypeVoice
};

@interface YPBChatMessage : YPBPersistentObject

@property (nonatomic) NSString *sendUserId;
@property (nonatomic) NSString *receiveUserId;
@property (nonatomic) NSNumber *msgType;
@property (nonatomic) NSString *msg;
@property (nonatomic) NSString *msgTime;

@end
