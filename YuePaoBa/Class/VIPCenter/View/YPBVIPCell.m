//
//  YPBVIPCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBVIPCell.h"
#import "YPBLikeButton.h"

@interface YPBVIPCell ()
{
    UIView *_containerView;
    UIImageView *_thumbImageView;
    UILabel *_nicknameLabel;
    UIImageView *_vipIcon;
    UIImageView *_wechatIcon;
    UILabel *_verifyLabel;
    UIImageView *_verifyImageView;
    UILabel *_detailLabel;
    
//    UIButton *_dateButton;
    UIImageView *_levelIcon;
    
    YPBLikeButton *_likeButton;
}
@end

@implementation YPBVIPCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _containerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_border"]];
        _containerView.userInteractionEnabled = YES;
        [self addSubview:_containerView];

        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.layer.cornerRadius = 5;
        _thumbImageView.layer.masksToBounds = YES;
        [_containerView addSubview:_thumbImageView];
        
        @weakify(self);
        _likeButton = [[YPBLikeButton alloc] initWithUserInteractionEnabled:YES];
        _likeButton.layer.cornerRadius = 4;
        _likeButton.layer.masksToBounds = YES;
        [_likeButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock1(self.likeAction, sender);
        } forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_likeButton];
        
        _nicknameLabel = [[UILabel alloc] init];
        [_containerView addSubview:_nicknameLabel];
        
        _vipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_icon"]];
        [_containerView addSubview:_vipIcon];
        
        _verifyLabel = [[UILabel alloc] init];
        _verifyLabel.textColor = [UIColor redColor];
        _verifyLabel.text = @"直播已认证";
        [_containerView addSubview:_verifyLabel];
        
        _verifyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fire_icon"]];
        [_containerView addSubview:_verifyImageView];

        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = kDefaultTextColor;
        _detailLabel.numberOfLines = 5;
        [_containerView addSubview:_detailLabel];
        
//        _dateButton = [[UIButton alloc] init];
//        UIImage *image = [UIImage imageNamed:@"date_normal_button"];
//        [_dateButton setImage:image forState:UIControlStateNormal];
//        [_dateButton setImage:[UIImage imageNamed:@"date_highlight_button"] forState:UIControlStateHighlighted];
//        [_containerView addSubview:_dateButton];
//
//        [_dateButton bk_addEventHandler:^(id sender) {
//            @strongify(self);
//            SafelyCallBlock1(self.dateAction, sender);
//        } forControlEvents:UIControlEventTouchUpInside];
        
        _levelIcon = [[UIImageView alloc] init];
        _levelIcon.hidden = YES;
        [self addSubview:_levelIcon];
    }
    return self;
}

- (void)dealloc {
    [_user removeObserver:self forKeyPath:NSStringFromSelector(@selector(isGreet))];
    [_user removeObserver:self forKeyPath:NSStringFromSelector(@selector(receiveGreetCount))];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _containerView.frame = CGRectInset(self.bounds, 15, 5);
    
    const CGFloat thumbHeight = _containerView.bounds.size.height - 20;
    const CGFloat thumbWidth = thumbHeight;
    const CGFloat thumbX = 10;
    const CGFloat thumbY = (_containerView.bounds.size.height - thumbHeight)/2;
    _thumbImageView.frame = CGRectMake(thumbX, thumbY, thumbWidth, thumbHeight);
    
    const CGFloat likeWidth = lround(CGRectGetWidth(_thumbImageView.frame)*0.2);
    const CGFloat likeHeight = lround(likeWidth * 1.2);
    const CGFloat likeX = CGRectGetMaxX(_thumbImageView.frame)-5-likeWidth;
    _likeButton.frame = CGRectMake(likeX, CGRectGetMinY(_thumbImageView.frame)+5, likeWidth, likeHeight);
    
    const CGFloat nicknameX = CGRectGetMaxX(_thumbImageView.frame) + 15;
    const CGFloat nicknameWidth = _containerView.bounds.size.width - 15 - nicknameX;
    const CGFloat nicknameHeight = MIN(16.,CGRectGetHeight(_thumbImageView.frame)*0.1);
    const CGFloat nicknameY = thumbY + 5;
    _nicknameLabel.frame = CGRectMake(nicknameX, nicknameY, nicknameWidth, nicknameHeight);
    _nicknameLabel.font = [UIFont systemFontOfSize:nicknameHeight];
    
    const CGFloat defaultIconSize = 25;
    //CGRect iconFrame = CGRectMake(nicknameX, CGRectGetMaxY(_nicknameLabel.frame)+5, defaultIconSize, defaultIconSize);
    _vipIcon.frame = CGRectMake(nicknameX, CGRectGetMaxY(_nicknameLabel.frame)+5, defaultIconSize, defaultIconSize * _vipIcon.image.size.height / _vipIcon.image.size.width);
    
    if (_wechatIcon && !_wechatIcon.hidden) {
        _wechatIcon.frame = CGRectMake(CGRectGetMaxX(_vipIcon.frame)+2, CGRectGetMaxY(_vipIcon.frame)-defaultIconSize, defaultIconSize, defaultIconSize);
    }
    
    _verifyLabel.font = [UIFont systemFontOfSize:_nicknameLabel.font.pointSize * 0.8];
    CGSize textSize = [_verifyLabel.text sizeWithAttributes:@{NSFontAttributeName:_verifyLabel.font}];
    _verifyLabel.frame = CGRectMake(nicknameX, CGRectGetMaxY(_vipIcon.frame)+15, textSize.width, textSize.height);
    
    const CGFloat verifyImageWidth = 20;
    const CGFloat verifyImageHeight = verifyImageWidth * _verifyImageView.image.size.height / _verifyImageView.image.size.width;
    _verifyImageView.frame = CGRectMake(CGRectGetMaxX(_verifyLabel.frame)+5, CGRectGetMaxY(_verifyLabel.frame)-verifyImageHeight, verifyImageWidth, verifyImageHeight);
    
    _detailLabel.font = _verifyLabel.font;
    const CGFloat detailX = _nicknameLabel.frame.origin.x;
    const CGFloat detailY = CGRectGetMaxY(_verifyLabel.frame)+5;
    const CGFloat detailWidth = _nicknameLabel.frame.size.width;
    const CGFloat detailHeight = _detailLabel.font.pointSize;
    _detailLabel.frame = CGRectMake(detailX, detailY, detailWidth, detailHeight);
    
//    const CGSize dateImageSize = [_dateButton imageForState:UIControlStateNormal].size;
//    const CGFloat dateWidth = _nicknameLabel.frame.size.width * 0.8;
//    const CGFloat dateHeight = dateWidth * dateImageSize.height / dateImageSize.width;
//    const CGFloat dateX = _nicknameLabel.frame.origin.x + (_nicknameLabel.frame.size.width-dateWidth)/2;
//    const CGFloat dateY = CGRectGetMaxY(_detailLabel.frame) + (CGRectGetMaxY(_containerView.bounds)-5-CGRectGetMaxY(_detailLabel.frame)-dateHeight)/2;
//    _dateButton.frame = CGRectMake(dateX, dateY, dateWidth, dateHeight);

    const CGFloat levelHeight = self.bounds.size.height*0.3;
    const CGFloat levelWidth = levelHeight * (116./107.);
    _levelIcon.frame = CGRectMake(0, 0, levelWidth, levelHeight);
}

- (void)setUser:(YPBUser *)user {
    [_user removeObserver:self forKeyPath:NSStringFromSelector(@selector(isGreet))];
    [_user removeObserver:self forKeyPath:NSStringFromSelector(@selector(receiveGreetCount))];
    _user = user;
    [_user addObserver:self forKeyPath:NSStringFromSelector(@selector(isGreet)) options:NSKeyValueObservingOptionNew context:nil];
    [_user addObserver:self forKeyPath:NSStringFromSelector(@selector(receiveGreetCount)) options:NSKeyValueObservingOptionNew context:nil];
    
    [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:user.logoUrl]];
    _nicknameLabel.text = user.nickName;
    
    if (user.weixinNum.length > 0 && !_wechatIcon) {
        _wechatIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wechat_icon"]];
        [_containerView addSubview:_wechatIcon];
    }
    _wechatIcon.hidden = user.weixinNum.length==0;
    
    _likeButton.numberOfLikes = user.receiveGreetCount.unsignedIntegerValue;
    _likeButton.selected = user.isGreet;
    
    _detailLabel.text = [NSString stringWithFormat:@"交友目的：%@",user.purpose.length > 0 ?user.purpose: @"保密"];
}

- (void)setLevel:(NSUInteger)level {
    _level = level;
    
    if (level > 3) {
        _levelIcon.hidden = YES;
        _levelIcon.image = nil;
    } else {
        NSString *levelImage = [NSString stringWithFormat:@"vip_level%ld", level];
        _levelIcon.image = [UIImage imageNamed:levelImage];
        _levelIcon.hidden = NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isGreet"]) {
        NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        _likeButton.selected = newValue.boolValue;
    } else if ([keyPath isEqualToString:@"receiveGreetCount"]) {
        NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
        _likeButton.numberOfLikes = newValue.unsignedIntegerValue;
    }
}
@end
