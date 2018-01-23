//
//  YPBMyGiftDetailViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"
#import "YPBUserGiftsDataSource.h"

@interface YPBMyGiftDetailViewController : YPBBaseViewController

@property (nonatomic,assign) id<YPBUserGiftsDataSource> dataSource;
@property (nonatomic) NSString *summaryPrefix;

- (instancetype)initWithDataSource:(id<YPBUserGiftsDataSource>)dataSource;

@end
