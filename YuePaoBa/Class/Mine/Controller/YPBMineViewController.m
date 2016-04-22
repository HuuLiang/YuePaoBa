//
//  YPBMineViewController.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/3.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBMineViewController.h"
#import "YPBAvatarView.h"
#import "YPBMineProfileCell.h"
#import "YPBUserDetailModel.h"
#import "YPBUserAvatarUpdateModel.h"
#import "YPBVIPPriviledgeViewController.h"
#import "YPBEditMineDetailViewController.h"
#import "YPBMineAccessViewController.h"
#import "YPBTableViewCell.h"
#import "YPBPhotoBar.h"
#import "YPBPhotoPicker.h"
#import "YPBUserPhotoAddModel.h"
#import "YPBUserPhotoDeleteModel.h"
#import "YPBPhotoBrowser.h"
#import "YPBMyGiftViewController.h"
#import "YPBSettingViewController.h"
#import "GeTuiSdk.h"

static NSString *const kNoUserInfoErrorMessage = @"无法获取用户详细信息，请刷新后重试";

@interface YPBMineViewController ()
{
    YPBTableViewCell *_vipCell;
    YPBTableViewCell *_likeCell;
    YPBTableViewCell *_giftCell;
    
    YPBTableViewCell *_photoCell;
    YPBPhotoBar *_photoBar;
    
    YPBTableViewCell *_genderCell;
    YPBTableViewCell *_figureCell;
    YPBTableViewCell *_heightCell;
    YPBTableViewCell *_professionCell;
    YPBTableViewCell *_interestCell;
    YPBTableViewCell *_wechatCell;
    YPBTableViewCell *_incomeCell;
    YPBTableViewCell *_assetsCell;
    YPBTableViewCell *_ageCell;
    YPBTableViewCell *_purposeCell;
}
@property (nonatomic,retain) YPBMineProfileCell *profileCell;
@property (nonatomic,retain) YPBUserDetailModel *mineDetailModel;
@property (nonatomic,retain) YPBUserAvatarUpdateModel *avatarUpdateModel;
@property (nonatomic,retain) YPBUserPhotoAddModel *photoAddModel;
@property (nonatomic,retain) YPBUserPhotoDeleteModel *photoDeleteModel;
@end

@implementation YPBMineViewController

DefineLazyPropertyInitialization(YPBUserDetailModel, mineDetailModel)
DefineLazyPropertyInitialization(YPBUserAvatarUpdateModel, avatarUpdateModel)
DefineLazyPropertyInitialization(YPBUserPhotoAddModel, photoAddModel)
DefineLazyPropertyInitialization(YPBUserPhotoDeleteModel, photoDeleteModel)

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserRestoreNotification) name:kUserInRestoreNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVIPUpgradeSuccessNotification) name:kVIPUpgradeSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurrentUserChangeNotification:) name:kCurrentUserChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //进入此界面刷新tarbaritem角标
    [self refreshBadgeValue];
    
    self.layoutTableView.rowHeight = MAX(kScreenHeight * 0.07,44);
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"setting_icon"]
                                                                                style:UIBarButtonItemStylePlain
                                                                              handler:^(id sender)
    {
        @strongify(self);
        YPBSettingViewController *settingVC = [[YPBSettingViewController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"edit_icon"]
                                                                                 style:UIBarButtonItemStylePlain
                                                                               handler:^(id sender)
    {
        @strongify(self);
        
        YPBUser *user = [YPBUser currentUser];
        if (user.isRegistered) {
//            @weakify(self);
            YPBEditMineDetailViewController *editVC = [[YPBEditMineDetailViewController alloc] initWithUser:user.copy];
//            editVC.successHandler = ^(id obj) {
//                @strongify(self);
//                [self reloadDetailInfos];
//            };
            [self.navigationController pushViewController:editVC animated:YES];
        } else {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:kNoUserInfoErrorMessage inViewController:self];
        }
        
    }];
    
    [self.layoutTableView YPB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self refreshMineDetails];
    }];
    [self initLayoutCells];
    [self reloadUI];
    
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_vipCell) {
            YPBVIPPriviledgeViewController *priviledgeVC = [[YPBVIPPriviledgeViewController alloc] initWithContentType:[YPBUtil isVIP]?YPBPaymentContentTypeRenewVIP:YPBPaymentContentTypeMineVIP];
            [self.navigationController pushViewController:priviledgeVC animated:YES];
        } else if (cell == self->_giftCell) {
            YPBMyGiftViewController *myGiftVC = [[YPBMyGiftViewController alloc] init];
            [self.navigationController pushViewController:myGiftVC animated:YES];
        }
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![YPBUser currentUser].isRegistered) {
        [self.layoutTableView YPB_triggerPullToRefresh];
    }
}

- (void)onUserRestoreNotification {
    [self refreshMineDetails];
}

- (void)onCurrentUserChangeNotification:(NSNotification *)notification {
    [self reloadUI];
    [self refreshBadgeValue];
}

- (void)refreshMineDetails {
    @weakify(self);
    NSString *userId = [YPBUser currentUser].userId;
    
    NSString * clientId = [GeTuiSdk clientId];
    //获取到userid 和  clientId向服务器发送
    if (userId != nil && clientId != nil ) {
        [[YPBSystemConfigModel sharedModel] sendPushInfoWithUserID:userId clientID:[GeTuiSdk clientId]];
    }
    
    [self.mineDetailModel fetchUserDetailWithUserId:userId
                                             byUser:userId
                                  completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self.layoutTableView YPB_endPullToRefresh];
        
        if (success) {
            BOOL isRestore = ![YPBUser currentUser].isRegistered;

            YPBUser *user = obj;
            [user saveAsCurrentUser];
//            [self refreshBadgeValue];
//            [self reloadUI];
            
            if (isRestore) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserRestoreSuccessNotification object:user];
            }
        }
    }];
}

- (void)initLayoutCells {
    NSUInteger section = 0;
    [self setLayoutCell:self.profileCell cellHeight:kScreenWidth/1.5 inRow:0 andSection:section];
    
    [self setHeaderHeight:15 inSection:++section];
    
    _photoCell = [[YPBTableViewCell alloc] init];
    _photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _photoBar = [[YPBPhotoBar alloc] initWithUsePhotoAddItem:YES];
    @weakify(self);
    _photoBar.photoAddAction = ^(id obj) {
        @strongify(self);
        if ([YPBUser currentUser].isRegistered) {
            [self pickingPhotos];
        } else {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:kNoUserInfoErrorMessage inViewController:self];
        }
    };
    _photoBar.selectAction = ^(NSUInteger index, id sender) {
        @strongify(self);
        [YPBPhotoBrowser showPhotoBrowserInView:self.view.window
                                     withPhotos:[YPBUser currentUser].userPhotos
                              currentPhotoIndex:index];
    };
    _photoBar.holdAction = ^(NSUInteger index, id sender) {
        @strongify(self);
        UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:@"我的相册"];
        [actionSheet bk_addButtonWithTitle:@"删除照片" handler:^{
            [self deletePhotoWithIndex:index];
        }];
        [actionSheet bk_setDestructiveButtonWithTitle:@"取消" handler:nil];
        [actionSheet showInView:self.view];
    };
    [_photoCell addSubview:_photoBar];
    {
        [_photoBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_photoCell);
        }];
    }
    [self setLayoutCell:_photoCell cellHeight:kScreenHeight*0.15 inRow:0 andSection:section];
    
    [self setHeaderHeight:15 inSection:++section];
    
    NSUInteger row = 0;
    _likeCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"like_icon"] title:@"？人喜欢了你"];
    _likeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_likeCell inRow:row++ andSection:section];
    
    if ([YPBSystemConfig sharedConfig].vipPointInfo.length > 0) {
        _vipCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"vip_icon"] title:@"开通VIP"];
        _vipCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _vipCell.iconImageView.contentMode = UIViewContentModeCenter;
        [self setLayoutCell:_vipCell inRow:row++ andSection:section];
    }
    
    _giftCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"gift_icon"] title:@"我的礼物"];
    _giftCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self setLayoutCell:_giftCell inRow:row++ andSection:section];
    
    [self setHeaderHeight:15 inSection:++section];
    
    row = 0;
    _genderCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"female_icon"] title:@"性别：??"];
    _genderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_genderCell inRow:row++ andSection:section];
    
    _figureCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"figure_icon"] title:@"身材：?? ?? ??"];
    _figureCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_figureCell inRow:row++ andSection:section];
    
    _heightCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"height_icon"] title:@"身高：???cm"];
    _heightCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_heightCell inRow:row++ andSection:section];
    
    _professionCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"profession_icon"] title:@"职业：？？？"];
    _professionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_professionCell inRow:row++ andSection:section];
    
    _interestCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"interest_icon"] title:@"兴趣：？？？"];
    _interestCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_interestCell inRow:row++ andSection:section];
    
    _wechatCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"wechat_icon"] title:@"微信：********"];
    _wechatCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_wechatCell inRow:row++ andSection:section];
    
    _incomeCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"income_icon"] title:@"月收入：？？？"];
    _incomeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_incomeCell inRow:row++ andSection:section];
    
    _assetsCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"assets_icon"] title:@"资产情况：？？？"];
    _assetsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_assetsCell inRow:row++ andSection:section];
    
    _ageCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"age_icon"] title:@"年龄：？"];
    _ageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_ageCell inRow:row++ andSection:section];
    
    _purposeCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"purpose_icon"] title:@"交友目的: ?"];
    _purposeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_purposeCell inRow:row++ andSection:section];
}

- (YPBMineProfileCell *)profileCell {
    if (_profileCell) {
        return _profileCell;
    }
    
    @weakify(self);
    _profileCell = [[YPBMineProfileCell alloc] init];
//    _profileCell.name = [YPBUser currentUser].nickName;
//    _profileCell.isVIP = [YPBUser currentUser].isVip;
    _profileCell.avatarAction = ^{
        @strongify(self);
        [self pickingAvatar];
    };
    _profileCell.viewFollowedAction = ^{
        @strongify(self);
        
        if ([YPBUser currentUser].isRegistered) {
            YPBMineAccessViewController *recvVC = [[YPBMineAccessViewController alloc] initWithAccessType:YPBMineAccessTypeGreetingReceived];
            [self.navigationController pushViewController:recvVC animated:YES];
        } else {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:kNoUserInfoErrorMessage inViewController:self];
        }
        
    };
    _profileCell.viewFollowingAction = ^{
        @strongify(self);
        if ([YPBUser currentUser].isRegistered) {
            YPBMineAccessViewController *recvVC = [[YPBMineAccessViewController alloc] initWithAccessType:YPBMineAccessTypeGreetingSent];
            [self.navigationController pushViewController:recvVC animated:YES];
        } else {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:kNoUserInfoErrorMessage inViewController:self];
        }
    };
    _profileCell.viewAccessedAction = ^{
        @strongify(self);
        if ([YPBUser currentUser].isRegistered) {
            YPBMineAccessViewController *recvVC = [[YPBMineAccessViewController alloc] initWithAccessType:YPBMineAccessTypeAccessViewed];
            [self.navigationController pushViewController:recvVC animated:YES];
        } else {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:kNoUserInfoErrorMessage inViewController:self];
        }
    };
    return _profileCell;
}

- (void)pickingAvatar {
    @weakify(self);
    YPBPhotoPicker *photoPicker = [[YPBPhotoPicker alloc] init];
    photoPicker.allowsEditing = YES;
    photoPicker.cameraDevice = YPBPhotoPickingCameraDeviceFront;
    [photoPicker showPickingSheetInViewController:self
                                        withTitle:@"选取头像"
                                completionHandler:^(BOOL success,
                                                    NSArray<UIImage *> *originalImages,
                                                    NSArray<UIImage *> *thumbImages)
    {
        if (photoPicker == nil || !success || thumbImages.count == 0) {
            return;
        }
        
        UIImage *pickedImage = originalImages[0];
        [[YPBMessageCenter defaultCenter] showProgressWithTitle:@"头像上传中..." subtitle:nil];
        NSString *name = [NSString stringWithFormat:@"%@_%@_avatar.jpg", [YPBUser currentUser].userId, [[NSDate date] stringWithFormat:kDefaultDateFormat]];
        [YPBUploadManager uploadImage:pickedImage
                             withName:name
                      progressHandler:^(double progress)
         {
             [[YPBMessageCenter defaultCenter] proceedProgressWithPercent:progress];
         } completionHandler:^(BOOL success, id obj) {
             @strongify(self);
             
             void (^Handler)(BOOL result) = ^(BOOL result){
                 [[YPBMessageCenter defaultCenter] hideProgress];
                 
                 if (result) {
                     [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"头像更新成功" inViewController:self];
                     //self.profileCell.avatarImage = pickedImage;
                     
                     [YPBUser currentUser].logoUrl = obj;
                     [[YPBUser currentUser] saveAsCurrentUser];
                 } else {
                     [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"头像更新失败" inViewController:self];
                 }
             };
             
             if (success) {
                 [self.avatarUpdateModel updateAvatarOfUser:[YPBUser currentUser].userId withURL:obj completionHandler:^(BOOL success, id errorMsg) {
                     Handler(success);
                 }];
             } else {
                 Handler(NO);
             }
         }];
    }];
}

- (void)pickingPhotos {
    @weakify(self);
    YPBPhotoPicker *photoPicker = [[YPBPhotoPicker alloc] init];
    photoPicker.multiplePicking = YES;
    photoPicker.maximumNumberOfMultiplePicking = 5;
    
    [photoPicker showPickingSheetInViewController:self
                                        withTitle:@"选取照片"
                                completionHandler:^(BOOL success,
                                                    NSArray<UIImage *> *originalImages,
                                                    NSArray<UIImage *> *thumbImages)
    {
        if (photoPicker == nil || !success || originalImages.count != thumbImages.count) {
            return ;
        }
        
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [[YPBMessageCenter defaultCenter] showProgressWithTitle:@"照片上传中..." subtitle:nil];
        // Upload images to Qiniu Server
        [YPBUploadManager uploadOriginalImages:originalImages thumbImages:thumbImages withFilePrefix:[YPBUser currentUser].userId progressHandler:^(double progress) {
            [[YPBMessageCenter defaultCenter] proceedProgressWithPercent:progress];
        } completionHandler:^(NSArray *uploadedOriginalImages, NSArray *uploadedThumbImages) {
            
            if (uploadedOriginalImages.count == 0 || uploadedThumbImages.count == 0) {
                [[YPBMessageCenter defaultCenter] hideProgress];
                [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"照片上传失败" inViewController:self];
                return ;
            }
            
            // Photo Add REST API
            @weakify(self);
            
            [self.photoAddModel addOriginalPhotos:uploadedOriginalImages
                                      thumbPhotos:uploadedThumbImages
                                           byUser:[YPBUser currentUser].userId
                            withCompletionHandler:^(BOOL success, id obj)
            {
                [[YPBMessageCenter defaultCenter] hideProgress];
                
                @strongify(self);
                if (!self) {
                    return ;
                }
                
                if (success) {
                    NSUInteger failures = originalImages.count - uploadedOriginalImages.count;
                    if (failures > 0) {
                        [[YPBMessageCenter defaultCenter] showWarningWithTitle:[NSString stringWithFormat:@"%ld张照片添加成功，%ld张照片上传失败", uploadedOriginalImages.count, failures] inViewController:self];
                    } else {
                        [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"照片添加成功" inViewController:self];
                    }
                    
                    [[YPBUser currentUser] addOriginalPhotoUrls:uploadedOriginalImages thumbPhotoUrls:uploadedThumbImages];
                    [[YPBUser currentUser] saveAsCurrentUser];
                    //[self reloadPhotoBarImages];
                } else {
                    [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"照片添加失败" inViewController:self];
                }
            }];
        }];
    }];
}

- (void)refreshBadgeValue {
    NSUInteger unreadCount = [YPBUser currentUser].unreadTotalCount;
    if (unreadCount == 0) {
        self.navigationController.tabBarItem.badgeValue = nil;
    } else if (unreadCount < 100) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (unsigned long)unreadCount];
    } else {
        self.navigationController.tabBarItem.badgeValue = @"99+";
    }
    DLog(@"-------unreadCount--------%ld",unreadCount);
}

- (void)reloadUI {
    if (!self.isViewLoaded) {
        return ;
    }
    
    self.profileCell.name = [YPBUser currentUser].nickName;
    self.profileCell.avatarURL = [NSURL URLWithString:[YPBUser currentUser].logoUrl];
    
    self.profileCell.followedNumber = [YPBUser currentUser].unreadReceiveGreetCount;
    self.profileCell.followingNumber = [YPBUser currentUser].unreadGreetCount;
    self.profileCell.accessedNumber = [YPBUser currentUser].unreadAccessCount;
    
    if (_likeCell) {
        NSString *suffix = @" 人喜欢了你";
        NSMutableAttributedString *likeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", [YPBUser currentUser].receiveGreetCount ?: @0, suffix]];
        [likeString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                                    NSFontAttributeName:[UIFont systemFontOfSize:14.]} range:NSMakeRange(0, likeString.length-suffix.length)];
        _likeCell.titleLabel.attributedText = likeString;
    }
    
    [self reloadVIP];
    [self reloadPhotoBarImages];
    [self reloadDetailInfos];
}

- (void)reloadVIP {
    self.profileCell.isVIP = [YPBUtil isVIP];
    
    if ([YPBUtil isVIP]) {
        _vipCell.titleLabel.text = @"VIP续费";
        _vipCell.subtitleLabel.text = [YPBUtil shortVIPExpireDate];
    } else {
        _vipCell.titleLabel.text = @"开通VIP";
    }
}

- (void)reloadPhotoBarImages {
    if (_photoBar) {
        NSMutableArray *thumbPhotos = [NSMutableArray array];
        [[YPBUser currentUser].userPhotos enumerateObjectsUsingBlock:^(YPBUserPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.smallPhoto.length > 0) {
                [thumbPhotos addObject:obj.smallPhoto];
            }
        }];
        [_photoBar setImageURLStrings:thumbPhotos titleStrings:nil];
    }
}

- (void)reloadDetailInfos {
    _genderCell.imageView.image = [YPBUser currentUser].gender==YPBUserGenderFemale?[UIImage imageNamed:@"female_icon"]:[UIImage imageNamed:@"male_icon"];
    _genderCell.titleLabel.text = [YPBUser currentUser].gender==YPBUserGenderFemale?@"性别：女":@"性别：男";
    
    _heightCell.titleLabel.text = [NSString stringWithFormat:@"身高：%@", [YPBUser currentUser].heightDescription ?: @""];
    _figureCell.titleLabel.text = [YPBUser currentUser].figureDescription;
    _professionCell.titleLabel.text = [NSString stringWithFormat:@"职业：%@", [YPBUser currentUser].profession ?: @""];
    _interestCell.titleLabel.text = [NSString stringWithFormat:@"兴趣：%@", [YPBUser currentUser].note ?: @""];
    _wechatCell.titleLabel.text = [NSString stringWithFormat:@"微信：%@", [YPBUser currentUser].weixinNum ?: @""];
    _incomeCell.titleLabel.text = [NSString stringWithFormat:@"月收入：%@", [YPBUser currentUser].monthIncome ?: @""];
    _assetsCell.titleLabel.text = [NSString stringWithFormat:@"资产情况：%@", [YPBUser currentUser].assets ?: @""];
    _ageCell.titleLabel.text = [NSString stringWithFormat:@"年龄：%@", [YPBUser currentUser].ageDescription ?: @""];
    _purposeCell.titleLabel.text = [NSString stringWithFormat:@"交友目的：%@", [YPBUser currentUser].purpose];
}

- (void)onVIPUpgradeSuccessNotification {
    [self reloadVIP];
}

- (void)deletePhotoWithIndex:(NSUInteger)index {
    if (index >= [YPBUser currentUser].userPhotos.count) {
        return ;
    }
    
    @weakify(self);
    YPBUserPhoto *deletePhoto = [YPBUser currentUser].userPhotos[index];
    [self.photoDeleteModel deleteUserPhotoWithId:deletePhoto.id completionHandler:^(BOOL success, id obj) {
        @strongify(self);
        if (success) {
            [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"成功删除照片" inViewController:self];
            
            [[YPBUser currentUser] deleteUserPhoto:deletePhoto];
            [[YPBUser currentUser] saveAsCurrentUser];
            
            //[self reloadPhotoBarImages];
        } else {
            [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"删除照片失败" inViewController:self];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
