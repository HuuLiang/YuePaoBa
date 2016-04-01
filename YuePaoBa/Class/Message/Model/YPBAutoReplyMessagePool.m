//
//  YPBAutoReplyMessagePool.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBAutoReplyMessagePool.h"
#import "YPBChatMessage.h"
#import "YPBAutoReplyMessage.h"
#import "YPBContact.h"

static const NSUInteger kRollingTimeInterval = 60;
static const NSUInteger kReplyingTimeInterval = 60 * 5;

@interface YPBAutoReplyMessagePool ()
@property (nonatomic,retain) dispatch_queue_t rollingQueue;
@end

@implementation YPBAutoReplyMessagePool

+ (instancetype)sharedPool {
    static YPBAutoReplyMessagePool *_sharedPool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPool = [[YPBAutoReplyMessagePool alloc] init];
    });
    return _sharedPool;
}

- (void)startRollingMessagesToAutoReply {
    if (self.rollingQueue) {
        return ;
    }
    self.rollingQueue = dispatch_queue_create("com.yuepaoba.message.autoreply.rolling.queue", nil);
    [self doRollingMessagesAndAutoReply];
}

- (void)doRollingMessagesAndAutoReply {
    dispatch_async(self.rollingQueue, ^{
        __block NSTimeInterval latestMessageInterval = kRollingTimeInterval;
        [[YPBAutoReplyMessage allUnrepliedMessages] enumerateObjectsUsingBlock:^(YPBAutoReplyMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDate *replyDateTime = [YPBUtil dateFromString:obj.replyTime];
            DLog(@"------replyDateTime----%@",replyDateTime);
            
            [[YPBLocalNotification sharedInstance] createLocalNotificationWithMessage:obj.replyMessage Date:replyDateTime];
            
            if ([replyDateTime isInPast]) {
                NSString *sender = obj.userId;
                NSString *message = obj.replyMessage;
                NSString *msgTime = obj.replyTime;
                DLog(@"--sender-%@---message-%@-----msgTime-%@---",sender,message,msgTime);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    YPBContact *contact = [YPBContact existingContactWithUserId:sender];
                    if (!contact) {
                        return ;
                    }
                    [contact beginUpdate];
                    contact.unreadMessages = @(contact.unreadMessages.unsignedIntegerValue+1);
                    contact.recentMessage = message;
                    contact.recentTime = msgTime;
                    [contact endUpdate];
                    
                    YPBChatMessage *replyMessage = [YPBChatMessage chatMessage];
                    replyMessage.sendUserId = sender;
                    replyMessage.receiveUserId = [YPBUser currentUser].userId;
                    replyMessage.msgType = @(YPBChatMessageTypeAutoReply);
                    replyMessage.msg = message;
                    replyMessage.msgTime = msgTime;
                    [replyMessage persist];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageChangeNotification object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMessagePushNotification object:@[replyMessage]];
                });
                
                [obj beginUpdate];
                obj.status = @(YPBAutoReplyStatusReplied);
                [obj endUpdate];
                
            } else {
                NSTimeInterval messageInterval = [[YPBUtil dateFromString:obj.replyTime] timeIntervalSinceNow];
                if (messageInterval < latestMessageInterval) {
                    latestMessageInterval = messageInterval;
                }
                DLog(@"Auto reply message: %@ - will reply in %ld seconds", obj.replyMessage, (long)messageInterval);
            }
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            sleep(latestMessageInterval);
            [self doRollingMessagesAndAutoReply];
        });
    });
}


- (void)addChatMessageForReply:(YPBChatMessage *)chatMessage {
    NSAssert(![chatMessage.receiveUserId isEqualToString:[YPBUser currentUser].userId], @"The receiver cannot be the current user for auto reply");
    
    NSString *userId = chatMessage.receiveUserId;
    
    dispatch_async(self.rollingQueue, ^{
        NSArray<YPBAutoReplyMessage *> *allMessages = [YPBAutoReplyMessage allMessages];
        
        YPBAutoReplyMessage *unrepliedMessage = [allMessages bk_match:^BOOL(YPBAutoReplyMessage *obj)
        {
            if ([obj.userId isEqualToString:userId]) {
                return YES;
            }
            return NO;
        }];
        if (unrepliedMessage) {
            return ;
        }
        
        NSMutableArray *allReplyWords = [NSMutableArray array];
        [allMessages enumerateObjectsUsingBlock:^(YPBAutoReplyMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [allReplyWords addObject:obj.replyMessage];
        }];
        NSString *replyWord = [[YPBAutoReplyWords sharedInstance] randomWordExcludeWords:allReplyWords];
        if (!replyWord) {
            replyWord = [[YPBAutoReplyWords sharedInstance] randomWord];
        }
        
        if (!replyWord) {
            return ;
        }
        
        YPBAutoReplyMessage *replyMessage = [YPBAutoReplyMessage replyMessage];
        replyMessage.userId = userId;
        replyMessage.replyTime = [YPBUtil stringFromDate:[NSDate dateWithTimeIntervalSinceNow:10+arc4random_uniform(kReplyingTimeInterval)]];
        replyMessage.replyMessage = replyWord;
        replyMessage.status = @(YPBAutoReplyStatusUnreplied);
        [replyMessage persist];
    });
    
}
@end
