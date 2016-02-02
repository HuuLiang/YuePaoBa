//
//  YPBMessagePushModel.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"
#import "YPBPushedMessage.h"

@interface YPBMessagePushResponse : YPBURLResponse
@property (nonatomic,retain) NSArray<YPBPushedMessage *> *msgList;
@end

@interface YPBMessagePushModel : YPBEncryptedURLRequest

+ (instancetype)sharedModel;

- (void)notifyLoginPush;
- (void)fetchMessageByUserInteraction;

- (BOOL)fetchMessageWithUserId:(NSString *)userId
                 loginDuration:(NSUInteger)duration
             completionHandler:(YPBCompletionHandler)handler;

@end
