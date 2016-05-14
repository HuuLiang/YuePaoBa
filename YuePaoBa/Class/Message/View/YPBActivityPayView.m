//
//  YPBActivityPayView.m
//  YuePaoBa
//
//  Created by Liang on 16/5/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBActivityPayView.h"
#import "YPBPaymentModel.h"

@interface YPBActivityPayView ()
{
    UIButton        *_closeBtn;
    UIImageView     *_bgImg;
    UITableViewCell *_cellOne;
    UITableViewCell *_cellTwo;
    UITableViewCell *_cellThree;
}

@end

@implementation YPBActivityPayView

- (void)initCell:(UITableViewCell *)cell WithImage:(NSString *)imageName Title:(NSString *)title {
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [cell addSubview:imgV];
    
    UILabel * label = [[UILabel alloc] init];
    label.text = title;
    label.backgroundColor = [UIColor redColor];
    [cell addSubview:label];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [payBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    {
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
        
        }];
    }
    
}

- (void)initCell {
    _cellOne.backgroundColor = [UIColor colorWithHexString:@"#fffffd"];
    _cellOne.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *oneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [oneBtn setBackgroundImage:[UIImage imageNamed:@"message_choose"] forState:UIControlStateNormal];
    [oneBtn setBackgroundImage:[UIImage imageNamed:@"message_choose_done"] forState:UIControlStateSelected];
    oneBtn.layer.cornerRadius = 15;
    oneBtn.layer.masksToBounds = YES;
    oneBtn.selected = YES;
    [_cellOne addSubview:oneBtn];
    
    
    UIButton *threeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [threeBtn setBackgroundImage:[UIImage imageNamed:@"message_choose"] forState:UIControlStateNormal];
    [threeBtn setBackgroundImage:[UIImage imageNamed:@"message_choose_done"] forState:UIControlStateSelected];
    threeBtn.layer.cornerRadius = 15;
    threeBtn.layer.masksToBounds = YES;
    threeBtn.selected = NO;
    [_cellOne addSubview:threeBtn];
    
    [oneBtn bk_whenTapped:^{
        oneBtn.selected = !oneBtn.selected;
        threeBtn.selected = !threeBtn.selected;
    }];
    
    [threeBtn bk_whenTapped:^{
        oneBtn.selected = !oneBtn.selected;
        threeBtn.selected = !threeBtn.selected;
    }];
    
    UILabel *oneLabel = [[UILabel alloc] init];
    oneLabel.text = [NSString stringWithFormat:@"%@/个月",@"50"];
    oneLabel.font = [UIFont systemFontOfSize:14.];
    oneLabel.backgroundColor = [UIColor clearColor];
    [_cellOne addSubview:oneLabel];
    
    UILabel *threeLabel = [[UILabel alloc] init];
    threeLabel.backgroundColor = [UIColor clearColor];
    threeLabel.font = [UIFont systemFontOfSize:14.];
    threeLabel.numberOfLines = 0;
    NSString *string = [NSString stringWithFormat:@"%@/季度\n返100元话费",@"100"];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange rangge = [string rangeOfString:[NSString stringWithFormat:@"返100元话费"]];
    if (rangge.location != NSNotFound) {
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor redColor] range:rangge];
    }
    threeLabel.attributedText = attributedStr;
    [_cellOne addSubview:threeLabel];
    
    {
        [oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cellOne).offset(10);
            make.centerY.equalTo(_cellOne);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_cellOne);
            make.left.equalTo(oneBtn.mas_right).offset(5);
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
        
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 10;
        
        _bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_paybanner"]];
        [self addSubview:_bgImg];
        
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"home_close"] forState:UIControlStateNormal];
        [self addSubview:_closeBtn];
        {
            [_closeBtn bk_whenTapped:^{
                [self.superview endLoading];
                [self removeFromSuperview];
            }];
        }
        
        _cellOne = [[UITableViewCell alloc] init];
        [self addSubview:_cellOne];
        [self initCell];
        
        _cellTwo = [[UITableViewCell alloc] init];
        _cellTwo.backgroundColor = [UIColor cyanColor];
        [self addSubview:_cellTwo];
        [self initCell:_cellTwo WithImage:@"vip_wenchat_icon" Title:@"微信支付"];
        
        _cellThree = [[UITableViewCell alloc] init];
        _cellThree.backgroundColor = [UIColor blueColor];
        _cellThree.alpha = 0.5;
        _cellThree.layer.cornerRadius = 10;
        [self addSubview:_cellThree];
        [self initCell:_cellThree WithImage:@"vip_alipay_icon" Title:@"支付宝支付"];
        
    }
    return self;
}

- (void)layoutSubviews {
    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(SCREEN_WIDTH*0.8*0.55));
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_right).offset(-8);
        make.centerY.equalTo(self.mas_top).offset(4);
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

@end
