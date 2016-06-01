//
//  YPBErrorHandler.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/10.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "YPBErrorHandler.h"
#import "YPBURLRequest.h"

NSString *const kNetworkErrorNotification = @"YPBNetworkErrorNotification";
NSString *const kNetworkErrorCodeKey = @"YPBNetworkErrorCodeKey";
NSString *const kNetworkErrorMessageKey = @"YPBNetworkErrorMessageKey";
NSString *const kNetworkErrorValueKey   = @"YPBNetworkErrorValueKey";

@implementation YPBErrorHandler

+ (instancetype)sharedHandler {
    static YPBErrorHandler *_handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _handler = [[YPBErrorHandler alloc] init];
    });
    return _handler;
}

- (void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkError:) name:kNetworkErrorNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onNetworkError:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    YPBURLResponseStatus resp = (YPBURLResponseStatus)(((NSNumber *)userInfo[kNetworkErrorCodeKey]).unsignedIntegerValue);
    NSNumber *value = userInfo[kNetworkErrorValueKey];
    if (resp == YPBURLResponseFailedByInterface) {
        if ([value isEqualToNumber:@1009]) {
            YPBShowWarning(@"当前账号名未注册");
        } else if ([value isEqualToNumber:@1016]) {
            YPBShowWarning(@"密码不正确");
        } else if ([value isEqualToNumber:@1015]) {
            YPBShowWarning(@"获取授权失败");
        } else {
            YPBShowError(@"网络数据返回失败");
        }
    } else if (resp == YPBURLResponseFailedByNetwork) {
        YPBShowError(@"网络错误，请检查网络连接");
    }
    
}
@end
