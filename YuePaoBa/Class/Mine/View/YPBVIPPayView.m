//
//  YPBVIPPayView.m
//  YuePaoBa
//
//  Created by Liang on 16/7/16.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBVIPPayView.h"
#import "YPBSystemConfig.h"

@interface YPBVIPPayView ()
{
    UITableViewCell *_payYearCell;
    UITableViewCell *_payMonthsCell;
    
    UIButton        *_monthBtn;
    UIButton        *_seasonBtn;
    UIButton        *_yearBtn;
    
    NSInteger        price;
    
    NSUInteger       _month;
}
@property (nonatomic,retain) YPBSystemConfig *payConfig;
@end

@implementation YPBVIPPayView
DefineLazyPropertyInitialization(YPBSystemConfig, payConfig)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f6f7ec"];
        
        self.payConfig = [YPBSystemConfig sharedConfig];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#ff6633"];
        [self addSubview:lineView];
        
        UILabel *paylabel = [[UILabel alloc] init];
        paylabel.textColor = [UIColor colorWithHexString:@"#333333"];
        paylabel.backgroundColor = [UIColor colorWithHexString:@"fffffd"];
        paylabel.text = @"  选择钻石VIP套餐";
        paylabel.font = [UIFont systemFontOfSize:kScreenHeight * 24 / 1334.];
        [self addSubview:paylabel];
        
        [self initPayYearCell];
        
        [self initPayMonthsCell];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
        [self addSubview:view];
        
        UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:[YPBUtil isVIP] ? @"vip_payment_button_isvip" :@"vip_payment_button_pay"];
        [payBtn setBackgroundImage:image forState:UIControlStateNormal];
        [payBtn setBackgroundImage:image forState:UIControlStateSelected];
        [view addSubview:payBtn];
        
        {
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kScreenWidth * 10 / 750.);
                make.top.equalTo(self).offset(2);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 4 / 750., kScreenHeight * 30 / 1334.));
            }];
            
            [paylabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lineView.mas_right).offset(2);
                make.right.equalTo(self);
                make.centerY.equalTo(lineView.mas_centerY);
                make.height.equalTo(@(kScreenHeight * 30 / 1334.));
            }];
            
            [_payYearCell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lineView.mas_bottom);
                make.left.right.equalTo(self);
                make.height.equalTo(@(SCREEN_HEIGHT/14));
            }];
            
            [_payMonthsCell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_payYearCell.mas_bottom).offset(-1);
                make.left.right.equalTo(self);
                make.height.equalTo(@(SCREEN_HEIGHT/14));
            }];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_payMonthsCell.mas_bottom);
                make.left.right.bottom.equalTo(self);
            }];
            
            [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(view);
                make.height.equalTo(@(SCREEN_HEIGHT/14*0.7));
                make.width.equalTo(payBtn.mas_height).multipliedBy(image.size.width/image.size.height);
            }];
            
        }
        
        _yearBtn.selected = YES;
        _seasonBtn.selected = NO;
        _monthBtn.selected = NO;
        
        price = [_payConfig.vipPointDictionary[@"12"] integerValue];
        _month = 12;
        
        
        [payBtn bk_addEventHandler:^(id sender) {
            _payWithInfoBlock(price,_month);
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)initPayYearCell {
    _payYearCell = [[UITableViewCell alloc] init];
    _payYearCell.layer.borderWidth = 1.0f;
    _payYearCell.layer.borderColor = [UIColor colorWithHexString:@"#f6f7ec"].CGColor;
    [self addSubview:_payYearCell];
    _payYearCell.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    _payYearCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _yearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_yearBtn setBackgroundImage:[UIImage imageNamed:@"message_choose"] forState:UIControlStateNormal];
    [_yearBtn setBackgroundImage:[UIImage imageNamed:@"message_choose_done"] forState:UIControlStateSelected];
    _yearBtn.layer.cornerRadius = 12.5;
    _yearBtn.layer.masksToBounds = YES;
    [_payYearCell addSubview:_yearBtn];
    
    UILabel *yearLabel = [[UILabel alloc] init];
    yearLabel.backgroundColor = [UIColor clearColor];
    yearLabel.font = [UIFont systemFontOfSize:kScreenWidth * 32 / 750.];
    yearLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    NSString *yearString = [NSString stringWithFormat:@"%ld元/年,返100元话费!!!",((NSString *)_payConfig.vipPointDictionary[@"12"]).integerValue/100];
    NSMutableAttributedString *yearAttributedStr = [[NSMutableAttributedString alloc] initWithString:yearString];
    NSRange yearRangge = [yearString rangeOfString:[NSString stringWithFormat:@"返100元话费!!!"]];
    if (yearRangge.location != NSNotFound) {
        [yearAttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor redColor] range:yearRangge];
    }
    yearLabel.attributedText = yearAttributedStr;
    [_payYearCell addSubview:yearLabel];
    
    
    
    [_yearBtn bk_whenTapped:^{
        if (!_yearBtn.selected) {
            _yearBtn.selected = YES;
            _seasonBtn.selected = NO;
            _monthBtn.selected = NO;
            price = [_payConfig.vipPointDictionary[@"12"] integerValue];
            _month = 12;
        }
    }];
    
    {
        [_yearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_payYearCell).offset(15);
            make.centerY.equalTo(_payYearCell);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        [yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_payYearCell);
            make.left.equalTo(_yearBtn.mas_right).offset(5);
            make.height.mas_equalTo(80);
            make.right.equalTo(_payYearCell).offset(-5);
        }];
    }
    
}

- (void)initPayMonthsCell {
    _payMonthsCell = [[UITableViewCell alloc] init];
    [self addSubview:_payMonthsCell];
    _payMonthsCell.layer.borderWidth = 1.0f;
    _payMonthsCell.layer.borderColor = [UIColor colorWithHexString:@"#f6f7ec"].CGColor;
    _payMonthsCell.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    _payMonthsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _seasonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seasonBtn setBackgroundImage:[UIImage imageNamed:@"message_choose"] forState:UIControlStateNormal];
    [_seasonBtn setBackgroundImage:[UIImage imageNamed:@"message_choose_done"] forState:UIControlStateSelected];
    _seasonBtn.layer.cornerRadius = 12.5;
    _seasonBtn.layer.masksToBounds = YES;
    _seasonBtn.selected = YES;
    [_payMonthsCell addSubview:_seasonBtn];
    
    _monthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_monthBtn setBackgroundImage:[UIImage imageNamed:@"message_choose"] forState:UIControlStateNormal];
    [_monthBtn setBackgroundImage:[UIImage imageNamed:@"message_choose_done"] forState:UIControlStateSelected];
    _monthBtn.layer.cornerRadius = 12.5;
    _monthBtn.layer.masksToBounds = YES;
    _monthBtn.selected = NO;
    [_payMonthsCell addSubview:_monthBtn];
    
    price = [_payConfig.vipPointDictionary[@"3"] integerValue];
    
    [_seasonBtn bk_whenTapped:^{
        if (!_seasonBtn.selected) {
            _yearBtn.selected = NO;
            _seasonBtn.selected = YES;
            _monthBtn.selected = NO;
            price = [_payConfig.vipPointDictionary[@"3"] integerValue];
            _month = 3;
        }
    }];
    
    
    [_monthBtn bk_whenTapped:^{
        if (!_monthBtn.selected) {
            _yearBtn.selected = NO;
            _seasonBtn.selected = NO;
            _monthBtn.selected = YES;
            price = [_payConfig.vipPointDictionary[@"1"] integerValue];
            _month = 1;
        }
    }];
    
    UILabel *seasonLabel = [[UILabel alloc] init];
    seasonLabel.backgroundColor = [UIColor clearColor];
    seasonLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    seasonLabel.font = [UIFont systemFontOfSize:kScreenWidth * 28 / 750.];
    seasonLabel.numberOfLines = 0;
    NSString *seasonString = [NSString stringWithFormat:@"%ld元/季度\n返20元话费",((NSString *)_payConfig.vipPointDictionary[@"3"]).integerValue/100];
    NSMutableAttributedString *seasonAttributedStr = [[NSMutableAttributedString alloc] initWithString:seasonString];
    NSRange seasonRangge = [seasonString rangeOfString:[NSString stringWithFormat:@"返20元话费"]];
    if (seasonRangge.location != NSNotFound) {
        [seasonAttributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                             NSFontAttributeName:[UIFont systemFontOfSize:kScreenWidth * 24 / 750.]} range:seasonRangge
         ];
    }
    seasonLabel.attributedText = seasonAttributedStr;
    [_payMonthsCell addSubview:seasonLabel];
    
    UILabel *monthLabel = [[UILabel alloc] init];
    monthLabel.backgroundColor = [UIColor clearColor];
    monthLabel.font = [UIFont systemFontOfSize:kScreenWidth * 28 / 750.];
    monthLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    monthLabel.numberOfLines = 0;
    NSString *monthString = [NSString stringWithFormat:@"%ld元/月\n返10元话费",((NSString *)_payConfig.vipPointDictionary[@"1"]).integerValue/100];
    NSMutableAttributedString *monthAttributedStr = [[NSMutableAttributedString alloc] initWithString:monthString];
    NSRange monthRangge = [monthString rangeOfString:[NSString stringWithFormat:@"返10元话费"]];
    if (monthRangge.location != NSNotFound) {
        [monthAttributedStr addAttribute:NSFontAttributeName
                                   value:[UIFont systemFontOfSize:kScreenWidth * 24 / 750.] range:monthRangge];
    }
    monthLabel.attributedText = monthAttributedStr;
    [_payMonthsCell addSubview:monthLabel];
    
    
    {
        [_seasonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_payMonthsCell).offset(15);
            make.centerY.equalTo(_payMonthsCell);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        [seasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_payMonthsCell);
            make.left.equalTo(_seasonBtn.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(80, _payMonthsCell.frame.size.height*0.8));
        }];
        
        [monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_payMonthsCell);
            make.right.equalTo(_payMonthsCell.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(80, _payMonthsCell.frame.size.height*0.8));
        }];
        
        [_monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_payMonthsCell);
            make.right.equalTo(monthLabel.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
    
}


@end
