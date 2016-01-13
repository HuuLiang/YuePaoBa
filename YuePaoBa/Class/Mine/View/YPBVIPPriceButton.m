//
//  YPBVIPPriceButton.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBVIPPriceButton.h"

@implementation YPBVIPPriceButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;

        self.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -0.08);
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}
@end
