//
//  UIView+YPBMask.h
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YPBMask)

@property (nonatomic,retain,readonly) UIView *YPB_maskView;

- (void)YPB_showMask;
- (void)YPB_hideMask;

@end
