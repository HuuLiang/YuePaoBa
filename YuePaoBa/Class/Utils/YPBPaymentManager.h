//
//  YPBPaymentManager.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPBPaymentInfo.h"

@interface YPBPaymentManager : NSObject

+ (instancetype)sharedManager;

- (void)payWithPaymentInfo:(YPBPaymentInfo *)paymentInfo completionHandler:(YPBCompletionHandler)handler;
- (void)notifyPaymentResult:(PAYRESULT)result withPaymentInfo:(YPBPaymentInfo *)paymentInfo;

@end
