//
//  YPBEditMineDetailViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/24.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBLayoutViewController.h"

@interface YPBEditMineDetailViewController : YPBLayoutViewController

@property (nonatomic,retain,readonly) YPBUser *user;

- (instancetype)initWithUser:(YPBUser *)user;

@end
