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
@property (nonatomic,copy) YPBCompletionHandler completionHandler;
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
    self.completionHandler = handle;
    if (paymentInfo.paymentType.unsignedIntegerValue == YPBPaymentTypeWeChatPay) {
        [[WeChatPayManager sharedInstance] startWeChatPayWithOrderNo:paymentInfo.orderId
                                                               price:paymentInfo.orderPrice.unsignedIntegerValue
                                                   completionHandler:^(PAYRESULT payResult)
        {
            @strongify(self);
            [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
            //SafelyCallBlock2(handle, payResult==PAYRESULT_SUCCESS, paymentInfo);
        }];
    } else if (paymentInfo.paymentType.unsignedIntegerValue == YPBPaymentTypeAlipay) {
        [[AlipayManager shareInstance] startAlipay:paymentInfo.orderId
                                             price:paymentInfo.orderPrice.unsignedIntegerValue
                                        withResult:^(PAYRESULT result, Order *order)
         {
            @strongify(self);
            [self notifyPaymentResult:result withPaymentInfo:paymentInfo];
            //SafelyCallBlock2(handle, result==PAYRESULT_SUCCESS, paymentInfo);
        }];
    } else {
        SafelyCallBlock2(self.completionHandler, PAYRESULT_UNKNOWN, paymentInfo);
        self.completionHandler = nil;
    }
}

- (void)notifyPaymentResult:(PAYRESULT)result withPaymentInfo:(YPBPaymentInfo *)paymentInfo {
    if (result == PAYRESULT_SUCCESS) {
        NSArray<YPBPaymentInfo *> *successPaymentInfos = [YPBUtil allSuccessfulPaymentInfos];
        if ([successPaymentInfos bk_any:^BOOL(id obj) {
            YPBPaymentInfo *successPaymentInfo = obj;
            return [successPaymentInfo.orderId isEqualToString:paymentInfo.orderId];
        }]) {
            DLog(@"Payment order: %@ has already paid !", paymentInfo.orderId);
            SafelyCallBlock2(self.completionHandler, result==PAYRESULT_SUCCESS, paymentInfo);
            self.completionHandler = nil;
            return ;
        }
    }
    
    paymentInfo.paymentResult = @(result);
    paymentInfo.paymentStatus = @(YPBPaymentStatusNotProcessed);
    [paymentInfo save];
    
    [[YPBPaymentModel sharedModel] commitPaymentInfo:paymentInfo];
    
    if (paymentInfo.payPointType.unsignedIntegerValue == YPBPayPointTypeVIP) {
        [self upgradeVIPWithPaymentInfo:paymentInfo];
    } else if (paymentInfo.payPointType.unsignedIntegerValue == YPBPayPointTypeGift) {
//        [self sendGiftWithPaymentInfo:paymentInfo];
    }
    
    SafelyCallBlock2(self.completionHandler, result==PAYRESULT_SUCCESS, paymentInfo);
    self.completionHandler = nil;
}

- (void)upgradeVIPWithPaymentInfo:(YPBPaymentInfo *)paymentInfo {
    PAYRESULT result = paymentInfo.paymentResult.unsignedIntegerValue;
    if (result == PAYRESULT_SUCCESS) {
        NSString *vipExpireTime = [YPBUtil renewVIPByMonths:paymentInfo.monthsPaid.unsignedIntegerValue];
        [self.vipUpgradeModel upgradeToVIPWithExpireTime:vipExpireTime completionHandler:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kVIPUpgradeSuccessNotification object:nil];
    }
}

//- (void)sendGiftWithPaymentInfo:(YPBPaymentInfo *)paymentInfo {
//    PAYRESULT result = paymentInfo.paymentResult.unsignedIntegerValue;
//    if (result == PAYRESULT_SUCCESS) {
//        [self.sendGiftModel sendGift:gift.id
//                              toUser:self.user.userId
//                        withNickName:self.user.nickName
//                   completionHandler:^(BOOL success, id obj)
//         {
//             
//         }];
//    }
//}
@end
