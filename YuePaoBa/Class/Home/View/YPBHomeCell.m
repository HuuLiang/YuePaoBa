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
        
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [self addSubview:_footerView];
        
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.textColor = [UIColor whiteColor];
        [_footerView addSubview:_nicknameLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [_footerView addSubview:_detailLabel];
        
        _likeButton = [[YPBLikeButton alloc] initWithUserInteractionEnabled:NO];
        [self addSubview:_likeButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _thumbImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    const CGFloat footerViewHeight = lround(self.bounds.size.height*0.12);
    _footerView.frame = CGRectMake(0, self.bounds.size.height-footerViewHeight, self.bounds.size.width, footerViewHeight);
    
    const CGFloat nicknameX = 5;
    const CGFloat nicknameWidth = self.bounds.size.width / 2 - nicknameX;
    const CGFloat nicknameHeight = lround(footerViewHeight * 0.8);
    _nicknameLabel.frame = CGRectMake(nicknameX, (footerViewHeight-nicknameHeight)/2, nicknameWidth, nicknameHeight);
    _nicknameLabel.font = [UIFont boldSystemFontOfSize:footerViewHeight * 0.5];
    
    const CGFloat detailX = CGRectGetMaxX(_nicknameLabel.frame);
    const CGFloat detailY = CGRectGetMinY(_nicknameLabel.frame);
    const CGFloat detailWidth = CGRectGetMaxX(_footerView.bounds)-5-detailX;
    _detailLabel.frame = CGRectMake(detailX, detailY, detailWidth, CGRectGetHeight(_nicknameLabel.frame));
    _detailLabel.font = _nicknameLabel.font;
    
    const CGFloat likeWidth = lround(CGRectGetWidth(self.bounds)*0.2);
    const CGFloat likeHeight = lround(likeWidth * 1.2);
    const CGFloat likeX = CGRectGetWidth(self.bounds)-5-likeWidth;
    _likeButton.frame = CGRectMake(likeX, 5, likeWidth, likeHeight);
}

- (void)setUser:(YPBUser *)user {
    _user = user;
    
    [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:user.logoUrl]];
    _nicknameLabel.text = user.nickName;
    _detailLabel.text = [NSString stringWithFormat:@"%@cm/%@岁", user.height, user.age];
    _likeButton.numberOfLikes = user.receiveGreetCount.unsignedIntegerValue;
}
@end
