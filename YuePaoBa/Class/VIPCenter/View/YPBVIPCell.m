//
//  YPBVIPCell.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/1.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBVIPCell.h"

@interface YPBVIPCell ()
{
    UIView *_containerView;
    UIImageView *_thumbImageView;
    UILabel *_nicknameLabel;
    UIImageView *_genderIcon;
    UILabel *_ageLabel;
    UIImageView *_likeIcon;
    UILabel *_likeLabel;
    UILabel *_detailLabel;
    
    UIButton *_dateButton;
    UIImageView *_levelIcon;
}
@property (nonatomic,readonly) CGSize maximumAgeLabelSize;
@end

@implementation YPBVIPCell
@synthesize maximumAgeLabelSize = _maximumAgeLabelSize;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _containerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_border"]];
        [self addSubview:_containerView];

        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.layer.cornerRadius = 5;
        _thumbImageView.layer.masksToBounds = YES;
        [_containerView addSubview:_thumbImageView];
        
        _nicknameLabel = [[UILabel alloc] init];
        [_containerView addSubview:_nicknameLabel];
        
        _genderIcon = [[UIImageView alloc] init];
        [_containerView addSubview:_genderIcon];
        
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.font = [UIFont systemFontOfSize:14];
        _ageLabel.textColor = kDefaultTextColor;
        [_containerView addSubview:_ageLabel];
        
        _likeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like_icon"]];
        [_containerView addSubview:_likeIcon];
        
        _likeLabel = [[UILabel alloc] init];
        _likeLabel.font = [UIFont systemFontOfSize:14.];
        _likeLabel.textColor = kDefaultTextColor;
        [_containerView addSubview:_likeLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = kDefaultTextColor;
        _detailLabel.numberOfLines = 5;
        [_containerView addSubview:_detailLabel];
        
        _dateButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageNamed:@"date_normal_button"];
        [_dateButton setImage:image forState:UIControlStateNormal];
        [_dateButton setImage:[UIImage imageNamed:@"date_highlight_button"] forState:UIControlStateHighlighted];
        [_containerView addSubview:_dateButton];

        @weakify(self);
        [_dateButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock1(self.dateAction, sender);
        } forControlEvents:UIControlEventTouchUpInside];
        
        _levelIcon = [[UIImageView alloc] init];
        _levelIcon.hidden = YES;
        [self addSubview:_levelIcon];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _containerView.frame = CGRectInset(self.bounds, 15, 15);
    
    const CGFloat thumbHeight = _containerView.bounds.size.height - 20;
    const CGFloat thumbWidth = thumbHeight;
    const CGFloat thumbX = 10;
    const CGFloat thumbY = (_containerView.bounds.size.height - thumbHeight)/2;
    _thumbImageView.frame = CGRectMake(thumbX, thumbY, thumbWidth, thumbHeight);
    
    const CGFloat nicknameX = CGRectGetMaxX(_thumbImageView.frame) + 15;
    const CGFloat nicknameWidth = _containerView.bounds.size.width - 15 - nicknameX;
    const CGFloat nicknameHeight = MIN(16.,CGRectGetHeight(_thumbImageView.frame)*0.1);
    const CGFloat nicknameY = thumbY + 5;
    _nicknameLabel.frame = CGRectMake(nicknameX, nicknameY, nicknameWidth, nicknameHeight);
    _nicknameLabel.font = [UIFont systemFontOfSize:nicknameHeight];
    
    _genderIcon.frame = CGRectMake(nicknameX, CGRectGetMaxY(_nicknameLabel.frame)+5, 15, 15);
    _ageLabel.frame = CGRectMake(CGRectGetMaxX(_genderIcon.frame)+5, _genderIcon.frame.origin.y,
                                 self.maximumAgeLabelSize.width, self.maximumAgeLabelSize.height);
    
    _likeIcon.frame = CGRectMake(CGRectGetMaxX(_ageLabel.frame)+15, _genderIcon.frame.origin.y, 15, 15);
    
    const CGFloat likeLabelX = CGRectGetMaxX(_likeIcon.frame)+5;
    _likeLabel.frame = CGRectMake(likeLabelX, _likeIcon.frame.origin.y,
                                  CGRectGetMaxX(_nicknameLabel.frame)-likeLabelX, _likeLabel.font.pointSize);

    const CGFloat levelHeight = self.bounds.size.height*0.3;
    const CGFloat levelWidth = levelHeight * (116./107.);
    _levelIcon.frame = CGRectMake(0, 0, levelWidth, levelHeight);
    
    const CGSize dateImageSize = [_dateButton imageForState:UIControlStateNormal].size;
    const CGFloat dateWidth = _nicknameLabel.frame.size.width * 0.8;
    const CGFloat dateHeight = dateWidth * dateImageSize.height / dateImageSize.width;
    const CGFloat dateX = _nicknameLabel.frame.origin.x + (_nicknameLabel.frame.size.width-dateWidth)/2;
    _dateButton.frame = CGRectMake(dateX, CGRectGetMaxY(_containerView.bounds)-dateHeight-5, dateWidth, dateHeight);
    
    const CGFloat detailX = _nicknameLabel.frame.origin.x;
    const CGFloat detailY = CGRectGetMaxY(_genderIcon.frame) + 5;
    const CGFloat detailWidth = _nicknameLabel.frame.size.width;
    const CGFloat detailHeight = CGRectGetMinY(_dateButton.frame) - detailY;
    _detailLabel.frame = CGRectMake(detailX, detailY, detailWidth, detailHeight);
    _detailLabel.font = [UIFont systemFontOfSize:_nicknameLabel.font.pointSize * 0.8];
}

- (CGSize)maximumAgeLabelSize {
    if (_maximumAgeLabelSize.width > 0 && _maximumAgeLabelSize.height > 0) {
        return _maximumAgeLabelSize;
    }
    
    NSString *maxAge = @"100";
    _maximumAgeLabelSize = [maxAge sizeWithAttributes:@{NSFontAttributeName:_ageLabel.font}];
    return _maximumAgeLabelSize;
}

- (void)setUser:(YPBUser *)user {
    _user = user;
    
    [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:user.logoUrl]];
    _nicknameLabel.text = user.nickName;
    _genderIcon.image = [UIImage imageNamed:user.gender==YPBUserGenderFemale?@"female_icon":@"male_icon"];
    _ageLabel.text = user.age.stringValue;
    _likeLabel.text = user.receiveGreetCount.stringValue ?: @"0";
    
    NSMutableString *details = [NSMutableString string];
    if (user.height) {
        [details appendFormat:@"身高：%@cm\n",user.height];
    }
    
    if (user.profession.length > 0) {
        [details appendFormat:@"职业：%@\n", user.profession];
    }
    
    if (user.bwh.length > 0) {
        [details appendFormat:@"身材：%@\n", user.bwh];
    }
    
    if (user.note.length > 0) {
        [details appendFormat:@"兴趣：%@\n", user.note];
    }
    _detailLabel.text = details;
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
@end
