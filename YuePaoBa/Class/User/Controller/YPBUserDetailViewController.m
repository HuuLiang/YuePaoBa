//
//  YPBUserDetailViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUserDetailViewController.h"
#import "YPBUserProfileCell.h"
#import "YPBUserDetailModel.h"
#import "YPBUserAccessModel.h"
#import "YPBTableViewCell.h"
#import "YPBPhotoBar.h"
#import "YPBPhotoGridViewController.h"
#import "YPBUserPhotoViewController.h"
#import "YPBMessageViewController.h"
#import "YPBContact.h"
#import "YPBVIPPriviledgeViewController.h"
#import "YPBSendGiftViewController.h"
#import "YPBLiveShowViewController.h"
#import "YPBUserDetailFooterBar.h"
#import "YPBUserProfileViewController.h"
#import "YPBReportViolationViewController.h"
#import "YPBBlacklist.h"
#import "YPBLocalNotification.h"
#import "YPBSystemConfig.h"
#import "YPBMessageCenter.h"

@interface YPBUserDetailViewController ()
{
    YPBUserProfileCell *_profileCell;

    YPBPhotoBar *_photoBar;
    YPBTableViewCell *_liveShowCell;
    YPBPhotoBar *_giftBar;
    
    YPBUserDetailFooterBar *_footerBar;
}
@property (nonatomic) NSString *userId;
@property (nonatomic,retain) YPBUserDetailModel *userDetailModel;
@property (nonatomic,retain) YPBUserAccessModel *userAccessModel;

@property (nonatomic,retain) YPBUser *user;
@end

@implementation YPBUserDetailViewController

DefineLazyPropertyInitialization(YPBUserDetailModel, userDetailModel)
DefineLazyPropertyInitialization(YPBUserAccessModel, userAccessModel)

- (instancetype)initWithUserId:(NSString *)userId {
    self = [self init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    @weakify(self);
    [self.layoutTableView YPB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadUserDetail];
    }];
    [self.layoutTableView YPB_triggerPullToRefresh];
    
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_profileCell) {
            [self onProfile];
        } else if (cell == self->_liveShowCell) {
            [self onLiveShow];
        }
    };
    
    _footerBar = [[YPBUserDetailFooterBar alloc] init];
    _footerBar.greetAction = ^(id sender) {
        @strongify(self);
        [self greetUser];
    };
    _footerBar.giftAction = ^(id sender) {
        @strongify(self);
        [self sendGift];
    };
    _footerBar.dateAction = ^(id sender) {
        @strongify(self);
        [self dateWithTheUser];
    };
    [self.view addSubview:_footerBar];
    {
        [_footerBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(50);
        }];
    }
    self.layoutTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    [YPBStatistics logEvent:kLogUserDetailViewedEvent fromUser:[YPBUser currentUser].userId toUser:self.userId];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"more_icon"]
                                                                                 style:UIBarButtonItemStylePlain
                                                                               handler:^(id sender)
    {
        @strongify(self);
        UIActionSheet *moreSheet = [[UIActionSheet alloc] init];
        moreSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [moreSheet bk_addButtonWithTitle:@"举报该用户" handler:^{
            YPBReportViolationViewController *reportVC = [[YPBReportViolationViewController alloc] initWithUserId:self.userId];
            [self.navigationController pushViewController:reportVC animated:YES];
        }];
        if ([[YPBBlacklist sharedInstance] checkUserIdIsTure:_userId]) {
            [moreSheet bk_addButtonWithTitle:@"移除黑名单" handler:^{
                if (_userId.length > 0 && _user.nickName.length > 0) {
                    [[YPBBlacklist sharedInstance] cancleUserFromBlacklist:_userId];
                    [self.view showMessageWithTitle:@"操作成功"];
                } else {
                    [self.view showMessageWithTitle:@"操作无效"];
                }
            }];
        } else {
            [moreSheet bk_addButtonWithTitle:@"拉黑该用户" handler:^{
                if (_userId.length > 0 && _user.nickName.length > 0) {
                    UIAlertView *view = [UIAlertView bk_alertViewWithTitle:@"拉黑后将不会收到对方发的消息"];
                    [view bk_setCancelButtonWithTitle:@"确认" handler:^{
                        [[YPBBlacklist sharedInstance] addUserIntoBlacklist:_userId UserImage:_user.logoUrl NickName:_user.nickName];
                        [self.view showMessageWithTitle:@"操作成功"];
                    }];
                    [view bk_setCancelButtonWithTitle:@"取消" handler:^{
                        
                    }];
                    [view show];
                    
                    //判断是否已经有本地的通知在  若有则删除
                    [[YPBLocalNotification sharedInstance] checkLocalNotificationWithUserId:_userId];
                } else {
                    [self.view showMessageWithTitle:@"操作无效,请重试"];
                }
            }];
        }
        
        [moreSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
        [moreSheet showInView:self.view];
    }];
}

- (void)dealloc {
    self.user = nil;
}

- (void)loadUserDetail {
    @weakify(self);
    [self.userDetailModel fetchUserDetailWithUserId:self.userId
                                             byUser:[YPBUser currentUser].userId
                                  completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self.layoutTableView YPB_endPullToRefresh];
        
        if (success) {
            YPBUser *user = obj;
            [self onSuccessfullyAccessedUser:user];
        }
    }];
}

- (void)onSuccessfullyAccessedUser:(YPBUser *)user
{
    self.user = user;
    [self updateLayoutCells];
    _footerBar.isGreet = user.isGreet;
    _footerBar.numberOfGreets = user.receiveGreetCount.unsignedIntegerValue;
}

- (void)setUser:(YPBUser *)user {
    if (_user) {
        [_user removeObserver:self forKeyPath:NSStringFromSelector(@selector(isGreet))];
        [_user removeObserver:self forKeyPath:NSStringFromSelector(@selector(receiveGreetCount))];
        [_user removeObserver:self forKeyPath:NSStringFromSelector(@selector(gifts))];
    }
    
    _user = user;
    
    if (_user) {
        [_user addObserver:self forKeyPath:NSStringFromSelector(@selector(isGreet)) options:NSKeyValueObservingOptionNew context:nil];
        [_user addObserver:self forKeyPath:NSStringFromSelector(@selector(receiveGreetCount)) options:NSKeyValueObservingOptionNew context:nil];
        [_user addObserver:self forKeyPath:NSStringFromSelector(@selector(gifts)) options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)greetUser {
    if (self.user.userId.length == 0) {
        [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"无法获取用户信息" inViewController:self];
        return ;
    }
    
    if ([[YPBBlacklist sharedInstance] checkUserIdIsTure:self.user.userId]) {
        [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"该用户已被拉黑,打招呼失败" inViewController:self];
        return;
    }
    
    if (self.user.isGreet) {
        [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"您已经和TA打过招呼了！" inViewController:self];
        return ;
    }
    
    if (![YPBUtil isVIP] && [YPBUser currentUser].greetCount.unsignedIntegerValue >= 5) {
        YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymentContentTypeGreetMore];
        [self.navigationController pushViewController:vipVC animated:YES];
        return;
    }
    
    @weakify(self);
    [_profileCell beginLoading];
    
    [self.userAccessModel accessUserWithUserId:self.user.userId
                                    accessType:YPBUserAccessTypeGreet
                             completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_profileCell endLoading];
        if (success) {
            self.user.isGreet = YES;
            self.user.receiveGreetCount = @(self.user.receiveGreetCount.unsignedIntegerValue+1);
            [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"打招呼成功" inViewController:self];
        }
    }];
}

- (void)sendGift {
    if (!self.user.isRegistered) {
        [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"无法获取用户信息" inViewController:self];
        return ;
    }
    if ([[YPBSystemConfig sharedConfig].isUseApplePay isEqualToString:@"1"]) {
        [[YPBMessageCenter defaultCenter] showMessageWithTitle:@"暂无法赠送礼物😁" inViewController:self];
        return;
    }
    YPBSendGiftViewController *sendGiftVC = [[YPBSendGiftViewController alloc] initWithUser:self.user];
    [self.navigationController pushViewController:sendGiftVC animated:YES];
}

- (void)dateWithTheUser {
    if (!self.user.isRegistered) {
        [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"无法获取用户信息" inViewController:self];
        return ;
    }
    
    if ([YPBContact refreshContactRecentTimeWithUser:self.user]) {
        [YPBMessageViewController showMessageWithUser:self.user inViewController:self];
    }
    
    [YPBStatistics logEvent:kLogUserDateEvent fromUser:[YPBUser currentUser].userId toUser:self.userId];
}

- (void)onLiveShow {
    if ([YPBUtil isVIP]) {
        YPBLiveShowViewController *liveShowVC = [[YPBLiveShowViewController alloc] initWithUser:self.user];
        [self presentViewController:liveShowVC animated:YES completion:nil];
    } else {
        YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymentContentTypeVideo];
        [self.navigationController pushViewController:vipVC animated:YES];
    }
}

- (void)onProfile {
    if (!self.user.isRegistered) {
        [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"无法获取用户信息" inViewController:self];
        return ;
    }
    
    YPBUserProfileViewController *profileVC = [[YPBUserProfileViewController alloc] initWithUser:self.user];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)updateLayoutCells {
    [self removeAllLayoutCells];
    
    NSUInteger section = 0;
    [self initUserProfileCellLayoutsInSection:section++];
    [self initUserPhotoCellLayoutsInSection:section++];
    if (self.user.userVideo.videoUrl.length > 0) {
        [self initUserLiveShowCellLayoutsInSection:section++];
    }
    [self initUserGiftCellLayoutsInSection:section++];
    [self.layoutTableView reloadData];
}

- (void)initUserProfileCellLayoutsInSection:(NSUInteger)section {
    YPBUserProfileCell *profileCell = [[YPBUserProfileCell alloc] init];
    profileCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    profileCell.user = self.user;
    @weakify(self);
    profileCell.wechatAction = ^(id sender) {
        @strongify(self);
        if ([YPBUtil isVIP]) {
            if (self.user.isRegistered) {
                [YPBMessageViewController showMessageForWeChatWithUser:self.user inViewController:self];
            } else {
                [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"无法获取用户信息" inViewController:self];
            }
        } else {
            YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymentContentTypeWeChatId];
            [self.navigationController pushViewController:vipVC animated:YES];
            
            [YPBStatistics logEvent:kLogUserWeChatViewedForPaymentEvent fromUser:[YPBUser currentUser].userId toUser:self.userId];
        }
    };

    [self setLayoutCell:profileCell cellHeight:MIN(kScreenHeight*0.4, 150) inRow:0 andSection:section];
    _profileCell = profileCell;
}

- (void)initUserPhotoCellLayoutsInSection:(NSUInteger)section {
    [self setHeaderTitle:@"个人相册" height:20 inSection:section];
    
    YPBTableViewCell *photoCell = [[YPBTableViewCell alloc] init];
    photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _photoBar = [[YPBPhotoBar alloc] init];
    @weakify(self);
    _photoBar.selectAction = ^(NSUInteger index, id sender) {
        @strongify(self);
        YPBPhotoBar *photoBar = sender;
        if ([photoBar photoIsLocked:index]) {
            YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymentContentTypePhoto];
            [self.navigationController pushViewController:vipVC animated:YES];
        } else {
            YPBUserPhotoViewController *photoVC = [YPBUserPhotoViewController showPhotoBrowserInView:self.view.window
                                                                                          withPhotos:self.user.userPhotos
                                                                                   currentPhotoIndex:index];
            @weakify(self,photoVC);
            photoVC.tapLockAction = ^(id sender) {
                @strongify(self,photoVC);
                [photoVC hide];
                
                YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymentContentTypePhoto];
                [self.navigationController pushViewController:vipVC animated:YES];
            };
            
            [YPBStatistics logEvent:kLogUserPhotoViewedEvent fromUser:[YPBUser currentUser].userId toUser:self.userId];
        }
    };
    _photoBar.shouldLockAction = ^BOOL(NSUInteger index) {
        if ([YPBUtil isVIP]) {
            return NO;
        } else {
            return index > 2;
        }
    };
    
    if (self.user.userPhotos.count > 0) {
        NSMutableArray *thumbPhotos = [NSMutableArray array];
        [self.user.userPhotos enumerateObjectsUsingBlock:^(YPBUserPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.smallPhoto.length > 0) {
                [thumbPhotos addObject:obj.smallPhoto];
            }
        }];
        [_photoBar setImageURLStrings:thumbPhotos titleStrings:nil];
    }
    
    [photoCell addSubview:_photoBar];
    {
        [_photoBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(photoCell);//.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
    }
    [self setLayoutCell:photoCell cellHeight:MAX(kScreenHeight*0.15,96) inRow:0 andSection:section];
}

- (void)initUserLiveShowCellLayoutsInSection:(NSUInteger)section {
    [self setHeaderTitle:@"TA的直播秀" height:20 inSection:section];
    
    _liveShowCell = [[YPBTableViewCell alloc] init];
    _liveShowCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [_liveShowCell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.user.userVideo.imgCover]];
    
    UIImage *playImage = [UIImage imageNamed:@"video_play_icon"];
    UIImageView *playIconView = [[UIImageView alloc] initWithImage:playImage];
    [_liveShowCell.backgroundImageView addSubview:playIconView];
    {
        [playIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_liveShowCell.backgroundImageView);
        }];
    }
    [self setLayoutCell:_liveShowCell cellHeight:kScreenWidth*0.5 inRow:0 andSection:section];
}

- (void)initUserGiftCellLayoutsInSection:(NSUInteger)section {
    [self setHeaderTitle:@"TA收到的礼物" height:20 inSection:section];
    YPBTableViewCell *giftCell = [[YPBTableViewCell alloc] init];
    giftCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:giftCell cellHeight:MAX(kScreenHeight*0.15,96) inRow:0 andSection:section];
    
    @weakify(self);
    _giftBar = [[YPBPhotoBar alloc] init];
    _giftBar.placeholder = @"TA还未收到过礼物~~~";
    _giftBar.selectAction = ^(NSUInteger index, id sender) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self sendGift];
    };
    [giftCell addSubview:_giftBar];
    {
        [_giftBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(giftCell);
        }];
    }
    
    if (self.user.gifts.count > 0) {
        [self refreshGiftBar];
    }
}

- (void)refreshGiftBar {
    NSMutableArray *giftPhotos = [NSMutableArray array];
    NSMutableArray *giftTitles = [NSMutableArray array];
    [self.user.gifts enumerateObjectsUsingBlock:^(YPBGift * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.imgUrl.length == 0) {
            return ;
        }
        
        [giftPhotos addObject:obj.imgUrl];
        [giftTitles addObject:obj.userName ?: @"未知"];
    }];
    [_giftBar setImageURLStrings:giftPhotos titleStrings:giftTitles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(isGreet))]) {
        NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        _footerBar.isGreet = newValue.boolValue;
        
        if (newValue.boolValue) {
            SafelyCallBlock1(self.greetSuccessAction, nil);
        }
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(receiveGreetCount))]) {
        NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        _footerBar.numberOfGreets = newValue.unsignedIntegerValue;
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(gifts))]) {
        [self refreshGiftBar];
    }
}

#pragma mark - UIActionSheetDelegate



@end
