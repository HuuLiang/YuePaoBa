//
//  YPBCommonCityViewController.m
//  YuePaoBa
//
//  Created by Liang on 16/5/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBCommonCityViewController.h"
#import "YPBUserListModel.h"
#import "YPBHomeCollectionViewLayout.h"
#import "YPBHomeCell.h"
#import "YPBUserDetailViewController.h"
#import "YPBVIPPriviledgeViewController.h"
#import "YPBUserAccessModel.h"
#import "YPBMessagePushModel.h"

static NSString *const kHomeCellReusableIdentifier = @"HomeCellReusableIdentifier";


@interface YPBCommonCityViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_layoutCollectionView;
}
@property (nonatomic,retain) YPBUserListModel *userListModel;
@property (nonatomic,retain) NSMutableArray<YPBUser *> *users;
@property (nonatomic,retain) YPBUserAccessModel *userAccessModel;
@end

@implementation YPBCommonCityViewController

DefineLazyPropertyInitialization(YPBUserListModel, userListModel)
DefineLazyPropertyInitialization(NSMutableArray, users)
DefineLazyPropertyInitialization(YPBUserAccessModel, userAccessModel);

- (void)didRestoreUser:(YPBUser *)user {
    [_layoutCollectionView YPB_triggerPullToRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    YPBHomeCollectionViewLayout *layout = [[YPBHomeCollectionViewLayout alloc] init];
    layout.interItemSpacing = 1;
    
    _layoutCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layoutCollectionView.backgroundColor = self.view.backgroundColor;
    _layoutCollectionView.delegate = self;
    _layoutCollectionView.dataSource = self;
    _layoutCollectionView.showsVerticalScrollIndicator = NO;
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

- (void)loadOrRefreshData:(BOOL)isRefresh {
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
            
            if (!isRefresh) {
                [[YPBMessagePushModel sharedModel] fetchMessageByUserInteraction];
            }
        } else if ([obj isKindOfClass:[NSString class]]) {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:obj inViewController:self];
        }
    };
    
    if (isRefresh) {
        [self.userListModel fetchUserListWithGender:[YPBUser currentUser].oppositeGender space:YPBUserSpaceRecommend completionHandler:handler];
    } else {
        [self.userListModel fetchUserListInNextPageWithCompletionHandler:handler];
    }
}

- (void)onVIPUpgradeSuccessNotification:(NSNotification *)notification {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YPBHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellReusableIdentifier forIndexPath:indexPath];
    
    if (indexPath.item < self.users.count) {
        YPBUser *user = self.users[indexPath.item];
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
                    //[[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"打招呼成功" inViewController:self];
                    
                    user.receiveGreetCount = @(user.receiveGreetCount.unsignedIntegerValue+1);
                    user.isGreet = YES;
                    cell.user = user;
                }
            }];
        };
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.users.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YPBUser *user = self.users[indexPath.item];
    YPBHomeCell *cell = (YPBHomeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    YPBUserDetailViewController *detailVC = [[YPBUserDetailViewController alloc] initWithUserId:user.userId];
    detailVC.greetSuccessAction = ^(id obj) {
        cell.user.isGreet = YES;
        cell.user.receiveGreetCount = @(cell.user.receiveGreetCount.unsignedIntegerValue+1);
    };
    [self.navigationController pushViewController:detailVC animated:YES];
    [YPBStatistics logEvent:kLogUserHomeClickEvent fromUser:[YPBUser currentUser].userId toUser:user.userId];
}
@end
