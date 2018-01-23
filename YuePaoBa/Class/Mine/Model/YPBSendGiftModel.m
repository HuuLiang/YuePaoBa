//
//  YPBSendGiftModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBSendGiftModel.h"

@implementation YPBSendGiftModel

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)sendGift:(NSNumber *)giftId
          toUser:(NSString *)userId
    withNickName:(NSString *)nickName completionHandler:(YPBCompletionHandler)handler
{
    if (!giftId || userId.length == 0 || nickName.length == 0 || ![YPBUser currentUser].isRegistered) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    NSDictionary *params = @{@"giftId":giftId,
                             @"giveUserId":[YPBUser currentUser].userId,
                             @"giveUserName":[YPBUser currentUser].nickName ?: @"",
                             @"receiveUserId":userId,
                             @"receiveUserName":nickName};
    BOOL ret = [self requestURLPath:YPB_SEND_GIFT_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, errorMessage);
    }];
    return ret;
}
@end
