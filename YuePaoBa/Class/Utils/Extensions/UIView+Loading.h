//
//  UIView+Loading.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/12/21.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Loading)

@property (nonatomic,retain,readonly) UIView *loadingView;

- (void)beginLoading;
- (void)endLoading;

@end
