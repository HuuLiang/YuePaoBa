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
    UITableViewCell *_cellOne;
    UITableViewCell *_cellTwo;
    UITableViewCell *_cellThree;
    
    UIButton        *_oneBtn;
    NSInteger        price;
}
@property (nonatomic,retain) YPBVIPPriviledgeViewController *vipView;
@property (nonatomic,retain) YPBSystemConfig *payConfig;
@end

@implementation YPBActivityPayView

//DefineLazyPropertyInitialization(YPBVIPPriviledgeViewController, vipView);

- (void)initCell:(UITableViewCell *)cell WithImage:(NSString *)imageName Title:(NSString *)title {
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [cell addSubview:imgV];
    
    UILabel * label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:13.];
//    label.backgroundColor = [UIColor redColor];
    [cell addSubview:label];

    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"vip_payment_button_go_normal"];
    [payBtn setBackgroundImage:image forState:UIControlStateNormal];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"vip_payment_button_go_highlight"] forState:UIControlStateSelected];
    [cell addSubview:payBtn];
    
    [cell bk_whenTapped:^{
        if (cell == _cellTwo) {
            [self payWithPaymentType:YPBPaymentTypeWeChatPay];
        } else if (cell == _cellThree) {
            [self payWithPaymentType:YPBPaymentTypeAlipay];
        }
    }];
    
    [payBtn bk_whenTapped:^{
        if (cell == _cellTwo) {
            [self payWithPaymentType:YPBPaymentTypeWeChatPay];
        } else if (cell == _cellThree) {
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
            make.height.equalTo(@(cell.frame.size.height*0.9));
            make.width.equalTo(payBtn.mas_height).multipliedBy(image.size.width/image.size.height);
        }];
    }
}

- (void)initCell {
    _cellOne.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    _cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _oneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_oneBtn setBackgroundImage:[UIImage imageNamed:@"message_choose"] forState:UIControlStateNormal];
    [_oneBtn setBackgroundImage:[UIImage imageNamed:@"message_choose_done"] forState:UIControlStateSelected];
    _oneBtn.layer.cornerRadius = 15;
    _oneBtn.layer.masksToBounds = YES;
    _oneBtn.selected = NO;
    [_cellOne addSubview:_oneBtn];
    
    price = [_payConfig.vipPointDictionary[@"3"] integerValue];
    
    UIButton *threeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [threeBtn setBackgroundImage:[UIImage imageNamed:@"message_choose"] forState:UIControlStateNormal];
    [threeBtn setBackgroundImage:[UIImage imageNamed:@"message_choose_done"] forState:UIControlStateSelected];
    threeBtn.layer.cornerRadius = 15;
    threeBtn.layer.masksToBounds = YES;
    threeBtn.selected = YES;
    [_cellOne addSubview:threeBtn];
    
    [_oneBtn bk_whenTapped:^{
        if (!_oneBtn.selected) {
            _oneBtn.selected = YES;
            threeBtn.selected = NO;
            price = [_payConfig.vipPointDictionary[@"1"] integerValue];
        }
    }];
    
    [threeBtn bk_whenTapped:^{
        if (!threeBtn.selected) {
            _oneBtn.selected = NO;
            threeBtn.selected = YES;
            price = [_payConfig.vipPointDictionary[@"3"] integerValue];
        }
    }];
    
    UILabel *oneLabel = [[UILabel alloc] init];
    oneLabel.text = [NSString stringWithFormat:@"%ld/月\n返100元话费",((NSString *)_payConfig.vipPointDictionary[@"1"]).integerValue/100];
    oneLabel.font = [UIFont systemFontOfSize:14.];
    oneLabel.backgroundColor = [UIColor clearColor];
    [_cellOne addSubview:oneLabel];
    
    UILabel *threeLabel = [[UILabel alloc] init];
    threeLabel.backgroundColor = [UIColor clearColor];
    threeLabel.font = [UIFont systemFontOfSize:14.];
    threeLabel.numberOfLines = 0;
    NSString *string = [NSString stringWithFormat:@"%ld/季度\n返100元话费",((NSString *)_payConfig.vipPointDictionary[@"3"]).integerValue/100];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange rangge = [string rangeOfString:[NSString stringWithFormat:@"返100元话费"]];
    if (rangge.location != NSNotFound) {
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor redColor] range:rangge];
    }
    threeLabel.attributedText = attributedStr;
    [_cellOne addSubview:threeLabel];
    
    {
        [_oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cellOne).offset(10);
            make.centerY.equalTo(_cellOne);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_cellOne);
            make.left.equalTo(_oneBtn.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(60, _cellOne.frame.size.height*0.8));
        }];
        
        [threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_cellOne);
            make.right.equalTo(_cellOne.mas_right).offset(-10);
            make.size.mas_equalTo(CGSizeMake(80, _cellOne.frame.size.height*0.8));
        }];
        
        [threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_cellOne);
            make.right.equalTo(threeLabel.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _payConfig = [YPBSystemConfig sharedConfig];
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        _bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_paybanner"]];
        [self addSubview:_bgImg];
        
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"home_close"] forState:UIControlStateNormal];
        [self addSubview:_closeBtn];
        {
            [_closeBtn bk_whenTapped:^{
                _closeBlock();
            }];
        }
        
        _cellOne = [[UITableViewCell alloc] init];
        [self addSubview:_cellOne];
        [self initCell];
        
        _cellTwo = [[UITableViewCell alloc] init];
        _cellTwo.layer.borderWidth = 0.5;
        _cellTwo.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _cellTwo.layer.masksToBounds = YES;
        [self addSubview:_cellTwo];
        [self initCell:_cellTwo WithImage:@"vip_wechat_icon" Title:@"微信支付"];
        
        _cellThree = [[UITableViewCell alloc] init];
        _cellThree.layer.cornerRadius = 10;
        [self addSubview:_cellThree];
        [self initCell:_cellThree WithImage:@"vip_alipay_icon" Title:@"支付宝支付"];
        
        [self layoutSubview];
    }
    return self;
}


- (void)payWithPaymentType:(YPBPaymentType)type {
    self.vipView = [[YPBVIPPriviledgeViewController alloc] initWithContentType:YPBPaymnetContentTypeActivity];
    NSInteger month = 1;
    if (!_oneBtn.selected) {
        month = 3;
    }
    
#if DEBUG
    price = 1;
#endif
    [self.vipView payWithPrice:price paymentType:type forMonths:month];
}

- (void)layoutSubview {
    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(SCREEN_WIDTH*0.8*0.55));
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_cellOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgImg.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@((SCREEN_HEIGHT*0.6-SCREEN_WIDTH*0.8*0.55)/3-5));
    }];
    
    [_cellTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cellOne.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(@((SCREEN_HEIGHT*0.6-SCREEN_WIDTH*0.8*0.55)/3));
    }];
    
    [_cellThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cellTwo.mas_bottom);
        make.left.right.bottom.equalTo(self);
        
    }];

}

-(void)setImg:(UIImage *)img {
    _bgImg.image = img;
}

- (void)setCloseBtnHidden:(BOOL)closeBtnHidden {
    _closeBtn.hidden = closeBtnHidden;
}

@end
