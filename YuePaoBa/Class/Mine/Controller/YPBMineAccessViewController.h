//
//  YPBMineAccessViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/31.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

typedef NS_ENUM(NSUInteger, YPBMineAccessType) {
    YPBMineAccessTypeGreetingSent,
    YPBMineAccessTypeGreetingReceived,
    YPBMineAccessTypeAccessViewed
};

@interface YPBMineAccessViewController : YPBBaseViewController

@property (nonatomic,readonly) YPBMineAccessType accessType;

- (instancetype)initWithAccessType:(YPBMineAccessType)accessType;

@end
