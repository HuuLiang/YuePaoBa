//
//  YPBRadioButton.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/12.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "YPBRadioButton.h"

@implementation YPBRadioButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:14.];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if ([self imageForState:self.state] == nil) {
        return CGRectZero;
    }
    
    if (self.imageRectBlock) {
        return self.imageRectBlock(contentRect);
    }
    return CGRectMake(0, 0, CGRectGetHeight(contentRect), CGRectGetHeight(contentRect));
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if ([self titleForState:self.state] == nil) {
        return CGRectZero;
    }
    
    if (self.titleRectBlock) {
        return self.titleRectBlock(contentRect);
    }
    
    CGRect titleRect = [self imageRectForContentRect:contentRect];
    const CGFloat x = CGRectGetMaxX(titleRect)+5;
    return CGRectMake(x, 0, CGRectGetMaxX(contentRect)-x, CGRectGetHeight(contentRect));
}
@end
