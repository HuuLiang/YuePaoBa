//
//  YPBNeighborViewController.m
//  YuePaoBa
//
//  Created by Liang on 16/3/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBNeighborViewController.h"
#import "YPBNeighborCell.h"

@interface YPBNeighborViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_neighborTableView;
    NSMutableArray *_dataSource;
}
@end

@implementation YPBNeighborViewController

#pragma mark - system

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 10; i++) {
        NSString *str = [NSString stringWithFormat:@"cellContent%ld",(long)i];
        [_dataSource addObject:str];
    }
    
    _neighborTableView = [[UITableView alloc] init];
    _neighborTableView.backgroundColor = [UIColor cyanColor];
    [_neighborTableView registerClass:[YPBNeighborCell class] forCellReuseIdentifier:@"neighborCellId"];
    _neighborTableView.delegate = self;
    _neighborTableView.dataSource = self;
    [self.view addSubview:_neighborTableView];
}

- (void)viewWillLayoutSubviews {
    _neighborTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)viewDidLayoutSubviews {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBNeighborCell *cell = [tableView dequeueReusableCellWithIdentifier:@"neighborCellId" forIndexPath:indexPath];
    [cell setCellWithInfo:_dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"--------select Me-------");
}

@end
