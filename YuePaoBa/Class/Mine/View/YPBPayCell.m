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


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundImage = [[UIImageView alloc] init];
        _backgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_backgroundImage];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_priceLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_detailLabel];
        
        _payButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _payButton.backgroundColor = [UIColor colorWithRed:66/255.0 green:217/255.0 blue:101/255.0 alpha:1.0];
        _payButton.layer.cornerRadius = 5;
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:20];
        _payButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_payButton];
        
    }
    return self;
}

- (void)setDetailText:(NSString *)detailText {
    _detailLabel.text = detailText;
    [self LayoutSubviews];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)LayoutSubviews {
    NSDictionary *Dic = @{@"_back":_backgroundImage,
                          @"_price":_priceLabel,
                          @"_detail":_detailLabel,
                          @"_pay":_payButton};
    NSArray *contraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_back(55)]-10-[_price]-10-[_pay(80)]-10-|" options:0 metrics:nil views:Dic];
    NSArray *contraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_back(55)]-10-[_detail]-10-[_pay(80)]-10-|" options:0 metrics:nil views:Dic];
    NSArray *contraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12.5-[_back(55)]-12.5-|" options:0 metrics:nil views:Dic];
    NSArray *contraints4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_price(20)]-[_detail]-25-|" options:0 metrics:nil views:Dic];
    if ([_detailLabel.text isEqualToString:@""]) {
        contraints4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_price(20)]-30-|" options:0 metrics:nil views:Dic];
    }
    NSArray *contraints5 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_pay]-25-|" options:0 metrics:nil views:Dic];
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:contraints1];
    [array addObjectsFromArray:contraints2];
    [array addObjectsFromArray:contraints3];
    [array addObjectsFromArray:contraints4];
    [array addObjectsFromArray:contraints5];
    [self addConstraints:array];
}


@end
