//
//  YPBUserProfileCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUserProfileCell.h"
#import "YPBAvatarView.h"
#import "YPBLikeButton.h"

static NSString *const kUserProfileDetailCellReusableIdentifier = @"UserProfileDetailCellReusableIdentifier";

typedef NS_ENUM(NSUInteger, YPBUserProfileDetailCell) {
    YPBUserProfileDetailCellNickName,
    YPBUserProfileDetailCellAge,
    YPBUserProfileDetailCellHeight,
    YPBUserProfileDetailCellCup,
    YPBUserProfileDetailCellTarget,
    YPBUserProfileDetailCellCount
};

@interface YPBUserProfileCell ()
{
    YPBAvatarView *_avatarView;
    UIImageView *_backgroundImageView;
//    UITableView *_detailTableView;
//    UIButton *_wechatButton;
}
@end

@implementation YPBUserProfileCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *backgroundMaskView = [[UIView alloc] init];
        backgroundMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
        self.backgroundView = _backgroundImageView;
        [_backgroundImageView addSubview:backgroundMaskView];
        {
            [backgroundMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_backgroundImageView);
            }];
        }
        
        _avatarView = [[YPBAvatarView alloc] init];
        _avatarView.showName = NO;
        [self.contentView addSubview:_avatarView];
        {
            [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.centerX.equalTo(self);
//                make.left.equalTo(self.contentView).offset(kScreenWidth * 0.05);
                
                make.height.equalTo(self.contentView).multipliedBy(0.6);
                make.width.equalTo(_avatarView.mas_height);
            }];
        }
        
//        _detailTableView = [[UITableView alloc] init];
//        _detailTableView.backgroundColor = [UIColor clearColor];
//        _detailTableView.delegate = self;
//        _detailTableView.dataSource = self;
//        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _detailTableView.scrollEnabled = NO;
//        _detailTableView.userInteractionEnabled = NO;
//        [_detailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kUserProfileDetailCellReusableIdentifier];
//        [self.contentView addSubview:_detailTableView];
//        {
//            [_detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.contentView);
//                make.bottom.equalTo(self.contentView).offset(-40);
//                make.right.equalTo(self.contentView);
//                make.left.equalTo(_avatarView.mas_right).offset(kScreenWidth * 0.05);
//            }];
//        }
        
//        _wechatButton = [[UIButton alloc] init];
//        _wechatButton.layer.borderWidth = 1;
//        _wechatButton.layer.borderColor = [UIColor whiteColor].CGColor;
//        _wechatButton.layer.cornerRadius = 5;
//        _wechatButton.layer.masksToBounds = YES;
//        _wechatButton.titleLabel.font = [UIFont systemFontOfSize:13.];
//        [_wechatButton setTitle:@"查看微信号" forState:UIControlStateNormal];
//        [_wechatButton setImage:[UIImage imageNamed:@"user_wechat_icon"] forState:UIControlStateNormal];
//        @weakify(self);
//        [_wechatButton bk_addEventHandler:^(id sender) {
//            @strongify(self);
//            SafelyCallBlock1(self.wechatAction, sender);
//        } forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_wechatButton];
//        {
//            [_wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_detailTableView.mas_bottom).offset(5);
//                make.bottom.equalTo(self.contentView).offset(-5);
//                make.left.equalTo(_detailTableView).offset(10);
//                make.width.equalTo(_detailTableView).multipliedBy(0.75);
//            }];
//        }
    }
    return self;
}

- (void)setUser:(YPBUser *)user {
    _user = user;
    
    _avatarView.imageURL = [NSURL URLWithString:user.logoUrl];
    [_backgroundImageView sd_setImageWithURL:_avatarView.imageURL placeholderImage:nil options:SDWebImageRefreshCached|SDWebImageDelayPlaceholder];
    _avatarView.isVIP = user.isVip;
    
//    [_detailTableView reloadData];
}

//#pragma mark - UITableViewDataSource,UITableViewDelegate
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserProfileDetailCellReusableIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor clearColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    if (indexPath.row == YPBUserProfileDetailCellNickName) {
//        cell.imageView.image = [UIImage imageNamed:@"user_online_icon"];
//        cell.textLabel.text = self.user.nickName ?: @"？？？";
//        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.];
//        cell.textLabel.textColor = [UIColor whiteColor];
//    } else if (indexPath.row == YPBUserProfileDetailCellHeight) {
//        cell.imageView.image = [UIImage imageNamed:@"user_height_icon"];
//        cell.textLabel.text = [NSString stringWithFormat:@"身高：%@", self.user.heightDescription.length > 0 ? self.user.heightDescription : @"保密"];
//        cell.textLabel.font = [UIFont systemFontOfSize:13.];
//        cell.textLabel.textColor = [UIColor whiteColor];
//    } else if (indexPath.row == YPBUserProfileDetailCellAge) {
//        cell.imageView.image = [UIImage imageNamed:@"user_age_icon"];
//        cell.textLabel.text = [NSString stringWithFormat:@"年龄：%@", self.user.ageDescription.length > 0 ? self.user.ageDescription : @"保密" ];
//        cell.textLabel.font = [UIFont systemFontOfSize:13.];
//        cell.textLabel.textColor = [UIColor whiteColor];
//    } else if (indexPath.row == YPBUserProfileDetailCellCup) {
//        cell.imageView.image = [UIImage imageNamed:@"user_cup_icon"];
//        cell.textLabel.font = [UIFont systemFontOfSize:13.];
//        cell.textLabel.textColor = [UIColor whiteColor];
//        
//        if (self.user.gender == YPBUserGenderFemale) {
//            cell.textLabel.text = [NSString stringWithFormat:@"罩杯：%@", self.user.cupDescription.length > 0 ? self.user.cupDescription : @"保密"];
//        } else {
//            cell.textLabel.text = [NSString stringWithFormat:@"体重：%@", self.user.weightDescription ?: @"保密"];
//        }
//        
//    } else if (indexPath.row == YPBUserProfileDetailCellTarget) {
//        cell.imageView.image = [UIImage imageNamed:@"user_propose_icon"];
//        cell.textLabel.text = [NSString stringWithFormat:@"交友目的：%@", self.user.purpose ?: @"保密"];
//        cell.textLabel.font = [UIFont systemFontOfSize:13.];
//        cell.textLabel.textColor = [UIColor whiteColor];
//    }
//    return cell;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return YPBUserProfileDetailCellCount;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    const CGFloat nickNameCellHeight = CGRectGetHeight(tableView.bounds) / 3;
//    if (indexPath.row == YPBUserProfileDetailCellNickName) {
//        return nickNameCellHeight;
//    } else {
//        return (CGRectGetHeight(tableView.bounds) - nickNameCellHeight) / (YPBUserProfileDetailCellCount-1);
//    }
//}
@end
