//
//  YPBVideoTitleView.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/27.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBVideoTitleView.h"

@interface YPBVideoTitleView ()
{
    UIImageView *_avatarImageView;
    
    UILabel *_liveLabel;
    UIImageView *_liveIconImageView;
    UILabel *_detailLabel;
}
@end

@implementation YPBVideoTitleView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        [self addSubview:_avatarImageView];
        {
            [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(8);
                make.centerY.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.8);
                make.width.equalTo(_avatarImageView.mas_height);
            }];
        }
        
        _liveLabel = [[UILabel alloc] init];
        _liveLabel.textColor = [UIColor whiteColor];
        _liveLabel.text = @"直播视频认证";
        [self addSubview:_liveLabel];
        {
            [_liveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_centerY).offset(-2.5);
                make.left.equalTo(_avatarImageView.mas_right).offset(10);
            }];
        }
        
        _liveIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fire_icon"]];
        [self addSubview:_liveIconImageView];
        {
            [_liveIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_liveLabel);
                make.left.equalTo(_liveLabel.mas_right).offset(3);
            }];
        }
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor whiteColor];
        [self addSubview:_detailLabel];
        {
            [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_liveLabel.mas_bottom).offset(2.5);
                make.left.equalTo(_liveLabel);
            }];
        }
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    _avatarImageView.layer.cornerRadius = CGRectGetHeight(_avatarImageView.frame)/2;
    
    _liveLabel.font = [UIFont systemFontOfSize:MIN(CGRectGetHeight(self.bounds)*0.25,16)];
    _detailLabel.font = _liveLabel.font;
}

- (instancetype)initWithAvatarUrl:(NSURL *)avatarUrl detail:(NSString *)detail; {
    self = [self init];
    if (self) {
        self.avatarUrl = avatarUrl;
        self.detail = detail;
    }
    return self;
}

- (void)setAvatarUrl:(NSURL *)avatarUrl {
    _avatarUrl = avatarUrl;
    [_avatarImageView sd_setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
}

- (void)setDetail:(NSString *)detail {
    _detail = detail;
    _detailLabel.text = detail;
}
@end
