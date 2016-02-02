//
//  YPBAutoReplyMessage.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPersistentObject.h"

typedef NS_ENUM(NSUInteger, YPBAutoReplyStatus) {
    YPBAutoReplyStatusUnreplied,
    YPBAutoReplyStatusReplied
};

@interface YPBAutoReplyMessage : YPBPersistentObject

@property (nonatomic) NSString *msgId;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *replyMessage;
@property (nonatomic) NSString *replyTime;
@property (nonatomic) NSNumber<RLMInt> *status;

+ (instancetype)replyMessage;
+ (NSArray<YPBAutoReplyMessage *> *)allMessages;
+ (NSArray<YPBAutoReplyMessage *> *)allUnrepliedMessages;

@end

RLM_ARRAY_TYPE(YPBAutoReplyMessage)