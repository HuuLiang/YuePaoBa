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
    
    if (resp == YPBURLResponseFailedByInterface) {
        YPBShowError(@"网络数据返回失败");
    } else if (resp == YPBURLResponseFailedByNetwork) {
        YPBShowError(@"网络错误，请检查网络连接");
    }
    
}
@end
