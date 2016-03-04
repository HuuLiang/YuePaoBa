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
    _layoutTableView.rowHeight = kScreenWidth * 0.5;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVIPUpgradeSuccessNotification) name:kVIPUpgradeSuccessNotification object:nil];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if (![YPBUtil isVIP]) {
//        @weakify(self);
//        [YPBVIPEntranceView showVIPEntranceInView:self.view canClose:NO withEnterAction:^(id obj) {
//            @strongify(self);
//            YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] init];
//            [self.navigationController pushViewController:vipVC animated:YES];
//        }];
//    }
//}

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

- (void)onVIPUpgradeSuccessNotification {
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
        
        @weakify(self,cell);
        cell.likeAction = ^(id sender) {
            @strongify(self,cell);
            if (user.isGreet) {
                [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"您已经和TA打过招呼了！" inViewController:self];
                return ;
            }
            
            if (![YPBUtil isVIP] && [YPBUser currentUser].greetCount.unsignedIntegerValue >= 5) {
                YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymentContentTypeGreetMore];
                [self.navigationController pushViewController:vipVC animated:YES];
                return;
            }
            
            [sender beginLoading];
            [self.userAccessModel accessUserWithUserId:user.userId accessType:YPBUserAccessTypeGreet completionHandler:^(BOOL success, id obj) {
                [sender endLoading];
                
                if (success) {
                    [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"打招呼成功" inViewController:self];
                    
                    user.receiveGreetCount = @(user.receiveGreetCount.unsignedIntegerValue+1);
                    user.isGreet = YES;
                    cell.user = user;
                }
            }];
        };
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YPBUser *user = self.users[indexPath.row];
    YPBVIPCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    YPBUserDetailViewController *detailVC = [[YPBUserDetailViewController alloc] initWithUserId:user.userId];
    detailVC.greetSuccessAction = ^(id obj) {
        cell.user.isGreet = YES;
        cell.user.receiveGreetCount = @(cell.user.receiveGreetCount.unsignedIntegerValue+1);
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
