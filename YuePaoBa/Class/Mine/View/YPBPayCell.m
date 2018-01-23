//
//  YPBPayCell.m
//  YuePaoBa
//
//  Created by Liang on 16/3/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPayCell.h"
#import "Masonry.h"
#import "YPBApplePay.h"
#import "YPBSystemConfig.h"

@implementation YPBPayCell

- (void)addSubiews {
    _backgroundImage = [[UIImageView alloc] init];
    [self addSubview:_backgroundImage];
    
    _priceLabel = [[UILabel alloc] init];
    [self addSubview:_priceLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.textColor = [UIColor grayColor];
    _detailLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_detailLabel];
    
    _payButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _payButton.backgroundColor = [UIColor colorWithRed:66/255.0 green:217/255.0 blue:101/255.0 alpha:1.0];
    _payButton.layer.cornerRadius = 5;
    [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _payButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_payButton];
}

- (void)setCellInfoWithPrice:(NSString*)price Month:(NSString *)monthInfo {
    [self addSubiews];
    DLog("--price--%@-",price);
    _monthTime = monthInfo;
    
    if ([monthInfo isEqualToString:@"one"]) {
        _backgroundImage.image = [UIImage imageNamed:@"pay_153-2"];
        _priceLabel.text = @"1个月";
        _detailLabel.text = @"";
    } else if ([monthInfo isEqualToString:@"three"]) {
        _backgroundImage.image = [UIImage imageNamed:@"pay_153-1"];
        _priceLabel.text = @"3个月";
        _detailLabel.text = @"限时特惠:买3送3";
        if ([YPBUtil isApplePay]) {
            _detailLabel.text = @"限时特惠:优惠50%";
        }
    }
     [_payButton setTitle:[NSString stringWithFormat:@"%@元",price] forState:UIControlStateNormal];
    
    [self LayoutSubviews];
}

- (void)LayoutSubviews {
    {
        [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(SCREEN_HEIGHT/12, SCREEN_HEIGHT/12));
        }];
        
        if ([_detailLabel.text isEqualToString:@""]) {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_backgroundImage.mas_right).offset(10);
                make.centerY.equalTo(self.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(160, 20));
            }];
        } else {
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_backgroundImage.mas_right).offset(10);
                make.bottom.equalTo(self.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(160, 20));
            }];
        }
    
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundImage.mas_right).offset(10);
            make.top.equalTo(_priceLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(160, 20));
        }];
        
        [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/6, SCREEN_HEIGHT/18));
        }];
    }
}


@end
