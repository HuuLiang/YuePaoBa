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
@property (nonatomic,retain) NSMutableDictionary *cells;
@property (nonatomic,retain) NSMutableDictionary *cellHeights;
@end

@implementation YPBLayoutViewController
@synthesize layoutTableView = _layoutTableView;

DefineLazyPropertyInitialization(NSMutableDictionary, cells)
DefineLazyPropertyInitialization(NSMutableDictionary, cellHeights)

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
    
    _layoutTableView = [[TPKeyboardAvoidingTableView alloc] init];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    return _layoutTableView;
}

- (void)setLayoutCell:(UITableViewCell *)cell inRow:(NSUInteger)row andSection:(NSUInteger)section {
    [self setLayoutCell:cell cellHeight:_layoutTableView.rowHeight inRow:row andSection:section];
}

- (void)setLayoutCell:(UITableViewCell *)cell
           cellHeight:(CGFloat)height
                inRow:(NSUInteger)row
           andSection:(NSUInteger)section {
    NSString *indexString = [NSString stringWithFormat:@"%ld-%ld", section, row];
    [self.cells setObject:cell forKey:indexString];
    [self.cellHeights setObject:@(height) forKey:indexString];
}

- (NSString *)indexStringforIndexPath:(NSIndexPath *)indexPath {
    return indexPath ? [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row] : nil;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableSet *set = [NSMutableSet set];
    [self.cells.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj;
        NSArray *sep = [key componentsSeparatedByString:@"-"];
        if (sep.count == 2) {
            [set addObject:sep[0]];
        }
    }];
    return set.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = self.cells[[self indexStringforIndexPath:indexPath]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *keys = [self.cells.allKeys bk_select:^BOOL(id obj) {
        if ([obj hasPrefix:[NSString stringWithFormat:@"%ld-",section]]) {
            return YES;
        }
        return NO;
    }];
    return keys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = self.cellHeights[[self indexStringforIndexPath:indexPath]];
    return height.floatValue;
}
@end
