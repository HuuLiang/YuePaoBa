//
//  YPBPaymentInfo.m
//  yuepaoba
//
//  Created by Sean Yue on 15/12/17.
//  Copyright © 2015年 yuepaoba. All rights reserved.
//

#import "YPBPaymentInfo.h"
#import "NSMutableDictionary+Safety.h"

static NSString *const kPaymentInfoPaymentIdKeyName = @"yuepaoba_paymentinfo_paymentid_keyname";
static NSString *const kPaymentInfoOrderIdKeyName = @"yuepaoba_paymentinfo_orderid_keyname";
static NSString *const kPaymentInfoOrderPriceKeyName = @"yuepaoba_paymentinfo_orderprice_keyname";
static NSString *const kPaymentInfoContentIdKeyName = @"yuepaoba_paymentinfo_contentid_keyname";
static NSString *const kPaymentInfoContentTypeKeyName = @"yuepaoba_paymentinfo_contenttype_keyname";
static NSString *const kPaymentInfoPayPointTypeKeyName = @"yuepaoba_paymentinfo_paypointtype_keyname";
static NSString *const kPaymentInfoMonthsPaidKeyName = @"yuepaoba_paymentinfo_monthspaid_keyname";
static NSString *const kPaymentInfoPaymentTypeKeyName = @"yuepaoba_paymentinfo_paymenttype_keyname";
static NSString *const kPaymentInfoPaymentResultKeyName = @"yuepaoba_paymentinfo_paymentresult_keyname";
static NSString *const kPaymentInfoPaymentStatusKeyName = @"yuepaoba_paymentinfo_paymentstatus_keyname";
static NSString *const kPaymentInfoPaymentTimeKeyName = @"yuepaoba_paymentinfo_paymenttime_keyname";

@implementation YPBPaymentInfo

- (NSString *)paymentId {
    if (_paymentId) {
        return _paymentId;
    }
    
    _paymentId = [NSUUID UUID].UUIDString.md5;
    return _paymentId;
}

+ (instancetype)paymentInfoFromDictionary:(NSDictionary *)payment {
    YPBPaymentInfo *paymentInfo = [[self alloc] init];
    paymentInfo.paymentId = payment[kPaymentInfoPaymentIdKeyName];
    paymentInfo.orderId = payment[kPaymentInfoOrderIdKeyName];
    paymentInfo.orderPrice = payment[kPaymentInfoOrderPriceKeyName];
    paymentInfo.contentId = payment[kPaymentInfoContentIdKeyName];
    paymentInfo.contentType = payment[kPaymentInfoContentTypeKeyName];
    paymentInfo.payPointType = payment[kPaymentInfoPayPointTypeKeyName];
    paymentInfo.monthsPaid = payment[kPaymentInfoMonthsPaidKeyName];
    paymentInfo.paymentType = payment[kPaymentInfoPaymentTypeKeyName];
    paymentInfo.paymentResult = payment[kPaymentInfoPaymentResultKeyName];
    paymentInfo.paymentStatus = payment[kPaymentInfoPaymentStatusKeyName];
    paymentInfo.paymentTime = payment[kPaymentInfoPaymentTimeKeyName];
    return paymentInfo;
}

- (NSDictionary *)dictionaryFromCurrentPaymentInfo {
    NSMutableDictionary *payment = [NSMutableDictionary dictionary];
    [payment safely_setObject:self.paymentId forKey:kPaymentInfoPaymentIdKeyName];
    [payment safely_setObject:self.orderId forKey:kPaymentInfoOrderIdKeyName];
    [payment safely_setObject:self.orderPrice forKey:kPaymentInfoOrderPriceKeyName];
    [payment safely_setObject:self.contentId forKey:kPaymentInfoContentIdKeyName];
    [payment safely_setObject:self.contentType forKey:kPaymentInfoContentTypeKeyName];
    [payment safely_setObject:self.payPointType forKey:kPaymentInfoPayPointTypeKeyName];
    [payment safely_setObject:self.monthsPaid forKey:kPaymentInfoMonthsPaidKeyName];
    [payment safely_setObject:self.paymentType forKey:kPaymentInfoPaymentTypeKeyName];
    [payment safely_setObject:self.paymentResult forKey:kPaymentInfoPaymentResultKeyName];
    [payment safely_setObject:self.paymentStatus forKey:kPaymentInfoPaymentStatusKeyName];
    [payment safely_setObject:self.paymentTime forKey:kPaymentInfoPaymentTimeKeyName];
    return payment;
}

- (void)save {
    NSArray *paymentInfos = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentInfoKeyName];
    
    NSMutableArray *paymentInfosM = [paymentInfos mutableCopy];
    if (!paymentInfosM) {
        paymentInfosM = [NSMutableArray array];
    }
    
    NSDictionary *payment = [paymentInfos bk_match:^BOOL(id obj) {
        NSString *paymentId = ((NSDictionary *)obj)[kPaymentInfoPaymentIdKeyName];
        if ([paymentId isEqualToString:self.paymentId]) {
            return YES;
        }
        return NO;
    }];
    
    if (payment) {
        [paymentInfosM removeObject:payment];
    }
    
    payment = [self dictionaryFromCurrentPaymentInfo];
    [paymentInfosM addObject:payment];
    
    [[NSUserDefaults standardUserDefaults] setObject:paymentInfosM forKey:kPaymentInfoKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DLog(@"Save payment info: %@", payment);
}

@end
