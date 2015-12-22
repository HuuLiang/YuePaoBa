//
//  YPBMineProfileCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/17.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBMineProfileCell.h"
#import "YPBAvatarView.h"
#import "YPBProfileActionButton.h"

@interface YPBMineProfileCell ()
{
    YPBAvatarView *_avatarView;
    UIImageView *_backgroundImageView;
}
@end

@implementation YPBMineProfileCell

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
        //_avatarView.showName = NO;
        [self addSubview:_avatarView];
        {
            [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self).multipliedBy(0.4);
                make.width.equalTo(_avatarView.mas_height);
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(10);
            }];
        }
        
        @weakify(self);
        YPBProfileActionButton *followedButton = [[YPBProfileActionButton alloc] initWithImage:[UIImage imageNamed:@"profile_followed"]
                                                                                         title:@"收到招呼的人" action:^(id sender) {
                                                                                             @strongify(self);
                                                                                             [self onFollowedAction];
                                                                                         }];
        [self addSubview:followedButton];
        {
            [followedButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).multipliedBy(0.4);
                make.bottom.equalTo(self).offset(-10);
                make.width.equalTo(self).multipliedBy(0.25);
                make.height.equalTo(self).dividedBy(3);
            }];
        }
        
        YPBProfileActionButton *followingButton = [[YPBProfileActionButton alloc] initWithImage:[UIImage imageNamed:@"profile_following"]
                                                                                          title:@"打过招呼的人" action:^(id sender) {
                                                                                              @strongify(self);
                                                                                              [self onFollowingAction];
                                                                                          }];
        [self addSubview:followingButton];
        {
            [followingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.size.top.equalTo(followedButton);
            }];
        }
        
        YPBProfileActionButton *accessedButton = [[YPBProfileActionButton alloc] initWithImage:[UIImage imageNamed:@"profile_accessed"]
                                                                                         title:@"谁访问了我" action:^(id sender) {
                                                                                             @strongify(self);
                                                                                             [self onAccessedAction];
                                                                                         }];
        [self addSubview:accessedButton];
        {
            [accessedButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).multipliedBy(1.6);
                make.size.top.equalTo(followingButton);
            }];
        }
        
        UIView *separator1 = [[UIView alloc] init];
        separator1.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:separator1];
        {
            [separator1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).multipliedBy(0.7);
                make.centerY.equalTo(followedButton);
                make.height.equalTo(followedButton).multipliedBy(0.6);
                make.width.mas_equalTo(0.5);
            }];
        }
        
        UIView *separator2 = [[UIView alloc] init];
        separator2.backgroundColor = separator1.backgroundColor;
        [self addSubview:separator2];
        {
            [separator2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).multipliedBy(1.3);
                make.size.centerY.equalTo(separator1);
            }];
        }
        
    }
    return self;
}

- (void)setAvatarImage:(UIImage *)avatarImage {
    _avatarImage = avatarImage;
    _avatarView.image = avatarImage;
    _backgroundImageView.image = avatarImage;
}

- (void)setName:(NSString *)name {
    _name = name;
    _avatarView.name = name;
}

- (void)onFollowedAction {
    if (self.viewFollowedAction) {
        self.viewFollowedAction();
    }
}

- (void)onFollowingAction {
    if (self.viewFollowingAction) {
        self.viewFollowingAction();
    }
}

- (void)onAccessedAction {
    if (self.viewAccessedAction) {
        self.viewAccessedAction();
    }
}
@end
