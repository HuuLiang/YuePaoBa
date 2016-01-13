//
//  UIView+YPBMask.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "UIView+YPBMask.h"

static const void *kUIMaskViewAssociatedKey = &kUIMaskViewAssociatedKey;

@implementation UIView (YPBMask)

- (UIView *)YPB_maskView {
    return objc_getAssociatedObject(self, kUIMaskViewAssociatedKey);
}

- (void)YPB_showMask {
    UIView *maskView = self.YPB_maskView;
    if (!maskView) {
        maskView = [[UIView alloc] init];
        maskView.frame = self.bounds;
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        maskView.alpha = 0;
        [self addSubview:maskView];
        objc_setAssociatedObject(self, kUIMaskViewAssociatedKey, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 1;
        }];
    }
}

- (void)YPB_hideMask {
    UIView *maskView = self.YPB_maskView;
    if (maskView) {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [maskView removeFromSuperview];
            objc_setAssociatedObject(self, kUIMaskViewAssociatedKey, nil, OBJC_ASSOCIATION_ASSIGN);
        }];
    }
}

@end
