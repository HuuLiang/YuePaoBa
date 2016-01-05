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
    UILabel *_likeLabel;
    UILabel *_detailLabel;
    
    UIButton *_dateButton;
    UIImageView *_levelIcon;
}
@end

@implementation YPBVIPCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
        {
            [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self).insets(UIEdgeInsetsMake(15, 15, 15, 15));
            }];
        }
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_border"]];
        [_containerView addSubview:backgroundView];
        {
            [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_containerView);
            }];
        }
        
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.layer.cornerRadius = 5;
        _thumbImageView.layer.masksToBounds = YES;
        [_containerView addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_containerView);
                make.height.equalTo(_containerView).offset(-20);
                make.width.equalTo(_thumbImageView.mas_height);
                make.left.equalTo(_containerView).offset(10);
            }];
        }
        
        _nicknameLabel = [[UILabel alloc] init];
        //_nicknameLabel.font = [UIFont systemFontOfSize:16.];
        [_containerView addSubview:_nicknameLabel];
        {
            [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_thumbImageView.mas_right).offset(15);
                make.right.equalTo(_containerView).offset(-15);
                make.top.equalTo(_thumbImageView).offset(5);
            }];
        }
        
        _genderIcon = [[UIImageView alloc] init];
        [_containerView addSubview:_genderIcon];
        {
            [_genderIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_nicknameLabel);
                make.top.equalTo(_nicknameLabel.mas_bottom).offset(5);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
        }
        
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.font = [UIFont systemFontOfSize:14];
        _ageLabel.textColor = kDefaultTextColor;
        [_containerView addSubview:_ageLabel];
        {
            [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_genderIcon.mas_right).offset(5);
                make.centerY.equalTo(_genderIcon);
            }];
        }
        
        UIImageView *likeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like_icon"]];
        [_containerView addSubview:likeIcon];
        {
            [likeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_ageLabel.mas_right).offset(15);
                make.centerY.equalTo(_ageLabel);
                make.size.mas_equalTo(CGSizeMake(15, 15));
            }];
        }
        
        _likeLabel = [[UILabel alloc] init];
        _likeLabel.font = [UIFont systemFontOfSize:14.];
        _likeLabel.textColor = kDefaultTextColor;
        [_containerView addSubview:_likeLabel];
        {
            [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(likeIcon.mas_right).offset(5);
                make.centerY.equalTo(likeIcon);
            }];
        }
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14.];
        _detailLabel.textColor = kDefaultTextColor;
        _detailLabel.numberOfLines = 4;
        [_containerView addSubview:_detailLabel];
        {
            [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_genderIcon);
                make.top.equalTo(_genderIcon.mas_bottom).offset(5);
                make.right.equalTo(_containerView).offset(-15);
            }];
        }
        
        UIView *buttonLayoutView = [[UIView alloc] init];
        [_containerView addSubview:buttonLayoutView];
        {
            [buttonLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_detailLabel.mas_bottom);
                make.left.equalTo(_thumbImageView.mas_right).offset(15);
                make.right.equalTo(_containerView).offset(-15);
                make.bottom.equalTo(_containerView);
            }];
        }
        
        _dateButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageNamed:@"date_normal_button"];
        [_dateButton setImage:image forState:UIControlStateNormal];
        [_dateButton setImage:[UIImage imageNamed:@"date_highlight_button"] forState:UIControlStateHighlighted];
        [buttonLayoutView addSubview:_dateButton];
        {
            [_dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(buttonLayoutView);
                make.width.equalTo(buttonLayoutView).multipliedBy(0.8);
                make.height.equalTo(_dateButton.mas_width).multipliedBy(image.size.height/image.size.width);
            }];
        }
        
        @weakify(self);
        [_dateButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock1(self.dateAction, sender);
        } forControlEvents:UIControlEventTouchUpInside];
        
        _levelIcon = [[UIImageView alloc] init];
        _levelIcon.hidden = YES;
        [self addSubview:_levelIcon];
        {
            [_levelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self);
                make.height.equalTo(self).multipliedBy(0.3);
                make.width.equalTo(_levelIcon.mas_height).multipliedBy(116./107.);
            }];
        }
    }
    return self;
}

- (void)layoutSubviews {
    _nicknameLabel.font = [UIFont systemFontOfSize:MIN(16.,CGRectGetHeight(_thumbImageView.frame)*0.1)];
    _detailLabel.font = [UIFont systemFontOfSize:_nicknameLabel.font.pointSize * 0.9];
    [super layoutSubviews];
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
