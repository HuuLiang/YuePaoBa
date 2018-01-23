//
//  YPBUserProfileViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/3/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBLayoutViewController.h"

@interface YPBUserProfileViewController : YPBLayoutViewController

@property (nonatomic,retain,readonly) YPBUser *user;

- (instancetype)initWithUser:(YPBUser *)user;

@end
