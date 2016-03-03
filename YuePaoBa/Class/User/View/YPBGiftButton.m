//
//  YPBGiftButton.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/2/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBGiftButton.h"

@implementation YPBGiftButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.font = [UIFont systemFontOfSize:CGRectGetHeight(self.titleLabel.frame)*0.6];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if (CGRectEqualToRect(contentRect, CGRectZero)) {
        return CGRectZero;
    }
    
    CGFloat size = MIN(contentRect.size.width, contentRect.size.height);
    CGRect imageRect = CGRectMake(0, 0, size, size);
    return CGRectInset(imageRect, 5, 5);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (CGRectEqualToRect(contentRect, CGRectZero)) {
        return CGRectZero;
    }
    
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    const CGFloat y = CGRectGetMaxY(imageRect)+5;
    return CGRectMake(0, y, CGRectGetWidth(contentRect), CGRectGetHeight(contentRect)-y);
}
@end
