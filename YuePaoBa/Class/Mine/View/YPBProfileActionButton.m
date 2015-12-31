//
//  YPBProfileActionButton.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/17.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBProfileActionButton.h"

static const CGFloat kBadgeLabelSize = 20.;

@interface YPBProfileActionButton ()
@property (nonatomic,retain) UILabel *badgeLabel;
@end

@implementation YPBProfileActionButton

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title action:(YPBProfileButtonAction)action {
    self = [super init];
    if (self) {
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateNormal];
        [self setAction:action];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13.];
    }
    return self;
}

- (void)setAction:(YPBProfileButtonAction)action {
    _action = action;
    if (action) {
        [self bk_addEventHandler:^(id sender) {
            action(sender);
        } forControlEvents:UIControlEventTouchUpInside];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    const CGFloat width = CGRectGetWidth(contentRect) * 0.6;
    const CGFloat x = CGRectGetMinX(contentRect) + (CGRectGetWidth(contentRect)-width)/2;
    return CGRectMake(x, 0, width, width);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    
    const CGFloat width = CGRectGetWidth(contentRect);
    const CGFloat height = (CGRectGetHeight(contentRect) - CGRectGetHeight(imageRect)) * 0.7;
    return CGRectMake(0, CGRectGetMaxY(contentRect)-height, width, height);
}

- (UILabel *)badgeLabel {
    if (_badgeLabel) {
        return _badgeLabel;
    }
    
    _badgeLabel = [[UILabel alloc] init];
    _badgeLabel.layer.cornerRadius = kBadgeLabelSize / 2;
    _badgeLabel.layer.masksToBounds = YES;
    _badgeLabel.backgroundColor = [UIColor colorWithHexString:@"#f7163c"];
    _badgeLabel.font = [UIFont systemFontOfSize:kBadgeLabelSize * 0.8];
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    _badgeLabel.adjustsFontSizeToFitWidth = YES;
    _badgeLabel.hidden = YES;
    [self addSubview:_badgeLabel];
    {
        [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self.mas_centerX).multipliedBy(1.75);
            make.size.mas_equalTo(CGSizeMake(kBadgeLabelSize, kBadgeLabelSize));
        }];
    }
    return _badgeLabel;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    
    self.badgeLabel.hidden = badgeValue.length == 0;
    self.badgeLabel.text = badgeValue;
}
@end
