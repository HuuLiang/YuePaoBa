//
//  YPBActivateModel.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/19.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBActivateModel.h"

@implementation YPBActivateResponse

@end

@implementation YPBActivateModel

+ (instancetype)sharedModel {
    static YPBActivateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[YPBActivateModel alloc] init];
    });
    return _sharedModel;
}

+ (Class)responseClass {
    return [YPBActivateResponse class];
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (BOOL)requestActivationWithCompletionHandler:(YPBCompletionHandler)handler {
    NSString *appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSDictionary *params = @{@"channelNo":YPB_CHANNEL_NO,
                             @"appVersion":appVersion,
                             @"appId":YPB_REST_APPID};
    
    @weakify(self);
    BOOL success = [self requestURLPath:YPB_USER_ACTIVATION_URL
                             withParams:params
                        responseHandler:^(YPBURLResponseStatus respStatus,
                                          NSString *errorMessage)
    {
        @strongify(self);
        if (respStatus == YPBURLResponseSuccess) {
            YPBActivateResponse *response = self.response;
            _activationId = response.uuid;
        }
        SafelyCallBlock2(handler, respStatus == YPBURLResponseSuccess, _activationId);
    }];
    return success;
}

//- (void)processResponseObject:(id)responseObject withResponseHandler:(YPBURLResponseHandler)responseHandler {
//    NSNumber *code = responseObject[@"code"];
//    if (code.unsignedIntegerValue == kSuccessResponseCode) {
//        <#statements#>
//    }
//}

@end
