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
//                make.height.equalTo(self).multipliedBy(0.6);
//                make.width.equalTo(_iconImageView.mas_height);
                make.size.mas_equalTo(CGSizeMake(kScreenHeight*0.06, kScreenHeight*0.06));
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(20);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_iconImageView.mas_right).offset(20);
            }];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.font = [UIFont systemFontOfSize:CGRectGetHeight(_iconImageView.frame)/2.5];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    _iconImageView.image = iconImage;
}

@end
