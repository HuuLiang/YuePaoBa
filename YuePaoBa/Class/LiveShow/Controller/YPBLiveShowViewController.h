//
//  YPBLiveShowViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

@interface YPBLiveShowViewController : YPBBaseViewController

@property (nonatomic,retain,readonly) YPBUser *user;

- (instancetype)initWithUser:(YPBUser *)user;

@end
