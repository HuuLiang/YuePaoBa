//
//  YPBApplePay.m
//  YuePaoBa
//
//  Created by Liang on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBApplePay.h"

@interface YPBApplePay () <SKPaymentTransactionObserver,SKProductsRequestDelegate>

@end

@implementation YPBApplePay

+(YPBApplePay *)applePay {
    static YPBApplePay *_pay = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _pay = [[YPBApplePay alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:_pay];
    });
    return _pay;
}

+ (void)getProductionInfos {
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:@[]]];
    productsRequest.delegate = [self applePay];
    [productsRequest start];
}

- (void)payWithProductionId:(NSString *)proId {
    SKMutablePayment *aPayment = [[SKMutablePayment alloc] init];
    aPayment.productIdentifier = proId;
    [[SKPaymentQueue defaultQueue] addPayment:aPayment];
}

//获取支付结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
}

//获取商品详情
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
}

@end
