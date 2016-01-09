//
//  UIView+Loading.m
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/21.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "UIView+Loading.h"
#import <MBProgressHUD.h>

static const void *kUILoadingViewAssociatedKey = &kUILoadingViewAssociatedKey;
static const void *kUIProgressingViewAssociatedKey = &kUIProgressingViewAssociatedKey;

@implementation UIView (Loading)

- (UIView *)ypb_loadingView {
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

- (UIView *)ypb_progressingView {
    UIView *progressingView = objc_getAssociatedObject(self, kUIProgressingViewAssociatedKey);
    if (progressingView) {
        return progressingView;
    }
    
    MBProgressHUD *progressHud = [[MBProgressHUD alloc] initWithView:self];
    objc_setAssociatedObject(self, kUIProgressingViewAssociatedKey, progressHud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    progressHud.mode = MBProgressHUDModeDeterminate;
    [self addSubview:progressHud];
    return progressHud;
}

- (void)beginLoading {
    if ([self.subviews containsObject:self.ypb_loadingView]) {
        return ;
    }
    
    [self addSubview:self.ypb_loadingView];
    {
        [self.ypb_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

- (void)endLoading {
    if ([self.subviews containsObject:self.ypb_loadingView]) {
        [self.ypb_loadingView removeFromSuperview];
    }
}

- (void)beginProgressingWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    MBProgressHUD *progressHud = (MBProgressHUD *)self.ypb_progressingView;
    progressHud.labelText = title;
    progressHud.detailsLabelText = subtitle;
    [progressHud show:YES];
}

- (void)progressWithPercent:(double)percent {
    MBProgressHUD *progressHud = (MBProgressHUD *)self.ypb_progressingView;
    progressHud.progress = percent;
}

- (void)endProgressing {
    MBProgressHUD *progressHud = (MBProgressHUD *)self.ypb_progressingView;
    [progressHud hide:YES];
}
@end
