//
//  YPBUserDetailViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBLayoutViewController.h"

@interface YPBUserDetailViewController : YPBLayoutViewController

@property (nonatomic,copy) YPBAction greetSuccessAction;

- (instancetype)initWithUserId:(NSString *)userId;

@end
