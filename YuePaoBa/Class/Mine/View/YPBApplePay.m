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
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:@[@"YPB_VIP_30",@"YPB_VIP_90"]]];
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
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSLog(@"pay out:%ld",(long)transaction.transactionState);
        /*
         SKPaymentTransactionStatePurchasing,    // Transaction is being added to the server queue.
         SKPaymentTransactionStatePurchased,     // Transaction is in queue, user has been charged.  Client should complete the transaction.
         SKPaymentTransactionStateFailed,        // Transaction was cancelled or failed before being added to the server queue.
         SKPaymentTransactionStateRestored,      // Transaction was restored from user's purchase history.  Client should complete the transaction.
         SKPaymentTransactionStateDeferred*/
        NSLog(@"%@",transaction.transactionIdentifier);
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"正在购买中");
                break;
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"购买完成");
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                //验证字符串,如果是8.0以上的系统，通过新的方式获取到receiptData
                NSData * receiptData;
                NSString * version=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
                if (version.intValue>=8)
                {
                    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
                    receiptData = [NSData dataWithContentsOfURL:receiptUrl];
                }
                else
                {
                    receiptData = transaction.transactionReceipt;
                }
                NSString * base64Str=[self encode:receiptData.bytes length:receiptData.length];
                NSLog(@"%@",base64Str);
            }
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"购买失败");
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

-(NSString *)encode:(const uint8_t *)input length:(NSInteger)length
{
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    for (NSInteger i = 0; i < length; i += 3)
    {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++)
        {
            value <<= 8;
            if (j < length)
            {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

//获取商品详情
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"-------------myProduct-----------------%lu",(unsigned long)myProduct.count);
    NSLog(@"无效产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"--------------------");
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
    }
    [self payWithProductionId:@"YPB_VIP_30"];
}
@end
