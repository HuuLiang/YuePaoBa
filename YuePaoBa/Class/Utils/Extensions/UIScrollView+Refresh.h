//
//  UIScrollView+Refresh.h
//  YuePaoBa
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView (Refresh)

- (void)YPB_addPullToRefreshWithHandler:(void (^)(void))handler;
- (void)YPB_triggerPullToRefresh;
- (void)YPB_endPullToRefresh;

- (void)YPB_addPagingRefreshWithHandler:(void (^)(void))handler;
- (void)YPB_pagingRefreshNoMoreData;

@end
