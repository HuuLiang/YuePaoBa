//
//  YPBSendBarrageModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBSendBarrageModel.h"

@implementation YPBSendBarrageModel

- (BOOL)sendBarrage:(NSString *)barrage forPhoto:(NSNumber *)photoId withCompletionHandler:(YPBCompletionHandler)handler {
    if (barrage.length == 0 || photoId == nil || ![YPBUser currentUser].isRegistered) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    NSDictionary *params = @{@"msg":barrage,
                             @"userId":[YPBUser currentUser].userId,
                             @"objectType":@1,
                             @"objectId":photoId};
    
    BOOL ret = [self requestURLPath:YPB_SEND_BARRAGE_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
