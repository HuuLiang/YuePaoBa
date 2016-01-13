//
//  YPBVIPEntranceView.m
//  YuePaoBa
//
//  Created by Sean Yue on 16/1/12.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "YPBVIPEntranceView.h"

static const void *kVIPEntranceViewAssociatedKey = &kVIPEntranceViewAssociatedKey;

@interface YPBVIPEntranceView ()
{
    UIImageView *_backgroundImageView;
    UIButton *_enterButton;
}
@property (nonatomic) BOOL canClose;
@end

@implementation YPBVIPEntranceView

+ (instancetype)VIPEntranceInView:(UIView *)view {
    return objc_getAssociatedObject(view, kVIPEntranceViewAssociatedKey);
}

+ (instancetype)showVIPEntranceInView:(UIView *)view canClose:(BOOL)canClose withEnterAction:(YPBAction)enterAction {
    YPBVIPEntranceView *thisView = [self VIPEntranceInView:view];
    if (!thisView) {
        thisView = [[self alloc] init];
        objc_setAssociatedObject(view, kVIPEntranceViewAssociatedKey, thisView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    thisView.canClose = canClose;
    thisView.enterAction = enterAction;
    [thisView showInView:view];
    return thisView;
}

#ifdef DEBUG

- (void)dealloc {
    DLog(@"YPBVIPEntranceView dealloc");
}

#endif

- (instancetype)init {
    self = [super init];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] init];
        [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[YPBSystemConfig sharedConfig].ballPayWindowurl]
                                placeholderImage:[UIImage imageNamed:@"vip_entrance_background"]];
        [self addSubview:_backgroundImageView];
        {
            [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
        
        _enterButton = [[UIButton alloc] init];
        UIImage *enterImage = [UIImage imageNamed:@"vip_entrance_button"];
        [_enterButton setImage:enterImage forState:UIControlStateNormal];
        [self addSubview:_enterButton];
        {
            [_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self).offset(-30);
            }];
        }
        
        @weakify(self);
        [_enterButton bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock1(self.enterAction, sender);
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)showInView:(UIView *)view {
    if ([view.subviews containsObject:self]) {
        return ;
    }
    
    [view YPB_showMask];
    @weakify(self);
    [view.YPB_maskView bk_whenTapped:^{
        @strongify(self);
        if (self.canClose) {
            [self hide];
        }
    }];
    
    const CGFloat viewScale = 577.0/636.0;
    const CGFloat viewWidth = CGRectGetWidth(view.bounds) * 0.9;
    const CGFloat viewHeight = viewWidth / viewScale;
    const CGFloat viewX = (CGRectGetWidth(view.bounds)-viewWidth)/2;
    const CGFloat viewY = (CGRectGetHeight(view.bounds)-viewHeight)/2;
    
    self.alpha = 0;
    self.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    if (self.superview) {
        [self.superview YPB_hideMask];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            objc_setAssociatedObject(self.superview, kVIPEntranceViewAssociatedKey, nil, OBJC_ASSOCIATION_ASSIGN);
            [self removeFromSuperview];
        }];
    }
}
@end
