//
//  YPBReportViolationViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/17.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBLayoutViewController.h"

@interface YPBReportViolationViewController : YPBLayoutViewController

@property (nonatomic,readonly) NSString *userId;

- (instancetype)initWithUserId:(NSString *)userId;

@end
