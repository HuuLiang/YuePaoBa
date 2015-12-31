//
//  YPBLayoutViewController.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/11.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBBaseViewController.h"

typedef void (^YPBLayoutTableViewAction)(NSIndexPath *indexPath, UITableViewCell *cell);

@interface YPBLayoutViewController : YPBBaseViewController <UITableViewSeparatorDelegate,UITableViewDataSource>

@property (nonatomic,retain,readonly) UITableView *layoutTableView;
@property (nonatomic,copy) YPBLayoutTableViewAction layoutTableViewAction;

// Cell & Cell Height
- (void)setLayoutCell:(UITableViewCell *)cell
                inRow:(NSUInteger)row
           andSection:(NSUInteger)section;

- (void)setLayoutCell:(UITableViewCell *)cell
           cellHeight:(CGFloat)height
                inRow:(NSUInteger)row
           andSection:(NSUInteger)section;

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)cellHeightAtIndexPath:(NSIndexPath *)indexPath;

// Header height & title
- (void)setHeaderHeight:(CGFloat)height inSection:(NSUInteger)section;
- (void)setHeaderTitle:(NSString *)title height:(CGFloat)height inSection:(NSUInteger)section;

@end
