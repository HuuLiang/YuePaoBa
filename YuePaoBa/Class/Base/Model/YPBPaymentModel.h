//
//  YPBPaymentModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/15.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "YPBEncryptedURLRequest.h"
#import "YPBPaymentInfo.h"

@interface YPBPaymentModel : YPBEncryptedURLRequest

+ (instancetype)sharedModel;

- (void)startRetryingToCommitUnprocessedOrders;
- (void)commitUnprocessedOrders;
- (BOOL)commitPaymentInfo:(YPBPaymentInfo *)paymentInfo;

@end
