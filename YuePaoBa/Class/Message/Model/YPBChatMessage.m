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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sendUserId=%@ or receiveUserId=%@", userId, userId];
    RLMResults *results = [self objectsInRealm:[self classRealm] withPredicate:predicate];
    return [self objectsFromResults:results];
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
    chatMessage.msgType = @(YPBChatMessageTypeOption);
    chatMessage.msg = message.proDesc;
    chatMessage.options = message.options;
    chatMessage.msgTime = message.msgTime;
    return chatMessage;
}

- (id)copyWithZone:(NSZone *)zone {
    YPBChatMessage *copiedMessage = [[[self class] allocWithZone:zone] init];
    copiedMessage.msgId = [self.msgId copyWithZone:zone];
    copiedMessage.sendUserId = [self.sendUserId copyWithZone:zone];
    copiedMessage.receiveUserId = [self.receiveUserId copyWithZone:zone];
    copiedMessage.msgType = [self.msgType copyWithZone:zone];
    copiedMessage.msg = [self.msg copyWithZone:zone];
    copiedMessage.msgTime = [self.msgTime copyWithZone:zone];
    copiedMessage.options = [self.options copyWithZone:zone];
    return copiedMessage;
}
@end
