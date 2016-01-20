//
//  YPBMessagePushModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBMessagePushModel.h"
#import "YPBContact.h"
#import "YPBChatMessage.h"

@implementation YPBMessagePushResponse

- (Class)msgListElementClass {
    return [YPBPushedMessage class];
}

@end

@interface YPBMessagePushModel ()
@property (nonatomic,retain) NSTimer *pollingTimer;
@property (nonatomic) NSUInteger pollingSeconds;
@end

@implementation YPBMessagePushModel

+ (instancetype)sharedModel {
    static YPBMessagePushModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[YPBMessagePushModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [YPBMessagePushResponse class];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (![YPBUser currentUser].isRegistered) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserRestoreSuccessNotification) name:kUserRestoreSuccessNotification object:nil];
        }
    }
    return self;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (void)onUserRestoreSuccessNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self notifyLoginPush];
}

- (void)notifyLoginPush {
    if ([YPBUser currentUser].isRegistered) {
        [YPBUtil accumalateLoginFrequency];
        [self startMessagePushPolling];
    }
}

- (void)startMessagePushPolling {
    @weakify(self);
    
    if ([YPBUtil loginFrequency] == 1) {
        const NSUInteger timeInterval = 30;
        self.pollingTimer = [NSTimer bk_scheduledTimerWithTimeInterval:timeInterval block:^(NSTimer *timer) {
            @strongify(self);
            [self fetchMessageWithUserId:[YPBUser currentUser].userId
                           loginDuration:self.pollingSeconds
                       completionHandler:^(BOOL success, id obj)
             {
                 if (success && obj) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:kMessagePushNotification object:obj];
                 }
             }];
            self.pollingSeconds += timeInterval;
            
            if (self.pollingSeconds > 60) {
                [self stopMessagePushPolling];
            }
        } repeats:YES];
        [self.pollingTimer fire];
    } else {
        NSUInteger seconds = [YPBUtil secondsSinceRegister];
        [self fetchMessageWithUserId:[YPBUser currentUser].userId
                       loginDuration:seconds
                   completionHandler:^(BOOL success, id obj)
        {
            if (success && obj) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMessagePushNotification object:obj];
            }
        }];
    }
}

- (void)stopMessagePushPolling {
    [self.pollingTimer invalidate];
    self.pollingTimer = nil;
}

- (BOOL)fetchMessageWithUserId:(NSString *)userId
                 loginDuration:(NSUInteger)duration
             completionHandler:(YPBCompletionHandler)handler
{
    if (userId.length == 0) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    @weakify(self);
    NSDictionary *params = @{@"userId":userId,
                             @"loginSeq":@([YPBUtil loginFrequency]),
                             @"duration":@(duration)};
    BOOL ret = [self requestURLPath:YPB_USER_MESSAGE_PUSH_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        NSArray<YPBPushedMessage *> *pushedMessages;
        if (respStatus == YPBURLResponseSuccess) {
            YPBMessagePushResponse *resp = self.response;
            
            pushedMessages = [resp.msgList bk_select:^BOOL(id obj) {
                YPBPushedMessage *msg = obj;
                if (msg.userId.length > 0) {
                    msg.msgTime = [YPBUtil currentDateString];
                    return YES;
                }
                return NO;
            }];
        }
        
        NSMutableArray<YPBChatMessage *> *chatMessages = [NSMutableArray array];
        [pushedMessages enumerateObjectsUsingBlock:^(YPBPushedMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YPBContact *contact = [YPBContact contactWithPushedMessage:obj];
            
            [contact beginUpdate];
            contact.unreadMessages = @(contact.unreadMessages.unsignedIntegerValue+1);
            contact.recentMessage = obj.proDesc;
            contact.recentTime = [YPBUtil currentDateString];
            [contact endUpdate];
            
            YPBChatMessage *chatMessage = [YPBChatMessage chatMessageFromPushedMessage:obj];
            if (chatMessage) {
                [chatMessage persist];
                [chatMessages addObject:chatMessage];
            }
        }];
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, chatMessages.count>0 ? chatMessages : nil);
    }];
    return ret;
}
@end
