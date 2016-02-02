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
    return [self objectsFromPersistence];
}

+ (NSArray<YPBAutoReplyMessage *> *)allUnrepliedMessages {

    RLMResults *results = [self objectsInRealm:[[self class] classRealm] where:@"status==%ld", YPBAutoReplyStatusUnreplied];
    return [self objectsFromResults:results];
}

+ (instancetype)replyMessage {
    YPBAutoReplyMessage *message = [[self alloc] init];
    message.msgId = [NSUUID UUID].UUIDString.md5;
    return message;
}
@end
