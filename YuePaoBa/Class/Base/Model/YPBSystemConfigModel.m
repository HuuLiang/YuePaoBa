//
//  YPBSystemConfigModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBSystemConfigModel.h"

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
    @weakify(self);
    BOOL ret = [self requestURLPath:YPB_SYSTEM_CONFIG_URL
                         withParams:nil
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
@end
