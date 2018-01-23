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
    
    UIView *_separator1;
    UIView *_separator2;
}
@end

@implementation YPBMineProfileCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
        self.backgroundView = _backgroundImageView;
        
        UIView *backgroundMaskView = [[UIView alloc] initWithFrame:_backgroundImageView.bounds];
        backgroundMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        backgroundMaskView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [_backgroundImageView addSubview:backgroundMaskView];
        
        _avatarView = [[YPBAvatarView alloc] init];
        @weakify(self);
        [_avatarView bk_whenTapped:^{
            @strongify(self);
            SafelyCallBlock(self.avatarAction);
        }];
        [self addSubview:_avatarView];

        _followedButton = [[YPBProfileActionButton alloc] initWithImage:[UIImage imageNamed:@"profile_followed"]
                                                                  title:@"收到招呼的人" action:^(id sender) {
                                                                                             @strongify(self);
                                                                                             [self onFollowedAction];
                                                                                         }];
        [self addSubview:_followedButton];
        
        _followingButton = [[YPBProfileActionButton alloc] initWithImage:[UIImage imageNamed:@"profile_following"]
                                                                   title:@"打过招呼的人" action:^(id sender) {
                                                                                              @strongify(self);
                                                                                              [self onFollowingAction];
                                                                                          }];
        [self addSubview:_followingButton];
        
        _accessedButton = [[YPBProfileActionButton alloc] initWithImage:[UIImage imageNamed:@"profile_accessed"]
                                                                  title:@"谁访问了我" action:^(id sender) {
                                                                                             @strongify(self);
                                                                                             [self onAccessedAction];
                                                                                         }];
        [self addSubview:_accessedButton];
        
        _separator1 = [[UIView alloc] init];
        _separator1.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:_separator1];
        
        _separator2 = [[UIView alloc] init];
        _separator2.backgroundColor = _separator1.backgroundColor;
        [self addSubview:_separator2];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat followedWidth = self.bounds.size.width / 4;
    const CGFloat followedHeight = lround(self.bounds.size.height / 3);
    const CGFloat followedX = self.bounds.size.width * 0.2 - followedWidth / 2;
    const CGFloat followedY = self.bounds.size.height - 10 - followedHeight;
    _followedButton.frame = CGRectMake(followedX, followedY, followedWidth, followedHeight);
    
    const CGFloat followingWidth = followedWidth;
    const CGFloat followingHeight = followedHeight;
    const CGFloat followingX = self.bounds.size.width / 2 - followingWidth / 2;
    const CGFloat followingY = followedY;
    _followingButton.frame = CGRectMake(followingX, followingY, followingWidth, followingHeight);
    
    const CGFloat accessWidth = followedWidth;
    const CGFloat accessHeight = followedHeight;
    const CGFloat accessX = self.bounds.size.width * 0.8 - accessWidth / 2;
    const CGFloat accessY = followingY;
    _accessedButton.frame = CGRectMake(accessX, accessY, accessWidth, accessHeight);
    
    const CGFloat separatorWidth = 0.5;
    const CGFloat separatorHeight = followedHeight * 0.6;
    const CGFloat separatorX = lround(self.bounds.size.width * 0.35);
    const CGFloat separatorY = _followedButton.frame.origin.y + (CGRectGetHeight(_followedButton.frame)-separatorHeight)/2;
    _separator1.frame = CGRectMake(separatorX, separatorY, separatorWidth, separatorHeight);
    _separator2.frame = CGRectMake(lround(self.bounds.size.width * 0.65), separatorY, separatorWidth, separatorHeight);
    
    const CGFloat avatarWidth = lround(self.bounds.size.width * 0.25);
    const CGFloat avatarX = (self.bounds.size.width-avatarWidth)/2;
    const CGFloat avatarY = 10;
    const CGFloat avatarHeight = CGRectGetMinY(_followedButton.frame)-avatarY*2;
    
    _avatarView.frame = CGRectMake(avatarX, avatarY, avatarWidth, avatarHeight);
}

- (void)setAvatarURL:(NSURL *)avatarURL {
    _avatarURL = avatarURL;
    _avatarView.imageURL = avatarURL;
    [_backgroundImageView sd_setImageWithURL:avatarURL];
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

- (void)setIsVIP:(BOOL)isVIP {
    _isVIP = isVIP;
    _avatarView.isVIP = isVIP;
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
