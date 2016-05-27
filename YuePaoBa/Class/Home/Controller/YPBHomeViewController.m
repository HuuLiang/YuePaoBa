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
#import "YPBUserAccessModel.h"
#import "YPBMessagePushModel.h"
#import "YPBActivityViewController.h"

#import "YPBMessageViewController.h"
#import "YPBRecommendCell.h"
#import "YPBContact.h"

#import "YPBUserAccessQueryModel.h"


static NSString *const kHomeCellReusableIdentifier = @"HomeCellReusableIdentifier";
static NSString *const kRecommendCellReuseIdentifier = @"RecommendCellReuseIdentifier";
static NSString *const kFirstRecommentIdentifier = @"FirstRecomment";
static NSString *const KNotiGreetIdentifier     = @"NotiGreetIdentifier";

@interface YPBHomeViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_layoutCollectionView;
    UICollectionView *_recommendCollectionView;
    BOOL _isHaveRobot;
}
@property (nonatomic,retain) YPBUserListModel *userListModel;
@property (nonatomic,retain) NSMutableArray<YPBUser *> *users;
@property (nonatomic,retain) NSMutableArray<YPBUser *> *recommendUsers;
@property (nonatomic,retain) NSMutableArray<YPBUser *> *greetUsers;
@property (nonatomic,retain) YPBUserAccessModel *userAccessModel;
@property (nonatomic) YPBUserAccessQueryModel *accessQueryModel;
@property (nonatomic,retain) NSMutableArray<YPBContact *> *contacts;
@end

@implementation YPBHomeViewController

DefineLazyPropertyInitialization(YPBUserListModel, userListModel)
DefineLazyPropertyInitialization(NSMutableArray, users)
DefineLazyPropertyInitialization(NSMutableArray, recommendUsers);
DefineLazyPropertyInitialization(NSMutableArray, greetUsers);
DefineLazyPropertyInitialization(YPBUserAccessModel, userAccessModel);
DefineLazyPropertyInitialization(YPBUserAccessQueryModel, accessQueryModel)


- (void)didRestoreUser:(YPBUser *)user {
    [_layoutCollectionView YPB_triggerPullToRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _isHaveRobot = NO;
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
    
    NSUserDefaults *recommendDefaults = [NSUserDefaults standardUserDefaults];
    NSString * string = [recommendDefaults objectForKey:kFirstRecommentIdentifier];
    if (![string isEqualToString:kFirstRecommentIdentifier]) {
        DLog("%ld",[YPBUser currentUser].gender);
        if ([YPBUser currentUser].userId != nil && [YPBUser currentUser].gender != 0) {
            [self popRecommendView];
            [self.userListModel fetchUserRecommendUserListWithSex:[YPBUser currentUser].oppositeGender CompletionHandler:^(BOOL success, id obj) {
                if (success) {
                    [self.recommendUsers addObjectsFromArray:obj];
                    [self.greetUsers addObjectsFromArray:obj];
                    [self->_recommendCollectionView reloadData];
                }
            }];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVIPUpgradeSuccessNotification:) name:kVIPUpgradeSuccessNotification object:nil];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"兑换"
//                                                                                style:UIBarButtonItemStylePlain
//                                                                              handler:^(id sender)
//                                             {
//                                                 YPBActivityViewController *acView = [[YPBActivityViewController alloc] init];
//                                                 [self.navigationController pushViewController:acView animated:YES];
//                                             }];
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
        [self.userListModel fetchUserListWithGender:[YPBUser currentUser].oppositeGender space:YPBUserSpaceHome completionHandler:handler];
    } else {
        [self.userListModel fetchUserListInNextPageWithCompletionHandler:handler];
    }
}

- (void)onVIPUpgradeSuccessNotification:(NSNotification *)notification {
    //[[YPBVIPEntranceView VIPEntranceInView:self.view] hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popRecommendView {
    [self.view  beginLoading];
    
    UIView *recommendView = [[UIView alloc] init];
    recommendView.backgroundColor = [UIColor whiteColor];
    recommendView.layer.cornerRadius = 7;
    [self.view addSubview:recommendView];
    
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bgImg"]];
    bgImg.contentMode = UIViewContentModeScaleToFill;
    bgImg.clipsToBounds = YES;
    bgImg.userInteractionEnabled = YES;
    [recommendView addSubview:bgImg];
    
    UIImageView *starImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_star"]];
    starImg.contentMode = UIViewContentModeScaleAspectFit;
    starImg.userInteractionEnabled = YES;
    [bgImg addSubview:starImg];
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setImage:[UIImage imageNamed:@"home_close"] forState:UIControlStateNormal];
    [recommendView addSubview:closeButton];

    [closeButton bk_addEventHandler:^(id sender) {
        [self.view endLoading];
        [recommendView removeFromSuperview];
        //获取招呼数量  创建小红娘
        //检测打招呼人数
        [self performSelector:@selector(checkAccess) withObject:self afterDelay:10];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *greetLabel = [[UILabel alloc] init];
    greetLabel.text = @"立即打招呼";
    greetLabel.textColor = [UIColor whiteColor];
    greetLabel.textAlignment = NSTextAlignmentCenter;
    greetLabel.layer.cornerRadius = 3;
    greetLabel.layer.masksToBounds = YES;
    greetLabel.userInteractionEnabled = YES;
    greetLabel.backgroundColor = [UIColor colorWithHexString:@"#50aad9"];
    [recommendView addSubview:greetLabel];
    {
        [greetLabel bk_whenTapped:^{
            //批量打招呼
            for (YPBUser *user in _greetUsers) {
                [self.userAccessModel accessUserWithUserId:user.userId accessType:YPBUserAccessTypeGreet completionHandler:^(BOOL success, id obj) {
                    if (success) {
                        user.receiveGreetCount = @(user.receiveGreetCount.unsignedIntegerValue+1);
                        user.isGreet = YES;
                        if ([YPBContact refreshContactRecentTimeWithUser:user]) {
                            [YPBMessageViewController sendGreetMessageWith:user inViewController:self];
                        }
                    }
                }];
            }
            [self.view endLoading];
            [recommendView removeFromSuperview];
            [self loadOrRefreshData:YES];
            [self performSelector:@selector(checkAccess) withObject:self afterDelay:10];
            //
            NSUserDefaults *recommendDefaults = [NSUserDefaults standardUserDefaults];
            [recommendDefaults setObject:kFirstRecommentIdentifier forKey:kFirstRecommentIdentifier];
            [recommendDefaults synchronize];
        }];
    }
    
    _recommendCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:[self createLayout]];
//    _recommendCollectionView.collectionViewLayout = [self createLayout];
    _recommendCollectionView.backgroundColor = [UIColor clearColor];
    _recommendCollectionView.delegate = self;
    _recommendCollectionView.dataSource = self;
    _recommendCollectionView.showsVerticalScrollIndicator = NO;
    [_recommendCollectionView registerClass:[YPBRecommendCell class] forCellWithReuseIdentifier:kRecommendCellReuseIdentifier];
    [bgImg addSubview:_recommendCollectionView];
    
    {
        [recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(SCREEN_HEIGHT/35);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH *0.8, SCREEN_HEIGHT*0.6+SCREEN_HEIGHT/8));
        }];
        
        
        [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(recommendView);
            make.height.equalTo(@(SCREEN_HEIGHT*0.6));
        }];
        
        [starImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgImg);
            make.top.equalTo(recommendView).offset(0);
        }];
        
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(recommendView.mas_right).offset(-8);
            make.centerY.equalTo(recommendView.mas_top).offset(8);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [greetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(recommendView);
            make.top.equalTo(bgImg.mas_bottom).offset(SCREEN_HEIGHT/8*0.2);
            make.size.mas_equalTo(CGSizeMake(210, SCREEN_HEIGHT/8*0.6));
        }];
        
        [_recommendCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(bgImg);
            make.top.equalTo(bgImg).offset(SCREEN_HEIGHT/14);
        }];
    }
}

- (UICollectionViewFlowLayout *)createLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = SCREEN_HEIGHT/50.;
    layout.minimumInteritemSpacing = SCREEN_WIDTH/37.;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH*0.8-30-2*SCREEN_WIDTH/37)/3-9, (SCREEN_WIDTH*0.8-30-2*SCREEN_WIDTH/37)/3+3);
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    return layout;
}

- (void)checkAccess {
    [self.accessQueryModel queryUser:[YPBUser currentUser].userId withAccessType:YPBUserGetAccessTypeGreeting greetType:YPBUserGreetingTypeSent page:1 completionHandler:^(BOOL success, id obj) {
        if (success) {
            NSArray * array = obj;
            NSUserDefaults *greetDefaults = [NSUserDefaults standardUserDefaults];
            if (array.count/5 == [greetDefaults integerForKey:KNotiGreetIdentifier]) {
                return ;
            } else {
                [greetDefaults setInteger:array.count/5 forKey:KNotiGreetIdentifier];
                [greetDefaults synchronize];
                if (array.count/5 >= 1) {
                    //通知红娘小助手
                    self.contacts = [NSMutableArray arrayWithArray:[YPBContact allContacts]];
                    
                    __block NSUInteger unreadMessages = 0;
                    [self.contacts enumerateObjectsUsingBlock:^(YPBContact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        unreadMessages += obj.unreadMessages.unsignedIntegerValue;
                        if ([obj.userType isEqualToNumber:[NSNumber numberWithInteger:[YPBROBOTID integerValue]]]) {
                            _isHaveRobot = YES;
                        }
                    }];
                    //添加红娘小助手
                    if (!_isHaveRobot) {
                        YPBContact *robotContact = [[YPBContact alloc] init];
                        [robotContact beginUpdate];
                        robotContact.userId = YPBROBOTID;
                        robotContact.logoUrl = kRobotContactLogoUrl;
                        robotContact.nickName = @"红娘小助手";
                        robotContact.userType = [NSNumber numberWithInteger:[YPBROBOTID integerValue]];
                        robotContact.recentMessage = @"欢迎来到心动速配";
                        robotContact.recentTime = [YPBUtil stringFromDate:[NSDate date]];
                        [robotContact endUpdate];
                        [self.contacts addObject:robotContact];
                        
                        [YPBMessageViewController sendSystemMessageWith:robotContact Type:YPBRobotPushTypeWelCome count:0 inViewController:self];
                        [YPBMessageViewController sendSystemMessageWith:robotContact Type:YPBRobotPushTypeGreet count:array.count inViewController:self];
                        
                    } else {
                        for (YPBContact *contact in self.contacts) {
                            if ([contact.userType isEqualToNumber:[NSNumber numberWithInteger:[YPBROBOTID integerValue]]]) {
                                [YPBMessageViewController sendSystemMessageWith:contact Type:YPBRobotPushTypeGreet count:array.count-array.count%5 inViewController:self];
                            }
                        }
                    }
                    
                } else {
                    [self performSelector:@selector(checkAccess) withObject:self afterDelay:100];
                }
            }
        } else {
            [self performSelector:@selector(checkAccess) withObject:self afterDelay:20];
        }
    }];
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _layoutCollectionView) {
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
    } else {
        YPBRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendCellReuseIdentifier forIndexPath:indexPath];
        if (indexPath.item < self.recommendUsers.count) {
            YPBUser *user = self.recommendUsers[indexPath.item];
            cell.user = user;
        }
//        [cell bk_whenTapped:^{
//            [cell setBtnState];
//        }];
        return cell;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _layoutCollectionView) {
        return self.users.count;
    } else {
        return self.recommendUsers.count;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _layoutCollectionView) {
        YPBUser *user = self.users[indexPath.item];
        YPBHomeCell *cell = (YPBHomeCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        YPBUserDetailViewController *detailVC = [[YPBUserDetailViewController alloc] initWithUserId:user.userId];
        detailVC.greetSuccessAction = ^(id obj) {
            cell.user.isGreet = YES;
            cell.user.receiveGreetCount = @(cell.user.receiveGreetCount.unsignedIntegerValue+1);
        };
        [self.navigationController pushViewController:detailVC animated:YES];
        [YPBStatistics logEvent:kLogUserHomeClickEvent fromUser:[YPBUser currentUser].userId toUser:user.userId];
    } else if (collectionView == _recommendCollectionView) {
        YPBUser *user = self.recommendUsers[indexPath.item];
        YPBRecommendCell *cell = (YPBRecommendCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setBtnState];
        if (cell.btn.selected) {
            [_greetUsers addObject:user];
        } else if (!cell.btn.selected) {
            [_greetUsers removeObject:user];
        }
    }

}

@end
