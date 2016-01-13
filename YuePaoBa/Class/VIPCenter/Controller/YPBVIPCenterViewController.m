//
//  YPBVIPCenterViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBVIPCenterViewController.h"
#import "YPBVIPCell.h"
#import "YPBUserListModel.h"
#import "YPBUserAccessModel.h"
#import "YPBUserDetailViewController.h"
#import "YPBMessageViewController.h"
#import "YPBContact.h"
#import "YPBVIPEntranceView.h"
#import "YPBVIPPriviledgeViewController.h"

static NSString *const kVIPCellReusableIdentifier = @"VIPCellReusableIdentifier";

@interface YPBVIPCenterViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_layoutTableView;
}
@property (nonatomic,retain) YPBUserListModel *userListModel;
@property (nonatomic,retain) NSMutableArray<YPBUser *> *users;

@property (nonatomic,retain) YPBUserAccessModel *userAccessModel;
@end

@implementation YPBVIPCenterViewController

DefineLazyPropertyInitialization(YPBUserListModel, userListModel)
DefineLazyPropertyInitialization(NSMutableArray, users)
DefineLazyPropertyInitialization(YPBUserAccessModel, userAccessModel)

- (void)didRestoreUser:(YPBUser *)user {
    [_layoutTableView YPB_triggerPullToRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _layoutTableView = [[UITableView alloc] init];
    _layoutTableView.delegate = self;
    _layoutTableView.dataSource = self;
    _layoutTableView.rowHeight = kScreenWidth * 0.6;
    _layoutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_layoutTableView registerClass:[YPBVIPCell class] forCellReuseIdentifier:kVIPCellReusableIdentifier];
    [self.view addSubview:_layoutTableView];
    {
        [_layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutTableView YPB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadDataWithRefresh:YES];
    }];
    
    if ([YPBUser currentUser].isRegistered) {
        [_layoutTableView YPB_triggerPullToRefresh];
    }
    
    [_layoutTableView YPB_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadDataWithRefresh:NO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVIPUpgradeSuccessNotification:) name:kVIPUpgradeSuccessNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![YPBUser currentUser].isVip) {
        @weakify(self);
        [YPBVIPEntranceView showVIPEntranceInView:self.view canClose:NO withEnterAction:^(id obj) {
            @strongify(self);
            YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] init];
            [self.navigationController pushViewController:vipVC animated:YES];
        }];
    }
}

- (void)loadDataWithRefresh:(BOOL)isRefresh {
    @weakify(self);
    YPBCompletionHandler handler = ^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutTableView YPB_endPullToRefresh];
        
        if (success && obj) {
            if (isRefresh) {
                [self.users removeAllObjects];
            }
            
            [self.users addObjectsFromArray:obj];
            [self->_layoutTableView reloadData];
            
            if (self.userListModel.hasNoMoreData) {
                [self->_layoutTableView YPB_pagingRefreshNoMoreData];
            }
        }
    };
    
    if (isRefresh) {
        [self.userListModel fetchUserListWithGender:[YPBUser currentUser].oppositeGender space:YPBUserSpaceVIP completionHandler:handler];
    } else {
        [self.userListModel fetchUserListInNextPageWithCompletionHandler:handler];
    }
}

- (void)onVIPUpgradeSuccessNotification:(NSNotification *)notification {
    YPBVIPEntranceView *entranceView = [YPBVIPEntranceView VIPEntranceInView:self.view];
    [entranceView hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBVIPCell *cell = [tableView dequeueReusableCellWithIdentifier:kVIPCellReusableIdentifier forIndexPath:indexPath];

    if (indexPath.row < self.users.count) {
        YPBUser *user = self.users[indexPath.row];
        cell.level = indexPath.row+1;
        cell.user = user;
        
        @weakify(self);
        cell.dateAction = ^(id sender) {
            @strongify(self);
            if ([YPBContact refreshContactRecentTimeWithUser:user]) {
                [YPBMessageViewController showMessageWithUser:user inViewController:self];
            }
        };
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBUser *user = self.users[indexPath.row];
    YPBUserDetailViewController *detailVC = [[YPBUserDetailViewController alloc] initWithUserId:user.userId];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
