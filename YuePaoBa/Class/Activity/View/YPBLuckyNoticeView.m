//
//  YPBLuckyNoticeView.m
//  YuePaoBa
//
//  Created by Liang on 16/8/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBLuckyNoticeView.h"

@interface YPBLuckyNoticeView ()
{
    UIImageView *_imgV;
}
@end

@implementation YPBLuckyNoticeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        
        _imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_pay_icon"]];
        _imgV.userInteractionEnabled = YES;
        [self addSubview:_imgV];
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"activity_noticlose_icon"] forState:UIControlStateNormal];
        [self addSubview:_closeBtn];
        
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setTitle:@"去充值" forState:UIControlStateNormal];
        _payBtn.backgroundColor = [UIColor colorWithHexString:@"#e5413c"];
        [_payBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        _payBtn.layer.cornerRadius = kWidth(10);
        [self addSubview:_payBtn];

        {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kWidth(60), kWidth(60)));
            }];
            
            [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.mas_bottom).offset(-kWidth(70));
                make.size.mas_equalTo(CGSizeMake(kWidth(298), kWidth(70)));
            }];
        }
        
    }
    return self;
}

@end
