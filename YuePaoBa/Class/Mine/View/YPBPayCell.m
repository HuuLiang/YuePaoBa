//
//  YPBPayCell.m
//  YuePaoBa
//
//  Created by Liang on 16/3/15.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBPayCell.h"
#import "Masonry.h"

@implementation YPBPayCell

- (void)addSubiews {
//    _backgroundImage = [[UIImageView alloc] init];
//    [self addSubview:_backgroundImage];
    self.backgroundColor = [UIColor colorWithHexString:@"fffffd"];
//    self.accessoryType = UITableViewCellAccessoryNone;
    
    _priceLabel = [[UILabel alloc] init];
    [self addSubview:_priceLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.textColor = [UIColor redColor];
    _detailLabel.font = [UIFont systemFontOfSize:14];
//    _detailLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_detailLabel];
    
    _payButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _payButton.backgroundColor = [UIColor colorWithHexString:@"#ee8188"];
    _payButton.layer.cornerRadius = 5;
    [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _payButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    [self addSubview:_payButton];
}

- (void)setCellInfoWithMonth:(NSString *)monthInfo {
    [self addSubiews];
    
    YPBSystemConfig *systemConfig = [YPBSystemConfig sharedConfig];
    NSUInteger price1Month = ((NSString *)systemConfig.vipPointDictionary[@"1"]).integerValue;
    NSUInteger price3Month = ((NSString *)systemConfig.vipPointDictionary[@"3"]).integerValue;
    DLog("%lu %lu",(unsigned long)price1Month,(unsigned long)price3Month);
    
    if ([monthInfo isEqualToString:@"one"]) {
//        _backgroundImage.image = [UIImage imageNamed:@"pay_153-2"];
        _priceLabel.text = [NSString stringWithFormat:@"%i元/每月",price1Month/100];
        _detailLabel.text = @"";
//        [_payButton setTitle:[NSString stringWithFormat:@"%lu元",price1Month/100] forState:UIControlStateNormal];
       [_payButton setTitle:@"开通" forState:UIControlStateNormal];
    } else if ([monthInfo isEqualToString:@"three"]) {
//        _backgroundImage.image = [UIImage imageNamed:@"pay_153-1"];
        _priceLabel.text = [NSString stringWithFormat:@"%i元/季度",price3Month/100];
        _detailLabel.text = @"返100元话费";
//        [_payButton setTitle:[NSString stringWithFormat:@"%lu元",price3Month/
//                              100] forState:UIControlStateNormal];
        [_payButton setTitle:@"开通" forState:UIControlStateNormal];
    }
    if ([YPBUser currentUser].isVip) {
        [_payButton setTitle:@"续费" forState:UIControlStateNormal];
    }
    
    [self LayoutSubviews];
}

- (void)LayoutSubviews {
    {
//        [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.mas_centerY);
//            make.left.equalTo(self).offset(10);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_HEIGHT/12, SCREEN_HEIGHT/12));
//        }];
        
//        if ([_detailLabel.text isEqualToString:@""]) {
//            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(_backgroundImage.mas_right).offset(10);
//                make.centerY.equalTo(self.mas_centerY);
//                make.size.mas_equalTo(CGSizeMake(160, 20));
//            }];
//        } else {
//            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(_backgroundImage.mas_right).offset(10);
//                make.bottom.equalTo(self.mas_centerY);
//                make.size.mas_equalTo(CGSizeMake(160, 20));
//            }];
//        }
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH/20);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100, SCREEN_HEIGHT/30));
        }];
    
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_priceLabel.mas_right).offset(SCREEN_WIDTH/15);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(160, 20));
        }];
        
        [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/5, SCREEN_HEIGHT/18));
        }];
    }
}


@end
