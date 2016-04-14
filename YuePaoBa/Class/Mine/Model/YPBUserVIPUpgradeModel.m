//
//  YPBUserVIPUpgradeModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBUserVIPUpgradeModel.h"
#import "YPBVipUpgradeInfo.h"

static const NSTimeInterval kRetryingTimeInterval = 180;

@interface YPBUserVIPUpgradeModel ()
@property (nonatomic,retain) NSTimer *retryingTimer;
@end

@implementation YPBUserVIPUpgradeModel

+ (instancetype)sharedModel {
    static YPBUserVIPUpgradeModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (BOOL)upgradeToVIPWithExpireTime:(NSString *)expireTime
                 completionHandler:(YPBCompletionHandler)handler {
    if (![YPBUser currentUser].isRegistered || expireTime.length == 0) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    NSDictionary *params = @{@"userId":[YPBUser currentUser].userId,
                             @"vipEndTime":expireTime};
    BOOL ret = [self requestURLPath:YPB_USER_VIP_UPGRADE_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    if (respStatus == YPBURLResponseSuccess) {
                        [YPBUser currentUser].isVip = YES;
                        [YPBUser currentUser].vipEndTime = expireTime;
                        [[YPBUser currentUser] saveAsCurrentUser];
                    }
                    SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, errorMessage);
                }];
    return ret;
}

- (void)startRetryingToSynchronizeVIPInfos {
    if (!self.retryingTimer) {
        @weakify(self);
        self.retryingTimer = [NSTimer bk_scheduledTimerWithTimeInterval:kRetryingTimeInterval block:^(NSTimer *timer) {
            @strongify(self);
            DLog(@"VIP: on retrying to commit unprocessed vip infos!");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self synchronizeVIPInfos];
            });
        } repeats:YES];
        [self.retryingTimer fire];
    }
}

- (void)stopRetryingToCommitUnprocessedOrders {
    [self.retryingTimer invalidate];
    self.retryingTimer = nil;
}

- (void)synchronizeVIPInfos {
    if (![[YPBUser currentUser].vipEndTime isEqualToString:[YPBUtil vipExpireDate]]) {
        NSDate *localVipExpTime = [YPBUtil dateFromString:[YPBUtil vipExpireDate]];
        NSDate *remoteVipExpTime = [YPBUtil dateFromString:[YPBUser currentUser].vipEndTime];
        if (remoteVipExpTime == nil || [remoteVipExpTime isEarlierThanDate:localVipExpTime]) {
            [self upgradeToVIPWithExpireTime:[YPBUtil vipExpireDate] completionHandler:nil];
        } else if (remoteVipExpTime != nil && [localVipExpTime isEarlierThanDate:remoteVipExpTime]) {
            [YPBUtil setVIPExpireDate:[YPBUser currentUser].vipEndTime];
        }
    }
}
@end
