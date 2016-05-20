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

@interface YPBUserDetailViewController ()
{
    YPBUserProfileCell *_profileCell;
    YPBTableViewCell *_wechatCell;

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
//            [self onProfile];
        } else if (cell == self->_liveShowCell) {
            [self onLiveShow];
        } else if (cell == self->_wechatCell) {
            [self onWechat];
        }
    };
    
    _footerBar = [[YPBUserDetailFooterBar alloc] init];
    _footerBar.layer.masksToBounds = YES;
    _footerBar.layer.borderColor = [UIColor colorWithHexString:@"#c0c0c0"].CGColor;
    _footerBar.layer.borderWidth = 0.5;
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
            make.bottom.left.right.equalTo(self.view);
//            make.left.equalTo(self.view).offset(self.view.frame.size.width/5);
//            make.right.equalTo(self.view).offset(-self.view.frame.size.width/5);
            make.height.mas_equalTo(50);
        }];
    }
    self.layoutTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    [YPBStatistics logEvent:kLogUserDetailViewedEvent fromUser:[YPBUser currentUser].userId toUser:self.userId];
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
    
    if (self.user.isGreet) {
        [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"您已经和TA打过招呼了！" inViewController:self];
        return ;
    }
    
    //&& [YPBUser currentUser].greetCount.unsignedIntegerValue >= 5
//    if (![YPBUtil isVIP] ) {
//        YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymentContentTypeGreetMore];
//        [self.navigationController pushViewController:vipVC animated:YES];
//        return;
//    }
    
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
            if ([YPBContact refreshContactRecentTimeWithUser:self.user]) {
                [YPBMessageViewController sendGreetMessageWith:self.user inViewController:self];
            }
        }
    }];
}

- (void)sendGift {
    if (!self.user.isRegistered) {
        [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"无法获取用户信息" inViewController:self];
        return ;
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

- (void)onWechat {
    if ([YPBUtil isVIP]) {
        if (self.user.isRegistered) {
            [YPBMessageViewController showMessageForWeChatWithUser:self.user inViewController:self];
        } else {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"无法获取用户信息" inViewController:self];
        }
    } else {
        YPBVIPPriviledgeViewController *vipVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymentContentTypeWeChatId];
        [self.navigationController pushViewController:vipVC animated:YES];
        
        [YPBStatistics logEvent:kLogUserWeChatViewedForPaymentEvent fromUser:[YPBUser currentUser].userId toUser:self.user.userId];
    }
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
    [self initUserProfileView:section];
    [self.layoutTableView reloadData];
}

- (void)initUserProfileCellLayoutsInSection:(NSUInteger)section {
    YPBUserProfileCell *profileCell = [[YPBUserProfileCell alloc] init];
//    profileCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    profileCell.accessoryType = UITableViewCellAccessoryNone;
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

- (void)initUserProfileView:(NSUInteger)section {
    [self setHeaderTitle:@"" height:7 inSection:section];
    YPBTableViewCell *genderCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"female_icon"] title:@"性别：??"];
    genderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    genderCell.imageView.image = self.user.gender==YPBUserGenderUnknown?nil:self.user.gender==YPBUserGenderFemale?[UIImage imageNamed:@"female_icon"]:[UIImage imageNamed:@"male_icon"];
    genderCell.titleLabel.text = self.user.gender==YPBUserGenderUnknown?nil:self.user.gender==YPBUserGenderFemale?@"性别：女":@"性别：男";
    [self setLayoutCell:genderCell inRow:0 andSection:section];
    
    NSString *wechatTitle = @"微信：*******>>查看微信号";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:wechatTitle];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor], NSUnderlineStyleAttributeName:@(1)} range:NSMakeRange(wechatTitle.length-6, 6)];
    
    _wechatCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"wechat_icon"] title:nil];
    _wechatCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _wechatCell.titleLabel.attributedText = attrStr;
    [self setLayoutCell:_wechatCell inRow:1 andSection:section];
    
    YPBTableViewCell *interestCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"interest_icon"] title:[NSString stringWithFormat:@"兴趣：%@", self.user.note ?: @"？？？"]];
    interestCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:interestCell inRow:2 andSection:section];
    
    YPBTableViewCell *purposeCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"purpose_icon"] title:[NSString stringWithFormat:@"交友目的：%@", self.user.purpose]];
    purposeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:purposeCell inRow:3 andSection:section];
    
    
    NSInteger count = [self.user.marry integerValue];
    YPBTableViewCell *marryCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"marry_icon"] title:[NSString stringWithFormat:@"婚姻状况：%@",[YPBUser allMarriageDescription][count]]];
    marryCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:marryCell inRow:4 andSection:section++];
    
    [self setHeaderHeight:7 inSection:section];
    YPBTableViewCell *heightCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"height_icon"] title:[NSString stringWithFormat:@"身高：%@", self.user.heightDescription ?: @"???cm"]];
    heightCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:heightCell inRow:0 andSection:section];
    
    YPBTableViewCell *ageCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"age_icon"] title:[NSString stringWithFormat:@"年龄：%@", self.user.ageDescription ?: @"？？"]];
    ageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:ageCell inRow:1 andSection:section];
    
    YPBTableViewCell *figureCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"figure_icon"] title:self.user.figureDescription ?: @"身材：?? ?? ??"];
    figureCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:figureCell inRow:2 andSection:section++];
    
    [self setHeaderHeight:7 inSection:section];
    
    NSInteger eduCount = [self.user.edu integerValue];
    YPBTableViewCell *educationCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"education_icon"] title:[NSString stringWithFormat:@"学历：%@",[YPBUser allEducationsDescription][eduCount]]];
    educationCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:educationCell inRow:0 andSection:section];
    
    YPBTableViewCell *incomeCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"income_icon"] title:[NSString stringWithFormat:@"月收入：%@", self.user.monthIncome ?: @"？？？"]];
    incomeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:incomeCell inRow:1 andSection:section];
    
    YPBTableViewCell *professionCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"profession_icon"] title:[NSString stringWithFormat:@"职业：%@", self.user.profession ?: @"？？？"]];
    professionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:professionCell inRow:2 andSection:section];
    
    YPBTableViewCell *assetsCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"assets_icon"] title:[NSString stringWithFormat:@"资产情况：%@", self.user.assets ?: @"？？？"]];
    assetsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:assetsCell inRow:3 andSection:section];
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
@end
