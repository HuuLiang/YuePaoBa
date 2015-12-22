//
//  UIView+Loading.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/21.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "UIView+Loading.h"

static const void *kUILoadingViewAssociatedKey = &kUILoadingViewAssociatedKey;

@implementation UIView (Loading)

- (UIView *)loadingView {
    UIView *loadingView = objc_getAssociatedObject(self, kUILoadingViewAssociatedKey);
    if (loadingView) {
        return loadingView;
    }
    
    loadingView = [[UIView alloc] init];
    loadingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    objc_setAssociatedObject(self, kUILoadingViewAssociatedKey, loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicatorView startAnimating];
    [loadingView addSubview:indicatorView];
    {
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(loadingView);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
    }
    return loadingView;
}

- (void)beginLoading {
    if ([self.subviews containsObject:self.loadingView]) {
        return ;
    }
    
    [self addSubview:self.loadingView];
    {
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

- (void)endLoading {
    if ([self.subviews containsObject:self.loadingView]) {
        [self.loadingView removeFromSuperview];
    }
}
@end
