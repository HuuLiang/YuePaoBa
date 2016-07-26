//
//  YPBActivityPayView.m
//  YuePaoBa
//
//  Created by Liang on 16/5/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBActivityPayView.h"
#import "YPBPaymentModel.h"
#import "YPBVIPPriviledgeViewController.h"
#import "YPBSystemConfig.h"

@interface YPBActivityPayView ()
{
    UIButton        *_closeBtn;
    UIImageView     *_bgImg;
    
    UITableViewCell *_payYearCell;
    UITableViewCell *_payMonthsCell;
    
    UITableViewCell *_wxPayCell;
    UITableViewCell *_aliPayCell;
    
    UIButton        *_monthBtn;
    UIButton        *_seasonBtn;
    UIButton        *_yearBtn;
    
    NSInteger        price;
}
@property (nonatomic,retain) YPBVIPPriviledgeViewController *vipView;
@property (nonatomic,retain) YPBSystemConfig *payConfig;
@end

@implementation YPBActivityPayView

//DefineLazyPropertyInitialization(YPBVIPPriviledgeViewController, vipView);

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _payConfig = [YPBSystemConfig sharedConfig];
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0.5f;
        
        _bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vipcenter_banner.jpg"]];
        [self addSubview:_bgImg];
        
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"vip_payview_close"] forState:UIControlStateNormal];
        [self addSubview:_closeBtn];
        {
            [_closeBtn bk_whenTapped:^{
                _closeBlock();
            }];
        }
        
        
        [self initPayYearCell];
        
        [self initPayMonthsCell];
        
        _yearBtn.selected = YES;
        _seasonBtn.selected = NO;
        _monthBtn.selected = NO;
        
        price = [_payConfig.vipPointDictionary[@"12"] integerValue];
        
        _wxPayCell = [[UITableViewCell alloc] init];
        _wxPayCell.layer.borderWidth = 0.5;
        _wxPayCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _wxPayCell.layer.masksToBounds = YES;
        [self addSubview:_wxPayCell];
        [self initCell:_wxPayCell WithImage:@"vip_wechat_icon" Title:@"微信支付"];
        
        _aliPayCell = [[UITableViewCell alloc] init];
        _aliPayCell.layer.borderWidth = 0.5;
        _aliPayCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _aliPayCell.layer.cornerRadius = 10;
        [self addSubview:_aliPayCell];
        [self initCell:_aliPayCell WithImage:@"vip_alipay_icon" Title:@"支付宝支付"];
        
        [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@(SCREEN_WIDTH*0.8*0.55));
        }];
        
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(10);
            make.top.equalTo(self.mas_top).offset(-10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [_payYearCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bgImg.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(@((SCREEN_HEIGHT*0.6-SCREEN_WIDTH*0.8*0.55)/4 - 5));
        }];
        
        [_payMonthsCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_payYearCell.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(@((SCREEN_HEIGHT*0.6-SCREEN_WIDTH*0.8*0.55)/4-5 - 5));
        }];
        
        [_wxPayCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_payMonthsCell.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(@((SCREEN_HEIGHT*0.6-SCREEN_WIDTH*0.8*0.55)/4 + 5));
        }];
        
        [_aliPayCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_wxPayCell.mas_bottom);
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(@((SCREEN_HEIGHT*0.6-SCREEN_WIDTH*0.8*0.55)/4 + 5));
            
        }];
        
    }
    return self;
}

- (void)payWithPaymentType:(YPBPaymentType)type {
    self.vipView = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymnetContentTypeActivity];
    NSInteger month = 1;
    if (_yearBtn.selected) {
        month = 12;
    } else if (_seasonBtn.selected) {
        month = 3;
    } else if (_monthBtn.selected) {
        month = 1;
    }
    
#if DEBUG
    price = 1;
#endif
    [self.vipView payWithPrice:price paymentType:type forMonths:month];
}


- (void)initPayYearCell {
    _payYearCell = [[UITableViewCell alloc] init];
    _payYearCell.layer.borderWidth = 0.5;
    _payYearCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
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
    _payMonthsCell.layer.borderWidth = 0.5f;
    _payMonthsCell.layer.borderColor = [UIColor lightGrayColor].CGColor;
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
        }
    }];
    
    
    [_monthBtn bk_whenTapped:^{
        if (!_monthBtn.selected) {
            _yearBtn.selected = NO;
            _seasonBtn.selected = NO;
            _monthBtn.selected = YES;
            price = [_payConfig.vipPointDictionary[@"1"] integerValue];
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

- (void)initCell:(UITableViewCell *)cell WithImage:(NSString *)imageName Title:(NSString *)title {
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [cell addSubview:imgV];
    
    UILabel * label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:13.];
    //    label.backgroundColor = [UIColor redColor];
    [cell addSubview:label];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"vip_payment_button_pay"];
    [payBtn setBackgroundImage:image forState:UIControlStateNormal];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"vip_payment_button_pay"] forState:UIControlStateSelected];
    [cell addSubview:payBtn];
    
    [cell bk_whenTapped:^{
        if (cell == _wxPayCell) {
            [self payWithPaymentType:YPBPaymentTypeWeChatPay];
        } else if (cell == _aliPayCell) {
            [self payWithPaymentType:YPBPaymentTypeAlipay];
        }
    }];
    
    [payBtn bk_whenTapped:^{
        if (cell == _wxPayCell) {
            [self payWithPaymentType:YPBPaymentTypeWeChatPay];
        } else if (cell == _aliPayCell) {
            [self payWithPaymentType:YPBPaymentTypeAlipay];
        }
    }];
    
    {
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.equalTo(cell).offset(cell.frame.size.width/20.);
            make.size.mas_equalTo(CGSizeMake(cell.frame.size.height*0.9, cell.frame.size.height*0.9));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.equalTo(imgV.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(80, cell.frame.size.height*0.8));
        }];
        
        [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.right.equalTo(cell).offset(-cell.frame.size.width/20.);
            make.height.equalTo(@(cell.frame.size.height*0.9/1.5));
            make.width.equalTo(payBtn.mas_height).multipliedBy(image.size.width/image.size.height);
        }];
    }
}



-(void)setImg:(UIImage *)img {
    _bgImg.image = img;
}

- (void)setCloseBtnHidden:(BOOL)closeBtnHidden {
    _closeBtn.hidden = closeBtnHidden;
}

@end