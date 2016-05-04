//
//  YPBCommonCityViewController.m
//  YuePaoBa
//
//  Created by Liang on 16/5/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBCommonCityViewController.h"

@interface YPBCommonCityViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation YPBCommonCityViewController

DefineLazyPropertyInitialization(NSMutableArray,dataSource);

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self.dataSource addObjectsFromArray:@[@"1",@"2",@"3",@"4"]];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}
@end
