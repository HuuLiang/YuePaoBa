//
//  YPBSettingViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBSettingViewController.h"

@interface YPBSettingViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_layoutTableView;
}
@property (nonatomic,retain) NSMutableDictionary *cells;
@end

@implementation YPBSettingViewController

DefineLazyPropertyInitialization(NSMutableDictionary, cells)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath {
    return self.cells[[NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row]];
}

- (void)setCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self.cells setObject:cell forKey:[NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row]];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellAtIndexPath:indexPath];
    if (cell) {
        return cell;
    }
    
    cell = [[UITableViewCell alloc] init];
    [self setCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
@end
