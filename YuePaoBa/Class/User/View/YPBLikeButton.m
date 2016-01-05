//
//  YPBLikeButton.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBLikeButton.h"

@interface YPBLikeButton ()

@end

@implementation YPBLikeButton

- (instancetype)initWithUserInteractionEnabled:(BOOL)enabled {
    self = [self init];
    if (self) {
        self.userInteractionEnabled = enabled;

        if (!enabled) {
            self.selected = YES;
        }
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setImage:[UIImage imageNamed:@"dislike_icon"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"like_icon"] forState:UIControlStateSelected];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitle:@"0" forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect titleRect = [self titleRectForContentRect:[self contentRectForBounds:self.bounds]];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:CGRectGetHeight(titleRect)];
}

- (void)setNumberOfLikes:(NSUInteger)numberOfLikes {
    _numberOfLikes = numberOfLikes;
    
    NSString *title = numberOfLikes > 9999 ? @"9999+" : [NSString stringWithFormat:@"%ld", numberOfLikes];
    [self setTitle:title forState:UIControlStateNormal];
}

//- (CGRect)contentRectForBounds:(CGRect)bounds {
//    return CGRectInset(bounds, bounds.size.width*0.1, bounds.size.height*0.1);
//}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(contentRect.origin.x, contentRect.origin.y, contentRect.size.width, contentRect.size.height * 0.3);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect titleRect = [self titleRectForContentRect:contentRect];
    
    const CGFloat width = CGRectGetWidth(contentRect) * 0.5;
    const CGFloat height = width;
    const CGFloat x = contentRect.origin.x + (contentRect.size.width-width)/2;
    const CGFloat y = CGRectGetMaxY(titleRect);
    return CGRectMake(x, y, width, height);
}
@end
