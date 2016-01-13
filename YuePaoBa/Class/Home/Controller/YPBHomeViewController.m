//
//  YPBHomeViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBHomeViewController.h"
#import "YPBUserListModel.h"
#import "YPBHomeCollectionViewLayout.h"
#import "YPBHomeCell.h"
#import "YPBUserDetailViewController.h"
#import "YPBVIPEntranceView.h"
#import "YPBVIPPriviledgeViewController.h"

static NSString *const kHomeCellReusableIdentifier = @"HomeCellReusableIdentifier";

@interface YPBHomeViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain) YPBUserListModel *userListModel;
@property (nonatomic,retain) NSMutableArray<YPBUser *> *users;
@end

@implementation YPBHomeViewController

DefineLazyPropertyInitialization(YPBUserListModel, userListModel)
DefineLazyPropertyInitialization(NSMutableArray, users)

- (void)didRestoreUser:(YPBUser *)user {
    [_layoutCollectionView YPB_triggerPullToRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    YPBHomeCollectionViewLayout *layout = [[YPBHomeCollectionViewLayout alloc] init];
    layout.interItemSpacing = 1;
    
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = self.view.backgroundColor;
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    [_layoutCollectionView registerClass:[YPBHomeCell class] forCellWithReuseIdentifier:kHomeCellReusableIdentifier];
    [self.view addSubview:_layoutCollectionView];
    {
        [_layoutCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    @weakify(self);
    [_layoutCollectionView YPB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadOrRefreshData:YES];
    }];
    
    if ([YPBUser currentUser].isRegistered) {
        [_layoutCollectionView YPB_triggerPullToRefresh];
    }
    
    [_layoutCollectionView YPB_addPagingRefreshWithHandler:^{
        @strongify(self);
        [self loadOrRefreshData:NO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVIPUpgradeSuccessNotification:) name:kVIPUpgradeSuccessNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadOrRefreshData:(BOOL)isRefresh {
    if (![YPBUser currentUser].isVip && [self.userListModel.paginator.page isEqualToNumber:[YPBSystemConfig sharedConfig].firstPayPages]) {
        [_layoutCollectionView YPB_endPullToRefresh];
        
        @weakify(self);
        [YPBVIPEntranceView showVIPEntranceInView:self.view canClose:YES withEnterAction:^(id obj) {
            @strongify(self);
            YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] init];
            [self.navigationController pushViewController:vipVC animated:YES];
        }];
        return ;
    }
    
    @weakify(self);
    YPBCompletionHandler handler = ^(BOOL success, id obj) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_layoutCollectionView YPB_endPullToRefresh];
        
        if (success && obj) {
            if (isRefresh) {
                [self.users removeAllObjects];
            }
            
            [self.users addObjectsFromArray:obj];
            [self->_layoutCollectionView reloadData];
            
            if (self.userListModel.hasNoMoreData) {
                [self->_layoutCollectionView YPB_pagingRefreshNoMoreData];
            }
        } else if ([obj isKindOfClass:[NSString class]]) {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:obj inViewController:self];
        }
    };
    
    if (isRefresh) {
        [self.userListModel fetchUserListWithGender:[YPBUser currentUser].oppositeGender space:YPBUserSpaceHome completionHandler:handler];
    } else {
        [self.userListModel fetchUserListInNextPageWithCompletionHandler:handler];
    }
}

- (void)onVIPUpgradeSuccessNotification:(NSNotification *)notification {
    [[YPBVIPEntranceView VIPEntranceInView:self.view] hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YPBHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellReusableIdentifier forIndexPath:indexPath];
    cell.user = self.users[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.users.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YPBUser *user = self.users[indexPath.item];
    YPBUserDetailViewController *detailVC = [[YPBUserDetailViewController alloc] initWithUserId:user.userId];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
