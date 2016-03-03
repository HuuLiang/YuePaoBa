//
//  YPBVIPPriviledgeViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

@interface YPBVIPPriviledgeViewController : YPBBaseViewController

@property (nonatomic) YPBPaymentContentType contentType;

- (instancetype)init __attribute__((unavailable("Must use initWithContentType: instead.")));
- (instancetype)initWithContentType:(YPBPaymentContentType)contentType;

@end
