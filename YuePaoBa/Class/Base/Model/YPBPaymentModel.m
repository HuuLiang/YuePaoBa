//
//  YPBPaymentModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/15.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "YPBPaymentModel.h"
#import "NSDictionary+YPBSign.h"
#import "YPBPaymentInfo.h"

static const NSTimeInterval kRetryingTimeInterval = 180;

static NSString *const kSignKey = @"qdge^%$#@(sdwHs^&";
static NSString *const kPaymentEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";

typedef void (^YPBPaymentCompletionHandler)(BOOL success);

@interface YPBPaymentModel ()
@property (nonatomic,retain) NSTimer *retryingTimer;
@end

@implementation YPBPaymentModel

+ (instancetype)sharedModel {
    static YPBPaymentModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[YPBPaymentModel alloc] init];
    });
    return _sharedModel;
}

- (NSURL *)baseURL {
    return nil;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (YPBURLRequestMethod)requestMethod {
    return YPBURLPostRequest;
}

+ (NSString *)signKey {
    return kSignKey;
}

- (NSDictionary *)encryptWithParams:(NSDictionary *)params {
    NSDictionary *signParams = @{  @"appId":YPB_REST_APPID,
                                   @"key":kSignKey,
                                   @"imsi":@"999999999999999",
                                   @"channelNo":YPB_CHANNEL_NO,
                                   @"pV":YPB_REST_PV };
    
    NSString *sign = [signParams signWithDictionary:[self class].commonParams keyOrders:[self class].keyOrdersOfCommonParams];
    NSString *encryptedDataString = [params encryptedStringWithSign:sign password:kPaymentEncryptionPassword excludeKeys:@[@"key"]];
    return @{@"data":encryptedDataString, @"appId":YPB_REST_APPID};
}

- (void)startRetryingToCommitUnprocessedOrders {
    if (!self.retryingTimer) {
        @weakify(self);
        self.retryingTimer = [NSTimer bk_scheduledTimerWithTimeInterval:kRetryingTimeInterval block:^(NSTimer *timer) {
            @strongify(self);
            DLog(@"Payment: on retrying to commit unprocessed orders!");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self commitUnprocessedOrders];
            });
        } repeats:YES];
        [self.retryingTimer fire];
    }
}

- (void)stopRetryingToCommitUnprocessedOrders {
    [self.retryingTimer invalidate];
    self.retryingTimer = nil;
}

- (void)commitUnprocessedOrders {
    NSArray<YPBPaymentInfo *> *unprocessedPaymentInfos = [YPBUtil paidNotProcessedPaymentInfos];
    [unprocessedPaymentInfos enumerateObjectsUsingBlock:^(YPBPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self commitPaymentInfo:obj];
    }];
}

- (BOOL)commitPaymentInfo:(YPBPaymentInfo *)paymentInfo {
    return [self commitPaymentInfo:paymentInfo withCompletionHandler:nil];
}

- (BOOL)commitPaymentInfo:(YPBPaymentInfo *)paymentInfo withCompletionHandler:(YPBPaymentCompletionHandler)handler {
    NSDictionary *statusDic = @{@(PAYRESULT_SUCCESS):@(1), @(PAYRESULT_FAIL):@(0), @(PAYRESULT_ABANDON):@(2), @(PAYRESULT_UNKNOWN):@(0)};
    
    if ([YPBUser currentUser].userId.length == 0 || paymentInfo.orderId.length == 0) {
        return NO;
    }
    
    NSDictionary *params = @{@"uuid":[YPBUtil activationId],
                             @"orderNo":paymentInfo.orderId,
                             @"imsi":@"999999999999999",
                             @"imei":@"999999999999999",
                             @"payMoney":paymentInfo.orderPrice.stringValue,
                             @"channelNo":YPB_CHANNEL_NO,
                             @"contentId":paymentInfo.contentId ?: [YPBUser currentUser].userId,
                             @"contentType":paymentInfo.contentType ?: @"0",
                             @"pluginType":paymentInfo.paymentType,
                             @"payPointType":paymentInfo.payPointType ?: @(YPBPayPointTypeUnknown),
                             @"appId":YPB_REST_APPID,
                             @"versionNo":@(YPB_REST_APP_VERSION.integerValue),
                             @"status":statusDic[paymentInfo.paymentResult],
                             @"pV":YPB_REST_PV,
                             @"payTime":paymentInfo.paymentTime,
                             @"notePayTimes":@([YPBUtil loginFrequency])};
    
    BOOL success = [super requestURLPath:YPB_PAYMENT_COMMIT_URL
                              withParams:params
                         responseHandler:^(YPBURLResponseStatus respStatus, NSString *errorMessage)
    {
        if (respStatus == YPBURLResponseSuccess) {
            paymentInfo.paymentStatus = @(YPBPaymentStatusProcessed);
            [paymentInfo save];
        } else {
            DLog(@"Payment: fails to commit the order with orderId:%@", paymentInfo.orderId);
        }
                        
        if (handler) {
            handler(respStatus == YPBURLResponseSuccess);
        }
    }];
    return success;
}

- (void)processResponseObject:(id)responseObject withResponseHandler:(YPBURLResponseHandler)responseHandler {
    NSDictionary *decryptedResponse = [self decryptResponse:responseObject];
    DLog(@"Payment response : %@", decryptedResponse);
    NSNumber *respCode = decryptedResponse[@"response_code"];
    YPBURLResponseStatus status = (respCode.unsignedIntegerValue == 100) ? YPBURLResponseSuccess : YPBURLResponseFailedByInterface;
    if (responseHandler) {
        responseHandler(status, nil);
    }
}
@end
