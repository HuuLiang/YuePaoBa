//
//  YPBLayoutViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/11.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

@interface YPBLayoutViewController : YPBBaseViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain,readonly) UITableView *layoutTableView;

- (void)setLayoutCell:(UITableViewCell *)cell
                inRow:(NSUInteger)row
           andSection:(NSUInteger)section;

- (void)setLayoutCell:(UITableViewCell *)cell
           cellHeight:(CGFloat)height
                inRow:(NSUInteger)row
           andSection:(NSUInteger)section;
@end
