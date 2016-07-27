//
//  YPBChatMessage.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

typedef NS_ENUM(NSUInteger, YPBChatMessageType) {
    YPBChatMessageTypeUnknown,
    YPBChatMessageTypeWord,
    YPBChatMessageTypePhoto,
    YPBChatMessageTypeVoice,
    YPBChatMessageTypeOption,
    YPBChatMessageTypeAutoReply,
    YPBChatMessageTypeRobotPush,
};

typedef NS_ENUM(NSUInteger ,YPBRobotPushType) {
    YPBRobotPushTypeUnknown,
    YPBRobotPushTypeWelCome,
    YPBRobotPushTypeGreet
};

@class YPBPushedMessage;

@interface YPBChatMessage : JKDBModel

@property (nonatomic) NSString *msgId;
@property (nonatomic) NSString *sendUserId;
@property (nonatomic) NSString *receiveUserId;

@property (nonatomic) NSInteger msgType;
@property (nonatomic) NSString *msg;
@property (nonatomic) NSString *msgTime;

@property (nonatomic) NSString *options;

+ (instancetype)chatMessage;
+ (NSArray<YPBChatMessage *> *)allMessagesForUser:(NSString *)userId;

+ (instancetype)chatMessageFromPushedMessage:(YPBPushedMessage *)message;
@end
