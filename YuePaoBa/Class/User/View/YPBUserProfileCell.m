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

@interface YPBUserProfileCell ()
{
    YPBAvatarView *_avatarView;
    UIImageView *_backgroundImageView;
    UIButton *_dateButton;
    YPBLikeButton *_likeButton;
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
        [self addSubview:_avatarView];
        {
            [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self).multipliedBy(0.5);
                make.width.equalTo(_avatarView.mas_height);
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(10);
            }];
        }
        
        _dateButton = [[UIButton alloc] init];
        UIImage *image = [UIImage animatedImageWithImages:@[[UIImage imageNamed:@"date_normal_button"],
                                                            [UIImage imageNamed:@"date_highlight_button"]] duration:0.5];
        [_dateButton setImage:image forState:UIControlStateNormal];
        [self addSubview:_dateButton];
        {
            [_dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self).offset(-2);
                make.width.equalTo(self).dividedBy(3);
                make.height.equalTo(_dateButton.mas_width).multipliedBy(115./253.);
            }];
        }
        
        @weakify(self);
        [_dateButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock1(self.dateAction, sender);
        } forControlEvents:UIControlEventTouchUpInside];
        
        _likeButton = [[YPBLikeButton alloc] initWithUserInteractionEnabled:YES];
        [self addSubview:_likeButton];
        {
            [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-5);
                make.top.equalTo(self).offset(5);
                make.width.equalTo(self).multipliedBy(0.15);
                make.height.equalTo(_likeButton.mas_width);
            }];
        }
        
        [_likeButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock1(self.likeAction, sender);
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setUser:(YPBUser *)user {
    _user = user;
    
    _avatarView.imageURL = [NSURL URLWithString:user.logoUrl];
    [_backgroundImageView sd_setImageWithURL:_avatarView.imageURL placeholderImage:nil options:SDWebImageRefreshCached|SDWebImageDelayPlaceholder];
    _avatarView.name = user.nickName;
    _avatarView.isVIP = user.isVip;
    
    self.liked = user.isGreet;
}

- (void)setLiked:(BOOL)liked {
    _liked = liked;
    _likeButton.selected = liked;
}
@end
