//
//  YPBAutoReplyMessage.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBAutoReplyMessage.h"

@implementation YPBAutoReplyMessage

+ (NSString *)namespace {
    return kAutoReplyMessagePersistentNamespace;
}

+ (NSString *)primaryKey {
    return @"msgId";
}

+ (NSArray<YPBAutoReplyMessage *> *)allMessages {
    return [self findAll];
}

+ (NSArray<YPBAutoReplyMessage *> *)allUnrepliedMessages {
    return [self findByCriteria:[NSString stringWithFormat:@"WHERE status==%ld",YPBAutoReplyStatusUnreplied]];
}

+ (instancetype)replyMessage {
    YPBAutoReplyMessage *message = [[self alloc] init];
    message.msgId = [NSUUID UUID].UUIDString.md5;
    return message;
}
@end
