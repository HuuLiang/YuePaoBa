//
//  YPBSendBarrageModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBSendBarrageModel.h"

@implementation YPBSendBarrageModel

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)sendBarrage:(NSString *)barrage
        forObjectId:(NSNumber *)objectId
        barrageType:(YPBBarrageType)barrageType
   barrageTimestamp:(NSNumber *)timestamp withCompletionHandler:(YPBCompletionHandler)handler {
    if (barrage.length == 0 || objectId == nil || barrageType == YPBBarrageTypeUnknown || ![YPBUser currentUser].isRegistered) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    NSDictionary *params = @{@"msg":barrage,
                             @"userId":[YPBUser currentUser].userId,
                             @"objectType":@(barrageType),
                             @"objectId":objectId,
                             @"barrageTime":timestamp?:@(0),
                             @"userName":[YPBUser currentUser].nickName ?: [NSNull null]};
    
    BOOL ret = [self requestURLPath:YPB_SEND_BARRAGE_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, errorMessage);
    }];
    return ret;
}

@end
