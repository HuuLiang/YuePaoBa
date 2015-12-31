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
    
    YPBProfileActionButton *_followedButton;
    YPBProfileActionButton *_followingButton;
    YPBProfileActionButton *_accessedButton;
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
        [_avatarView bk_whenTapped:^{
            @strongify(self);
            SafelyCallBlock(self.avatarAction);
        }];
        
        _followedButton = [[YPBProfileActionButton alloc] initWithImage:[UIImage imageNamed:@"profile_followed"]
                                                                  title:@"收到招呼的人" action:^(id sender) {
                                                                                             @strongify(self);
                                                                                             [self onFollowedAction];
                                                                                         }];
        [self addSubview:_followedButton];
        {
            [_followedButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).multipliedBy(0.4);
                make.bottom.equalTo(self).offset(-10);
                make.width.equalTo(self).multipliedBy(0.25);
                make.height.equalTo(self).dividedBy(3);
            }];
        }
        
        _followingButton = [[YPBProfileActionButton alloc] initWithImage:[UIImage imageNamed:@"profile_following"]
                                                                   title:@"打过招呼的人" action:^(id sender) {
                                                                                              @strongify(self);
                                                                                              [self onFollowingAction];
                                                                                          }];
        [self addSubview:_followingButton];
        {
            [_followingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.size.top.equalTo(_followedButton);
            }];
        }
        
        _accessedButton = [[YPBProfileActionButton alloc] initWithImage:[UIImage imageNamed:@"profile_accessed"]
                                                                  title:@"谁访问了我" action:^(id sender) {
                                                                                             @strongify(self);
                                                                                             [self onAccessedAction];
                                                                                         }];
        [self addSubview:_accessedButton];
        {
            [_accessedButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).multipliedBy(1.6);
                make.size.top.equalTo(_followingButton);
            }];
        }
        
        UIView *separator1 = [[UIView alloc] init];
        separator1.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:separator1];
        {
            [separator1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).multipliedBy(0.7);
                make.centerY.equalTo(_followedButton);
                make.height.equalTo(_followedButton).multipliedBy(0.6);
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
    SafelyCallBlock(self.viewFollowedAction);
}

- (void)onFollowingAction {
    SafelyCallBlock(self.viewFollowingAction);
}

- (void)onAccessedAction {
    SafelyCallBlock(self.viewAccessedAction);
}

- (void)setFollowedNumber:(NSUInteger)followedNumber {
    _followedNumber = followedNumber;
    _followedButton.badgeValue = followedNumber > 0 ? [NSString stringWithFormat:@"%ld", followedNumber] : nil;
}

- (void)setFollowingNumber:(NSUInteger)followingNumber {
    _followingNumber = followingNumber;
    _followingButton.badgeValue = followingNumber > 0 ? [NSString stringWithFormat:@"%ld", followingNumber] : nil;
}

- (void)setAccessedNumber:(NSUInteger)accessedNumber {
    _accessedNumber = accessedNumber;
    _accessedButton.badgeValue = accessedNumber > 0 ? [NSString stringWithFormat:@"%ld", accessedNumber] : nil;
}

- (UIView *)mineAvatarView {
    return _avatarView;
}
@end
