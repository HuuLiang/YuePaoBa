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
#import "YPBVIPPriviledgeViewController.h"
#import "YPBActivityPayView.h"

static NSString *const kVIPCellReusableIdentifier = @"VIPCellReusableIdentifier";

@interface YPBVIPCenterViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_layoutTableView;
}
@property (nonatomic,retain) YPBUserListModel *userListModel;
@property (nonatomic,retain) NSMutableArray<YPBUser *> *users;
@property (nonatomic) YPBActivityPayView *payView;
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
    
    [self popVipView];
    
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

- (void)popVipView {
    @weakify(self);
    if (![YPBUtil isVIP]) {
        [self.view beginLoading];
        if (!self.payView) {
            _payView = [[YPBActivityPayView alloc] init];
            [self.view addSubview:_payView];
            self.payView.img = [UIImage imageNamed:@"vipcenter_banner.jpg"];
            self.payView.closeBtnHidden = NO;
            self.payView.closeBlock = ^(void) {
                @strongify(self);
                [self.payView removeFromSuperview];
                [self.view endLoading];
            };
            
            {
                [_payView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view);
                    make.centerY.equalTo(self.view).offset(SCREEN_HEIGHT * 0.05);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.6));
                }];
            }
        } else {
            self.payView.hidden = NO;
        }
        
    } else {
        [self.view endLoading];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.payView) {
        self.payView.hidden = YES;
        [self.view endLoading];
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

- (void)onVIPUpgradeSuccessNotification {
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
