//
//  YPBApplePay.h
//  YuePaoBa
//
//  Created by Liang on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface YPBApplePay : NSObject

+ (YPBApplePay *)applePay;

+ (void)getProductionInfos;

- (void)payWithProductionId:(NSString *)proId;

@end
