//
//  YPBBlacklistDetail.m
//  YuePaoBa
//
//  Created by Liang on 16/4/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBBlacklistDetail.h"

@implementation YPBBlacklistDetail

- (void)updateInfoWithUserInfo:(NSDictionary *)dic {
    UIImageView *userImage = [[UIImageView alloc] init];
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = 33;
    [userImage sd_setImageWithURL:[NSURL URLWithString:dic[@"logoUrl"]]];
    [self.contentView addSubview:userImage];
    
    
    UILabel *nicklabel = [[UILabel alloc] init];
//    nicklabel.backgroundColor = [UIColor cyanColor];
    nicklabel.font = [UIFont systemFontOfSize:22];
    nicklabel.text = dic[@"nickname"];
    [self.contentView addSubview:nicklabel];
    
    UILabel *time = [[UILabel alloc] init];
//    time.backgroundColor = [UIColor yellowColor];
    time.font = [UIFont systemFontOfSize:15];
    time.text = dic[@"date"];
    [self.contentView addSubview:time];
    
    [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(2);
        make.left.equalTo(self.contentView).offset(5);
        make.size.mas_equalTo(CGSizeMake(66, 66));
    }];
    
    [nicklabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(userImage.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 25));
    }];
    
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nicklabel.mas_bottom).offset(5);
        make.left.equalTo(userImage.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 15));
    }];
}

@end
