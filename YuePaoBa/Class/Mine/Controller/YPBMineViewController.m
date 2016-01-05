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
#import "YPBUserPhotoBar.h"
#import "YPBPhotoPicker.h"

@interface YPBMineViewController ()
{
    YPBTableViewCell *_vipCell;
    YPBTableViewCell *_likeCell;
    
    YPBTableViewCell *_photoCell;
    YPBUserPhotoBar *_photoBar;
}
@property (nonatomic,retain) YPBAvatarView *sideMenuAvatarView;
@property (nonatomic,retain) YPBMineProfileCell *profileCell;
@property (nonatomic,retain) YPBUserDetailModel *mineDetailModel;
@property (nonatomic,retain) YPBUserAvatarUpdateModel *avatarUpdateModel;
@end

@implementation YPBMineViewController

DefineLazyPropertyInitialization(YPBUserDetailModel, mineDetailModel)
DefineLazyPropertyInitialization(YPBUserAvatarUpdateModel, avatarUpdateModel)

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurrentUserChange) name:kCurrentUserChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.layoutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"edit_icon"]
                                                                                 style:UIBarButtonItemStylePlain
                                                                               handler:^(id sender)
    {
        @strongify(self);
        
        YPBUser *user = [YPBUser currentUser];
        
        YPBEditMineDetailViewController *editVC = [[YPBEditMineDetailViewController alloc] initWithUser:user.copy];
        [self.navigationController pushViewController:editVC animated:YES];
//        if (user.isRegistered) {
//            YPBEditMineDetailViewController *editVC = [[YPBEditMineDetailViewController alloc] initWithUser:user.copy];
//            [self.navigationController pushViewController:editVC animated:YES];
//        } else {
//            [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"无法获取用户详细信息，请刷新后重试" subtitle:nil];
//        }
        
    }];
    
    [self.layoutTableView YPB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self refreshMineDetails];
    }];
    [self.layoutTableView YPB_triggerPullToRefresh];
    
    [self initLayoutCells];
    
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_vipCell) {
            YPBVIPPriviledgeViewController *priviledgeVC = [[YPBVIPPriviledgeViewController alloc] init];
            [self.navigationController pushViewController:priviledgeVC animated:YES];
        }
    };
}

- (void)refreshMineDetails {
    @weakify(self);
    [self.mineDetailModel fetchUserDetailWithUserId:[YPBUser currentUser].userId
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
            [user setAsCurrentUser];
        }
    }];
}

- (void)initLayoutCells {
    [self setLayoutCell:self.profileCell cellHeight:kScreenWidth/1.5 inRow:0 andSection:0];
    
    [self setHeaderHeight:15 inSection:1];
    
    _vipCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"vip_icon"] title:@"开通VIP"];
    _vipCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _vipCell.iconImageView.contentMode = UIViewContentModeCenter;
    [self setLayoutCell:_vipCell cellHeight:kScreenHeight*0.08 inRow:0 andSection:1];
    
    _likeCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"like_icon"] title:@"？人喜欢了你"];
    [self setLayoutCell:_likeCell cellHeight:kScreenHeight*0.08 inRow:1 andSection:1];
    
    [self setHeaderHeight:15 inSection:2];
    
    _photoCell = [[YPBTableViewCell alloc] init];
    _photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _photoBar = [[YPBUserPhotoBar alloc] initWithUsePhotoAddItem:YES];
    @weakify(self);
    _photoBar.photoAddAction = ^(id obj) {
        @strongify(self);
        [self pickingPhotos];
    };
    [_photoCell addSubview:_photoBar];
    {
        [_photoBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_photoCell);
        }];
    }
    [self setLayoutCell:_photoCell cellHeight:kScreenHeight*0.15 inRow:0 andSection:2];
}

- (YPBMineProfileCell *)profileCell {
    if (_profileCell) {
        return _profileCell;
    }
    
    @weakify(self);
    _profileCell = [[YPBMineProfileCell alloc] init];
    _profileCell.name = [YPBUser currentUser].nickName;
    _profileCell.isVIP = [YPBUser currentUser].isVip;
    _profileCell.avatarAction = ^{
        @strongify(self);
        [self pickingAvatar];
    };
    _profileCell.viewFollowedAction = ^{
        @strongify(self);
        YPBMineAccessViewController *recvVC = [[YPBMineAccessViewController alloc] initWithAccessType:YPBMineAccessTypeGreetingReceived];
        [self.navigationController pushViewController:recvVC animated:YES];
    };
    _profileCell.viewFollowingAction = ^{
        @strongify(self);
        YPBMineAccessViewController *recvVC = [[YPBMineAccessViewController alloc] initWithAccessType:YPBMineAccessTypeGreetingSent];
        [self.navigationController pushViewController:recvVC animated:YES];
    };
    _profileCell.viewAccessedAction = ^{
        @strongify(self);
        YPBMineAccessViewController *recvVC = [[YPBMineAccessViewController alloc] initWithAccessType:YPBMineAccessTypeAccessViewed];
        [self.navigationController pushViewController:recvVC animated:YES];
    };
    return _profileCell;
}

- (YPBAvatarView *)sideMenuAvatarView {
    if (_sideMenuAvatarView) {
        return _sideMenuAvatarView;
    }
    
    _sideMenuAvatarView = [[YPBAvatarView alloc] init];
    @weakify(self);
    [_sideMenuAvatarView bk_whenTapped:^{
        @strongify(self);
        
        [[YPBUtil sideMenuViewController] hideMenuViewController];
        [[YPBUtil sideMenuViewController] setContentViewController:self.navigationController animated:YES];
    }];
    return _sideMenuAvatarView;
}

- (void)pickingAvatar {
    @weakify(self);
    YPBPhotoPicker *photoPicker = [[YPBPhotoPicker alloc] init];
    photoPicker.multiplePicking = NO;
    [photoPicker showPickingSheetInViewController:self
                                        withTitle:@"选取头像"
                                completionHandler:^(BOOL success,
                                                    NSArray<UIImage *> *originalImages,
                                                    NSArray<UIImage *> *thumbImages)
    {
        if (photoPicker == nil || !success || thumbImages.count == 0) {
            return;
        }
        
        UIImage *pickedImage = thumbImages[0];
        [[YPBMessageCenter defaultCenter] showProgressWithTitle:@"头像上传中..." subtitle:nil];
        NSString *name = [NSString stringWithFormat:@"%@_%@_avatar.jpg", [YPBUser currentUser].userId, [[NSDate date] stringWithFormat:kDefaultDateFormat]];
        [YPBUploadManager uploadImage:pickedImage
                             withName:name
                      progressHandler:^(double progress)
         {
             [[YPBMessageCenter defaultCenter] proceedProgressWithPercent:progress];
         } completionHandler:^(BOOL success, id obj) {
             @strongify(self);
             [[YPBMessageCenter defaultCenter] hideProgress];
             
             if (success) {
                 [self.avatarUpdateModel updateAvatarOfUser:[YPBUser currentUser].userId withURL:obj completionHandler:^(BOOL success, id obj) {
                     if (success) {
                         [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"头像更新成功" inViewController:self];
                         self.sideMenuAvatarView.image = pickedImage;
                         
                     }
                 }];
             } else {
                 DLog(@"头像图片上传失败：%@", ((NSError *)obj).localizedDescription);
                 [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"头像更新失败" inViewController:self];
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
        
        const NSUInteger totalCount = originalImages.count+thumbImages.count;
        NSMutableArray<UIImage *> *images = [NSMutableArray arrayWithCapacity:totalCount];
        NSMutableArray<NSString *> *names = [NSMutableArray arrayWithCapacity:totalCount];
        [originalImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *thumbImage = thumbImages[idx];
            [images addObject:obj];
            [images addObject:thumbImage];
            
            NSString *uuid = [NSUUID UUID].UUIDString;
            NSString *originalName = [NSString stringWithFormat:@"%@_%@_original.jpg", [YPBUser currentUser].userId, uuid];
            NSString *thumbName = [NSString stringWithFormat:@"%@_%@_thumbnail.jpg", [YPBUser currentUser].userId, uuid];
            [names addObject:originalName];
            [names addObject:thumbName];
        }];
        
        [[YPBMessageCenter defaultCenter] showProgressWithTitle:@"照片上传中..." subtitle:nil];
        [YPBUploadManager uploadImages:images withNames:names progressHandler:^(double progress) {
            [[YPBMessageCenter defaultCenter] proceedProgressWithPercent:progress];
        } completionHandler:^(NSArray *success, NSArray *failure) {
            [[YPBMessageCenter defaultCenter] hideProgress];
            
            if (failure.count > 0) {
                [[YPBMessageCenter defaultCenter] showErrorWithTitle:[NSString stringWithFormat:@"%ld张照片上传失败",failure.count] inViewController:self];
            }
            
//            if (success.count > 0) {
//                self->_photoBar.imageURLStrings =
//            }
        }];
    }];
}

- (void)onCurrentUserChange {
    self.sideMenuAvatarView.imageURL = [NSURL URLWithString:[YPBUser currentUser].logoUrl];
    self.sideMenuAvatarView.name = [YPBUser currentUser].nickName;
    self.sideMenuAvatarView.isVIP = [YPBUser currentUser].isVip;
    
    self.profileCell.name = [YPBUser currentUser].nickName;
    self.profileCell.isVIP = [YPBUser currentUser].isVip;
    self.profileCell.followedNumber = [YPBUser currentUser].receiveGreetCount.unsignedIntegerValue;
    self.profileCell.followingNumber = [YPBUser currentUser].greetCount.unsignedIntegerValue;
    self.profileCell.accessedNumber = [YPBUser currentUser].accessCount.unsignedIntegerValue;
    
    NSString *suffix = @" 人喜欢了你";
    NSMutableAttributedString *likeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", [YPBUser currentUser].receiveGreetCount ?: @0, suffix]];
    [likeString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:14.]} range:NSMakeRange(0, likeString.length-suffix.length)];
    _likeCell.titleLabel.attributedText = likeString;
    
    NSMutableArray *thumbPhotos = [NSMutableArray array];
    [[YPBUser currentUser].userPhotos enumerateObjectsUsingBlock:^(YPBUserPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.smallPhoto.length > 0) {
            [thumbPhotos addObject:obj.smallPhoto];
        }
    }];
    _photoBar.imageURLStrings = thumbPhotos;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YPBSideMenuItemDelegate

- (void)sideMenuController:(UIViewController *)viewController willAddToSideMenuCell:(UITableViewCell *)cell {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    @weakify(viewController,self);
    self.sideMenuAvatarView.avatarImageLoadHandler = ^(UIImage *image) {
        @strongify(viewController,self);
        viewController.backgroundImageView.image = image;
        self.profileCell.avatarImage = image;
    };
    
    self.sideMenuAvatarView.imageURL = [NSURL URLWithString:[YPBUser currentUser].logoUrl];
    self.sideMenuAvatarView.name = [YPBUser currentUser].nickName;
    self.sideMenuAvatarView.isVIP = [YPBUser currentUser].isVip;
    
    if (![cell.subviews containsObject:self.sideMenuAvatarView]) {
        [cell addSubview:self.sideMenuAvatarView];
        {
            [self.sideMenuAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell);
                make.width.equalTo(cell).multipliedBy(0.35);
                make.height.equalTo(cell).multipliedBy(0.8);
            }];
        }
    }
    
//    [[YPBUserDetailModel sharedModel] fetchUserDetailWithUserId:[YPBUser currentUser].userId completionHandler:^(BOOL success, id obj) {
//        if (success) {
//            YPBUser *user = obj;
//            [user setAsCurrentUser];
//        }
//    }];
}

- (BOOL)sideMenuController:(UIViewController *)sideMenuVC shouldPresentContentViewController:(UIViewController *)contentVC {
    return NO;
}

- (CGFloat)sideMenuItemHeight {
    return kScreenHeight * 0.3;
}
@end
