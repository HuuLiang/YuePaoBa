//
//  YPBRecommendCell.m
//  YuePaoBa
//
//  Created by Liang on 16/5/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBRecommendCell.h"

@interface YPBRecommendCell ()
{
    UIImageView *_bgImg;
    UILabel *_detail;
}

@end

@implementation YPBRecommendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _bgImg = [[UIImageView alloc] init];
        _bgImg.layer.cornerRadius = frame.size.width/2;
        _bgImg.layer.borderColor = [UIColor colorWithHexString:@"#ff9da5"].CGColor;
        _bgImg.layer.borderWidth = 4;
        _bgImg.layer.masksToBounds = YES;
        [self addSubview:_bgImg];

        _detail = [[UILabel alloc] init];
        _detail.backgroundColor = [UIColor clearColor];
        _detail.textColor = [UIColor whiteColor];
        _detail.font = [UIFont systemFontOfSize:11.];
        _detail.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_detail];
        
        _btn = [UIButton buttonWithType:UIButtonTypeSystem];
        _btn.layer.cornerRadius = self.frame.size.width/8;
        _btn.layer.masksToBounds = YES;
        [_btn setBackgroundImage:[UIImage imageNamed:@"home_choose"] forState:UIControlStateNormal];
        _btn.hidden = NO;
        _btn.selected =  YES;
        [self addSubview:_btn];
        
        [self layoutSubview];
    }
    return self;
}

- (void)layoutSubview {
    {
        [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(self.mas_width);
        }];
        
        [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self);
            make.top.equalTo(_bgImg.mas_bottom);
            make.width.equalTo(self.mas_width).multipliedBy(1.2);
        }];
        
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bgImg.mas_right).offset(-self.frame.size.width/6);
            make.centerY.equalTo(_bgImg.mas_bottom).offset(-self.frame.size.width/6);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width/4, self.frame.size.width/4));
        }];
    }
}

- (void)setUser:(YPBUser *)user {
    [_bgImg sd_setImageWithURL:[NSURL URLWithString:user.logoUrl]];
    _detail.text = [NSString stringWithFormat:@"%@岁  %@cm",user.age,user.height];
}

- (void)setBtnState {
    _btn.selected = !_btn.selected;
    _btn.hidden = !_btn.selected;
}

@end
