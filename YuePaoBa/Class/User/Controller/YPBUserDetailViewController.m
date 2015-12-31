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
#import "YPBUserPhotoBar.h"
#import "YPBPhotoGridViewController.h"
#import "YPBPhotoBrowser.h"

@interface YPBUserDetailViewController ()
{
    YPBUserProfileCell *_profileCell;
    YPBTableViewCell *_likeCell;
    YPBTableViewCell *_figureCell;
    YPBTableViewCell *_heightCell;
    YPBTableViewCell *_professionCell;
    YPBTableViewCell *_interestCell;
    YPBTableViewCell *_wechatCell;
    YPBTableViewCell *_incomeCell;
    YPBTableViewCell *_assetsCell;
    YPBTableViewCell *_ageCell;
    
    YPBTableViewCell *_morePhotoCell;
    YPBUserPhotoBar *_photoBar;
}
@property (nonatomic) NSString *userId;
@property (nonatomic,retain) YPBUserDetailModel *userDetailModel;
@property (nonatomic,retain) YPBUserAccessModel *userAccessModel;
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
    
    [self initLayoutCells];
    
    @weakify(self);
    [self.layoutTableView YPB_addPullToRefreshWithHandler:^{
        @strongify(self);
        [self loadUserDetail];
    }];
    [self.layoutTableView YPB_triggerPullToRefresh];
    
    self.layoutTableViewAction = ^(NSIndexPath *indexPath, UITableViewCell *cell) {
        @strongify(self);
        if (cell == self->_morePhotoCell) {
            if (self->_photoBar.imageURLStrings.count == 0) {
                [[YPBMessageCenter defaultCenter] showWarningWithTitle:@"TA的相册空空如也~~~" subtitle:nil];
            } else {
                YPBPhotoGridViewController *photoVC = [[YPBPhotoGridViewController alloc] initWithPhotos:self.userDetailModel.fetchedUser.userPhotos];
                [self.navigationController pushViewController:photoVC animated:YES];
            }

        }
    };
}

- (void)loadUserDetail {
    @weakify(self);
    [self.userDetailModel fetchUserDetailWithUserId:self.userId
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

- (void)onSuccessfullyAccessedUser:(YPBUser *)user {
    _profileCell.avatarImageURL = [NSURL URLWithString:user.logoUrl];
    _profileCell.name = user.nickName;
    _profileCell.isVIP = user.isVip;
    _profileCell.displayDateButton = YES;
    
    NSString *suffix = @" 人喜欢了你";
    NSMutableAttributedString *likeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", user.receiveGreetCount ?: @0, suffix]];
    [likeString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:14.]} range:NSMakeRange(0, likeString.length-suffix.length)];
    _likeCell.titleLabel.attributedText = likeString;
    
    _heightCell.titleLabel.text = [NSString stringWithFormat:@"身高：%@", user.height ?: @""];
    _figureCell.titleLabel.text = [NSString stringWithFormat:@"身材：%@", user.bwh ?: @""];
    _professionCell.titleLabel.text = [NSString stringWithFormat:@"职业：%@", user.profession ?: @""];
    _interestCell.titleLabel.text = [NSString stringWithFormat:@"兴趣：%@", user.note ?: @""];
    _wechatCell.titleLabel.text = [NSString stringWithFormat:@"微信：%@", user.weixinNum ?: @""];
    _incomeCell.titleLabel.text = [NSString stringWithFormat:@"月收入：%@", user.monthIncome ?: @""];
    _assetsCell.titleLabel.text = [NSString stringWithFormat:@"资产情况：%@", user.assets ?: @""];
    _ageCell.titleLabel.text = [NSString stringWithFormat:@"年龄：%@", user.age ?: @""];
    _morePhotoCell.titleLabel.text = user.userPhotos.count > 0 ? [NSString stringWithFormat:@"查看所有照片(%ld张)", user.userPhotos.count] : @"查看所有照片";
    
    NSMutableArray *thumbPhotos = [NSMutableArray array];
    [user.userPhotos enumerateObjectsUsingBlock:^(YPBUserPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.smallPhoto.length > 0) {
            [thumbPhotos addObject:obj.smallPhoto];
        }
    }];
    if (thumbPhotos.count > 0) {
        _photoBar.imageURLStrings = thumbPhotos;
    }
    
    [self.userAccessModel accessUserWithUserId:user.userId
                                    accessType:YPBUserAccessTypeViewDetail
                             completionHandler:nil];
}

- (void)greetUser {
    if (self.userDetailModel.fetchedUser.userId.length == 0) {
        [[YPBMessageCenter defaultCenter] showErrorWithTitle:@"无法获取用户信息" subtitle:nil];
        return ;
    }
    
    @weakify(self);
    [_profileCell beginLoading];
    
    [self.userAccessModel accessUserWithUserId:self.userDetailModel.fetchedUser.userId
                                    accessType:YPBUserAccessTypeGreet
                             completionHandler:^(BOOL success, id obj)
    {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        [self->_profileCell endLoading];
        if (success) {
            [[YPBMessageCenter defaultCenter] showSuccessWithTitle:@"打招呼成功" subtitle:nil];
        }
    }];
}

- (void)initLayoutCells {
    YPBUserProfileCell *profileCell = [[YPBUserProfileCell alloc] init];
    @weakify(self);
    profileCell.dateAction = ^(id sender) {
        @strongify(self);
        [self greetUser];
    };
    [self setLayoutCell:profileCell cellHeight:MIN(kScreenHeight*0.4, 200) inRow:0 andSection:0];
    _profileCell = profileCell;
    
    [self setHeaderTitle:@"个人相册" height:30 inSection:1];
    
    YPBTableViewCell *photoCell = [[YPBTableViewCell alloc] init];
    photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    _photoBar = [[YPBUserPhotoBar alloc] init];
    _photoBar.selectAction = ^(NSUInteger index) {
        @strongify(self);
        [YPBPhotoBrowser showPhotoBrowserInView:self.view.window
                                     withPhotos:self.userDetailModel.fetchedUser.userPhotos
                              currentPhotoIndex:index];
    };
    [photoCell addSubview:_photoBar];
    {
        [_photoBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(photoCell);//.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
    }
    [self setLayoutCell:photoCell cellHeight:kScreenHeight*0.15 inRow:0 andSection:1];
    
    _morePhotoCell = [[YPBTableViewCell alloc] init];
    _morePhotoCell.titleLabel.text = @"查看所有照片";
    _morePhotoCell.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setLayoutCell:_morePhotoCell inRow:1 andSection:1];
    
    const NSUInteger detailInfoSection = 2;
    [self setHeaderTitle:@"详细资料" height:30 inSection:detailInfoSection];
    
    NSUInteger row = 0;
    _likeCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"like_icon"] title:@"？人喜欢了你"];
    _likeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_likeCell inRow:row++ andSection:detailInfoSection];
    
    _figureCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"figure_icon"] title:@"身材：?? ?? ??"];
    _figureCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_figureCell inRow:row++ andSection:detailInfoSection];
    
    _heightCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"height_icon"] title:@"身高：???cm"];
    _heightCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_heightCell inRow:row++ andSection:detailInfoSection];
    
    _professionCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"profession_icon"] title:@"职业：？？？"];
    _professionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_professionCell inRow:row++ andSection:detailInfoSection];
    
    _interestCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"interest_icon"] title:@"兴趣：？？？"];
    _interestCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_interestCell inRow:row++ andSection:detailInfoSection];
    
    _wechatCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"wechat_icon"] title:@"微信：********"];
    _wechatCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_wechatCell inRow:row++ andSection:detailInfoSection];
    
    _incomeCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"income_icon"] title:@"月收入：？？？"];
    _incomeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_incomeCell inRow:row++ andSection:detailInfoSection];
    
    _assetsCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"assets_icon"] title:@"资产情况：？？？"];
    _assetsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_assetsCell inRow:row++ andSection:detailInfoSection];
    
    _ageCell = [[YPBTableViewCell alloc] initWithImage:[UIImage imageNamed:@"age_icon"] title:@"年龄：？"];
    _ageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setLayoutCell:_ageCell inRow:row++ andSection:detailInfoSection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
