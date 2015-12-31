//
//  YPBMineFigureViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/29.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBLayoutViewController.h"

@interface YPBMineFigureViewController : YPBLayoutViewController

@property (nonatomic,retain,readonly) YPBUser *user;
@property (nonatomic,copy) YPBAction saveAction;

- (instancetype)initWithUser:(YPBUser *)user;

@end
