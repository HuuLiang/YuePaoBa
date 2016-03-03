//
//  YPBSendGiftViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

@interface YPBSendGiftViewController : YPBBaseViewController

@property (nonatomic,retain,readonly) YPBUser *user;

- (instancetype)initWithUser:(YPBUser *)user;

@end
