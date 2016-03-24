//
//  YPBNeighborCell.m
//  YuePaoBa
//
//  Created by Liang on 16/3/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBNeighborCell.h"

@implementation YPBNeighborCell

- (void)addSubviews {
    self.backgroundColor = [UIColor magentaColor];
    
    _userImgV = [[UIImageView alloc] init];
    _userImgV.backgroundColor = [UIColor yellowColor];
    _userImgV.layer.cornerRadius = 40;
    [self addSubview:_userImgV];
    
    _userNameDistance = [[UILabel alloc] init];
    _userNameDistance.backgroundColor = [UIColor brownColor];
    [self addSubview:_userNameDistance];
    
    _userDetail = [[UILabel alloc] init];
    _userDetail.backgroundColor = [UIColor blueColor];
    [self addSubview:_userDetail];
    
    _focus = [[UILabel alloc] init];
    _focus.backgroundColor = [UIColor blackColor];
    [self addSubview:_focus];
    
    _contactBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _contactBtn.backgroundColor = [UIColor redColor];
    [_contactBtn setTitle:@"打招呼" forState:UIControlStateNormal];
    [_contactBtn addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_contactBtn];

}

- (void)doSomething:(UIButton *)button {
    [button setTitle:@"❤️  1999" forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
}

- (void)setCellWithInfo:(NSString *)str {
    [self addSubviews];
    
    
    
    
    
    [self layoutSubview];
}

- (void)layoutSubview {
    [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [_userNameDistance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(_userImgV.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [_userDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameDistance.mas_bottom);
        make.left.equalTo(_userImgV.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [_focus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userDetail.mas_bottom);
        make.left.equalTo(_userImgV.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [_contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-30);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
}


@end
