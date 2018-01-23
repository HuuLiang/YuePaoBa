//
//  YPBApplePay.m
//  YuePaoBa
//
//  Created by Liang on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBApplePay.h"
#import "YPBPaymentManager.h"
#import "YPBPaymentInfo.h"
#import "YPBPaymentManager.h"
#import "YPBUtil.h"
#import "YPBUserVIPUpgradeModel.h"
#import "YPBMessageCenter.h"

@interface YPBApplePay () <SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic,retain) YPBUserVIPUpgradeModel *vipUpgradeModel;
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

- (void)getProductionInfos {
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:@[@"YPB_VIP_1Month",@"YPB_VIP_3Month"]]];
    productsRequest.delegate = self;
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
        NSLog(@"pay out:%ld  id:%@",(long)transaction.transactionState,transaction.payment.productIdentifier);
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
                DLog("-----------base64Str------: %@",base64Str);
                
                /**
                 *  验证成功之后向自己的服务器提交结果
                 */
                [self sendInfoToServer:transaction.payment.productIdentifier];
                [self.delegate sendPaymentState:transaction.transactionState];
            }
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"购买失败");
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
                [self.delegate sendPaymentState:transaction.transactionState];
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
    _priceArray = [[NSMutableArray alloc] init];
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
        [_priceArray addObject:product.price];
    }
    
    [self setPriceInfoWithArray:_priceArray];
    
}

- (void)setPriceInfoWithArray:(NSArray *)array {
    [YPBSystemConfig sharedConfig].vipPointInfo = [NSString stringWithFormat:@"%d:1|%d:3",[_priceArray[0] integerValue]*100,[_priceArray[1] integerValue]*100];
    DLog("-----vipInfo-%@---",[YPBSystemConfig sharedConfig].vipPointInfo);
    _isGettingPriceInfo = NO;
}

#pragma mark - receiptData
- (void)sendInfoToServer:(NSString *)identifier {
    DLog("----identifier-----%@-",identifier);
    NSString *vipExpireTime = nil;
    if ([identifier isEqualToString:@"YPB_VIP_1Month"]) {
        vipExpireTime = [YPBUtil renewVIPByMonths:1];
    } else if ([identifier isEqualToString:@"YPB_VIP_3Month"]) {
        vipExpireTime = [YPBUtil renewVIPByMonths:3];
    }

    [self.vipUpgradeModel upgradeToVIPWithExpireTime:vipExpireTime completionHandler:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kVIPUpgradeSuccessNotification object:nil];
    YPBShowMessage(@"激活会员成功");
}

@end
