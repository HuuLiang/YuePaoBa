//
//  YPBWebViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

@interface YPBWebViewController : YPBBaseViewController

@property (nonatomic) NSURL *url;

- (instancetype)initWithURL:(NSURL *)url;

@end
