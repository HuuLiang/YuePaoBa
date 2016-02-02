//
//  YPBAutoReplyMessagePool.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YPBChatMessage;

@interface YPBAutoReplyMessagePool : NSObject

+ (instancetype)sharedPool;
- (void)startRollingMessagesToAutoReply;

- (void)addChatMessageForReply:(YPBChatMessage *)chatMessage;

@end
