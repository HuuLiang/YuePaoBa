//
//  YPBApplePay.h
//  YuePaoBa
//
//  Created by Liang on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol sendPaymentStateDelegate <NSObject>

- (void)sendPaymentState:(SKPaymentTransactionState)payState;

@end

@interface YPBApplePay : NSObject

@property (nonatomic) NSMutableArray *priceArray;

@property (nonatomic) BOOL isGettingPriceInfo;

@property (nonatomic)id<sendPaymentStateDelegate>delegate;

+ (YPBApplePay *)applePay;

- (void)getProductionInfos;

- (void)payWithProductionId:(NSString *)proId;

- (void)sendInfoToServer:(NSString *)identifier;


@end
