//
//  YPBBlacklistController.m
//  YuePaoBa
//
//  Created by Liang on 16/4/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBBlacklistController.h"
#import "YPBBlacklist.h"
#import "YPBBlacklistDetail.h"

@interface YPBBlacklistController ()
{
    NSMutableArray *_selectedIndexPath;
}

@end

@implementation YPBBlacklistController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _array = [NSMutableArray arrayWithArray:[[YPBBlacklist sharedInstance] getAllUserInfo]];
    [self.tableView registerClass:[YPBBlacklistDetail class] forCellReuseIdentifier:@"cellId"];
    DLog("%@",_array);
    
    _selectedIndexPath = [[NSMutableArray alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editeStyle:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}   

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBBlacklistDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    [cell updateInfoWithUserInfo:_array[indexPath.row]];
    return cell;
}

//编辑模式风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        [_selectedIndexPath addObject:indexPath];
        self.navigationItem.rightBarButtonItem.title = @"删除";
        if (_selectedIndexPath.count == _array.count) {
            self.navigationItem.leftBarButtonItem.title = @"全不选";
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.isEditing) {
        [_selectedIndexPath removeObject:indexPath];
        if (_selectedIndexPath.count == 0) {
            self.navigationItem.rightBarButtonItem.title = @"取消";
            self.navigationItem.leftBarButtonItem.title = @"全选";
        }
    }
}

#pragma mark - 编辑模式
- (void)deleteRowAtIndexPathes:(NSArray *)indexPathes {
    //删除数组的元素会影响后面的顺序，需要倒序删除
    NSArray * newIndexPathes = [indexPathes sortedArrayUsingSelector:@selector(compare:)];
    for (NSInteger i = newIndexPathes.count-1; i>= 0 ; i--) {
        NSIndexPath * indexPath = newIndexPathes[i];
        //删除数据源中的数据
        [_array removeObjectAtIndex:indexPath.row];
    }
}

//右button按钮事件
- (void)editeStyle:(UIBarButtonItem *)rightItem {
    if ([rightItem.title isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES animated:YES];
        rightItem.title = @"取消";
        [self.navigationItem setHidesBackButton:YES];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAll:)];
        self.navigationItem.leftBarButtonItem = leftItem;
    } else if ([rightItem.title isEqualToString:@"取消"]) {
        [self.tableView setEditing:NO animated:YES];
        rightItem.title = @"编辑";
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationItem setHidesBackButton:NO];
    } else if ([rightItem.title isEqualToString:@"删除"]) {
        [self deleteRowAtIndexPathes:_selectedIndexPath];
        [self.tableView deleteRowsAtIndexPaths:_selectedIndexPath withRowAnimation:UITableViewRowAnimationAutomatic];
        [_selectedIndexPath removeAllObjects];
        if (_array.count == 0) {
            [self.tableView setEditing:NO animated:YES];
            rightItem.title = @"编辑";
            self.navigationItem.leftBarButtonItem = nil;
            [self.navigationItem setHidesBackButton:NO];
        }
        [[YPBBlacklist sharedInstance] updateUserInfo:_array];
        rightItem.title = @"取消";
    }
}

//左button按钮事件
- (void)selectAll:(UIBarButtonItem *)leftItem {
    //获取表格视图内容的尺寸
    CGSize size = self.tableView.contentSize;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    //获取指定区域的cell的indexPath
    NSArray * indexPathes = [self.tableView indexPathsForRowsInRect:rect];
    
    if ([leftItem.title isEqualToString:@"全选"]) {
        for (NSIndexPath * indexPath in indexPathes) {
            //使用代码方式选中一行
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        //更新选中数组
        _selectedIndexPath.array = indexPathes;
        self.navigationItem.rightBarButtonItem.title = @"删除";
        leftItem.title = @"全不选";
    } else if ([leftItem.title isEqualToString:@"全不选"]) {
        for (NSIndexPath * indexPath in indexPathes) {
            //使用代码方式取消选中一行
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        //清空选中cell的记录数组
        [_selectedIndexPath removeAllObjects];
        self.navigationItem.rightBarButtonItem.title = @"取消";
        leftItem.title = @"全选";
    }
}


@end
