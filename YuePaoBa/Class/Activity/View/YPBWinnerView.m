//
//  YPBWinnerView.m
//  YuePaoBa
//
//  Created by Liang on 16/8/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBWinnerView.h"

@interface YPBWinnerView ()
{
    UIImageView *_bgImgV;
    
    UILabel *_timeLabel;
    
    UILabel *_blessLabel;
}
@end

@implementation YPBWinnerView

- (instancetype)initWithType:(YPBLuckyType)type
{
    self = [super init];
    if (self) {
        
        _bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_winbg_icon"]];
        _bgImgV.contentMode = UIViewContentModeScaleToFill;
        _bgImgV.userInteractionEnabled = YES;
        [self addSubview:_bgImgV];
        
        _closeImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_winclose_icon"]];
        _closeImgV.userInteractionEnabled = YES;
        [_bgImgV addSubview:_closeImgV];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor colorWithHexString:@"#ffe001"];
        _timeLabel.font = [UIFont systemFontOfSize:kWidth(50)];
        [_bgImgV addSubview:_timeLabel];
        
        if (type == YPBLuckyTypeMonth) {
            _timeLabel.text = @"一个月";
        } else if (type == YPBLuckyTypeSeason) {
            _timeLabel.text = @"一季度";
        } else if (type == YPBLuckyTypeYear) {
            _timeLabel.text = @"一年";
        }
        
        UILabel *_detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [UIColor colorWithHexString:@"ffe001"];
        _detailLabel.font = [UIFont systemFontOfSize:kWidth(32)];
        _detailLabel.text = @"VIP会员";
        [_bgImgV addSubview:_detailLabel];
        
        _blessLabel = [[UILabel alloc] init];
        _blessLabel.textAlignment = NSTextAlignmentCenter;
        _blessLabel.textColor = [UIColor colorWithHexString:@"#362e2b"];
        _blessLabel.font = [UIFont systemFontOfSize:kWidth(36)];
        _blessLabel.text = @"恭喜您抽中";
        [_bgImgV addSubview:_blessLabel];
        
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _repeatBtn.layer.cornerRadius = kWidth(10);
        _repeatBtn.layer.masksToBounds = YES;
        _repeatBtn.backgroundColor = [UIColor colorWithHexString:@"ffde00"];
        [_repeatBtn setTitle:@"再抽一次" forState:UIControlStateNormal];
        [_repeatBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _repeatBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(34)];
        [self addSubview:_repeatBtn];
        
        {
            [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.centerX.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(468), kWidth(291)));
            }];
            
            [_closeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bgImgV).offset(kWidth(7));
                make.right.equalTo(_bgImgV.mas_right).offset(-kWidth(7));
                make.size.mas_equalTo(CGSizeMake(kWidth(20), kWidth(20)));
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_bgImgV);
                make.top.equalTo(_bgImgV).offset(kWidth(92));
                make.height.equalTo(@(kWidth(50)));
            }];
            
            [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_bgImgV);
                make.top.equalTo(_timeLabel.mas_bottom).offset(kWidth(14));
                make.height.mas_equalTo(kWidth(32));
            }];
            
            [_blessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_bgImgV);
                make.top.equalTo(_detailLabel.mas_bottom).offset(kWidth(30));
                make.height.mas_equalTo(kWidth(36));
            }];
            
            [_repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_bgImgV.mas_bottom).offset(kWidth(40));
                make.size.mas_equalTo(CGSizeMake(kWidth(360), kWidth(78)));
            }];
        }
    }
    return self;
}

@end
