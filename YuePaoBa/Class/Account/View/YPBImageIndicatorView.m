//
//  YPBImageIndicatorView.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/28.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBImageIndicatorView.h"

@interface YPBImageIndicatorView ()
@property (nonatomic,retain) NSMutableArray<UIImageView *> *indicatorImageViews;
@end

@implementation YPBImageIndicatorView

DefineLazyPropertyInitialization(NSMutableArray, indicatorImageViews)

- (instancetype)initWithNumberOfIndicators:(NSUInteger)numberOfIndicators {
    self = [self init];
    if (self) {
        _numberOfIndicators = numberOfIndicators;
        
        UIImage *hollowImage = [UIImage imageNamed:@"indicator_point_hollow"];
        UIImage *solidImage = [UIImage imageNamed:@"indicator_point_solid"];
        CGRect imageFrame = CGRectMake(0, 0, hollowImage.size.width, hollowImage.size.height);
        
        const CGFloat interImageSpacing = 30;
        for (NSUInteger i = 0; i < numberOfIndicators; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:i==0?solidImage:hollowImage];
            imageView.frame = CGRectOffset(imageFrame, interImageSpacing*i, 0);
            [self addSubview:imageView];
            [self.indicatorImageViews addObject:imageView];
        }
    }
    return self;
}

- (void)setSelectedIndicator:(NSUInteger)selectedIndicator {
    if (selectedIndicator < self.indicatorImageViews.count) {
        NSUInteger oldSelection = _selectedIndicator;
        _selectedIndicator = selectedIndicator;
        
        if (oldSelection < self.indicatorImageViews.count) {
            UIImageView *oldSelected = self.indicatorImageViews[oldSelection];
            oldSelected.image = [UIImage imageNamed:@"indicator_point_hollow"];
        }
        
        UIImageView *selected = self.indicatorImageViews[selectedIndicator];
        selected.image = [UIImage imageNamed:@"indicator_point_solid"];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIImageView *lastImageView = self.indicatorImageViews.lastObject;
    self.bounds = CGRectMake(0, 0, CGRectGetMaxX(lastImageView.frame), CGRectGetHeight(lastImageView.frame));
}
@end
