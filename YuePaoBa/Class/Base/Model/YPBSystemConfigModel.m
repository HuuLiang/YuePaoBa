//
//  YPBSystemConfigModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBSystemConfigModel.h"

#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@implementation YPBSystemConfigResponse

- (Class)dataClass {
    return [YPBSystemConfig class];
}

@end

@implementation YPBSystemConfigModel

+ (instancetype)sharedModel {
    static YPBSystemConfigModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[YPBSystemConfigModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [YPBSystemConfigResponse class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)fetchSystemConfigWithCompletionHandler:(YPBCompletionHandler)handler {
    NSDictionary *params = @{@"clientVersion":XcodeAppVersion,@"channle":YPB_CHANNEL_NO};
    @weakify(self);
    BOOL ret = [self requestURLPath:YPB_SYSTEM_CONFIG_URL
                         withParams:params
                    responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        @strongify(self);
        
        YPBSystemConfig *systemConfig;
        if (respStatus == YPBURLResponseSuccess) {
            YPBSystemConfigResponse *resp = self.response;
            systemConfig = resp.data;
            self.fetchedSystemConfig = systemConfig;
        }
        
        SafelyCallBlock2(handler, respStatus==YPBURLResponseSuccess, systemConfig);
    }];
    return ret;
}

- (void)sendPushInfoWithUserID:(NSString *)userId clientID:(NSString *)clientId {
    NSLog(@"%@ %@",userId,clientId);
    DLog(@"userId================>%@ clientId================>%@",userId,clientId);
    NSDictionary * params = @{@"userId":userId,
                              @"clientId":clientId};
    BOOL ret = [self requestURLPath:YPB_UPDATE_CID_URL withParams:params responseHandler:nil];
    if (ret) {
        DLog(@"updata clientId success");
    } else {
        DLog(@"updata clientId failed");
    }
}

@end
