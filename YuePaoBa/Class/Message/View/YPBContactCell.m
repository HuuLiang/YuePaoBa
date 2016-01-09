//
//  YPBContactCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBContactCell.h"

@interface YPBContactCell ()
{
    UIImageView *_thumbImageView;
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
    UILabel *_notiLabel;
}
@end

@implementation YPBContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(30);
                make.height.equalTo(self).multipliedBy(0.8);
                make.width.equalTo(_thumbImageView.mas_height);
                make.centerY.equalTo(self);
            }];
        }
        
//        _notiView = [[UIView alloc] init];
//        _notiView.backgroundColor = [UIColor redColor];
//        [self addSubview:_notiView];
//        {
//            [_notiView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(self);
//                make.right.equalTo(self).offset(-15);
//                make.height.equalTo(self).dividedBy(3);
//                make.width.equalTo(_notiView.mas_height);
//            }];
//        }
//        
        _notiLabel = [[UILabel alloc] init];
        _notiLabel.clipsToBounds = YES;
        _notiLabel.backgroundColor = [UIColor redColor];
        _notiLabel.textColor = [UIColor whiteColor];
        _notiLabel.textAlignment = NSTextAlignmentCenter;
        _notiLabel.hidden = YES;
        _notiLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_notiLabel];
        {
            [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self).offset(-15);
                make.height.equalTo(self).dividedBy(3);
                make.width.equalTo(_notiLabel.mas_height);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        [self addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_thumbImageView.mas_right).offset(15);
                make.right.equalTo(_notiLabel.mas_left).offset(-15);
                make.bottom.equalTo(self.mas_centerY);
            }];
        }
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:14.];
        _subtitleLabel.textColor = kDefaultTextColor;
        [self addSubview:_subtitleLabel];
        {
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_titleLabel);
                make.top.equalTo(_titleLabel.mas_bottom).offset(5);
            }];
        }
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _thumbImageView.layer.cornerRadius = CGRectGetHeight(_thumbImageView.frame)/2;
    //_notiLabel.font = [UIFont systemFontOfSize:CGRectGetHeight(_notiLabel.frame)*0.8];
    _notiLabel.layer.cornerRadius = CGRectGetHeight(_notiLabel.frame)/2;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    _subtitleLabel.text = subtitle;
}

- (void)setNumberOfNotifications:(NSUInteger)numberOfNotifications {
    _numberOfNotifications = numberOfNotifications;
    if (numberOfNotifications > 99) {
        _notiLabel.text = @"99+";
    } else {
        _notiLabel.text = @(numberOfNotifications).stringValue;
    }
    _notiLabel.hidden = numberOfNotifications==0;
}
@end
