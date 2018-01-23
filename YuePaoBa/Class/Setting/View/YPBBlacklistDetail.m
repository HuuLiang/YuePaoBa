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
    userImage.layer.cornerRadius = 29;
    [userImage sd_setImageWithURL:[NSURL URLWithString:dic[@"logoUrl"]]];
    [self.contentView addSubview:userImage];
    
    
    UILabel *nicklabel = [[UILabel alloc] init];
    nicklabel.font = [UIFont boldSystemFontOfSize:15];
    nicklabel.text = dic[@"nickname"];
    [self.contentView addSubview:nicklabel];
    
    UILabel *time = [[UILabel alloc] init];
    time.font = [UIFont systemFontOfSize:15];
    time.text = dic[@"date"];
    time.textColor = [UIColor grayColor];
    [self.contentView addSubview:time];
    
    [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(58, 58));
    }];
    
    [nicklabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(userImage.mas_right).offset(13);
        make.size.mas_equalTo(CGSizeMake(200, 25));
    }];
    
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nicklabel.mas_bottom).offset(5);
        make.left.equalTo(userImage.mas_right).offset(13);
        make.size.mas_equalTo(CGSizeMake(200, 15));
    }];
}

@end
