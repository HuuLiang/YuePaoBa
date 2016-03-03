//
//  YPBPaymentManager.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPaymentManager.h"
#import "WeChatPayManager.h"
#import "AlipayManager.h"
#import "YPBPaymentModel.h"
#import "YPBUserVIPUpgradeModel.h"

@interface YPBPaymentManager ()
@property (nonatomic,retain) YPBUserVIPUpgradeModel *vipUpgradeModel;
@end

@implementation YPBPaymentManager

DefineLazyPropertyInitialization(YPBUserVIPUpgradeModel, vipUpgradeModel)

+ (instancetype)sharedManager {
    static YPBPaymentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)payWithPaymentInfo:(YPBPaymentInfo *)paymentInfo completionHandler:(YPBCompletionHandler)handle {
    NSParameterAssert(paymentInfo.isValid);
    if (!paymentInfo.isValid) {
        SafelyCallBlock2(handle, NO, paymentInfo);
        return ;
    } else {
        [paymentInfo save];
    }
    
    @weakify(self);
    if (paymentInfo.paymentType.unsignedIntegerValue == YPBPaymentTypeWeChatPay) {
        [[WeChatPayManager sharedInstance] startWeChatPayWithOrderNo:paymentInfo.orderId
                                                               price:paymentInfo.orderPrice.unsignedIntegerValue
                                                   completionHandler:^(PAYRESULT payResult)
        {
            @strongify(self);
            [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
            SafelyCallBlock2(handle, payResult==PAYRESULT_SUCCESS, paymentInfo);
        }];
    } else if (paymentInfo.paymentType.unsignedIntegerValue == YPBPaymentTypeAlipay) {
        [[AlipayManager shareInstance] startAlipay:paymentInfo.orderId
                                             price:paymentInfo.orderPrice.unsignedIntegerValue
                                        withResult:^(PAYRESULT result, Order *order)
         {
            @strongify(self);
            [self notifyPaymentResult:result withPaymentInfo:paymentInfo];
            SafelyCallBlock2(handle, result==PAYRESULT_SUCCESS, paymentInfo);
        }];
    }
}

- (void)notifyPaymentResult:(PAYRESULT)result withPaymentInfo:(YPBPaymentInfo *)paymentInfo {
    paymentInfo.paymentResult = @(result);
    paymentInfo.paymentStatus = @(YPBPaymentStatusNotProcessed);
    [paymentInfo save];
    
    [[YPBPaymentModel sharedModel] commitPaymentInfo:paymentInfo];
    
    if (paymentInfo.payPointType.unsignedIntegerValue == YPBPayPointTypeVIP) {
        [self upgradeVIPWithPaymentInfo:paymentInfo];
    } else if (paymentInfo.payPointType.unsignedIntegerValue == YPBPayPointTypeGift) {
        [self sendGiftWithPaymentInfo:paymentInfo];
    }
}

- (void)upgradeVIPWithPaymentInfo:(YPBPaymentInfo *)paymentInfo {
    PAYRESULT result = paymentInfo.paymentResult.unsignedIntegerValue;
    if (result == PAYRESULT_SUCCESS) {
        NSString *vipExpireTime = [YPBUtil renewVIPByMonths:paymentInfo.monthsPaid.unsignedIntegerValue];
        [self.vipUpgradeModel upgradeToVIPWithExpireTime:vipExpireTime completionHandler:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kVIPUpgradeSuccessNotification object:nil];
    }
}

- (void)sendGiftWithPaymentInfo:(YPBPaymentInfo *)paymentInfo {
    
}
@end
