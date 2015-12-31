//
//  YPBTableViewCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/23.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBTableViewCell.h"

@implementation YPBTableViewCell
@synthesize iconImageView = _iconImageView;
@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    return [self initWithImage:image title:title subtitle:nil];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        self.iconImageView.image = image;
        self.titleLabel.text = title;
        
        if (subtitle) {
            self.subtitleLabel.text = subtitle;
        }
    }
    return self;
}

- (UIImageView *)iconImageView {
    if (_iconImageView) {
        return _iconImageView;
    }
    
    _iconImageView = [[UIImageView alloc] init];
    //_iconImageView.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:_iconImageView];
    {
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(self.contentView).multipliedBy(0.5);
            make.width.equalTo(_iconImageView.mas_height);
        }];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:14.];
    _titleLabel.textColor = kDefaultTextColor;
    [self.contentView addSubview:_titleLabel];
    [self titleLabelRemakeConstraints];
    
    return _titleLabel;
}

- (void)titleLabelRemakeConstraints {
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView?_iconImageView.mas_right:self.contentView).offset(_iconImageView?15:15);
        make.right.equalTo(_subtitleLabel ? self.contentView.mas_centerX : self.contentView).offset(_subtitleLabel?0:-15);
        //            make.top.equalTo(self.contentView).offset(kTitleLabelTopBottomSpacing);
        //            make.bottom.equalTo(self.contentView).offset(-kTitleLabelTopBottomSpacing);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)subtitleLabelRemakeConstraints {
    [_subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(self.accessoryType==UITableViewCellAccessoryNone?-15:-5);
        make.left.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel) {
        return _subtitleLabel;
    }
    
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.font = [UIFont systemFontOfSize:14.];
    _subtitleLabel.textColor = kDefaultTextColor;
    _subtitleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_subtitleLabel];
    {
        [self subtitleLabelRemakeConstraints];
        [self titleLabelRemakeConstraints];
    }
    return _subtitleLabel;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
    [super setAccessoryType:accessoryType];
    [self subtitleLabelRemakeConstraints];
}
@end
