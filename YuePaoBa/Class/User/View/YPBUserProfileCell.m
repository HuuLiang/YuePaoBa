//
//  YPBUserProfileCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBUserProfileCell.h"
#import "YPBAvatarView.h"

@interface YPBUserProfileCell ()
{
    YPBAvatarView *_avatarView;
    UIImageView *_backgroundImageView;
    UIButton *_dateButton;
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
        _dateButton.hidden = YES;
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
    }
    return self;
}

- (void)setName:(NSString *)name {
    _name = name;
    _avatarView.name = name;
}

- (void)setAvatarImageURL:(NSURL *)avatarImageURL {
    _avatarImageURL = avatarImageURL;
    _avatarView.imageURL = avatarImageURL;
    [_backgroundImageView sd_setImageWithURL:avatarImageURL placeholderImage:nil options:SDWebImageRefreshCached|SDWebImageDelayPlaceholder];
}

- (void)setIsVIP:(BOOL)isVIP {
    _isVIP = isVIP;
    _avatarView.isVIP = isVIP;
}

- (void)setDisplayDateButton:(BOOL)displayDateButton {
    _displayDateButton = displayDateButton;
    _dateButton.hidden = !displayDateButton;
}
@end
