//
//  YPBSideMenuCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/2.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBSideMenuCell.h"

@interface YPBSideMenuCell ()
{
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
    UILabel *_badgeLabel;
}
@end

@implementation YPBSideMenuCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title iconImage:(UIImage *)iconImage {
    self = [self init];
    if (self) {
        _title = title;
        _iconImage = iconImage;
        
        _iconImageView = [[UIImageView alloc] initWithImage:iconImage];
        [self addSubview:_iconImageView];
        {
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self).multipliedBy(0.6);
                make.width.equalTo(_iconImageView.mas_height);
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(20);
            }];
        }
        
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.clipsToBounds = YES;
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.hidden = YES;
        [self addSubview:_badgeLabel];
        {
            [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self).offset(-15);
                make.height.equalTo(self).multipliedBy(0.4);
                make.width.equalTo(_badgeLabel.mas_height);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = title;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_iconImageView.mas_right).offset(20);
                make.right.equalTo(_badgeLabel.mas_left).with.offset(-10);
                make.top.bottom.equalTo(_iconImageView);
            }];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _badgeLabel.font = [UIFont systemFontOfSize:CGRectGetHeight(_badgeLabel.frame)*0.5];
    _badgeLabel.layer.cornerRadius = CGRectGetHeight(_badgeLabel.frame)/2;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    _iconImageView.image = iconImage;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeLabel.text = badgeValue;
    _badgeLabel.hidden = badgeValue.length == 0;
    [self setNeedsLayout];
}
@end
