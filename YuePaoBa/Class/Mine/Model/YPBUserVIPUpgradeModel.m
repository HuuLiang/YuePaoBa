//
//  YPBUserVIPUpgradeModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBUserVIPUpgradeModel.h"
#import "YPBVipUpgradeInfo.h"

static const NSTimeInterval kRetryingTimeInterval = 5;

@interface YPBUserVIPUpgradeModel ()
@property (nonatomic,retain) NSTimer *retryingTimer;
@property (nonatomic,retain) dispatch_queue_t persistenceQueue;
@end

@implementation YPBUserVIPUpgradeModel

- (dispatch_queue_t)persistenceQueue {
    if (_persistenceQueue) {
        return _persistenceQueue;
    }
    
    _persistenceQueue = dispatch_queue_create("yuepaoba_vipupgrade_persistence_queue", nil);
    return _persistenceQueue;
}

+ (instancetype)sharedModel {
    static YPBUserVIPUpgradeModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (BOOL)upgradeToVIPWithMonths:(NSNumber *)months
                   upgradeTime:(NSString *)upgradeTime
             completionHandler:(YPBCompletionHandler)handler {
    if (![YPBUser currentUser].isRegistered || months == nil || upgradeTime.length == 0) {
        SafelyCallBlock2(handler, NO, nil);
        return NO;
    }
    
    YPBVipUpgradeInfo *info = [[YPBVipUpgradeInfo alloc] init];
    info.upgradeMonths = months;
    info.upgradeTime = upgradeTime;
    info.userId = [YPBUser currentUser].userId;
    return [self upgradeToVIPWithInfo:info completionHandler:handler];
}

- (BOOL)upgradeToVIPWithInfo:(YPBVipUpgradeInfo *)info completionHandler:(YPBCompletionHandler)handler {
    NSDictionary *params = @{@"userId":info.userId, @"months":info.upgradeMonths, @"buyTime":info.upgradeTime};
    @weakify(self);
    BOOL ret = [self requestURLPath:YPB_USER_VIP_UPGRADE_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
                {
//                    @strongify(self);
//                    dispatch_async(self.persistenceQueue, ^{
//                        info.upgradeStatus = respStatus == YPBURLResponseSuccess ? @(YPBVipUpgradeStatusCommited) : @(YPBVipUpgradeStatusUncommited);
//                        [info persist];
//                    });
                    SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, errorMessage);
                }];
    return ret;
}

- (void)startRetryingToCommitUnprocessedVIPInfos {
//    if (!self.retryingTimer) {
//        @weakify(self);
//        self.retryingTimer = [NSTimer bk_scheduledTimerWithTimeInterval:kRetryingTimeInterval block:^(NSTimer *timer) {
//            @strongify(self);
//            DLog(@"VIP: on retrying to commit unprocessed vip infos!");
//            dispatch_async(self.persistenceQueue, ^{
//                [self commitUnprocessedVIPInfos];
//            });
//        } repeats:YES];
//        [self.retryingTimer fire];
//    }
}

- (void)stopRetryingToCommitUnprocessedOrders {
    [self.retryingTimer invalidate];
    self.retryingTimer = nil;
}

- (void)commitUnprocessedVIPInfos {
    NSArray<YPBVipUpgradeInfo *> *upgradeInfos = [YPBVipUpgradeInfo allUncomittedInfos];
    [upgradeInfos enumerateObjectsUsingBlock:^(YPBVipUpgradeInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self upgradeToVIPWithInfo:obj completionHandler:nil];
    }];
}
@end
