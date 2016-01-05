//
//  YPBHomeCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/22.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBHomeCell.h"
#import "YPBLikeButton.h"

@interface YPBHomeCell ()
{
    UIImageView *_thumbImageView;
    
    UIView *_footerView;
    UILabel *_nicknameLabel;
    UILabel *_detailLabel;
    
    YPBLikeButton *_likeButton;
}
@end

@implementation YPBHomeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _thumbImageView = [[UIImageView alloc] init];
        [self addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self addSubview:_footerView];
        {
            [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.12);
            }];
        }
        
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.textColor = [UIColor whiteColor];
        [_footerView addSubview:_nicknameLabel];
        {
            [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_footerView).offset(5);
                make.right.equalTo(_footerView.mas_centerX);
                make.centerY.equalTo(_footerView);
            }];
        }
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [_footerView addSubview:_detailLabel];
        {
            [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_footerView.mas_centerX);
                make.right.equalTo(_footerView).offset(-5);
                make.centerY.equalTo(_footerView);
            }];
        }
        
        _likeButton = [[YPBLikeButton alloc] initWithUserInteractionEnabled:NO];
        [self addSubview:_likeButton];
        {
            [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.width.equalTo(self).multipliedBy(0.2);
                make.height.equalTo(_likeButton.mas_width).multipliedBy(1.2);
            }];
        }
    }
    return self;
}

- (void)setUser:(YPBUser *)user {
    _user = user;
    
    [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:user.logoUrl]];
    _nicknameLabel.text = user.nickName;
    _detailLabel.text = [NSString stringWithFormat:@"%@cm/%@岁", user.height, user.age];
    _likeButton.numberOfLikes = user.receiveGreetCount.unsignedIntegerValue;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat footerHeight = CGRectGetHeight(_footerView.frame);
    if (footerHeight > 0) {
        _nicknameLabel.font = [UIFont boldSystemFontOfSize:footerHeight*0.5];
        _detailLabel.font = [UIFont boldSystemFontOfSize:footerHeight*0.5];
    }
}
@end
