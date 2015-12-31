//
//  YPBLayoutViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/11.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBLayoutViewController.h"
#import <TPKeyboardAvoidingTableView.h>

@interface YPBLayoutViewController ()
@property (nonatomic,retain) NSMutableDictionary<NSIndexPath *, UITableViewCell *> *cells;
@property (nonatomic,retain) NSMutableDictionary<NSIndexPath *, NSNumber *> *cellHeights;
@property (nonatomic,retain) NSMutableDictionary<NSNumber *, NSNumber *> *headerHeights;
@property (nonatomic,retain) NSMutableDictionary<NSNumber *, NSString *> *headerTitles;
@end

@implementation YPBLayoutViewController
@synthesize layoutTableView = _layoutTableView;

DefineLazyPropertyInitialization(NSMutableDictionary, cells)
DefineLazyPropertyInitialization(NSMutableDictionary, cellHeights)
DefineLazyPropertyInitialization(NSMutableDictionary, headerHeights)
DefineLazyPropertyInitialization(NSMutableDictionary, headerTitles)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.layoutTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)layoutTableView {
    if (_layoutTableView) {
        return _layoutTableView;
    }
    
    _layoutTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _layoutTableView.backgroundColor = kDefaultBackgroundColor;
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.hasRowSeparator = YES;
    _layoutTableView.hasSectionBorder = YES;
    _layoutTableView.sectionFooterHeight = 0.1;
    return _layoutTableView;
}

- (void)setLayoutCell:(UITableViewCell *)cell inRow:(NSUInteger)row andSection:(NSUInteger)section {
    [self setLayoutCell:cell cellHeight:_layoutTableView.rowHeight inRow:row andSection:section];
}

- (void)setLayoutCell:(UITableViewCell *)cell
           cellHeight:(CGFloat)height
                inRow:(NSUInteger)row
           andSection:(NSUInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.cells setObject:cell forKey:indexPath];
    [self.cellHeights setObject:@(height) forKey:indexPath];
}

- (void)setHeaderHeight:(CGFloat)height inSection:(NSUInteger)section {
    [self.headerHeights setObject:@(height) forKey:@(section)];
}

- (void)setHeaderTitle:(NSString *)title height:(CGFloat)height inSection:(NSUInteger)section {
    [self.headerHeights setObject:@(height) forKey:@(section)];
    [self.headerTitles setObject:title forKey:@(section)];
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath {
    return self.cells[indexPath];
}

- (CGFloat)cellHeightAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeights[indexPath].floatValue;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableSet *set = [NSMutableSet set];
    [self.cells.allKeys enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [set addObject:@(obj.section)];
    }];
    return set.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellAtIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *keys = [self.cells.allKeys bk_select:^BOOL(NSIndexPath *obj) {
        return obj.section == section;
    }];
    return keys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return MAX(self.headerHeights[@(section)].floatValue,0.1);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    const CGFloat headerHeight = self.headerHeights[@(section)].floatValue;
    if (headerHeight < 0.5) {
        return nil;
    }

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = tableView.backgroundColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14.];
    titleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.headerTitles[@(section)];
    [headerView addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerView);
        }];
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellAtIndexPath:indexPath];
    if (cell.selectionStyle != UITableViewCellSelectionStyleNone) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    SafelyCallBlock2(self.layoutTableViewAction, indexPath, cell);
}
@end
