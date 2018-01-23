//
//  YPBImageIndicatorView.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/28.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBImageIndicatorView : UIView

@property (nonatomic,readonly) NSUInteger numberOfIndicators;
@property (nonatomic) NSUInteger selectedIndicator;

- (instancetype)initWithNumberOfIndicators:(NSUInteger)numberOfIndicators;

@end
