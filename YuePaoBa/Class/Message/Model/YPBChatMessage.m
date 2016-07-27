//
//  YPBChatMessage.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBChatMessage.h"
#import "YPBPushedMessage.h"

@implementation YPBChatMessage

+ (NSString *)namespace {
    return kUserMessagePersistenceNamespace;
}

+ (instancetype)chatMessage {
    YPBChatMessage *message = [[self alloc] init];
    message.msgId = [NSUUID UUID].UUIDString.md5;
    return message;
}

+ (NSArray<YPBChatMessage *> *)allMessagesForUser:(NSString *)userId {
    return [self findByCriteria:[NSString stringWithFormat:@"WHERE sendUserId=%@ or receiveUserId=%@",userId,userId]];
}

+ (instancetype)lastMessageForUser:(NSString *)userId {
    return nil;
}

+ (NSString *)primaryKey {
    return @"msgId";
}

+ (instancetype)chatMessageFromPushedMessage:(YPBPushedMessage *)message {
    NSString *sendUserId = message.userId;
    NSString *receiveUserId = [YPBUser currentUser].userId;
    if (sendUserId.length == 0 || receiveUserId.length == 0) {
        return nil;
    }
    
    YPBChatMessage *chatMessage = [self chatMessage];
    chatMessage.sendUserId = sendUserId;
    chatMessage.receiveUserId = receiveUserId;
    chatMessage.msgType = YPBChatMessageTypeOption;
    chatMessage.msg = message.proDesc;
    chatMessage.options = message.options;
    chatMessage.msgTime = message.msgTime;
    return chatMessage;
}
@end
